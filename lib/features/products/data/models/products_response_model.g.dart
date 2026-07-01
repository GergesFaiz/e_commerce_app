// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponseModel _$ProductsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProductsResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsResponseModelToJson(
        ProductsResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ProductDetailsResponseModel _$ProductDetailsResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProductDetailsResponseModel(
      data: ProductModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDetailsResponseModelToJson(
        ProductDetailsResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageCover: json['imageCover'] as String,
      price: (json['price'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble(),
      ratingsAverage: (json['ratingsAverage'] as num).toDouble(),
      ratingsQuantity: (json['ratingsQuantity'] as num).toInt(),
      sold: (json['sold'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      category: CategoryRef.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageCover': instance.imageCover,
      'price': instance.price,
      'priceAfterDiscount': instance.priceAfterDiscount,
      'ratingsAverage': instance.ratingsAverage,
      'ratingsQuantity': instance.ratingsQuantity,
      'sold': instance.sold,
      'quantity': instance.quantity,
      'images': instance.images,
      'category': instance.category,
    };

CategoryRef _$CategoryRefFromJson(Map<String, dynamic> json) => CategoryRef(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$CategoryRefToJson(CategoryRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
