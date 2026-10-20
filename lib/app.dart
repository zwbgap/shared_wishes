import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/shell/presentation/main_shell.dart';

/// 应用根 —— 单一 [MaterialApp]，双平台差异由主题与页面骨架内部适配。
///
/// - iPhone 17 Pro / iOS 18：`CupertinoTheme` 覆写（系统蓝、SF Pro 字重）
/// - OPPO Find X9 Pro / ColorOS 16：Material 3 + Material You（Dynamic Color）
class SharedWishesApp extends StatelessWidget {
  const SharedWishesApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const MainShell(),
    );
  }
}
