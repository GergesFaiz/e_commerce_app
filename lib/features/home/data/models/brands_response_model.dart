import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'brands_response_model.g.dart';

@JsonSerializable()
class BrandsResponseModel {
  final List<BrandModel> data;
  BrandsResponseModel({required this.data});
  factory BrandsResponseModel.fromJson(Map<String, dynamic> json) => _$BrandsResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandsResponseModelToJson(this);
}

@JsonSerializable()
class BrandModel {
  @JsonKey(name: '_id')
  final String id;
  final String name, image;
  BrandModel({required this.id, required this.name, required this.image});
  factory BrandModel.fromJson(Map<String, dynamic> json) => _$BrandModelFromJson(json);
  Map<String, dynamic> toJson() => _$BrandModelToJson(this);
  BrandEntity toEntity() => BrandEntity(id: id, name: name, image: image);
}