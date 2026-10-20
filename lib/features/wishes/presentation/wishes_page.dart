import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/haptics/platform_haptics.dart';
import '../../../core/identity/device_identity.dart';
import '../../../core/platform/platform_info.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/repositories/membership_store.dart';
import '../../../data/repositories/wish_repository.dart';
import '../../../shared/widgets/adaptive_page_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/wish_card.dart';
import '../domain/wish.dart';
import 'wish_edit_sheet.dart';

/// Tab 1：愿望清单（主入口）。
class WishesPage extends ConsumerStatefulWidget {
  const WishesPage({super.key});

  @override
  ConsumerState<WishesPage> createState() => _WishesPageState();
}

class _WishesPageState extends ConsumerState<WishesPage>
    with AutomaticKeepAliveClientMixin {
  final PlatformHaptics _haptics = PlatformHaptics.forCurrentPlatform();

  @override
  bool get wantKeepAlive => true;

  /// 本机设备 ID（build 中 watch 赋值，供回调与文案使用）。
  String? _myDeviceId;

  // ---- 数据操作 ----

  Future<void> _createWish() async {
    unawaited(_haptics.trigger(HapticEvent.fabTap));
    final WishEditResult? result = await WishEditSheet.show(context);
    if (result == null) return;

    final String? groupId = ref.read(currentGroupIdProvider);
    final String? deviceId = _myDeviceId;
    if (groupId == null || deviceId == null) return;

    await ref.read(wishRepositoryProvider).create(
          groupId: groupId,
          title: result.title,
          createdByDeviceId: deviceId,
          description: result.description,
          category: result.category,
          targetDate: result.targetDate,
        );
    unawaited(_haptics.trigger(HapticEvent.saveSuccess));
  }

  Future<void> _editWish(Wish wish) async {
    final WishEditResult? result =
        await WishEditSheet.show(context, existing: wish);
    if (result == null) return;

    await ref.read(wishRepositoryProvider).update(
          remoteId: wish.remoteId,
          title: result.title,
          description: result.description,
          category: result.category,
          targetDate: result.targetDate,
        );
    unawaited(_haptics.trigger(HapticEvent.saveSuccess));
  }

  Future<void> _toggleWish(Wish wish) async {
    // 依据设计文档 Part 7：标记完成用强确认，取消用轻反馈
    unawaited(
      _haptics.trigger(
        wish.completed ? HapticEvent.checkboxOff : HapticEvent.wishCompleted,
      ),
    );
    final String? deviceId = _myDeviceId;
    if (deviceId == null) return;
    await ref.read(wishRepositoryProvider).setCompleted(
          remoteId: wish.remoteId,
          completed: !wish.completed,
          deviceId: deviceId,
        );
  }

  Future<bool> _confirmDelete(Wish wish) async {
    unawaited(_haptics.trigger(HapticEvent.swipeThreshold));
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('删除愿望'),
        content: Text('确定删除「${wish.title}」吗？'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(wishRepositoryProvider).delete(wish.remoteId);
      return true;
    }
    return false;
  }

  // ---- 展示文案 ----

  String _createdByLabel(Wish wish) {
    final DeviceIdentityService identity =
        ref.read(deviceIdentityServiceProvider);
    if (wish.createdByDeviceId != null &&
        wish.createdByDeviceId == _myDeviceId) {
      return '来自 ${identity.avatarEmoji ?? ''} ${identity.nickname ?? '我'}'
          .trim();
    }
    return '来自 小伙伴';
  }

  String _completedByLabel(Wish wish) {
    final DeviceIdentityService identity =
        ref.read(deviceIdentityServiceProvider);
    final String who =
        wish.completedByDeviceId != null && wish.completedByDeviceId == _myDeviceId
            ? (identity.nickname ?? '我')
            : '小伙伴';
    final String when = wish.completedAt == null
        ? ''
        : '于${DateFormat('M月d日').format(wish.completedAt!)}';
    return '✨ $who完成$when';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _myDeviceId = ref.watch(deviceIdProvider).value;
    final WishFilter filter = ref.watch(wishFilterProvider);
    final AsyncValue<List<Wish>> wishesValue = ref.watch(wishesProvider(filter));

    return AdaptivePageScaffold(
      title: '愿望',
      filterBar: _buildFilterBar(filter),
      fab: FloatingActionButton(
        heroTag: null,
        tooltip: '新愿望',
        onPressed: _createWish,
        child: const Icon(Icons.add),
      ),
      body: switch (wishesValue) {
        AsyncData(:final List<Wish> value) => _buildList(value, filter),
        AsyncError(:final Object error) => EmptyState(
            emoji: '⚠️',
            title: '加载失败',
            subtitle: '$error',
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildList(List<Wish> wishes, WishFilter filter) {
    if (wishes.isEmpty) {
      return EmptyState(
        emoji: '🎯',
        title: filter == WishFilter.completed ? '还没有已完成的愿望' : '还没有愿望',
        subtitle: '一起创建第一个吧',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      itemCount: wishes.length,
      itemBuilder: (BuildContext context, int index) {
        final Wish wish = wishes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Dismissible(
            key: ValueKey<String>(wish.remoteId),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _confirmDelete(wish),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.base),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(
                  AppPlatform.isIOS ? AppRadius.iosCard : AppRadius.androidCard,
                ),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
            child: WishCard(
              title: wish.title,
              description: wish.description,
              categoryLabel: wish.category == null
                  ? null
                  : kWishCategories[wish.category],
              targetDateLabel: wish.targetDate == null
                  ? null
                  : '📅 ${DateFormat('M月d日').format(wish.targetDate!)}',
              createdByLabel: _createdByLabel(wish),
              completed: wish.completed,
              completedByLabel:
                  wish.completed ? _completedByLabel(wish) : null,
              onToggle: () => _toggleWish(wish),
              onTap: () => _editWish(wish),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterBar(WishFilter filter) {
    void onChanged(WishFilter value) {
      _haptics.trigger(HapticEvent.tabSwitch);
      ref.read(wishFilterProvider.notifier).set(value);
    }

    if (AppPlatform.isIOS) {
      return CupertinoSlidingSegmentedControl<WishFilter>(
        groupValue: filter,
        onValueChanged: (WishFilter? value) {
          if (value == null) return;
          onChanged(value);
        },
        children: const <WishFilter, Widget>{
          WishFilter.all: Text('全部'),
          WishFilter.active: Text('进行中'),
          WishFilter.completed: Text('已完成'),
        },
      );
    }
    return SegmentedButton<WishFilter>(
      segments: const <ButtonSegment<WishFilter>>[
        ButtonSegment<WishFilter>(value: WishFilter.all, label: Text('全部')),
        ButtonSegment<WishFilter>(value: WishFilter.active, label: Text('进行中')),
        ButtonSegment<WishFilter>(
          value: WishFilter.completed,
          label: Text('已完成'),
        ),
      ],
      selected: <WishFilter>{filter},
      onSelectionChanged: (Set<WishFilter> selection) =>
          onChanged(selection.first),
    );
  }
}
