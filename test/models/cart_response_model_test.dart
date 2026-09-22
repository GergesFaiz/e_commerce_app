import 'package:e_commerce/features/cart/data/models/cart_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final productRefJson = {
    'id': 'pr1',
    'title': 'Cotton T-Shirt',
    'imageCover': 'img/tshirt.jpg',
  };

  final itemJson = {
    'id': 'item1',
    'count': 2,
    'price': 15.5,
    'product': productRefJson,
  };

  final cartDataJson = {
    'id': 'cart1',
    'cartOwner': 'user-123',
    'products': [itemJson],
    'totalCartPrice': 31.0,
  };

  final cartJson = {
    'status': 'success',
    'numOfCartItems': 2,
    'cartId': 'cart1',
    'data': cartDataJson,
  };

  group('CartResponseModel', () {
    test('parses all fields from JSON', () {
      final model = CartResponseModel.fromJson(cartJson);

      expect(model.status, 'success');
      expect(model.numOfCartItems, 2);
      expect(model.cartId, 'cart1');
      expect(model.data.cartOwner, 'user-123');
      expect(model.data.products, hasLength(1));
      expect(model.data.totalCartPrice, 31.0);
    });

    test('toJson round-trips', () {
      final model = CartResponseModel.fromJson(cartJson);
      final reparsed = CartResponseModel.fromJson(model.toJson());

      expect(reparsed.status, model.status);
      expect(reparsed.numOfCartItems, model.numOfCartItems);
      expect(reparsed.data.products.first.count, 2);
    });

    test('maps to entity', () {
      final entity = CartResponseModel.fromJson(cartJson).toEntity();

      expect(entity.id, 'cart1');
      expect(entity.cartOwner, 'user-123');
      expect(entity.totalCartPrice, 31.0);
      expect(entity.numOfCartItems, 2);
      expect(entity.products, hasLength(1));
      expect(entity.products.first.productId, 'pr1');
      expect(entity.products.first.title, 'Cotton T-Shirt');
      expect(entity.products.first.price, 15.5);
      expect(entity.products.first.count, 2);
    });
  });

  group('CartItemModel', () {
    test('toJson round-trips nested product ref', () {
      final model = CartItemModel.fromJson(itemJson);
      final reparsed = CartItemModel.fromJson(model.toJson());

      expect(reparsed.product.id, 'pr1');
      expect(reparsed.product.title, 'Cotton T-Shirt');
      expect(reparsed.price, 15.5);
    });
  });
}