import 'package:flutter/material.dart';
import 'skeleton.dart';
import '../../../domain/entities/shop.dart';

class ShopCarousel extends StatelessWidget {
  final List<Shop> shops;
  final void Function(Shop) onTap;

  const ShopCarousel({super.key, required this.shops, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final s = shops[index];
          return GestureDetector(
            onTap: () => onTap(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: 200,
              decoration: BoxDecoration(
                color: color.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Builder(
                      builder: (context) {
                        final dpr = MediaQuery.of(context).devicePixelRatio;
                        final cacheW = (200 * dpr).round();
                        return Image.network(
                          s.thumbnailUrl,
                          height: 110,
                          width: 200,
                          fit: BoxFit.cover,
                          cacheWidth: cacheW,
                          filterQuality: FilterQuality.medium,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 220),
                                  child: frame != null
                                      ? child
                                      : const SkeletonBox(
                                          width: 200,
                                          height: 110,
                                        ),
                                );
                              },
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return const SkeletonBox(width: 200, height: 110);
                          },
                          errorBuilder: (context, error, stack) =>
                              const SkeletonBox(width: 200, height: 110),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          s.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: shops.length,
      ),
    );
  }
}
