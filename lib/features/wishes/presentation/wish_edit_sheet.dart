import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/design_tokens.dart';
import '../domain/wish.dart';

/// 愿望编辑结果（Sheet 关闭时回传）。
class WishEditResult {
  const WishEditResult({
    required this.title,
    this.description,
    this.category,
    this.targetDate,
  });

  final String title;
  final String? description;
  final String? category;
  final DateTime? targetDate;
}

/// 新建 / 编辑愿望的底部弹层。
///
/// 用法：`final result = await WishEditSheet.show(context, existing: wish);`
/// 返回 null 表示用户取消。
class WishEditSheet extends StatefulWidget {
  const WishEditSheet({this.existing, super.key});

  /// 传入则为编辑模式，否则为新建。
  final Wish? existing;

  static Future<WishEditResult?> show(BuildContext context, {Wish? existing}) {
    return showModalBottomSheet<WishEditResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => WishEditSheet(existing: existing),
    );
  }

  @override
  State<WishEditSheet> createState() => _WishEditSheetState();
}

class _WishEditSheetState extends State<WishEditSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController =
      TextEditingController(text: widget.existing?.title ?? '');
  late final TextEditingController _descController =
      TextEditingController(text: widget.existing?.description ?? '');
  late String? _category = widget.existing?.category;
  late DateTime? _targetDate = widget.existing?.targetDate;

  bool get _isEdit => widget.existing != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final String desc = _descController.text.trim();
    Navigator.of(context).pop(
      WishEditResult(
        title: _titleController.text.trim(),
        description: desc.isEmpty ? null : desc,
        category: _category,
        targetDate: _targetDate,
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _targetDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // 键盘顶起时保持输入框可见
      padding: EdgeInsets.only(
        left: AppSpacing.base,
        right: AppSpacing.base,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.base,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _isEdit ? '编辑愿望' : '新愿望',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.base),
            TextFormField(
              controller: _titleController,
              autofocus: !_isEdit,
              maxLength: AppConstants.wishTitleMaxLength,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: '想做什么',
                hintText: '比如：周末去吃那家日料',
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return '标题不能为空';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _descController,
              maxLength: AppConstants.wishDescriptionMaxLength,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: '补充说明（可选）',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: <Widget>[
                for (final MapEntry<String, String> entry
                    in kWishCategories.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: _category == entry.key,
                    onSelected: (bool selected) {
                      setState(
                        () => _category = selected ? entry.key : null,
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                TextButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: Text(
                    _targetDate == null
                        ? '选个目标日期（可选）'
                        : DateFormat('yyyy年M月d日').format(_targetDate!),
                  ),
                ),
                if (_targetDate != null)
                  IconButton(
                    tooltip: '清除日期',
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => setState(() => _targetDate = null),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            FilledButton(
              onPressed: _save,
              child: Text(_isEdit ? '保存' : '创建'),
            ),
          ],
        ),
      ),
    );
  }
}
