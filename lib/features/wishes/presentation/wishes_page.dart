import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/haptics/platform_haptics.dart';
import '../../../core/platform/platform_info.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../shared/widgets/adaptive_page_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/wish_card.dart';

/// 愿望清单筛选维度。
enum WishFilter { all, active, completed }

/// Tab 1：愿望清单（主入口）。
class WishesPage extends StatefulWidget {
  const WishesPage({super.key});

  @override
  State<WishesPage> createState() => _WishesPageState();
}

class _WishesPageState extends State<WishesPage>
    with AutomaticKeepAliveClientMixin {
  final PlatformHaptics _haptics = PlatformHaptics.forCurrentPlatform();
  WishFilter _filter = WishFilter.all;

  // 骨架阶段使用演示数据（Phase 1 接入 Isar + Supabase 后移除）
  final List<_DemoWish> _wishes = <_DemoWish>[
    _DemoWish(
      title: '周末去吃那家日料',
      description: '藏在小巷里的老店',
      categoryLabel: '🍣 美食',
      targetDateLabel: '📅 下周六',
      createdByLabel: '来自 🐱 小明',
    ),
    _DemoWish(
      title: '一起去看极光',
      description: '想在冬天出发',
      categoryLabel: '✈️ 旅行',
      createdByLabel: '来自 🐶 小红',
    ),
    _DemoWish(
      title: '学会做提拉米苏',
      categoryLabel: '💡 学习',
      targetDateLabel: '📅 月底前',
      createdByLabel: '来自 🐱 小明',
      completed: true,
      completedByLabel: '✨ 小红完成于昨天',
    ),
  ];

  @override
  bool get wantKeepAlive => true;

  List<_DemoWish> get _visibleWishes => switch (_filter) {
        WishFilter.all => _wishes,
        WishFilter.active =>
          _wishes.where((_DemoWish w) => !w.completed).toList(),
        WishFilter.completed =>
          _wishes.where((_DemoWish w) => w.completed).toList(),
      };

  void _toggleWish(_DemoWish wish) {
    // 依据设计文档 Part 7：标记完成用强确认，取消用轻反馈
    _haptics.trigger(
      wish.completed ? HapticEvent.checkboxOff : HapticEvent.wishCompleted,
    );
    setState(() => wish.completed = !wish.completed);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final List<_DemoWish> visible = _visibleWishes;

    return AdaptivePageScaffold(
      title: '愿望',
      trailing: IconButton(
        icon: const Icon(Icons.filter_list),
        tooltip: '筛选',
        onPressed: () => _haptics.trigger(HapticEvent.dialogButton),
      ),
      filterBar: _buildFilterBar(),
      fab: FloatingActionButton(
        heroTag: null,
        tooltip: '新愿望',
        onPressed: () => _haptics.trigger(HapticEvent.fabTap),
        child: const Icon(Icons.add),
      ),
      body: visible.isEmpty
          ? EmptyState(
              emoji: '🎯',
              title: _filter == WishFilter.completed
                  ? '还没有已完成的愿望'
                  : '还没有愿望',
              subtitle: '一起创建第一个吧',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              itemCount: visible.length,
              itemBuilder: (BuildContext context, int index) {
                final _DemoWish wish = visible[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: WishCard(
                    key: ValueKey<String>(wish.title),
                    title: wish.title,
                    description: wish.description,
                    categoryLabel: wish.categoryLabel,
                    targetDateLabel: wish.targetDateLabel,
                    createdByLabel: wish.createdByLabel,
                    completed: wish.completed,
                    completedByLabel: wish.completedByLabel,
                    onToggle: () => _toggleWish(wish),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildFilterBar() {
    if (AppPlatform.isIOS) {
      return CupertinoSlidingSegmentedControl<WishFilter>(
        groupValue: _filter,
        onValueChanged: (WishFilter? value) {
          if (value == null) return;
          _haptics.trigger(HapticEvent.tabSwitch);
          setState(() => _filter = value);
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
      selected: <WishFilter>{_filter},
      onSelectionChanged: (Set<WishFilter> selection) {
        _haptics.trigger(HapticEvent.tabSwitch);
        setState(() => _filter = selection.first);
      },
    );
  }
}

/// 演示用可变模型（Phase 1 替换为 Isar 实体）。
class _DemoWish {
  _DemoWish({
    required this.title,
    this.description,
    this.categoryLabel,
    this.targetDateLabel,
    this.createdByLabel,
    this.completed = false,
    this.completedByLabel,
  });

  final String title;
  final String? description;
  final String? categoryLabel;
  final String? targetDateLabel;
  final String? createdByLabel;
  bool completed;
  final String? completedByLabel;
}
