import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/haptics/platform_haptics.dart';
import '../../../core/theme/design_tokens.dart';
import '../application/onboarding_controller.dart';

/// S0.4 设置昵称 + emoji 头像。
///
/// 提交时调用 [OnboardingNotifier.submitProfile] 完成建组 / 入组；
/// 成功且为入组分支时调用 [onSuccess]（由容器决定下一步）。
class ProfileFormPage extends ConsumerStatefulWidget {
  const ProfileFormPage({
    required this.onSuccess,
    required this.onBack,
    super.key,
  });

  final VoidCallback onSuccess;
  final VoidCallback onBack;

  @override
  ConsumerState<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends ConsumerState<ProfileFormPage> {
  late final TextEditingController _nicknameController;
  final PlatformHaptics _haptics = PlatformHaptics.forCurrentPlatform();

  @override
  void initState() {
    super.initState();
    _nicknameController =
        TextEditingController(text: ref.read(onboardingProvider).nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref
        .read(onboardingProvider.notifier)
        .setNickname(_nicknameController.text);
    final bool ok =
        await ref.read(onboardingProvider.notifier).submitProfile();
    if (!mounted) return;
    if (ok) {
      unawaited(_haptics.trigger(HapticEvent.saveSuccess));
      widget.onSuccess();
    } else {
      unawaited(_haptics.trigger(HapticEvent.validationError));
    }
  }

  @override
  Widget build(BuildContext context) {
    final OnboardingState state = ref.watch(onboardingProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isCreate = state.mode == OnboardingMode.create;
    final String? nicknameError =
        ref.read(onboardingProvider.notifier).validateNickname();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.base),
          children: <Widget>[
            Text('你是谁？', style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '对方会看到你的昵称和头像',
              style: textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _nicknameController,
              maxLength: AppConstants.nicknameMaxLength,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: '昵称',
                hintText: '2~20 个字',
                border: const OutlineInputBorder(),
                errorText: state.errorMessage == null &&
                        _nicknameController.text.trim().isEmpty
                    ? null
                    : nicknameError,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('选一个头像', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: kAvatarEmojiPool.map((String emoji) {
                final bool selected = emoji == state.avatarEmoji;
                return _EmojiChoice(
                  emoji: emoji,
                  selected: selected,
                  onTap: () {
                    _haptics.trigger(HapticEvent.checkboxOn);
                    ref
                        .read(onboardingProvider.notifier)
                        .setAvatarEmoji(emoji);
                  },
                );
              }).toList(),
            ),
            if (state.errorMessage != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              Text(
                state.errorMessage!,
                style: textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: state.submitting ||
                      _nicknameController.text.trim().length <
                          AppConstants.nicknameMinLength
                  ? null
                  : _submit,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: state.submitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isCreate ? '创建小窝' : '加入小窝',
                        style: const TextStyle(fontSize: 17),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiChoice extends StatelessWidget {
  const _EmojiChoice({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDuration.tap,
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: selected ? colors.primary : colors.outlineVariant,
            width: selected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 26)),
        ),
      ),
    );
  }
}
