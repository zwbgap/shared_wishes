import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/design_tokens.dart';
import '../../../shared/widgets/adaptive_page_scaffold.dart';

/// Tab 3：我们（组管理）。
class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptivePageScaffold(
      title: '我们',
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.base),
        children: <Widget>[
          const _GroupHeader(),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('成员'),
          const _MemberTile(emoji: '🐱', nickname: '小明', online: true),
          const _MemberTile(emoji: '🐶', nickname: '小红', online: false),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt),
            label: const Text('邀请新成员'),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('设置'),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('通知'),
            subtitle: const Text('愿望完成、新日常'),
          ),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('跟随系统深色模式'),
          ),
          ListTile(
            title: const Text('图片质量'),
            subtitle: const Text('高清'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            title: const Text('清除本地缓存'),
            subtitle: const Text('0 B'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.xxl),
          // 危险操作放在困难区（远离拇指热区），防误触
          TextButton(
            onPressed: () {},
            child: Text(
              '离开此组',
              style: TextStyle(
                color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemRed,
                  context,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: CupertinoDynamicColor.resolve(
          CupertinoColors.tertiarySystemFill,
          context,
        ),
        borderRadius: BorderRadius.circular(AppRadius.androidCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Text('我们的愿望', style: TextStyle(fontSize: 20)),
              Spacer(),
              Icon(Icons.edit_outlined, size: 18),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text('🐱 🐶', style: TextStyle(fontSize: 22)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '已创建 42 个愿望 · 12 个达成',
            style: TextStyle(
              fontSize: 14,
              color: CupertinoDynamicColor.resolve(
                CupertinoColors.secondaryLabel,
                context,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoDynamicColor.resolve(
            CupertinoColors.secondaryLabel,
            context,
          ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.emoji,
    required this.nickname,
    required this.online,
  });

  final String emoji;
  final String nickname;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(emoji, style: const TextStyle(fontSize: 28)),
      title: Text(nickname),
      subtitle: Text(online ? '在线' : '上次活跃 2 小时前'),
      trailing: online
          ? const Icon(Icons.circle, size: 8, color: Color(0xFF34C759))
          : null,
    );
  }
}
