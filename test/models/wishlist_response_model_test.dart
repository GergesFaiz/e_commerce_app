import 'package:e_commerce/features/wishlist/data/models/wishlist_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final productJson = {
    '_id': 'w1',
    'id': 'w1',
    'title': 'Smart Watch',
    'imageCover': 'img/watch.jpg',
    'price': 120,
    'priceAfterDiscount': 99.5,
    'ratingsAverage': 4.2,
  };

  group('WishlistResponseModel', () {
    test('parses GET /wishlist (products, no message)', () {
      final model = WishlistResponseModel.fromJson({
        'status': 'success',
        'count': 1,
        'data': [productJson],
      });

      expect(model.status, 'success');
      expect(model.message, '');
      expect(model.data, hasLength(1));
      expect(model.data.first.title, 'Smart Watch');
      expect(model.ids, ['w1']);
    });

    test('parses POST/DELETE answers (ids only)', () {
      final model = WishlistResponseModel.fromJson({
        'status': 'success',
        'message': 'Product added successfully to your wishlist',
        'data': ['w1', 'w2'],
      });

      expect(model.data, isEmpty);
      expect(model.ids, ['w1', 'w2']);
      expect(model.message, contains('added'));
    });

    test('handles a payload without data', () {
      final model = WishlistResponseModel.fromJson({'status': 'success'});

      expect(model.data, isEmpty);
      expect(model.ids, isEmpty);
    });

    test('maps items to entities', () {
      final entity = WishlistResponseModel.fromJson({
        'status': 'success',
        'data': [productJson],
      }).data.first.toEntity();

      expect(entity.id, 'w1');
      expect(entity.price, 120);
      expect(entity.priceAfterDiscount, 99.5);
      expect(entity.ratingsAverage, 4.2);
      expect(entity.imageCover, 'img/watch.jpg');
    });
  });

  group('WishlistItemModel', () {
    test('toJson round-trips', () {
      final model = WishlistItemModel.fromJson(productJson);
      final reparsed = WishlistItemModel.fromJson(model.toJson());

      expect(reparsed.id, model.id);
      expect(reparsed.title, model.title);
      expect(reparsed.price, model.price);
      expect(reparsed.priceAfterDiscount, model.priceAfterDiscount);
    });
  });
}
