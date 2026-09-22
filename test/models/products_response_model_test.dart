import 'package:e_commerce/features/products/data/models/products_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final categoryJson = {
    'id': 'cat-electronics',
    'name': 'Electronics',
  };

  final productJson = {
    'id': 'p1',
    'title': 'Wireless Headphones',
    'description': 'Active noise cancelling over-ear headphones',
    'imageCover': 'img/headphones.jpg',
    'price': 129.99,
    'priceAfterDiscount': 99.99,
    'ratingsAverage': 4.7,
    'ratingsQuantity': 120,
    'sold': 45,
    'quantity': 30,
    'images': ['img/a.jpg', 'img/b.jpg'],
    'category': categoryJson,
  };

  group('ProductModel', () {
    test('parses all fields from JSON', () {
      final model = ProductModel.fromJson(productJson);

      expect(model.id, 'p1');
      expect(model.title, 'Wireless Headphones');
      expect(model.description, contains('noise cancelling'));
      expect(model.imageCover, 'img/headphones.jpg');
      expect(model.price, 129.99);
      expect(model.priceAfterDiscount, 99.99);
      expect(model.ratingsAverage, 4.7);
      expect(model.ratingsQuantity, 120);
      expect(model.sold, 45);
      expect(model.quantity, 30);
      expect(model.images, ['img/a.jpg', 'img/b.jpg']);
      expect(model.category.id, 'cat-electronics');
      expect(model.category.name, 'Electronics');
    });

    test('toJson produces equivalent JSON that round-trips', () {
      final model = ProductModel.fromJson(productJson);
      final reparsed = ProductModel.fromJson(model.toJson());

      expect(reparsed.id, model.id);
      expect(reparsed.title, model.title);
      expect(reparsed.description, model.description);
      expect(reparsed.price, model.price);
      expect(reparsed.priceAfterDiscount, model.priceAfterDiscount);
      expect(reparsed.ratingsAverage, model.ratingsAverage);
      expect(reparsed.images, model.images);
      expect(reparsed.category.name, model.category.name);
    });

    test('handles nullable priceAfterDiscount', () {
      final json = Map<String, dynamic>.from(productJson)
        ..remove('priceAfterDiscount');
      final model = ProductModel.fromJson(json);
      expect(model.priceAfterDiscount, isNull);
    });

    test('maps to entity', () {
      final entity = ProductModel.fromJson(productJson).toEntity();

      expect(entity.id, 'p1');
      expect(entity.title, 'Wireless Headphones');
      expect(entity.price, 129.99);
      expect(entity.priceAfterDiscount, 99.99);
      expect(entity.categoryName, 'Electronics');
      expect(entity.images, hasLength(2));
    });
  });

  group('ProductsResponseModel', () {
    test('parses a list of products', () {
      final response = ProductsResponseModel.fromJson({
        'data': [productJson],
      });

      expect(response.data, hasLength(1));
      expect(response.data.first.title, 'Wireless Headphones');
    });

    test('toJson round-trips', () {
      final response = ProductsResponseModel.fromJson({
        'data': [productJson],
      });
      final reparsed = ProductsResponseModel.fromJson(response.toJson());

      expect(reparsed.data, hasLength(1));
      expect(reparsed.data.first.id, 'p1');
    });
  });

  group('ProductDetailsResponseModel', () {
    test('parses a single product payload', () {
      final details =
          ProductDetailsResponseModel.fromJson({'data': productJson});

      expect(details.data.price, 129.99);
      expect(details.data.category.name, 'Electronics');
    });
  });
}