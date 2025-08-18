import 'package:flutter/material.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceVariant;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              c.withValues(alpha: 0.5),
              c.withValues(alpha: 0.35),
              c.withValues(alpha: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
