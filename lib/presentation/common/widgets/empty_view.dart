import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String title;
  final String? description;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyView({
    super.key,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.primary.withValues(alpha: 0.12),
            child: Icon(Icons.inbox, color: c.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (description != null) const SizedBox(height: 2),
                if (description != null)
                  Text(
                    description!,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: c.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(width: 12),
            FilledButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}
