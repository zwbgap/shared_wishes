import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/platform/platform_info.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';

/// 愿望卡片 —— 支持"已完成标记"的完整视觉闭环。
///
/// 未完成：正常色 + 空心复选框
/// 已完成：删除线标题 + 70% 透明度 + 填充勾选 + 完成者徽标
///
/// 注意：**不使用固定高度**，以支持 iOS Dynamic Type / ColorOS 字体缩放
/// （最大 200%）。性能由 [RepaintBoundary] 与 `ListView.builder` 保证。
class WishCard extends StatelessWidget {
  const WishCard({
    required this.title,
    this.description,
    this.categoryLabel,
    this.targetDateLabel,
    this.createdByLabel,
    this.completed = false,
    this.completedByLabel,
    this.onToggle,
    this.onTap,
    super.key,
  });

  final String title;
  final String? description;

  /// 分类标签（如 "🍣 美食"）
  final String? categoryLabel;

  /// 目标日期文案（如 "📅 下周六"）
  final String? targetDateLabel;

  /// "来自：🐱 小明"
  final String? createdByLabel;

  /// 是否已完成
  final bool completed;

  /// "✨ 小明完成于昨天"
  final String? completedByLabel;

  /// 点击复选框（切换完成状态）
  final VoidCallback? onToggle;

  /// 点击卡片主体（进入详情）
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AppSemanticColors semantic = AppSemanticColors.of(context);
    final Color titleColor = completed
        ? semantic.completedForeground
        : CupertinoDynamicColor.resolve(CupertinoColors.label, context);
    final Color subColor = CupertinoDynamicColor.resolve(
      CupertinoColors.secondaryLabel,
      context,
    ).withValues(
      alpha: completed
          ? AppSemantics.completedSubTextOpacity
          : AppSemantics.completedTextOpacity,
    );

    return Semantics(
      button: true,
      label: title,
      hint: completed ? '点击查看详情' : '点击查看详情，勾选标记完成',
      value: completed ? '已完成' : '未完成',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: completed ? semantic.completedSurface : null,
          borderRadius: BorderRadius.circular(
            AppPlatform.isIOS ? AppRadius.iosCard : AppRadius.androidCard,
          ),
        ),
        child: RepaintBoundary(
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(
              AppPlatform.isIOS ? AppRadius.iosCard : AppRadius.androidCard,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildCheckbox(context, semantic),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: AppTouchTarget.wishCardMin - AppSpacing.base,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: titleColor,
                              decoration: completed
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              decorationColor: titleColor,
                            ),
                          ),
                          if (description != null && description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14, color: subColor),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.xs,
                              children: <Widget>[
                                if (categoryLabel != null)
                                  _MetaText(categoryLabel!),
                                if (targetDateLabel != null)
                                  _MetaText(targetDateLabel!),
                                if (!completed && createdByLabel != null)
                                  _MetaText(createdByLabel!),
                                if (completed && completedByLabel != null)
                                  _MetaText(
                                    completedByLabel!,
                                    color: semantic.success,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, AppSemanticColors semantic) {
    // 视觉 24，点击区强制 48 —— WCAG 2.5.8 / HIG / Material 3
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onToggle,
      child: Semantics(
        checked: completed,
        child: SizedBox(
          width: AppTouchTarget.checkboxHit,
          height: AppTouchTarget.checkboxHit,
          child: Center(
            child: AnimatedSwitcher(
              duration: AppDuration.checkBounce,
              child: completed
                  ? Icon(
                      AppPlatform.isIOS
                          ? CupertinoIcons.checkmark_circle_fill
                          : Icons.check_circle,
                      key: const ValueKey<String>('checked'),
                      size: AppTouchTarget.checkboxVisual,
                      color: semantic.success,
                    )
                  : Icon(
                      AppPlatform.isIOS
                          ? CupertinoIcons.circle
                          : Icons.radio_button_unchecked,
                      key: const ValueKey<String>('unchecked'),
                      size: AppTouchTarget.checkboxVisual,
                      color: CupertinoDynamicColor.resolve(
                        CupertinoColors.tertiaryLabel,
                        context,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaText extends StatelessWidget {
  const _MetaText(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: color ??
            CupertinoDynamicColor.resolve(CupertinoColors.secondaryLabel, context),
      ),
    );
  }
}
