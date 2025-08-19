import 'package:flutter/material.dart';

const String kShopMockImageAsset = 'assets/app_mock_images/mock-images.png';
const bool kUseMockShopImages = true;

class ShopImage extends StatelessWidget {
  final String? src;
  final double? width;
  final double? height;
  final BoxFit fit;
  final FilterQuality filterQuality;
  final int? cacheWidth;

  const ShopImage({
    super.key,
    this.src,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.filterQuality = FilterQuality.medium,
    this.cacheWidth,
  });

  @override
  Widget build(BuildContext context) {
    if (kUseMockShopImages || src == null || src!.isEmpty) {
      return Image.asset(
        kShopMockImageAsset,
        width: width,
        height: height,
        fit: fit,
        filterQuality: filterQuality,
      );
    }
    return Image.network(
      src!,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: cacheWidth,
      filterQuality: filterQuality,
    );
  }
}
