class WishlistItemEntity {
  final String id, title, imageCover;
  final double price;
  final double? priceAfterDiscount;
  final double ratingsAverage;
  const WishlistItemEntity({
    required this.id,
    required this.title,
    required this.imageCover,
    required this.price,
    this.priceAfterDiscount,
    this.ratingsAverage = 0,
  });
}
