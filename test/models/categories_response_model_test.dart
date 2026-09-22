import 'package:e_commerce/features/home/data/models/categories_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final categoryJson = {
    '_id': 'cat-laptops',
    'name': 'Laptops',
    'image': 'img/laptop.jpg',
  };

  group('CategoryModel', () {
    test('parses all fields from JSON including the _id alias', () {
      final model = CategoryModel.fromJson(categoryJson);

      expect(model.id, 'cat-laptops');
      expect(model.name, 'Laptops');
      expect(model.image, 'img/laptop.jpg');
    });

    test('toJson writes back the _id alias and round-trips', () {
      final model = CategoryModel.fromJson(categoryJson);
      final json = model.toJson();

      expect(json['_id'], 'cat-laptops');
      final reparsed = CategoryModel.fromJson(json);
      expect(reparsed.id, model.id);
      expect(reparsed.name, model.name);
      expect(reparsed.image, model.image);
    });

    test('maps to entity', () {
      final entity = CategoryModel.fromJson(categoryJson).toEntity();

      expect(entity.id, 'cat-laptops');
      expect(entity.name, 'Laptops');
      expect(entity.image, 'img/laptop.jpg');
    });
  });

  group('CategoriesResponseModel', () {
    test('parses a list of categories', () {
      final response = CategoriesResponseModel.fromJson({
        'data': [categoryJson],
      });

      expect(response.data, hasLength(1));
      expect(response.data.first.name, 'Laptops');
    });

    test('toJson round-trips', () {
      final response = CategoriesResponseModel.fromJson({
        'data': [categoryJson],
      });
      final reparsed = CategoriesResponseModel.fromJson(response.toJson());

      expect(reparsed.data.first.id, 'cat-laptops');
    });
  });
}