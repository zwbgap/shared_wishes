import 'dart:io' show Platform;

/// 平台判定（集中管理，避免业务层散落 [Platform] 调用，便于测试替换）。
abstract final class AppPlatform {
  static bool get isIOS => Platform.isIOS;

  static bool get isAndroid => Platform.isAndroid;

  /// 是否使用 Cupertino 风格组件与手势。
  static bool get useCupertinoStyle => isIOS;

  /// 图标按钮点击区最小尺寸（iOS 44 / Android 48）。
  static double get iconButtonHitSize => isIOS ? 44 : 48;

  /// 底部导航栏高度（iOS TabBar 49 / Material 3 NavigationBar 80）。
  static double get bottomNavHeight => isIOS ? 49 : 80;
}
