import 'dart:io' show Platform;

import 'package:flutter/services.dart';

/// 触觉反馈的**语义事件**（不依赖具体平台实现）。
///
/// 依据《设计文档 Part 7 触觉反馈映射表》。
enum HapticEvent {
  /// 切换 Tab
  tabSwitch,

  /// 勾选复选框（选中）
  checkboxOn,

  /// 取消勾选
  checkboxOff,

  /// 标记愿望完成（强确认）
  wishCompleted,

  /// 愿望达成庆祝（当前会话首次）
  wishCelebrate,

  /// 滑动删除达到阈值
  swipeThreshold,

  /// 表单校验失败
  validationError,

  /// 下拉刷新触发
  refreshTrigger,

  /// 保存成功
  saveSuccess,

  /// 上传完成
  uploadDone,

  /// 上传失败
  uploadFailed,

  /// 长按菜单弹出
  menuOpen,

  /// 弹窗按钮点击
  dialogButton,

  /// FAB 点击
  fabTap,

  /// Sheet 拖拽到停靠点
  sheetDetent,
}

/// 触觉反馈抽象层 —— 双端差异最大的"手感"点，必须集中封装。
///
/// 关键约束：OPPO Find X9 Pro 触控采样 300Hz，
/// 触觉反馈若延迟 > 50ms 会明显"跟不上手"，因此实现内不得有异步等待。
abstract interface class PlatformHaptics {
  const PlatformHaptics();

  Future<void> trigger(HapticEvent event);

  /// 按当前平台返回实现。
  static PlatformHaptics forCurrentPlatform() =>
      Platform.isIOS ? const IosHaptics() : const AndroidHaptics();
}

/// iOS 实现（Taptic Engine）。
class IosHaptics implements PlatformHaptics {
  const IosHaptics();

  @override
  Future<void> trigger(HapticEvent event) {
    switch (event) {
      case HapticEvent.tabSwitch:
      case HapticEvent.refreshTrigger:
      case HapticEvent.dialogButton:
      case HapticEvent.sheetDetent:
        return HapticFeedback.selectionClick();
      case HapticEvent.checkboxOn:
      case HapticEvent.saveSuccess:
      case HapticEvent.wishCelebrate:
        return HapticFeedback.mediumImpact();
      case HapticEvent.checkboxOff:
      case HapticEvent.uploadDone:
        return HapticFeedback.lightImpact();
      case HapticEvent.wishCompleted:
      case HapticEvent.fabTap:
        return HapticFeedback.heavyImpact();
      case HapticEvent.swipeThreshold:
        return HapticFeedback.mediumImpact();
      case HapticEvent.validationError:
      case HapticEvent.uploadFailed:
        return HapticFeedback.vibrate();
      case HapticEvent.menuOpen:
        return HapticFeedback.selectionClick();
    }
  }
}

/// Android / ColorOS 实现。
class AndroidHaptics implements PlatformHaptics {
  const AndroidHaptics();

  @override
  Future<void> trigger(HapticEvent event) {
    switch (event) {
      case HapticEvent.tabSwitch:
      case HapticEvent.refreshTrigger:
      case HapticEvent.dialogButton:
      case HapticEvent.sheetDetent:
        return HapticFeedback.selectionClick();
      case HapticEvent.checkboxOn:
        return HapticFeedback.lightImpact();
      case HapticEvent.checkboxOff:
      case HapticEvent.saveSuccess:
      case HapticEvent.uploadDone:
        return HapticFeedback.lightImpact();
      case HapticEvent.wishCompleted:
      case HapticEvent.wishCelebrate:
      case HapticEvent.fabTap:
        return HapticFeedback.heavyImpact();
      case HapticEvent.swipeThreshold:
      case HapticEvent.menuOpen:
        return HapticFeedback.vibrate();
      case HapticEvent.validationError:
      case HapticEvent.uploadFailed:
        return HapticFeedback.vibrate();
    }
  }
}
