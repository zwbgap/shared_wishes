import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'design_tokens.dart';

/// 业务语义色（Material 3 的 [ColorScheme] 没有 success / warning，用扩展补齐）。
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.warning,
    required this.danger,
    required this.accent,
    required this.completedSurface,
    required this.completedForeground,
  });

  /// 已完成 / 成功
  final Color success;

  /// 警告
  final Color warning;

  /// 危险操作
  final Color danger;

  /// 强调（亲密 / 庆祝）
  final Color accent;

  /// 已完成卡片背景
  final Color completedSurface;

  /// 已完成文字
  final Color completedForeground;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? warning,
    Color? danger,
    Color? accent,
    Color? completedSurface,
    Color? completedForeground,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      accent: accent ?? this.accent,
      completedSurface: completedSurface ?? this.completedSurface,
      completedForeground: completedForeground ?? this.completedForeground,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      completedSurface: Color.lerp(completedSurface, other.completedSurface, t)!,
      completedForeground:
          Color.lerp(completedForeground, other.completedForeground, t)!,
    );
  }

  /// 便捷读取。
  static AppSemanticColors of(BuildContext context) =>
      Theme.of(context).extension<AppSemanticColors>()!;
}

/// 双平台主题入口。
///
/// - iPhone 17 Pro / iOS 18：使用 [cupertino]（SF Pro 语义字重 + 系统蓝）
/// - OPPO Find X9 Pro / ColorOS 16：使用 [material]（Material 3 + Material You）
abstract final class AppTheme {
  // ---- 固定色（Material You 不可用时的回退色板）----
  static const Color fallbackPrimary = Color(0xFF6750A4);
  static const Color fallbackSecondary = Color(0xFF625B71);
  static const Color fallbackTertiary = Color(0xFF7D5260);

  // ---- iOS 系统色 ----
  static const Color iosTint = Color(0xFF007AFF);

  // ---- 通用语义色 ----
  static const Color successLight = Color(0xFF34C759);
  static const Color successDark = Color(0xFF30D158);
  static const Color warningLight = Color(0xFFFF9500);
  static const Color warningDark = Color(0xFFFF9F0A);
  static const Color dangerLight = Color(0xFFFF3B30);
  static const Color dangerDark = Color(0xFFFF453A);
  static const Color accentLight = Color(0xFFFF2D55);
  static const Color accentDark = Color(0xFFFF375F);

  /// Material 3 主题（Android / ColorOS 16）。
  ///
  /// [dynamicScheme] 由 `dynamic_color` 插件在受支持的 ColorOS 上注入（Material You）；
  /// 为空时回退到固定种子色。
  static ThemeData material(
    Brightness brightness, {
    ColorScheme? dynamicScheme,
  }) {
    final ColorScheme scheme = dynamicScheme ??
        ColorScheme.fromSeed(
          seedColor: fallbackPrimary,
          secondary: fallbackSecondary,
          tertiary: fallbackTertiary,
          brightness: brightness,
        );

    final bool isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[
        AppSemanticColors(
          success: isDark ? successDark : successLight,
          warning: isDark ? warningDark : warningLight,
          danger: isDark ? dangerDark : dangerLight,
          accent: isDark ? accentDark : accentLight,
          completedSurface: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          completedForeground: scheme.onSurface.withValues(
            alpha: AppSemantics.completedTextOpacity,
          ),
        ),
      ],
    );
  }

  /// Cupertino 主题（iPhone 17 Pro / iOS 18）。
  static CupertinoThemeData cupertino(Brightness brightness) {
    return CupertinoThemeData(
      brightness: brightness,
      primaryColor: iosTint,
      applyThemeToAll: true,
    );
  }
}
