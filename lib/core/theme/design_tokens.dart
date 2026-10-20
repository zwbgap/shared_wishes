/// 设计令牌（Design Tokens）—— 全项目唯一数值来源。
///
/// 依据《Shared Wishes 设计文档 Part 4》：
/// 8pt/dp Grid，所有尺寸为逻辑像素（Flutter 自动处理密度比）。
abstract final class AppSpacing {
  /// 组件内部微间距（图标与文字之间）
  static const double xs = 4;

  /// 最小点击间距 / 小间距
  static const double sm = 8;

  /// 按钮内部垂直 padding
  static const double md = 12;

  /// 屏幕边距 / 卡片内部 padding（标准）
  static const double base = 16;

  /// Section 间距
  static const double lg = 24;

  /// 大模块间距
  static const double xl = 32;

  /// 双行文本间距
  static const double xxl = 48;
}

/// 触摸目标最低尺寸（强制规范，WCAG 2.5.8 / HIG / Material 3）。
abstract final class AppTouchTarget {
  /// 复选框点击区 —— 视觉 24，点击区 48
  static const double checkboxHit = 48;

  /// 复选框视觉尺寸
  static const double checkboxVisual = 24;

  /// iOS 图标按钮点击区
  static const double iosIconButton = 44;

  /// Android 图标按钮点击区
  static const double androidIconButton = 48;

  /// 愿望卡片行高（固定高度 → 高性能列表）
  static const double wishCardRowExtent = 72;

  /// 愿望卡片单行显示的最小高度
  static const double wishCardMin = 72;

  /// 成员列表行高
  static const double memberRowExtent = 72;

  /// FAB 直径
  static const double fab = 56;

  /// Chip 最小高度
  static const double chipMin = 48;
}

/// 圆角（双端差异见设计文档 4.5）。
abstract final class AppRadius {
  /// iOS 卡片
  static const double iosCard = 14;

  /// Android Material 3 Filled Card
  static const double androidCard = 12;

  /// iOS Sheet 顶部
  static const double iosSheet = 22;

  /// Material 3 BottomSheet 顶部
  static const double androidSheet = 28;

  /// iOS 按钮
  static const double iosButton = 8;

  /// Material 3 Fully Rounded 按钮
  static const double androidButton = 20;

  /// iOS 输入框
  static const double iosField = 8;

  /// Material 3 Outlined 输入框
  static const double androidField = 4;

  /// Chip
  static const double chip = 8;
}

/// 动效时长（对齐 ProMotion 120Hz：8.33ms 为一帧）。
abstract final class AppDuration {
  /// 点击即时反馈
  static const Duration tap = Duration(milliseconds: 100);

  /// 标准过渡
  static const Duration transition = Duration(milliseconds: 250);

  /// 完成勾选弹跳
  static const Duration checkBounce = Duration(milliseconds: 200);

  /// 卡片状态切换
  static const Duration cardState = Duration(milliseconds: 400);

  /// 完成庆祝动画
  static const Duration celebrate = Duration(milliseconds: 600);
}

/// 语义颜色（双端通用的业务语义，具体色值由主题映射）。
///
/// 注意：不要直接引用这些常量渲染，应通过 [ColorScheme] / 语义扩展获取，
/// 以便自动适配 Dark Mode 与 Material You。
abstract final class AppSemantics {
  /// 已完成状态的文字透明度
  static const double completedTextOpacity = 0.7;

  /// 已完成状态的次要文字透明度
  static const double completedSubTextOpacity = 0.5;

  /// 离线提示背景透明度
  static const double offlineBannerOpacity = 0.9;
}

/// Emoji 头像候选池（温馨向，排除难识别字形）。
const List<String> kAvatarEmojiPool = <String>[
  '🐱', '🐶', '🐼', '🦊', '🐰', '🦄', '🐸', '🐙',
  '🦋', '🌸', '🌙', '⭐', '🍀', '☀️', '🎨', '🎵',
  '🐻', '🐨', '🦔', '🐧',
];

/// 愿望分类（emoji + 中文标签）。
const Map<String, String> kWishCategories = <String, String>{
  'food': '🍣 美食',
  'travel': '✈️ 旅行',
  'shopping': '🛍️ 购物',
  'experience': '🎁 体验',
  'home': '🏠 居家',
  'study': '💡 学习',
};
