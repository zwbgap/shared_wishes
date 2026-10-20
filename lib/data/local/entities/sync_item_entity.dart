import 'package:isar_community/isar.dart';

part 'sync_item_entity.g.dart';

/// 同步动作类型。
enum SyncAction {
  create,
  update,
  delete,
  markCompleted,

  /// 图片二进制上传
  uploadImage,
}

/// 同步队列项 —— **持久化**在本地 DB，进程被杀后可续传
/// （ColorOS 16 后台策略较激进，这是必须的）。
@collection
class SyncItemEntity {
  Id id = Isar.autoIncrement;

  /// 目标实体类型（wish / moment / device / group）
  @Index()
  late String entityType;

  /// 目标实体 remoteId
  @Index()
  late String entityId;

  @enumerated
  @Index()
  late SyncAction action;

  /// 变更载荷（JSON 字符串）
  late String payloadJson;

  /// 入队时间（离线场景下决定 Last-write-wins 的先后）
  @Index()
  late DateTime createdAt;

  int retryCount = 0;

  DateTime? lastAttemptAt;

  /// 最近一次失败原因
  String? lastError;
}
