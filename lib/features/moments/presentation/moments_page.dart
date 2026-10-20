import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/haptics/platform_haptics.dart';
import '../../../shared/widgets/adaptive_page_scaffold.dart';
import '../../../shared/widgets/empty_state.dart';

/// Tab 2：日常记录（照片 + 文字）。
///
/// Phase 0 仅搭建骨架与空状态；Phase 2 接入 image_picker + 压缩管线 +
/// StaggeredGridView 瀑布流。
class MomentsPage extends StatelessWidget {
  const MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PlatformHaptics haptics = PlatformHaptics.forCurrentPlatform();

    return AdaptivePageScaffold(
      title: '日常',
      fab: FloatingActionButton(
        heroTag: null,
        tooltip: '记录此刻',
        onPressed: () => haptics.trigger(HapticEvent.fabTap),
        child: Icon(
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoIcons.camera_fill
              : Icons.photo_camera,
        ),
      ),
      body: const EmptyState(
        emoji: '📷',
        title: '还没有记录',
        subtitle: '拍下今天的一个瞬间，对方会立刻看到',
      ),
    );
  }
}
