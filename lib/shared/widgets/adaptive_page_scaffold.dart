import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/platform/platform_info.dart';
import '../../core/theme/design_tokens.dart';

/// 平台自适应页面骨架。
///
/// - iOS：`CupertinoPageScaffold` + `CupertinoNavigationBar.largeTitle`（HIG 大标题）
/// - Android：`Scaffold` + Material 3 `AppBar`（Medium → Small 折叠）
///
/// 两端都把 FAB / 主操作放在底部拇指可达区。
class AdaptivePageScaffold extends StatelessWidget {
  const AdaptivePageScaffold({
    required this.title,
    required this.body,
    this.fab,
    this.trailing,
    this.filterBar,
    this.topBanner,
    super.key,
  });

  final String title;
  final Widget body;

  /// 主操作按钮（底部拇指区）
  final Widget? fab;

  /// 导航栏右侧操作
  final Widget? trailing;

  /// 筛选栏（SegmentedControl / SegmentedButton），粘在标题下方
  final Widget? filterBar;

  /// 顶部提示横幅（离线提示 / 上传进度）
  final Widget? topBanner;

  @override
  Widget build(BuildContext context) {
    if (AppPlatform.isIOS) {
      return _buildCupertino(context);
    }
    return _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text(title),
        trailing: trailing,
        border: null,
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                ?topBanner,
                if (filterBar != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.base,
                    ),
                    child: filterBar,
                  ),
                Expanded(child: body),
              ],
            ),
          ),
          if (fab != null)
            Positioned(
              right: AppSpacing.base,
              bottom: AppSpacing.base,
              child: fab!,
            ),
        ],
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[?trailing],
      ),
      body: Column(
        children: <Widget>[
          ?topBanner,
          if (filterBar != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              child: filterBar,
            ),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: fab,
      // FAB 位于导航栏之上（距底部约 96dp），
      // 且水平位于右下角 —— 天然避开 Find X9 Pro 居中偏下的超声波指纹区。
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
