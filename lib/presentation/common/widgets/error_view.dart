import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.actionText = '다시 시도',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: c.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: c.onErrorContainer.withValues(alpha: 0.12),
            child: Icon(Icons.error_outline, color: c.onErrorContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: c.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonal(onPressed: onRetry, child: Text(actionText)),
        ],
      ),
    );
  }
}
