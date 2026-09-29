import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'products_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductsResponseModel {
  final List<ProductModel> data;
  final PageMeta? metadata;
  ProductsResponseModel({required this.data, this.metadata});
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
  @JsonKey(readValue: _readId)
  final String id;
  final String title, imageCover;
  @JsonKey(defaultValue: '')
  final String description;
  final double price;
  final double? priceAfterDiscount;
  @JsonKey(defaultValue: 0)
  final double ratingsAverage;
  @JsonKey(defaultValue: 0)
  final int ratingsQuantity, sold, quantity;
  @JsonKey(defaultValue: <String>[])
  final List<String> images;
  final CategoryRef? category;
  final CategoryRef? brand;

  ProductModel({
    required this.id, required this.title, required this.description,
    required this.imageCover, required this.price, this.priceAfterDiscount,
    required this.ratingsAverage, required this.ratingsQuantity,
    required this.sold, required this.quantity, required this.images,
    this.category, this.brand,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  ProductEntity toEntity() => ProductEntity(
    id: id, title: title, description: description, imageCover: imageCover,
    price: price, priceAfterDiscount: priceAfterDiscount,
    ratingsAverage: ratingsAverage, ratingsQuantity: ratingsQuantity,
    sold: sold, quantity: quantity, images: images,
    categoryName: category?.name ?? '', brandName: brand?.name ?? '',
  );
}

/// Documents expose `_id`; products also carry a virtual `id`.
Object? _readId(Map json, String key) => json['_id'] ?? json['id'];

@JsonSerializable()
class PageMeta {
  final int? currentPage;
  final int? numberOfPages;
  final int? limit;
  PageMeta({this.currentPage, this.numberOfPages, this.limit});
  factory PageMeta.fromJson(Map<String, dynamic> json) => _$PageMetaFromJson(json);
  Map<String, dynamic> toJson() => _$PageMetaToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryRef {
  @JsonKey(readValue: _readId, defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String name;
  CategoryRef({required this.id, required this.name});
  factory CategoryRef.fromJson(Map<String, dynamic> json) => _$CategoryRefFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryRefToJson(this);
}