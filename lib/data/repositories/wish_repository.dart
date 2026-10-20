import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../../features/wishes/domain/wish.dart';
import '../local/entities/wish_entity.dart';
import '../local/local_database.dart';
import 'membership_store.dart';

/// 愿望仓库：愿望的查询与写入。
///
/// 离线优先：所有写入先落 Isar（标记 dirty），远端同步由
/// RemoteWishSync 负责（见 core/sync/remote_wish_sync.dart）。
abstract interface class WishRepository {
  /// 监听组内愿望列表（已排除软删除），首帧立即发射。
  ///
  /// 排序：未完成在前（createdAt 倒序），已完成在后（completedAt 倒序）。
  Stream<List<Wish>> watchWishes({
    required String groupId,
    required WishFilter filter,
  });

  /// 新建愿望，返回创建后的领域模型。
  Future<Wish> create({
    required String groupId,
    required String title,
    required String createdByDeviceId,
    String? description,
    String? category,
    DateTime? targetDate,
  });

  /// 更新可编辑字段（标题 / 描述 / 分类 / 目标日期）。
  Future<void> update({
    required String remoteId,
    required String title,
    String? description,
    String? category,
    DateTime? targetDate,
  });

  /// 标记完成 / 重新激活（completed → inProgress，单向不回 pending）。
  Future<void> setCompleted({
    required String remoteId,
    required bool completed,
    required String deviceId,
  });

  /// 软删除（删除优先于编辑，冲突时以删除为准）。
  Future<void> delete(String remoteId);
}

/// Isar 本地实现。
class IsarWishRepository implements WishRepository {
  IsarWishRepository(this._isar);

  final Isar _isar;
  static const Uuid _uuid = Uuid();

  @override
  Stream<List<Wish>> watchWishes({
    required String groupId,
    required WishFilter filter,
  }) {
    final QueryBuilder<WishEntity, WishEntity, QAfterFilterCondition> base =
        _isar.wishEntitys.where().groupIdEqualTo(groupId).filter().deletedAtIsNull();

    final QueryBuilder<WishEntity, WishEntity, QAfterFilterCondition> query =
        switch (filter) {
      WishFilter.all => base,
      WishFilter.active => base.and().not().statusEqualTo(WishStatus.completed),
      WishFilter.completed => base.and().statusEqualTo(WishStatus.completed),
    };

    return query.watch(fireImmediately: true).map(
          (List<WishEntity> entities) => _sort(
            entities.map(Wish.fromEntity).toList(),
          ),
        );
  }

  List<Wish> _sort(List<Wish> wishes) {
    int compareDate(DateTime? a, DateTime? b) {
      // null 视为最小（排最后）
      if (a == null && b == null) return 0;
      if (a == null) return 1;
      if (b == null) return -1;
      return b.compareTo(a); // 倒序：新的在前
    }

    wishes.sort((Wish a, Wish b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return a.completed
          ? compareDate(a.completedAt, b.completedAt)
          : compareDate(a.createdAt, b.createdAt);
    });
    return wishes;
  }

  @override
  Future<Wish> create({
    required String groupId,
    required String title,
    required String createdByDeviceId,
    String? description,
    String? category,
    DateTime? targetDate,
  }) async {
    final DateTime now = DateTime.now();
    final WishEntity entity = WishEntity()
      ..remoteId = _uuid.v4()
      ..groupId = groupId
      ..title = title
      ..description = description
      ..status = WishStatus.pending
      ..category = category
      ..targetDate = targetDate
      ..createdByDeviceId = createdByDeviceId
      ..createdAt = now
      ..updatedAt = now
      ..version = 1
      ..dirty = true;

    await _isar.writeTxn(() => _isar.wishEntitys.put(entity));
    return Wish.fromEntity(entity);
  }

  @override
  Future<void> update({
    required String remoteId,
    required String title,
    String? description,
    String? category,
    DateTime? targetDate,
  }) async {
    await _isar.writeTxn(() async {
      final WishEntity? entity =
          await _isar.wishEntitys.where().remoteIdEqualTo(remoteId).findFirst();
      if (entity == null || entity.deletedAt != null) return;
      entity
        ..title = title
        ..description = description
        ..category = category
        ..targetDate = targetDate
        ..updatedAt = DateTime.now()
        ..version = entity.version + 1
        ..dirty = true;
      await _isar.wishEntitys.put(entity);
    });
  }

  @override
  Future<void> setCompleted({
    required String remoteId,
    required bool completed,
    required String deviceId,
  }) async {
    await _isar.writeTxn(() async {
      final WishEntity? entity =
          await _isar.wishEntitys.where().remoteIdEqualTo(remoteId).findFirst();
      if (entity == null || entity.deletedAt != null) return;
      if (completed) {
        entity
          ..status = WishStatus.completed
          ..completedByDeviceId = deviceId
          ..completedAt = DateTime.now();
      } else {
        // 重新激活：回到 inProgress（不回 pending，保留历史轨迹）
        entity
          ..status = WishStatus.inProgress
          ..completedByDeviceId = null
          ..completedAt = null;
      }
      entity
        ..updatedAt = DateTime.now()
        ..version = entity.version + 1
        ..dirty = true;
      await _isar.wishEntitys.put(entity);
    });
  }

  @override
  Future<void> delete(String remoteId) async {
    await _isar.writeTxn(() async {
      final WishEntity? entity =
          await _isar.wishEntitys.where().remoteIdEqualTo(remoteId).findFirst();
      if (entity == null || entity.deletedAt != null) return;
      entity
        ..deletedAt = DateTime.now()
        ..updatedAt = DateTime.now()
        ..version = entity.version + 1
        ..dirty = true;
      await _isar.wishEntitys.put(entity);
    });
  }
}

/// 愿望仓库 Provider。
final wishRepositoryProvider = Provider<WishRepository>(
  (ref) => IsarWishRepository(LocalDatabase.instance),
);

/// 当前筛选维度。
class WishFilterNotifier extends Notifier<WishFilter> {
  @override
  WishFilter build() => WishFilter.all;

  void set(WishFilter filter) => state = filter;
}

/// 筛选维度 Provider。
final wishFilterProvider =
    NotifierProvider<WishFilterNotifier, WishFilter>(WishFilterNotifier.new);

/// 当前组的愿望列表（随筛选维度变化）。
final wishesProvider = StreamProvider.family<List<Wish>, WishFilter>(
  (ref, filter) {
    final String? groupId = ref.watch(currentGroupIdProvider);
    if (groupId == null) {
      return Stream<List<Wish>>.value(const <Wish>[]);
    }
    return ref
        .watch(wishRepositoryProvider)
        .watchWishes(groupId: groupId, filter: filter);
  },
);
