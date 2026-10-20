import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_entry.dart';
import 'core/sync/remote_wish_sync.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/shell/presentation/main_shell.dart';

/// 应用根 —— 单一 [MaterialApp]，双平台差异由主题与页面骨架内部适配。
///
/// - iPhone 17 Pro / iOS 18：`CupertinoTheme` 覆写（系统蓝、SF Pro 字重）
/// - OPPO Find X9 Pro / ColorOS 16：Material 3 + Material You（Dynamic Color）
///
/// 入口分流：未完成首次引导（未入组）→ [OnboardingFlow]；否则 → [MainShell]。
class SharedWishesApp extends ConsumerWidget {
  const SharedWishesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppEntryDestination destination = ref.watch(appEntryProvider);
    // 远端同步骨架：未配置 Supabase 或未入组时为 null（自动 no-op）
    ref.watch(remoteWishSyncProvider);

    return MaterialApp(
      title: '我们的愿望',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.material(Brightness.light),
      darkTheme: AppTheme.material(Brightness.dark),
      themeMode: ThemeMode.system,
      builder: (BuildContext context, Widget? child) {
        return CupertinoTheme(
          data: AppTheme.cupertino(Theme.of(context).brightness),
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: switch (destination) {
        AppEntryDestination.onboarding => const OnboardingFlow(),
        AppEntryDestination.main => const MainShell(),
      },
    );
  }
}
