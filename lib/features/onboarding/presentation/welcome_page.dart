import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';

/// S0.1 Welcome 引导页：3 张横向滑动卡片 + 底部「开始」按钮（拇指区）。
class WelcomePage extends StatefulWidget {
  const WelcomePage({required this.onStart, super.key});

  final VoidCallback onStart;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  static const List<_WelcomeCard> _cards = <_WelcomeCard>[
    _WelcomeCard(
      emoji: '🎯',
      title: '一起记录愿望',
      subtitle: '想去的地方、想吃的美食，\n都放进同一个清单',
    ),
    _WelcomeCard(
      emoji: '📷',
      title: '随手拍日常',
      subtitle: '照片和文字，\n实时同步给 TA',
    ),
    _WelcomeCard(
      emoji: '🔗',
      title: '无需账号，实时同步',
      subtitle: '一个邀请码，\n就是你们的全部',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _cards.length,
                onPageChanged: (int index) {
                  setState(() => _pageIndex = index);
                },
                itemBuilder: (BuildContext context, int index) {
                  final _WelcomeCard card = _cards[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(card.emoji, style: const TextStyle(fontSize: 80)),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          card.title,
                          style: textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.base),
                        Text(
                          card.subtitle,
                          style: textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _PageIndicator(count: _cards.length, index: _pageIndex),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.base,
                AppSpacing.lg,
                AppSpacing.base,
                AppSpacing.xl,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: widget.onStart,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Text('开始', style: TextStyle(fontSize: 17)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard {
  const _WelcomeCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  final String emoji;
  final String title;
  final String subtitle;
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == index;
        return AnimatedContainer(
          duration: AppDuration.transition,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? colors.primary : colors.outlineVariant,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
