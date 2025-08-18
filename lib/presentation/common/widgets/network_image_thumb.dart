import 'package:flutter/material.dart';
import 'skeleton.dart';

class NetworkImageThumb extends StatelessWidget {
  final String url;
  final double size;
  final double radius;
  final Color? placeholderColor;

  const NetworkImageThumb({
    super.key,
    required this.url,
    this.size = 56,
    this.radius = 8,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cacheW = (size * dpr).round();
    final ph =
        placeholderColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        cacheWidth: cacheW,
        filterQuality: FilterQuality.medium,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded) return child;
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: frame != null
                ? child
                : SkeletonBox(
                    width: size,
                    height: size,
                    borderRadius: BorderRadius.circular(radius),
                  ),
          );
        },
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SkeletonBox(
            width: size,
            height: size,
            borderRadius: BorderRadius.circular(radius),
          );
        },
        errorBuilder: (context, error, stack) => Container(
          width: size,
          height: size,
          color: ph,
          alignment: Alignment.center,
          child: const Icon(
            Icons.image_not_supported,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
