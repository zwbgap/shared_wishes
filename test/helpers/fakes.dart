// 测试用内存 fake：不依赖 Isar 原生库（widget 测试环境无 core 库）。
import 'dart:async';

import 'package:shared_wishes/data/repositories/group_repository.dart';
import 'package:shared_wishes/data/repositories/membership_store.dart';
import 'package:shared_wishes/data/repositories/wish_repository.dart';
import 'package:shared_wishes/features/wishes/domain/wish.dart';

/// 内存版愿望仓库：行为对齐接口契约，变更通过广播流通知。
class FakeWishRepository implements WishRepository {
  FakeWishRepository([List<Wish>? seed]) : wishes = List.of(seed ?? const []);

  final List<Wish> wishes;
  final StreamController<void> _changes = StreamController<void>.broadcast();
  int _seq = 0;

  List<Wish> _apply(WishFilter filter) => switch (filter) {
        WishFilter.all => List<Wish>.of(wishes),
        WishFilter.active =>
          wishes.where((Wish w) => !w.completed).toList(),
        WishFilter.completed =>
          wishes.where((Wish w) => w.completed).toList(),
      };

  @override
  Stream<List<Wish>> watchWishes({
    required String groupId,
    required WishFilter filter,
  }) async* {
    yield _apply(filter);
    await for (final void _ in _changes.stream) {
      yield _apply(filter);
    }
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
    final Wish wish = Wish(
      remoteId: 'fake-${_seq++}',
      groupId: groupId,
      title: title,
      status: WishStatus.pending,
      createdAt: now,
      updatedAt: now,
      completionNotes: const <String>[],
      version: 1,
      description: description,
      category: category,
      targetDate: targetDate,
      createdByDeviceId: createdByDeviceId,
    );
    wishes.add(wish);
    _changes.add(null);
    return wish;
  }

  @override
  Future<void> update({
    required String remoteId,
    required String title,
    String? description,
    String? category,
    DateTime? targetDate,
  }) async {
    final int i = wishes.indexWhere((Wish w) => w.remoteId == remoteId);
    if (i < 0) return;
    wishes[i] = wishes[i].copyWith(
      title: title,
      description: () => description,
      category: () => category,
      targetDate: () => targetDate,
    );
    _changes.add(null);
  }

  @override
  Future<void> setCompleted({
    required String remoteId,
    required bool completed,
    required String deviceId,
  }) async {
    final int i = wishes.indexWhere((Wish w) => w.remoteId == remoteId);
    if (i < 0) return;
    final Wish w = wishes[i];
    wishes[i] = completed
        ? w.copyWith(
            status: WishStatus.completed,
            completedByDeviceId: () => deviceId,
            completedAt: () => DateTime.now(),
          )
        : w.copyWith(
            status: WishStatus.inProgress,
            completedByDeviceId: () => null,
            completedAt: () => null,
          );
    _changes.add(null);
  }

  @override
  Future<void> delete(String remoteId) async {
    wishes.removeWhere((Wish w) => w.remoteId == remoteId);
    _changes.add(null);
  }

  void dispose() => _changes.close();
}

/// 固定结果的建组仓库。
class FakeGroupRepository implements GroupRepository {
  FakeGroupRepository({
    this.result = const GroupJoinResult(
      groupId: 'g1',
      inviteCode: 'TEST2345',
      groupName: '测试小窝',
    ),
  });

  final GroupJoinResult result;

  @override
  Future<GroupJoinResult> createGroup({
    required String groupName,
    required String nickname,
    required String avatarEmoji,
  }) async =>
      result;

  @override
  Future<GroupJoinResult> joinGroup({
    required String inviteCode,
    required String nickname,
    required String avatarEmoji,
  }) async =>
      result;
}

/// 内存版成员身份存储（不写 Isar）。
class FakeMembershipStore implements MembershipStore {
  bool _done = false;
  String? _groupId;
  String? _inviteCode;

  int saveCount = 0;

  @override
  bool get hasCompletedOnboarding => _done && _groupId != null;

  @override
  String? get currentGroupId => _groupId;

  @override
  String? get currentInviteCode => _inviteCode;

  @override
  Future<void> saveMembership({
    required GroupJoinResult result,
    required String deviceId,
    required String nickname,
    required String avatarEmoji,
  }) async {
    _done = true;
    _groupId = result.groupId;
    _inviteCode = result.inviteCode;
    saveCount++;
  }

  @override
  Future<void> clear() async {
    _done = false;
    _groupId = null;
    _inviteCode = null;
  }
}
