import 'package:isar_community/isar.dart';

part 'moment_entity.g.dart';

/// 日常记录本地实体（照片 + 文字）。
@collection
class MomentEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String remoteId;

  @Index()
  late String groupId;

  String? text;

  /// 本地图片路径（未上传完成前使用，保证离线可预览）
  List<String> localImagePaths = <String>[];

  /// 已上传后的 CDN URL（带签名）
  List<String> remoteImageUrls = <String>[];

  double? latitude;
  double? longitude;
  String? placeName;

  String? createdByDeviceId;
  DateTime createdAt = DateTime.now();

  int version = 1;

  /// 存在未上传完成的图片或未推送的变更
  @Index()
  bool dirty = false;

  /// 图片上传进度（0.0 ~ 1.0）
  double uploadProgress = 0;

  DateTime? deletedAt;
  DateTime? lastSyncedAt;
}
