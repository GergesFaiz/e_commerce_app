import 'package:e_commerce/features/orders/data/models/order_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // An order from GET /api/v1/orders/user/{userId} (a bare JSON array):
  // `_id` is the document id and `id` the numeric order number.
  final orderJson = {
    'shippingAddress': {'details': 'Street 1', 'phone': '01010700999', 'city': 'Cairo'},
    'taxPrice': 0,
    'shippingPrice': 0,
    'totalOrderPrice': 100,
    'paymentMethodType': 'cash',
    'isPaid': true,
    'isDelivered': false,
    '_id': 'order1',
    'user': {'_id': 'u1', 'name': 'Gerges'},
    'cartItems': [
      {
        'count': 2,
        '_id': 'oi1',
        'product': {
          '_id': 'pr-phone',
          'id': 'pr-phone',
          'title': 'Smartphone',
          'imageCover': 'img/phone.jpg',
        },
        'price': 50,
      },
    ],
    'createdAt': '2024-05-01T10:00:00.000Z',
    'id': 1234,
  };

  group('OrderModel', () {
    test('parses a user order', () {
      final model = OrderModel.fromJson(orderJson);

      expect(model.id, 'order1');
      expect(model.number, 1234);
      expect(model.totalOrderPrice, 100);
      expect(model.paymentMethodType, 'cash');
      expect(model.isPaid, isTrue);
      expect(model.isDelivered, isFalse);
      expect(model.city, 'Cairo');
      expect(model.cartItems.single.product.title, 'Smartphone');
    });

    test('maps to entity with a parsed DateTime', () {
      final entity = OrderModel.fromJson(orderJson).toEntity();

      expect(entity.id, 'order1');
      expect(entity.number, 1234);
      expect(entity.totalOrderPrice, 100.0);
      expect(entity.createdAt.year, 2024);
      expect(entity.cartItems.first.title, 'Smartphone');
      expect(entity.cartItems.first.price, 50.0);
    });

    test('toJson round-trips', () {
      final model = OrderModel.fromJson(orderJson);
      final reparsed = OrderModel.fromJson(model.toJson());

      expect(reparsed.id, model.id);
      expect(reparsed.number, model.number);
      expect(reparsed.createdAt, model.createdAt);
      expect(reparsed.cartItems.first.count, 2);
      expect(reparsed.cartItems.first.product.id, 'pr-phone');
    });
  });

  group('OrderResponseModel', () {
    test('parses POST /orders/{cartId} where products are ids', () {
      final created = Map<String, dynamic>.from(orderJson)
        ..['cartItems'] = [
          {'count': 1, '_id': 'oi1', 'product': 'pr-phone', 'price': 50},
        ];
      final entity = OrderResponseModel.fromJson({
        'status': 'success',
        'data': created,
      }).toEntity();

      expect(entity.id, 'order1');
      expect(entity.isPaid, isTrue);
      expect(entity.cartItems.single.productId, 'pr-phone');
      expect(entity.cartItems.single.title, '');
    });
  });
}
