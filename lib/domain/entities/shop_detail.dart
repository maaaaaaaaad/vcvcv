import 'service_item.dart';

class ShopDetail {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final List<ServiceItem> services;
  final bool isFavorite;

  const ShopDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.services,
    required this.isFavorite,
  });
}
