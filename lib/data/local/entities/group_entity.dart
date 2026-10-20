import 'package:isar_community/isar.dart';

part 'group_entity.g.dart';

/// 组本地实体（2~4 人共享空间）。
///
/// 一个设备只属于一个组，因此本地仅保留一条记录。
@collection
class GroupEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String groupId;

  String? name;

  /// 8 位邀请码（已剔除易混淆字符）
  String? inviteCode;

  DateTime createdAt = DateTime.now();

  int memberCount = 1;

  DateTime? lastSyncedAt;
}
