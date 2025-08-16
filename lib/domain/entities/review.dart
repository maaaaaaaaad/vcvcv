class Review {
  final String id;
  final String user;
  final double rating;
  final String text;
  final DateTime date;
  final List<String> imageUrls;

  const Review({
    required this.id,
    required this.user,
    required this.rating,
    required this.text,
    required this.date,
    required this.imageUrls,
  });
}
