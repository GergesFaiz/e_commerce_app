import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'products_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductsResponseModel {
  final List<ProductModel> data;
  ProductsResponseModel({required this.data});
  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) => _$ProductsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductDetailsResponseModel {
  final ProductModel data;
  ProductDetailsResponseModel({required this.data});
  factory ProductDetailsResponseModel.fromJson(Map<String, dynamic> json) => _$ProductDetailsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsResponseModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String id, title, description, imageCover;
  final double price;
  final double? priceAfterDiscount;
  final double ratingsAverage;
  final int ratingsQuantity, sold, quantity;
  final List<String> images;
  final CategoryRef category;

  ProductModel({
    required this.id, required this.title, required this.description,
    required this.imageCover, required this.price, this.priceAfterDiscount,
    required this.ratingsAverage, required this.ratingsQuantity,
    required this.sold, required this.quantity, required this.images,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() => ProductEntity(
    id: id, title: title, description: description, imageCover: imageCover,
    price: price, priceAfterDiscount: priceAfterDiscount,
    ratingsAverage: ratingsAverage, ratingsQuantity: ratingsQuantity,
    sold: sold, quantity: quantity, images: images, categoryName: category.name,
  );
}

@JsonSerializable(explicitToJson: true)
class CategoryRef {
  final String id, name;
  CategoryRef({required this.id, required this.name});
  factory CategoryRef.fromJson(Map<String, dynamic> json) => _$CategoryRefFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryRefToJson(this);
}