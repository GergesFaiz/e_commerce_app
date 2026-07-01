class OrderEntity {
  final String id;
  final int totalOrderPrice;
  final bool isPaid, isDelivered;
  final DateTime createdAt;
  final List<OrderItemEntity> cartItems;
  const OrderEntity({required this.id, required this.totalOrderPrice, required this.isPaid, required this.isDelivered, required this.createdAt, required this.cartItems});
}

class OrderItemEntity {
  final String productId, title, imageCover;
  final int count, price;
  const OrderItemEntity({required this.productId, required this.title, required this.imageCover, required this.count, required this.price});
}