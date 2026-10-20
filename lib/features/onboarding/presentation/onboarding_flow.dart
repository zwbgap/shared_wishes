import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_entry.dart';
import '../../../core/haptics/platform_haptics.dart';
import '../application/onboarding_controller.dart';
import 'choose_mode_page.dart';
import 'create_group_page.dart';
import 'invite_code_page.dart';
import 'join_group_page.dart';
import 'profile_form_page.dart';
import 'welcome_page.dart';

/// 首次引导流容器（S0 / S0.1 ~ S0.4）。
///
/// 单 Scaffold + 步骤切换（AnimatedSwitcher），系统返回键逐层回退。
/// 引导完成后调用 [AppEntryNotifier.enterMain] 进入主界面。
class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final OnboardingState state = ref.watch(onboardingProvider);
    final OnboardingNotifier notifier =
        ref.read(onboardingProvider.notifier);
    final PlatformHaptics haptics = PlatformHaptics.forCurrentPlatform();

    final Widget page = switch (state.step) {
      OnboardingStep.welcome => WelcomePage(
          onStart: () {
            haptics.trigger(HapticEvent.dialogButton);
            notifier.toChoose();
          },
        ),
      OnboardingStep.choose => ChooseModePage(
          onCreate: () {
            haptics.trigger(HapticEvent.dialogButton);
            notifier.selectCreate();
          },
          onJoin: () {
            haptics.trigger(HapticEvent.dialogButton);
            notifier.selectJoin();
          },
          onBack: notifier.back,
        ),
      OnboardingStep.createGroup => CreateGroupPage(
          key: const ValueKey<String>('createGroup'),
          initialValue: state.groupName,
          onNext: (String groupName) {
            haptics.trigger(HapticEvent.dialogButton);
            notifier.submitGroupName(groupName);
          },
          onBack: notifier.back,
        ),
      OnboardingStep.joinGroup => JoinGroupPage(
          key: const ValueKey<String>('joinGroup'),
          initialValue: state.inviteCodeInput,
          onNext: (String code) {
            haptics.trigger(HapticEvent.dialogButton);
            notifier.submitInviteCode(code);
          },
          onBack: notifier.back,
        ),
      OnboardingStep.profile => ProfileFormPage(
          key: ValueKey<String>('profile-${state.mode}'),
          onSuccess: () {
            if (state.mode == OnboardingMode.join) {
              ref.read(appEntryProvider.notifier).enterMain();
            }
          },
          onBack: notifier.back,
        ),
      OnboardingStep.inviteCode => InviteCodePage(
          inviteCode: state.result?.inviteCode ?? '',
          groupName: state.result?.groupName,
          onEnterMain: () {
            haptics.trigger(HapticEvent.saveSuccess);
            ref.read(appEntryProvider.notifier).enterMain();
          },
        ),
    };

    return PopScope(
      canPop: state.step == OnboardingStep.welcome,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) notifier.back();
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(
          key: ValueKey<OnboardingStep>(state.step),
          child: page,
        ),
      ),
    );
  }
}
