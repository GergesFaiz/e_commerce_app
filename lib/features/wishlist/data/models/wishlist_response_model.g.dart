// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishlistResponseModel _$WishlistResponseModelFromJson(
        Map<String, dynamic> json) =>
    WishlistResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WishlistResponseModelToJson(
        WishlistResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

WishlistItemModel _$WishlistItemModelFromJson(Map<String, dynamic> json) =>
    WishlistItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageCover: json['imageCover'] as String,
      price: json['price'] as num,
    );

Map<String, dynamic> _$WishlistItemModelToJson(WishlistItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageCover': instance.imageCover,
      'price': instance.price,
    };
