import 'package:isar_community/isar.dart';

part 'wish_entity.g.dart';

/// 愿望状态。
///
/// 状态流转（单向，保证成就感严肃性）：
/// pending → inProgress → completed
/// completed 不可直接回退，只能"重新激活"回到 inProgress。
enum WishStatus { pending, inProgress, completed }

/// 愿望本地实体（离线优先的唯一写入目标）。
@collection
class WishEntity {
  Id id = Isar.autoIncrement;

  /// 服务端主键（客户端生成的 UUID），同步幂等键
  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String groupId;

  late String title;
  String? description;

  @enumerated
  @Index()
  WishStatus status = WishStatus.pending;

  /// 分类 key（见 [kWishCategories]）
  String? category;

  /// 目标日期
  DateTime? targetDate;

  /// 创建者设备 ID
  String? createdByDeviceId;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // ---- 完成标记（"已完成"闭环） ----
  /// 标记完成者设备 ID
  String? completedByDeviceId;
  DateTime? completedAt;

  /// 完成纪念文字。冲突时多方文字都保留为数组（不丢内容）
  List<String> completionNotes = <String>[];

  // ---- 同步元数据 ----
  int version = 1;

  /// 本地存在未推送的变更
  @Index()
  bool dirty = false;

  /// 软删除时间（删除优先于编辑）
  DateTime? deletedAt;

  DateTime? lastSyncedAt;
}
