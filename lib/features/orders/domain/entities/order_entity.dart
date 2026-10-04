class OrderEntity {
  final String id;
  final int number;
  final double totalOrderPrice;
  final String paymentMethodType, city;
  final bool isPaid, isDelivered;
  final DateTime createdAt;
  final List<OrderItemEntity> cartItems;
  const OrderEntity({
    required this.id,
    required this.number,
    required this.totalOrderPrice,
    required this.paymentMethodType,
    required this.isPaid,
    required this.isDelivered,
    required this.createdAt,
    required this.cartItems,
    this.city = '',
  });
}

class OrderItemEntity {
  final String productId, title, imageCover;
  final int count;
  final double price;
  const OrderItemEntity({required this.productId, required this.title, required this.imageCover, required this.count, required this.price});
}
