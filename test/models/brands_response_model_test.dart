import 'package:e_commerce/features/home/data/models/brands_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final brandJson = {
    '_id': 'brand-samsung',
    'name': 'Samsung',
    'image': 'img/samsung.png',
  };

  group('BrandModel', () {
    test('parses all fields from JSON including the _id alias', () {
      final model = BrandModel.fromJson(brandJson);

      expect(model.id, 'brand-samsung');
      expect(model.name, 'Samsung');
      expect(model.image, 'img/samsung.png');
    });

    test('toJson writes back the _id alias and round-trips', () {
      final model = BrandModel.fromJson(brandJson);
      final json = model.toJson();

      expect(json['_id'], 'brand-samsung');
      final reparsed = BrandModel.fromJson(json);
      expect(reparsed.id, model.id);
      expect(reparsed.name, model.name);
      expect(reparsed.image, model.image);
    });

    test('maps to entity', () {
      final entity = BrandModel.fromJson(brandJson).toEntity();

      expect(entity.id, 'brand-samsung');
      expect(entity.name, 'Samsung');
      expect(entity.image, 'img/samsung.png');
    });
  });

  group('BrandsResponseModel', () {
    test('parses a list of brands', () {
      final response = BrandsResponseModel.fromJson({
        'data': [brandJson],
      });

      expect(response.data, hasLength(1));
      expect(response.data.first.name, 'Samsung');
    });

    test('toJson round-trips', () {
      final response = BrandsResponseModel.fromJson({
        'data': [brandJson],
      });
      final reparsed = BrandsResponseModel.fromJson(response.toJson());

      expect(reparsed.data.first.id, 'brand-samsung');
    });
  });
}