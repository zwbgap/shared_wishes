import 'package:flutter/cupertino.dart';

/// 空状态占位（双端共用）。
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.emoji,
    required this.title,
    this.subtitle,
    this.action,
    super.key,
  });

  /// 大号 emoji 图标
  final String emoji;

  /// 主文案
  final String title;

  /// 补充说明
  final String? subtitle;

  /// 引导操作按钮
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final Color mutedColor = CupertinoDynamicColor.resolve(
      CupertinoColors.secondaryLabel,
      context,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: mutedColor),
            ),
            if (subtitle != null) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: mutedColor),
              ),
            ],
            if (action != null) ...<Widget>[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
