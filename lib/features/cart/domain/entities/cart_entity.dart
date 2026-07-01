class CartEntity {
  final String id, cartOwner;
  final List<CartItemEntity> products;
  final double totalCartPrice;
  final int numOfCartItems;
  const CartEntity({required this.id, required this.cartOwner, required this.products, required this.totalCartPrice, required this.numOfCartItems});
}

class CartItemEntity {
  final String id, productId, title, imageCover;
  final double price;
  int count;
  CartItemEntity({required this.id, required this.productId, required this.title, required this.imageCover, required this.price, required this.count});
}