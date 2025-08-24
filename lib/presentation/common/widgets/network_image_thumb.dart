import 'package:flutter/material.dart';
import 'shop_image.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ShopImage(src: url, width: size, height: size, fit: BoxFit.cover),
    );
  }
}
