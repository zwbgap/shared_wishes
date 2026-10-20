import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/local/entities/wish_entity.dart';
import '../../data/local/local_database.dart';
import '../../data/repositories/membership_store.dart';
import '../constants/app_constants.dart';
import '../supabase/supabase_bootstrap.dart';

/// 愿望远端同步骨架。
///
/// ⚠️ 注意：**尚未在真实 Supabase 项目联调**（本地开发无项目实例）。
/// 列名映射依据 supabase/migrations/0001_init.sql，首次接入真实项目时
/// 需重点验证：realtime 订阅过滤、upsert 冲突键、时间字段时区。
///
/// 职责（仅当 [SupabaseBootstrap.isInitialized] 且已入组时激活）：
/// 1. 启动时全量拉取组内 wishes → upsert 进 Isar；
/// 2. 订阅远端变更（realtime stream）→ upsert 进 Isar；
/// 3. 监听本地 dirty 行 → 推送 upsert 到远端。
///
/// 失败仅记日志；离线队列 / 指数退避重试留待切片 D
/// （见 [AppConstants.syncMaxRetries] / [AppConstants.syncBackoffBase]）。
class RemoteWishSync {
  RemoteWishSync({
    required this.client,
    required this.isar,
    required this.groupId,
  });

  final SupabaseClient client;
  final Isar isar;
  final String groupId;

  static final Logger _log = Logger();

  StreamSubscription<List<Map<String, dynamic>>>? _remoteSub;
  StreamSubscription<List<WishEntity>>? _dirtySub;

  /// 推送重入保护（避免 watcher 在写库清 dirty 时触发并发推送）。
  bool _pushing = false;

  /// 启动同步：先全量拉取，再挂 realtime 订阅与 dirty 监听。
  Future<void> start() async {
    await _pullAll();
    _remoteSub = client
        .from(SupabaseTables.wishes)
        .stream(primaryKey: <String>['id'])
        .eq('group_id', groupId)
        .listen(
          _onRemoteRows,
          onError: (Object e, StackTrace s) =>
              _log.w('wishes realtime 订阅异常', error: e, stackTrace: s),
        );
    _dirtySub = isar.wishEntitys
        .where()
        .groupIdEqualTo(groupId)
        .filter()
        .dirtyEqualTo(true)
        .watch(fireImmediately: true)
        .listen((_) => unawaited(_pushDirty()));
  }

  /// 停止同步（离开组 / Provider 销毁时调用）。
  Future<void> stop() async {
    await _remoteSub?.cancel();
    await _dirtySub?.cancel();
    _remoteSub = null;
    _dirtySub = null;
  }

  // ---- 下行：远端 → 本地 ----

  Future<void> _pullAll() async {
    try {
      final List<Map<String, dynamic>> rows = await client
          .from(SupabaseTables.wishes)
          .select()
          .eq('group_id', groupId);
      await _upsertRows(rows);
    } catch (e, s) {
      _log.w('wishes 全量拉取失败', error: e, stackTrace: s);
    }
  }

  Future<void> _onRemoteRows(List<Map<String, dynamic>> rows) async {
    try {
      await _upsertRows(rows);
    } catch (e, s) {
      _log.w('wishes 远端变更写入本地失败', error: e, stackTrace: s);
    }
  }

  /// 远端行 upsert 进 Isar。本地 dirty 行跳过（本地未推送的变更优先）。
  Future<void> _upsertRows(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await isar.writeTxn(() async {
      for (final Map<String, dynamic> row in rows) {
        final String? remoteId = row['id'] as String?;
        if (remoteId == null) continue;
        WishEntity? entity = await isar.wishEntitys
            .where()
            .remoteIdEqualTo(remoteId)
            .findFirst();
        if (entity != null && entity.dirty) continue;
        entity ??= WishEntity()..remoteId = remoteId;
        applyRemoteRowToEntity(entity, row);
        entity
          ..dirty = false
          ..lastSyncedAt = DateTime.now();
        await isar.wishEntitys.put(entity);
      }
    });
  }

  // ---- 上行：本地 dirty → 远端 ----

