import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/platform/platform_info.dart';
import '../../core/storage/prefs_provider.dart';
import '../local/entities/device_entity.dart';
import '../local/entities/group_entity.dart';
import '../local/local_database.dart';
import 'group_repository.dart';

/// 成员身份本地持久化。
///
/// 建组 / 入组成功后，把组信息与"我"的设备信息写入 Isar，
/// 并在 SharedPreferences 记录引导完成标记与组快照（快速分流用）。
abstract interface class MembershipStore {
  /// 是否已完成首次引导（以本地组快照为准）。
  bool get hasCompletedOnboarding;

  /// 当前组 ID（未入组为 null）。
  String? get currentGroupId;

  /// 当前组邀请码（未入组为 null）。
  String? get currentInviteCode;

  /// 持久化成员身份。
  Future<void> saveMembership({
    required GroupJoinResult result,
    required String deviceId,
    required String nickname,
    required String avatarEmoji,
  });

  /// 清空成员身份（离开组 / 解散组时使用）。
  Future<void> clear();
}

/// Isar + SharedPreferences 实现。
class IsarMembershipStore implements MembershipStore {
  IsarMembershipStore(this._prefs);

  final SharedPreferences _prefs;

  @override
  bool get hasCompletedOnboarding =>
      (_prefs.getBool(StorageKeys.onboardingDone) ?? false) &&
      currentGroupId != null;

  @override
  String? get currentGroupId => _prefs.getString(StorageKeys.groupId);

  @override
  String? get currentInviteCode => _prefs.getString(StorageKeys.inviteCode);

  @override
  Future<void> saveMembership({
    required GroupJoinResult result,
    required String deviceId,
    required String nickname,
    required String avatarEmoji,
  }) async {
    final Isar isar = LocalDatabase.instance;
    await isar.writeTxn(() async {
      await isar.groupEntitys.put(
        GroupEntity()
          ..groupId = result.groupId
          ..name = result.groupName
          ..inviteCode = result.inviteCode
          ..createdAt = DateTime.now()
          ..memberCount = 1
          ..lastSyncedAt = null,
      );
      await isar.deviceEntitys.put(
        DeviceEntity()
          ..deviceId = deviceId
          ..groupId = result.groupId
          ..nickname = nickname
          ..avatarEmoji = avatarEmoji
          ..platform = AppPlatform.isIOS ? 'ios' : 'android'
          ..modelName = null
          ..isMe = true
          ..lastActiveAt = DateTime.now(),
      );
    });

    await _prefs.setString(StorageKeys.groupId, result.groupId);
    await _prefs.setString(StorageKeys.inviteCode, result.inviteCode);
    if (result.groupName != null) {
      await _prefs.setString(StorageKeys.groupName, result.groupName!);
    } else {
      await _prefs.remove(StorageKeys.groupName);
    }
    await _prefs.setBool(StorageKeys.onboardingDone, true);
  }

  @override
  Future<void> clear() async {
    final Isar isar = LocalDatabase.instance;
    await isar.writeTxn(() async {
      await isar.groupEntitys.clear();
      await isar.deviceEntitys.clear();
    });
    await _prefs.remove(StorageKeys.groupId);
    await _prefs.remove(StorageKeys.groupName);
    await _prefs.remove(StorageKeys.inviteCode);
    await _prefs.setBool(StorageKeys.onboardingDone, false);
  }
}

/// 成员身份存储 Provider。
final membershipStoreProvider = Provider<MembershipStore>(
  (ref) => IsarMembershipStore(ref.watch(sharedPreferencesProvider)),
);

/// 当前组 ID（未入组为 null）。
///
/// 该值只在引导完成 / 离开组时变化；变化由调用方显式
/// `ref.invalidate(currentGroupIdProvider)` 触发。
final currentGroupIdProvider = Provider<String?>(
  (ref) => ref.watch(membershipStoreProvider).currentGroupId,
);
