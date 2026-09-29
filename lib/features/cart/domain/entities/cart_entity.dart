class CartEntity {
  final String id, cartOwner;
  final List<CartItemEntity> products;
  final double totalCartPrice;
  final int numOfCartItems;
  const CartEntity({required this.id, required this.cartOwner, required this.products, required this.totalCartPrice, required this.numOfCartItems});

  static const empty = CartEntity(id: '', cartOwner: '', products: [], totalCartPrice: 0, numOfCartItems: 0);

  /// Quantity of [productId] in the cart, or 0.
  int countOf(String productId) {
    for (final p in products) {
      if (p.productId == productId) return p.count;
    }
    return 0;
  }
}

class CartItemEntity {
  final String id, productId, title, imageCover, brand;
  final double price;
  final int count;
  const CartItemEntity({required this.id, required this.productId, required this.title, required this.imageCover, required this.price, required this.count, this.brand = ''});
}
