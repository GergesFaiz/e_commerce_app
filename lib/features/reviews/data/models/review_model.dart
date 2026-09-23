class Review {
  final String id;
  final String text;
  final double rating;
  final String userName;
  final String createdAt;

  const Review({
    required this.id,
    required this.text,
    required this.rating,
    required this.userName,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return Review(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      text: (json['review'] ?? '').toString(),
      rating: ((json['rating'] as num?) ?? 0).toDouble(),
      userName: user is Map ? (user['name'] ?? '').toString() : '',
      createdAt: (json['createdAt'] ?? '').toString(),
    );
  }

  static List<Review> listOf(dynamic data) {
    if (data is! List) return const [];
    return data
        .whereType<Map>()
        .map((e) => Review.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
