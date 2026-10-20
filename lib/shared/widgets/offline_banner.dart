import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_status.dart';
import '../../core/theme/design_tokens.dart';

/// 离线提示横幅（不阻挡滚动，命中"离线优先"原则）。
///
/// 仅在 [SyncStatus.offline] / [SyncStatus.error] 时展示。
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SyncStatus status = ref.watch(syncStatusProvider);
    if (status == SyncStatus.idle || status == SyncStatus.syncing) {
      return const SizedBox.shrink();
    }

    final bool isError = status == SyncStatus.error;
    final Color background = isError
        ? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context)
        : CupertinoDynamicColor.resolve(
            CupertinoColors.tertiarySystemFill,
            context,
          );

    return Container(
      width: double.infinity,
      color: background.withValues(alpha: AppSemantics.offlineBannerOpacity),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        isError ? '同步出错，将在网络恢复后自动重试' : '离线中，本地仍可正常操作',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          color: isError
              ? CupertinoDynamicColor.resolve(CupertinoColors.white, context)
              : CupertinoDynamicColor.resolve(CupertinoColors.label, context),
        ),
      ),
    );
  }
}
