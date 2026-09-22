import 'package:e_commerce/features/wishlist/data/models/wishlist_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final itemJson = {
    'id': 'w1',
    'title': 'Smart Watch',
    'imageCover': 'img/watch.jpg',
    'price': 99.5,
  };

  group('WishlistResponseModel', () {
    test('parses status, message and items', () {
      final model = WishlistResponseModel.fromJson({
        'status': 'success',
        'message': 'Wishlist fetched successfully',
        'data': [itemJson],
      });

      expect(model.status, 'success');
      expect(model.message, 'Wishlist fetched successfully');
      expect(model.data, hasLength(1));
      expect(model.data!.first.title, 'Smart Watch');
    });

    test('handles a payload without items (nullable data)', () {
      final model = WishlistResponseModel.fromJson({
        'status': 'success',
        'message': 'No items in wishlist',
      });

      expect(model.data, isNull);
    });

    test('maps items to entities', () {
      final model = WishlistResponseModel.fromJson({
        'status': 'success',
        'message': 'ok',
        'data': [itemJson],
      });

      final entity = model.data!.first.toEntity();
      expect(entity.id, 'w1');
      expect(entity.price, 99.5);
      expect(entity.imageCover, 'img/watch.jpg');
    });
  });

  group('WishlistItemModel', () {
    test('toJson round-trips', () {
      final model = WishlistItemModel.fromJson(itemJson);
      final reparsed = WishlistItemModel.fromJson(model.toJson());

      expect(reparsed.id, model.id);
      expect(reparsed.title, model.title);
      expect(reparsed.price, model.price);
    });
  });
}