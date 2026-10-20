import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/identity/device_identity.dart';
import '../../core/platform/platform_info.dart';
import '../../core/storage/prefs_provider.dart';
import '../../core/supabase/supabase_bootstrap.dart';
import '../../core/utils/invite_code.dart';

/// 建组 / 入组成功结果。
class GroupJoinResult {
  const GroupJoinResult({
    required this.groupId,
    required this.inviteCode,
    this.groupName,
  });

  final String groupId;
  final String inviteCode;
  final String? groupName;
}

/// 组操作失败（[message] 均为可直接展示给用户的中文文案）。
sealed class GroupFailure implements Exception {
  const GroupFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 邀请码不存在或格式错误。
final class GroupFailureInvalidCode extends GroupFailure {
  const GroupFailureInvalidCode() : super('邀请码无效，请检查后重试');
}

/// 组已满（上限 [AppConstants.maxGroupMembers] 人）。
final class GroupFailureGroupFull extends GroupFailure {
  const GroupFailureGroupFull() : super('该组已满（上限 4 人）');
}

/// 当前设备已在某个组中。
final class GroupFailureAlreadyInGroup extends GroupFailure {
  const GroupFailureAlreadyInGroup() : super('当前设备已加入一个组，请先离开原组');
}

/// 昵称 / emoji / 组名未通过服务端校验。
final class GroupFailureValidation extends GroupFailure {
  const GroupFailureValidation([String? detail])
      : super(detail ?? '昵称或头像不符合要求（昵称 2~20 字）');
}

/// 网络异常（无网 / 超时 / 服务不可达）。
final class GroupFailureNetwork extends GroupFailure {
  const GroupFailureNetwork() : super('网络异常，请检查网络后重试');
}

/// 未预期错误。
final class GroupFailureUnknown extends GroupFailure {
  const GroupFailureUnknown([String? detail])
      : super(detail ?? '操作失败，请稍后重试');
}

/// 组仓库：建组 / 入组。
///
/// 真实环境走 Supabase security definer RPC（邀请码校验、人数上限、
/// 字段校验全在服务端）；未配置 Supabase 时用 [LocalGroupRepository]
/// 走通本地开发流程。
abstract interface class GroupRepository {
  Future<GroupJoinResult> createGroup({
    required String groupName,
    required String nickname,
    required String avatarEmoji,
  });

  Future<GroupJoinResult> joinGroup({
    required String inviteCode,
    required String nickname,
    required String avatarEmoji,
  });
}

/// Supabase RPC 实现（对应 migrations/0001_init.sql 的 create_group / join_group）。
class SupabaseGroupRepository implements GroupRepository {
  SupabaseGroupRepository(this._client, this._identity);

  final SupabaseClient _client;
  final DeviceIdentityService _identity;

  static final Logger _log = Logger();

  @override
  Future<GroupJoinResult> createGroup({
    required String groupName,
    required String nickname,
    required String avatarEmoji,
  }) async {
    final String deviceId = await _identity.ensureDeviceId();
    final dynamic res = await _guardRpc(
      () => _client.rpc(
        'create_group',
        params: <String, dynamic>{
          'p_group_name': groupName,
          'p_nickname': nickname,
          'p_avatar_emoji': avatarEmoji,
          'p_platform': AppPlatform.isIOS ? 'ios' : 'android',
          'p_device_id': deviceId,
          // model_name 暂缺（未引入 device_info 插件），列允许 NULL
        },
      ),
    );
    return _parseResult(res);
  }

  @override
  Future<GroupJoinResult> joinGroup({
    required String inviteCode,
    required String nickname,
    required String avatarEmoji,
  }) async {
    if (!isValidInviteCode(inviteCode)) {
      throw const GroupFailureInvalidCode();
    }
    final String deviceId = await _identity.ensureDeviceId();
    final dynamic res = await _guardRpc(
      () => _client.rpc(
        'join_group',
        params: <String, dynamic>{
          'p_invite_code': normalizeInviteCode(inviteCode),
          'p_nickname': nickname,
          'p_avatar_emoji': avatarEmoji,
          'p_platform': AppPlatform.isIOS ? 'ios' : 'android',
          'p_device_id': deviceId,
        },
      ),
    );
    return _parseResult(res);
  }

