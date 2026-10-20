import 'package:isar_community/isar.dart';

part 'device_entity.g.dart';

/// 设备实体 —— 本项目"不分账户"，成员以设备为单位。
@collection
class DeviceEntity {
  Id id = Isar.autoIncrement;

  /// 设备唯一 ID（客户端生成 UUID，持久化于安全存储）
  @Index(unique: true, replace: true)
  late String deviceId;

  @Index()
  String? groupId;

  /// 昵称（2~20 字）
  String? nickname;

  /// emoji 头像（见 [kAvatarEmojiPool]）
  String? avatarEmoji;

  /// ios / android
  String? platform;

  /// 设备型号（如 "iPhone 17 Pro" / "OPPO Find X9 Pro"）
  String? modelName;

  /// 是否本机
  bool isMe = false;

  DateTime? lastActiveAt;
}
