import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/design_tokens.dart';

/// S0.2 创建新组：填写组名（可选）。
class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({
    required this.initialValue,
    required this.onNext,
    required this.onBack,
    super.key,
  });

  final String initialValue;
  final ValueChanged<String> onNext;
  final VoidCallback onBack;

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: widget.onBack),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('给小窝起个名字', style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '可选，之后还能改',
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _controller,
                maxLength: AppConstants.groupNameMaxLength,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  hintText: '比如：我们的小家',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (String value) => widget.onNext(value),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => widget.onNext(_controller.text),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text('下一步', style: TextStyle(fontSize: 17)),
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
