import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'categories_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoriesResponseModel {
  final List<CategoryModel> data;
  CategoriesResponseModel({required this.data});
  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) => _$CategoriesResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id')
  final String id;
  final String name, image;
  CategoryModel({required this.id, required this.name, required this.image});
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  CategoryEntity toEntity() => CategoryEntity(id: id, name: name, image: image);
}