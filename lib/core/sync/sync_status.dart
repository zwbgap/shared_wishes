import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 同步状态（驱动离线横幅 / 上传进度 UI）。
enum SyncStatus {
  /// 空闲（在线且无待同步项）
  idle,

  /// 正在同步
  syncing,

  /// 离线（本地操作正常，队列持久化）
  offline,

  /// 同步出错（可重试）
  error,
}

/// Riverpod 骨架示例：全局同步状态。
///
/// Phase 1 将由 `SyncEngine`（connectivity_plus + Isar sync_items + Supabase）
/// 驱动本状态。
class SyncStatusNotifier extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.idle;

  void update(SyncStatus status) => state = status;
}

final NotifierProvider<SyncStatusNotifier, SyncStatus> syncStatusProvider =
    NotifierProvider<SyncStatusNotifier, SyncStatus>(SyncStatusNotifier.new);
