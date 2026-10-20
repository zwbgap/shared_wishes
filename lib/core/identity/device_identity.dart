import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_constants.dart';
import '../storage/prefs_provider.dart';

/// 设备身份服务。
///
/// 管理本机 `deviceId`（客户端生成 UUID，作为**同步幂等键**，非鉴权依据）
/// 以及本机昵称 / emoji 的本地缓存。
///
/// 鉴权一律走 Supabase 匿名登录（见 [AuthSessionNotifier]）。
class DeviceIdentityService {
  DeviceIdentityService(this._prefs);

  final SharedPreferences _prefs;
  static const Uuid _uuid = Uuid();

  /// 已持久化的设备 ID（未生成为 null）
  String? get deviceId => _prefs.getString(StorageKeys.deviceId);

  /// 读取或生成设备 ID（幂等）。
  Future<String> ensureDeviceId() async {
    final String? existing = deviceId;
    if (existing != null && existing.isNotEmpty) return existing;
    final String id = _uuid.v4();
    await _prefs.setString(StorageKeys.deviceId, id);
    return id;
  }

  String? get nickname => _prefs.getString(StorageKeys.deviceNickname);

  String? get avatarEmoji => _prefs.getString(StorageKeys.deviceAvatarEmoji);

  /// 保存本机昵称与 emoji 头像。
  Future<void> saveProfile({
    required String nickname,
    required String avatarEmoji,
  }) async {
    await _prefs.setString(StorageKeys.deviceNickname, nickname);
    await _prefs.setString(StorageKeys.deviceAvatarEmoji, avatarEmoji);
  }
}

/// 设备身份服务 Provider。
final deviceIdentityServiceProvider = Provider<DeviceIdentityService>(
  (ref) => DeviceIdentityService(ref.watch(sharedPreferencesProvider)),
);

/// 本机设备 ID（首次读取时自动生成）。
final deviceIdProvider = FutureProvider<String>(
  (ref) => ref.watch(deviceIdentityServiceProvider).ensureDeviceId(),
);
