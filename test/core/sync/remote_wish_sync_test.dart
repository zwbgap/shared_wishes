// 远端同步映射单测：仅覆盖纯映射函数，不触碰 Supabase / Isar 实例。
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_wishes/core/sync/remote_wish_sync.dart';
import 'package:shared_wishes/data/local/entities/wish_entity.dart';

void main() {
  group('状态映射', () {
    test('WishStatus → 远端字符串', () {
      expect(wishStatusToRemote(WishStatus.pending), 'pending');
      expect(wishStatusToRemote(WishStatus.inProgress), 'in_progress');
      expect(wishStatusToRemote(WishStatus.completed), 'completed');
    });

    test('远端字符串 → WishStatus（未知值兜底 pending）', () {
      expect(wishStatusFromRemote('pending'), WishStatus.pending);
      expect(wishStatusFromRemote('in_progress'), WishStatus.inProgress);
      expect(wishStatusFromRemote('completed'), WishStatus.completed);
      expect(wishStatusFromRemote('unknown'), WishStatus.pending);
      expect(wishStatusFromRemote(null), WishStatus.pending);
    });

    test('状态映射往返一致', () {
      for (final WishStatus s in WishStatus.values) {
        expect(wishStatusFromRemote(wishStatusToRemote(s)), s);
      }
    });
  });

  group('wishEntityToRemoteRow', () {
    test('snake_case 列映射完整', () {
      final WishEntity entity = WishEntity()
        ..remoteId = 'r1'
        ..groupId = 'g1'
        ..title = '去看极光'
        ..description = '冬天出发'
        ..status = WishStatus.completed
        ..category = 'travel'
        ..targetDate = DateTime.utc(2026, 12, 25)
        ..createdByDeviceId = 'dev-1'
        ..createdAt = DateTime.utc(2026, 1, 1)
        ..updatedAt = DateTime.utc(2026, 1, 2)
        ..completedByDeviceId = 'dev-2'
        ..completedAt = DateTime.utc(2026, 2, 1)
        ..completionNotes = <String>['圆梦了']
        ..version = 3
        ..deletedAt = null;

      final Map<String, Object?> row = wishEntityToRemoteRow(entity);

      expect(row['id'], 'r1');
      expect(row['group_id'], 'g1');
      expect(row['title'], '去看极光');
      expect(row['description'], '冬天出发');
      expect(row['status'], 'completed');
      expect(row['category'], 'travel');
      expect(row['target_date'], DateTime.utc(2026, 12, 25).toIso8601String());
      expect(row['created_by'], 'dev-1');
      expect(row['created_at'], DateTime.utc(2026, 1, 1).toIso8601String());
      expect(row['updated_at'], DateTime.utc(2026, 1, 2).toIso8601String());
      expect(row['completed_by'], 'dev-2');
      expect(row['completed_at'], DateTime.utc(2026, 2, 1).toIso8601String());
      expect(row['completion_notes'], <String>['圆梦了']);
      expect(row['version'], 3);
      expect(row['deleted_at'], isNull);
    });

    test('软删除写入 deleted_at', () {
      final WishEntity entity = WishEntity()
        ..remoteId = 'r1'
        ..groupId = 'g1'
        ..title = 't'
        ..createdAt = DateTime.utc(2026)
        ..updatedAt = DateTime.utc(2026)
        ..deletedAt = DateTime.utc(2026, 3, 3);

      expect(wishEntityToRemoteRow(entity)['deleted_at'],
          DateTime.utc(2026, 3, 3).toIso8601String());
    });
  });

  group('applyRemoteRowToEntity', () {
    test('远端行字段正确落到实体', () {
      final WishEntity entity = WishEntity()
        ..remoteId = 'r1'
        ..groupId = 'g1'
        ..title = '';

      applyRemoteRowToEntity(entity, <String, dynamic>{
        'id': 'r1',
        'group_id': 'g1',
        'title': '去吃日料',
        'description': null,
        'status': 'in_progress',
        'category': 'food',
        'target_date': '2026-12-25T00:00:00.000Z',
        'created_by': 'dev-1',
        'created_at': '2026-01-01T00:00:00.000Z',
        'updated_at': '2026-01-02T00:00:00.000Z',
        'completed_by': null,
        'completed_at': null,
        'completion_notes': <dynamic>['第一条', 42, '第二条'],
        'version': 5,
        'deleted_at': '2026-03-03T00:00:00.000Z',
      });

      expect(entity.title, '去吃日料');
      expect(entity.description, isNull);
      expect(entity.status, WishStatus.inProgress);
      expect(entity.category, 'food');
      expect(entity.targetDate, DateTime.utc(2026, 12, 25));
      expect(entity.createdByDeviceId, 'dev-1');
      expect(entity.createdAt, DateTime.utc(2026));
      expect(entity.updatedAt, DateTime.utc(2026, 1, 2));
      expect(entity.completedByDeviceId, isNull);
      expect(entity.completedAt, isNull);
      // 非字符串项被过滤，内容不丢
      expect(entity.completionNotes, <String>['第一条', '第二条']);
      expect(entity.version, 5);
      expect(entity.deletedAt, DateTime.utc(2026, 3, 3));
    });

    test('映射往返：entity → row → entity 关键字段一致', () {
      final WishEntity source = WishEntity()
        ..remoteId = 'r9'
        ..groupId = 'g9'
        ..title = '学做提拉米苏'
        ..description = '月底前'
        ..status = WishStatus.completed
        ..category = 'study'
        ..createdByDeviceId = 'dev-1'
        ..createdAt = DateTime.utc(2026, 5, 1)
        ..updatedAt = DateTime.utc(2026, 5, 2)
        ..completedByDeviceId = 'dev-1'
        ..completedAt = DateTime.utc(2026, 5, 3)
        ..completionNotes = <String>['好吃']
        ..version = 2;

      final WishEntity restored = WishEntity()
        ..remoteId = 'x'
        ..groupId = 'x'
        ..title = '';
      applyRemoteRowToEntity(restored, wishEntityToRemoteRow(source));

      expect(restored.title, source.title);
      expect(restored.description, source.description);
      expect(restored.status, source.status);
      expect(restored.category, source.category);
      expect(restored.createdByDeviceId, source.createdByDeviceId);
      expect(restored.createdAt, source.createdAt);
      expect(restored.updatedAt, source.updatedAt);
      expect(restored.completedByDeviceId, source.completedByDeviceId);
      expect(restored.completedAt, source.completedAt);
      expect(restored.completionNotes, source.completionNotes);
      expect(restored.version, source.version);
      expect(restored.deletedAt, isNull);
    });
  });
}
