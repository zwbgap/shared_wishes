import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/identity/device_identity.dart';
import '../../../core/theme/design_tokens.dart';
import '../../../data/repositories/group_repository.dart';
import '../../../data/repositories/membership_store.dart';

/// 引导流步骤。
enum OnboardingStep {
  /// S0.1 Welcome（3 张卡片横滑）
  welcome,

  /// 分支选择：建组 / 入组
  choose,

  /// S0.2 创建新组（填组名）
  createGroup,

  /// S0.3 加入组（填邀请码）
  joinGroup,

  /// S0.4 设置昵称 + emoji
  profile,

  /// 建组成功：展示邀请码
  inviteCode,
}

/// 引导分支。
enum OnboardingMode { create, join }

/// 引导流状态。
class OnboardingState {
  const OnboardingState({
    required this.step,
    required this.mode,
    required this.groupName,
    required this.inviteCodeInput,
    required this.nickname,
    required this.avatarEmoji,
    required this.submitting,
    this.errorMessage,
    this.result,
  });

  factory OnboardingState.initial() => OnboardingState(
        step: OnboardingStep.welcome,
        mode: OnboardingMode.create,
        groupName: '',
        inviteCodeInput: '',
        nickname: '',
        avatarEmoji:
            kAvatarEmojiPool[Random().nextInt(kAvatarEmojiPool.length)],
        submitting: false,
      );

  final OnboardingStep step;
  final OnboardingMode mode;
  final String groupName;
  final String inviteCodeInput;
  final String nickname;
  final String avatarEmoji;

  /// 是否正在等待 RPC / 本地写入
  final bool submitting;

  /// 最近一次提交失败的用户可读文案
  final String? errorMessage;

  /// 建组 / 入组成功结果
  final GroupJoinResult? result;

  OnboardingState copyWith({
    OnboardingStep? step,
    OnboardingMode? mode,
    String? groupName,
    String? inviteCodeInput,
    String? nickname,
    String? avatarEmoji,
    bool? submitting,
    String? Function()? errorMessage,
    GroupJoinResult? result,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      mode: mode ?? this.mode,
      groupName: groupName ?? this.groupName,
      inviteCodeInput: inviteCodeInput ?? this.inviteCodeInput,
      nickname: nickname ?? this.nickname,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      submitting: submitting ?? this.submitting,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
      result: result ?? this.result,
    );
  }
}

/// 引导流状态机（对应设计文档 5.2 引导流）。
///
/// Riverpod 3：autoDispose 由 Provider 声明，Notifier 基类统一为 [Notifier]。
class OnboardingNotifier extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => OnboardingState.initial();

  // ---- 步骤导航 ----

  void toChoose() {
    state = state.copyWith(step: OnboardingStep.choose, errorMessage: () => null);
  }

  void selectCreate() {
    state = state.copyWith(
      step: OnboardingStep.createGroup,
      mode: OnboardingMode.create,
      errorMessage: () => null,
    );
  }

  void selectJoin() {
    state = state.copyWith(
      step: OnboardingStep.joinGroup,
      mode: OnboardingMode.join,
      errorMessage: () => null,
    );
  }

  /// 组名填完 → 进入昵称页
  void submitGroupName(String groupName) {
    state = state.copyWith(
      step: OnboardingStep.profile,
      groupName: groupName.trim(),
      errorMessage: () => null,
    );
  }

  /// 邀请码填完 → 进入昵称页
  void submitInviteCode(String inviteCode) {
    state = state.copyWith(
      step: OnboardingStep.profile,
      inviteCodeInput: inviteCode.trim().toUpperCase(),
      errorMessage: () => null,
    );
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname, errorMessage: () => null);
  }

  void setAvatarEmoji(String emoji) {
    state = state.copyWith(avatarEmoji: emoji, errorMessage: () => null);
  }

  /// 系统返回键 / 页面返回按钮。
  void back() {
    final OnboardingStep previous = switch (state.step) {
      OnboardingStep.choose => OnboardingStep.welcome,
      OnboardingStep.createGroup || OnboardingStep.joinGroup =>
        OnboardingStep.choose,
      OnboardingStep.profile => state.mode == OnboardingMode.create
          ? OnboardingStep.createGroup
          : OnboardingStep.joinGroup,
      _ => state.step,
    };
    if (previous != state.step) {
      state = state.copyWith(step: previous, errorMessage: () => null);
    }
  }

  // ---- 提交（建组 / 入组） ----

  /// 昵称校验：2~20 字（[AppConstants.nicknameMinLength]~[AppConstants.nicknameMaxLength]）。
  String? validateNickname() {
    final String trimmed = state.nickname.trim();
    if (trimmed.length < AppConstants.nicknameMinLength ||
        trimmed.length > AppConstants.nicknameMaxLength) {
      return '昵称需要 ${AppConstants.nicknameMinLength}~${AppConstants.nicknameMaxLength} 个字';
    }
    return null;
  }

  /// 提交昵称 + emoji，调用建组 / 入组仓库。
  ///
  /// 返回值：是否成功。失败时 [OnboardingState.errorMessage] 已更新。
  Future<bool> submitProfile() async {
    final String? validationError = validateNickname();
    if (validationError != null || state.submitting) {
      if (validationError != null) {
        state = state.copyWith(errorMessage: () => validationError);
      }
      return false;
    }

    state = state.copyWith(submitting: true, errorMessage: () => null);
    final String nickname = state.nickname.trim();

    try {
      final GroupRepository repository = ref.read(groupRepositoryProvider);
      final GroupJoinResult result = state.mode == OnboardingMode.create
          ? await repository.createGroup(
              groupName: state.groupName,
              nickname: nickname,
              avatarEmoji: state.avatarEmoji,
            )
          : await repository.joinGroup(
              inviteCode: state.inviteCodeInput,
              nickname: nickname,
              avatarEmoji: state.avatarEmoji,
            );

      // 持久化：本机昵称 / emoji + 组成员身份
      final DeviceIdentityService identity =
          ref.read(deviceIdentityServiceProvider);
      await identity.saveProfile(
        nickname: nickname,
        avatarEmoji: state.avatarEmoji,
      );
      await ref.read(membershipStoreProvider).saveMembership(
            result: result,
            deviceId: await identity.ensureDeviceId(),
            nickname: nickname,
            avatarEmoji: state.avatarEmoji,
          );

      state = state.copyWith(
        submitting: false,
        result: result,
        step: state.mode == OnboardingMode.create
            ? OnboardingStep.inviteCode
            : state.step,
      );
      return true;
    } on GroupFailure catch (e) {
      state = state.copyWith(
        submitting: false,
        errorMessage: () => e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        submitting: false,
        errorMessage: () => const GroupFailureUnknown().message,
      );
      return false;
    }
  }
}

/// 引导流状态机 Provider（离开引导流后自动销毁）。
final onboardingProvider =
    NotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
  OnboardingNotifier.new,
);
