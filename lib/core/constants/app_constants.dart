/// 业务常量（唯一来源）。
abstract final class AppConstants {
  /// 单组人数上限
  static const int maxGroupMembers = 4;

  /// 单组人数下限（1 人即"独享"待加入）
  static const int minGroupMembers = 1;

  /// 邀请码长度
  static const int inviteCodeLength = 8;

  /// 邀请码字符集（已剔除易混淆的 O / 0 / I / 1 / L）
  static const String inviteCodeCharset = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

  /// 昵称长度
  static const int nicknameMinLength = 2;
  static const int nicknameMaxLength = 20;

  /// 组名长度
  static const int groupNameMaxLength = 50;

  /// 愿望标题长度
  static const int wishTitleMaxLength = 100;

  /// 愿望描述长度
  static const int wishDescriptionMaxLength = 500;

  /// 完成纪念文字长度
  static const int completionNoteMaxLength = 200;

  /// 日常记录文字长度
  static const int momentTextMaxLength = 500;

  /// 单条日常最多图片数
  static const int momentMaxImages = 9;

  /// 图片压缩：最长边
  static const int imageMaxDimension = 1920;

  /// 图片压缩：JPEG 质量
  static const int imageJpegQuality = 80;

  /// 图片单张体积上限（字节，3MB）
  static const int imageMaxBytes = 3 * 1024 * 1024;

  /// 同步队列最大重试次数
  static const int syncMaxRetries = 5;

  /// 同步重试指数退避基数
  static const Duration syncBackoffBase = Duration(seconds: 5);

  /// 本地通知默认提醒时间（本地时区 21:30）
  static const int dailyReminderHour = 21;
  static const int dailyReminderMinute = 30;

  /// 缩略图内存缓存宽度
  static const int thumbnailMemCacheWidth = 400;

  /// 磁盘缓存宽度上限
  static const int thumbnailMaxDiskCacheWidth = 800;

  /// 本地图片缓存上限（字节，200MB）
  static const int imageCacheMaxBytes = 200 * 1024 * 1024;
}

/// 本地存储键（SharedPreferences / SecureStorage）。
abstract final class StorageKeys {
  static const String deviceId = 'device_id';
  static const String deviceNickname = 'device_nickname';
  static const String deviceAvatarEmoji = 'device_avatar_emoji';
  static const String groupId = 'group_id';
  static const String groupName = 'group_name';
  static const String inviteCode = 'invite_code';
  static const String onboardingDone = 'onboarding_done';
  static const String darkModePreference = 'dark_mode_preference';
  static const String imageQuality = 'image_quality';
  static const String dailyReminderEnabled = 'daily_reminder_enabled';
  static const String lastSyncAt = 'last_sync_at';
}

/// 同步 / 网络相关。
abstract final class SupabaseTables {
  static const String groups = 'groups';
  static const String devices = 'devices';
  static const String wishes = 'wishes';
  static const String moments = 'moments';

  /// 图片存储桶
  static const String momentsBucket = 'moments-images';
}
