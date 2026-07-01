class ProductEntity {
  final String id, title, description, imageCover;
  final double price;
  final double? priceAfterDiscount;
  final double ratingsAverage;
  final int ratingsQuantity, sold, quantity;
  final List<String> images;
  final String categoryName;

  const ProductEntity({
    required this.id, required this.title, required this.description,
    required this.imageCover, required this.price, this.priceAfterDiscount,
    required this.ratingsAverage, required this.ratingsQuantity,
    required this.sold, required this.quantity, required this.images,
    required this.categoryName,
  });
}