// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandsResponseModel _$BrandsResponseModelFromJson(Map<String, dynamic> json) =>
    BrandsResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => BrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BrandsResponseModelToJson(
        BrandsResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
