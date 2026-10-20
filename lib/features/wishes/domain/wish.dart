import '../../../data/local/entities/wish_entity.dart';

export '../../../data/local/entities/wish_entity.dart' show WishStatus;

/// 愿望清单筛选维度。
enum WishFilter { all, active, completed }

/// 愿望领域模型（不可变）。
///
/// 与 [WishEntity] 的区别：不含 Isar 自增主键与同步元数据（dirty /
/// lastSyncedAt），UI 层只依赖本模型。
class Wish {
  const Wish({
    required this.remoteId,
    required this.groupId,
    required this.title,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.completionNotes,
    required this.version,
    this.description,
    this.category,
    this.targetDate,
    this.createdByDeviceId,
    this.completedByDeviceId,
    this.completedAt,
  });

  /// 服务端主键（客户端生成 UUID，同步幂等键）
  final String remoteId;
  final String groupId;
  final String title;
  final String? description;
  final WishStatus status;

  /// 分类 key（见 kWishCategories）
  final String? category;
  final DateTime? targetDate;
  final String? createdByDeviceId;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? completedByDeviceId;
  final DateTime? completedAt;
  final List<String> completionNotes;
  final int version;

  bool get completed => status == WishStatus.completed;

  Wish copyWith({
    String? title,
    String? Function()? description,
    WishStatus? status,
    String? Function()? category,
    DateTime? Function()? targetDate,
    String? Function()? completedByDeviceId,
    DateTime? Function()? completedAt,
    DateTime? updatedAt,
    List<String>? completionNotes,
    int? version,
  }) {
    return Wish(
      remoteId: remoteId,
      groupId: groupId,
      title: title ?? this.title,
      description: description != null ? description() : this.description,
      status: status ?? this.status,
      category: category != null ? category() : this.category,
      targetDate: targetDate != null ? targetDate() : this.targetDate,
      createdByDeviceId: createdByDeviceId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedByDeviceId: completedByDeviceId != null
          ? completedByDeviceId()
          : this.completedByDeviceId,
      completedAt: completedAt != null ? completedAt() : this.completedAt,
      completionNotes: completionNotes ?? this.completionNotes,
      version: version ?? this.version,
    );
  }

  /// 领域模型 ← Isar 实体。
  factory Wish.fromEntity(WishEntity entity) {
    return Wish(
      remoteId: entity.remoteId,
      groupId: entity.groupId,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      category: entity.category,
      targetDate: entity.targetDate,
      createdByDeviceId: entity.createdByDeviceId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      completedByDeviceId: entity.completedByDeviceId,
      completedAt: entity.completedAt,
      completionNotes: List<String>.unmodifiable(entity.completionNotes),
      version: entity.version,
    );
  }
}
