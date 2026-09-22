import 'package:e_commerce/features/orders/data/models/order_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final orderItemJson = {
    'id': 'oi1',
    'count': 2,
    'price': 50,
    'product': {
      'id': 'pr-phone',
      'title': 'Smartphone',
      'imageCover': 'img/phone.jpg',
    },
  };

  final orderJson = {
    'id': 'order1',
    'totalOrderPrice': 100,
    'isPaid': true,
    'isDelivered': false,
    'createdAt': '2024-05-01T10:00:00.000Z',
    'cartItems': [orderItemJson],
  };

  group('OrderResponseModel', () {
    test('parses status and order data', () {
      final model = OrderResponseModel.fromJson({
        'status': 'success',
        'data': orderJson,
      });

      expect(model.status, 'success');
      expect(model.data.id, 'order1');
      expect(model.data.totalOrderPrice, 100);
      expect(model.data.isPaid, isTrue);
      expect(model.data.isDelivered, isFalse);
      expect(model.data.cartItems, hasLength(1));
    });

    test('maps to entity with a parsed DateTime', () {
      final entity = OrderResponseModel.fromJson({
        'status': 'success',
        'data': orderJson,
      }).toEntity();

      expect(entity.id, 'order1');
      expect(entity.totalOrderPrice, 100);
      expect(entity.isPaid, isTrue);
      expect(entity.createdAt.year, 2024);
      expect(entity.cartItems.first.title, 'Smartphone');
    });
  });

  group('OrdersListResponseModel', () {
    test('parses a list of orders', () {
      final model = OrdersListResponseModel.fromJson({
        'data': [orderJson],
      });

      expect(model.data, hasLength(1));
      expect(model.data.first.id, 'order1');
    });

    test('toJson round-trips', () {
      final model = OrdersListResponseModel.fromJson({
        'data': [orderJson],
      });
      final reparsed = OrdersListResponseModel.fromJson(model.toJson());

      expect(reparsed.data.first.totalOrderPrice, 100);
      expect(reparsed.data.first.cartItems.first.product.id, 'pr-phone');
    });
  });

  group('OrderModel', () {
    test('toJson round-trips', () {
      final model = OrderModel.fromJson(orderJson);
      final reparsed = OrderModel.fromJson(model.toJson());

      expect(reparsed.id, model.id);
      expect(reparsed.createdAt, model.createdAt);
      expect(reparsed.cartItems.first.count, 2);
    });
  });
}