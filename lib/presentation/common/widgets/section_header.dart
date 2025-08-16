import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionText, style: TextStyle(color: c.primary)),
        ),
      ],
    );
  }
}
