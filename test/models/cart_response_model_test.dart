import 'package:e_commerce/features/cart/data/models/cart_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // GET/PUT/DELETE /api/v1/cart: products are populated.
  final populatedCart = {
    'status': 'success',
    'numOfCartItems': 2,
    'cartId': 'cart1',
    'data': {
      '_id': 'cart1',
      'cartOwner': 'user-123',
      'products': [
        {
          'count': 2,
          '_id': 'item1',
          'product': {
            '_id': 'pr1',
            'id': 'pr1',
            'title': 'Cotton T-Shirt',
            'imageCover': 'img/tshirt.jpg',
            'brand': {'_id': 'b1', 'name': 'DeFacto'},
          },
          'price': 15.5,
        },
      ],
      'totalCartPrice': 31,
    },
  };

  // POST /api/v1/cart: products reference ids only.
  final addedCart = {
    'status': 'success',
    'message': 'Product added successfully to your cart',
    'numOfCartItems': 3,
    'cartId': 'cart1',
    'data': {
      '_id': 'cart1',
      'cartOwner': 'user-123',
      'products': [
        {'count': 3, '_id': 'item1', 'product': 'pr1', 'price': 15.5},
      ],
      'totalCartPrice': 46.5,
    },
  };

  group('CartResponseModel', () {
    test('parses a populated cart', () {
      final model = CartResponseModel.fromJson(populatedCart);

      expect(model.status, 'success');
      expect(model.numOfCartItems, 2);
      expect(model.cartId, 'cart1');
      expect(model.data.id, 'cart1');
      expect(model.data.cartOwner, 'user-123');
      expect(model.data.products, hasLength(1));
      expect(model.data.totalCartPrice, 31);
    });

    test('maps to entity with the product id used by update/delete', () {
      final entity = CartResponseModel.fromJson(populatedCart).toEntity();

      expect(entity.id, 'cart1');
      expect(entity.totalCartPrice, 31.0);
      expect(entity.numOfCartItems, 2);
      final item = entity.products.single;
      expect(item.id, 'item1');
      expect(item.productId, 'pr1');
      expect(item.title, 'Cotton T-Shirt');
      expect(item.brand, 'DeFacto');
      expect(item.price, 15.5);
      expect(item.count, 2);
      expect(entity.countOf('pr1'), 2);
      expect(entity.countOf('other'), 0);
    });

    test('parses the add-to-cart answer where product is an id', () {
      final entity = CartResponseModel.fromJson(addedCart).toEntity();

      expect(entity.numOfCartItems, 3);
      expect(entity.products.single.productId, 'pr1');
      expect(entity.products.single.title, '');
      expect(entity.countOf('pr1'), 3);
    });

    test('parses the clear-cart answer as an empty cart', () {
      final entity =
          CartResponseModel.fromJson({'message': 'success'}).toEntity();

      expect(entity.products, isEmpty);
      expect(entity.numOfCartItems, 0);
      expect(entity.totalCartPrice, 0);
    });

    test('toJson round-trips', () {
      final model = CartResponseModel.fromJson(populatedCart);
      final reparsed = CartResponseModel.fromJson(model.toJson());

      expect(reparsed.numOfCartItems, model.numOfCartItems);
      expect(reparsed.data.products.first.count, 2);
      expect(reparsed.data.products.first.product.id, 'pr1');
      expect(reparsed.data.products.first.product.brand, 'DeFacto');
    });
  });
}