  Future<dynamic> _guardRpc(Future<dynamic> Function() call) async {
    try {
      return await call();
    } on PostgrestException catch (e) {
      _log.w('组 RPC 失败：${e.message}');
      throw _mapPostgrestError(e.message);
    } on SocketException {
      throw const GroupFailureNetwork();
    } on TimeoutException {
      throw const GroupFailureNetwork();
    } on AuthException catch (e) {
      _log.w('组 RPC 鉴权失败：${e.message}');
      throw const GroupFailureUnknown('登录状态失效，请重启应用重试');
    }
  }

  /// 服务端 raise exception 的中文文案 → 类型化错误。
  GroupFailure _mapPostgrestError(String message) {
    if (message.contains('邀请码无效')) return const GroupFailureInvalidCode();
    if (message.contains('该组已满')) return const GroupFailureGroupFull();
    if (message.contains('已加入一个组')) return const GroupFailureAlreadyInGroup();
    if (message.contains('网络')) return const GroupFailureNetwork();
    if (message.contains('昵称') ||
        message.contains('头像') ||
        message.contains('platform')) {
      return GroupFailureValidation(message);
    }
    if (message.contains('匿名登录')) {
      return const GroupFailureUnknown('登录状态失效，请重启应用重试');
    }
    return GroupFailureUnknown(message);
  }

  GroupJoinResult _parseResult(dynamic res) {
    final Map<String, dynamic> json = Map<String, dynamic>.from(res as Map);
    return GroupJoinResult(
      groupId: json['group_id'] as String,
      groupName: json['group_name'] as String?,
      inviteCode: json['invite_code'] as String,
    );
  }
}

/// 本地开发实现：未配置 Supabase 时使用。
///
/// - [createGroup] 本地生成邀请码并返回新组；
/// - [joinGroup] 仅当输入与本机已持久化的邀请码一致时视为成功
///   （模拟"同一台设备自建的组"），否则抛 [GroupFailureInvalidCode]。
class LocalGroupRepository implements GroupRepository {
  LocalGroupRepository(this._prefs);

  final SharedPreferences _prefs;
  static const Uuid _uuid = Uuid();

  @override
  Future<GroupJoinResult> createGroup({
    required String groupName,
    required String nickname,
    required String avatarEmoji,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return GroupJoinResult(
      groupId: _uuid.v4(),
      groupName: groupName.trim().isEmpty ? null : groupName.trim(),
      inviteCode: generateInviteCode(),
    );
  }

  @override
  Future<GroupJoinResult> joinGroup({
    required String inviteCode,
    required String nickname,
    required String avatarEmoji,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!isValidInviteCode(inviteCode)) {
      throw const GroupFailureInvalidCode();
    }
    final String? localCode = _prefs.getString(StorageKeys.inviteCode);
    final String code = normalizeInviteCode(inviteCode);
    if (localCode == null || localCode != code) {
      throw const GroupFailureInvalidCode();
    }
    final String? groupId = _prefs.getString(StorageKeys.groupId);
    if (groupId == null) {
      throw const GroupFailureInvalidCode();
    }
    return GroupJoinResult(
      groupId: groupId,
      groupName: _prefs.getString(StorageKeys.groupName),
      inviteCode: code,
    );
  }
}

/// 组仓库 Provider：按是否配置 Supabase 选择实现。
final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  if (SupabaseBootstrap.isInitialized) {
    return SupabaseGroupRepository(
      SupabaseBootstrap.client,
      ref.watch(deviceIdentityServiceProvider),
    );
  }
  return LocalGroupRepository(ref.watch(sharedPreferencesProvider));
});
