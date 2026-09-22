// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartResponseModel _$CartResponseModelFromJson(Map<String, dynamic> json) =>
    CartResponseModel(
      status: json['status'] as String,
      numOfCartItems: (json['numOfCartItems'] as num).toInt(),
      cartId: json['cartId'] as String,
      data: CartDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartResponseModelToJson(CartResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'numOfCartItems': instance.numOfCartItems,
      'cartId': instance.cartId,
      'data': instance.data.toJson(),
    };

CartDataModel _$CartDataModelFromJson(Map<String, dynamic> json) =>
    CartDataModel(
      id: json['id'] as String,
      cartOwner: json['cartOwner'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCartPrice: json['totalCartPrice'] as num,
    );

Map<String, dynamic> _$CartDataModelToJson(CartDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cartOwner': instance.cartOwner,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'totalCartPrice': instance.totalCartPrice,
    };

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String,
      count: (json['count'] as num).toInt(),
      price: json['price'] as num,
      product: CartProductRef.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'price': instance.price,
      'product': instance.product.toJson(),
    };

CartProductRef _$CartProductRefFromJson(Map<String, dynamic> json) =>
    CartProductRef(
      id: json['id'] as String,
      title: json['title'] as String,
      imageCover: json['imageCover'] as String,
    );

Map<String, dynamic> _$CartProductRefToJson(CartProductRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageCover': instance.imageCover,
    };
