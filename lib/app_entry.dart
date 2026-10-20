import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/repositories/membership_store.dart';

/// 应用入口目的地。
enum AppEntryDestination {
  /// 首次引导（未入组）
  onboarding,

  /// 主界面（三 Tab）
  main,
}

/// 入口分流控制器。
///
/// 冷启动依据本地组快照（SharedPreferences）判定；引导完成后
/// 由引导流显式调用 [enterMain]。
class AppEntryNotifier extends Notifier<AppEntryDestination> {
  @override
  AppEntryDestination build() {
    final MembershipStore store = ref.watch(membershipStoreProvider);
    return store.hasCompletedOnboarding
        ? AppEntryDestination.main
        : AppEntryDestination.onboarding;
  }

  /// 引导完成（建组 / 入组成功）→ 进入主界面。
  void enterMain() {
    ref.invalidate(currentGroupIdProvider);
    state = AppEntryDestination.main;
  }

  /// 离开组 / 解散组 → 回到引导流（后续切片接入组管理页）。
  void backToOnboarding() {
    ref.invalidate(currentGroupIdProvider);
    state = AppEntryDestination.onboarding;
  }
}

/// 入口分流 Provider。
final appEntryProvider =
    NotifierProvider<AppEntryNotifier, AppEntryDestination>(
  AppEntryNotifier.new,
);
