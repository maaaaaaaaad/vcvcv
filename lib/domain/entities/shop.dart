class Shop {
  final String id;
  final String name;
  final String category;
  final double rating;
  final double distanceKm;
  final String thumbnailUrl;
  final int reviewCount;
  final int reservationCount;

  const Shop({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.distanceKm,
    required this.thumbnailUrl,
    required this.reviewCount,
    required this.reservationCount,
  });
}