  Future<void> _pushDirty() async {
    if (_pushing) return;
    _pushing = true;
    try {
      final List<WishEntity> dirty = await isar.wishEntitys
          .where()
          .groupIdEqualTo(groupId)
          .filter()
          .dirtyEqualTo(true)
          .findAll();
      for (final WishEntity entity in dirty) {
        try {
          await client
              .from(SupabaseTables.wishes)
              .upsert(wishEntityToRemoteRow(entity));
          await isar.writeTxn(() async {
            entity
              ..dirty = false
              ..lastSyncedAt = DateTime.now();
            await isar.wishEntitys.put(entity);
          });
        } catch (e, s) {
          // 队列化重试留切片 D，此处仅记日志，行保持 dirty
          _log.w('wish 推送失败（${entity.remoteId}）', error: e, stackTrace: s);
        }
      }
    } finally {
      _pushing = false;
    }
  }
}

// ---- 纯映射函数（单测可覆盖，无需 Supabase / Isar 实例） ----

/// 状态 → 远端字符串。
String wishStatusToRemote(WishStatus status) => switch (status) {
      WishStatus.pending => 'pending',
      WishStatus.inProgress => 'in_progress',
      WishStatus.completed => 'completed',
    };

/// 远端字符串 → 状态（未知值兜底 pending）。
WishStatus wishStatusFromRemote(Object? value) => switch (value) {
      'in_progress' => WishStatus.inProgress,
      'completed' => WishStatus.completed,
      _ => WishStatus.pending,
    };

DateTime? _parseRemoteDate(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;

/// 本地实体 → 远端行（snake_case 列映射，见 migrations/0001_init.sql）。
Map<String, Object?> wishEntityToRemoteRow(WishEntity entity) {
  return <String, Object?>{
    'id': entity.remoteId,
    'group_id': entity.groupId,
    'title': entity.title,
    'description': entity.description,
    'status': wishStatusToRemote(entity.status),
    'category': entity.category,
    'target_date': entity.targetDate?.toIso8601String(),
    'created_by': entity.createdByDeviceId,
    'created_at': entity.createdAt.toIso8601String(),
    'updated_at': entity.updatedAt.toIso8601String(),
    'completed_by': entity.completedByDeviceId,
    'completed_at': entity.completedAt?.toIso8601String(),
    'completion_notes': entity.completionNotes,
    'version': entity.version,
    'deleted_at': entity.deletedAt?.toIso8601String(),
  };
}

/// 远端行 → 本地实体（就地写入；dirty / lastSyncedAt 由调用方维护）。
void applyRemoteRowToEntity(WishEntity entity, Map<String, dynamic> row) {
  entity
    ..groupId = row['group_id'] as String? ?? entity.groupId
    ..title = row['title'] as String? ?? ''
    ..description = row['description'] as String?
    ..status = wishStatusFromRemote(row['status'])
    ..category = row['category'] as String?
    ..targetDate = _parseRemoteDate(row['target_date'])
    ..createdByDeviceId = row['created_by'] as String?
    ..createdAt = _parseRemoteDate(row['created_at']) ?? DateTime.now()
    ..updatedAt = _parseRemoteDate(row['updated_at']) ?? DateTime.now()
    ..completedByDeviceId = row['completed_by'] as String?
    ..completedAt = _parseRemoteDate(row['completed_at'])
    ..completionNotes = <String>[
      for (final Object? note in (row['completion_notes'] as List? ?? const []))
        if (note is String) note,
    ]
    ..version = row['version'] as int? ?? 1
    ..deletedAt = _parseRemoteDate(row['deleted_at']);
}

/// 远端同步 Provider。
///
/// 未配置 Supabase 或未入组时为 null；入组后自动启动，销毁时自动停止。
final remoteWishSyncProvider = Provider<RemoteWishSync?>((ref) {
  if (!SupabaseBootstrap.isInitialized) return null;
  final String? groupId = ref.watch(currentGroupIdProvider);
  if (groupId == null) return null;

  final RemoteWishSync sync = RemoteWishSync(
    client: SupabaseBootstrap.client,
    isar: LocalDatabase.instance,
    groupId: groupId,
  );
  ref.onDispose(() => unawaited(sync.stop()));
  unawaited(sync.start());
  return sync;
});
