import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/haptics/platform_haptics.dart';
import '../../../core/theme/design_tokens.dart';

/// 建组成功：展示邀请码（可复制 / 系统分享），确认后进入主界面。
class InviteCodePage extends StatelessWidget {
  const InviteCodePage({
    required this.inviteCode,
    required this.onEnterMain,
    this.groupName,
    super.key,
  });

  final String inviteCode;
  final String? groupName;
  final VoidCallback onEnterMain;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: inviteCode));
    unawaited(
      PlatformHaptics.forCurrentPlatform().trigger(HapticEvent.saveSuccess),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('邀请码已复制'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _share() async {
    unawaited(
      PlatformHaptics.forCurrentPlatform().trigger(HapticEvent.dialogButton),
    );
    final String name = groupName?.trim().isNotEmpty == true
        ? '「$groupName」'
        : '我们的小窝';
    await SharePlus.instance.share(
      ShareParams(
        text: '来加入$name吧！在「我们的愿望」App 里输入邀请码：$inviteCode'
            '（最多 ${AppConstants.maxGroupMembers} 人）',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Spacer(),
              const Text('🎉', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 64)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '小窝建好了',
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '把邀请码发给 TA，最多 ${AppConstants.maxGroupMembers} 人',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              GestureDetector(
                onTap: () => _copy(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.lg,
                    horizontal: AppSpacing.base,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.iosCard),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Text(
                    inviteCode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      letterSpacing: 8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _copy(context),
                      icon: const Icon(Icons.copy),
                      label: const Text('复制'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _share,
                      icon: const Icon(Icons.share),
                      label: const Text('分享'),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: onEnterMain,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text('进入小窝', style: TextStyle(fontSize: 17)),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
