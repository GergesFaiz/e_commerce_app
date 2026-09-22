import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/wishlist_entity.dart';

part 'wishlist_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class WishlistResponseModel {
  final String status, message;
  final List<WishlistItemModel>? data;
  WishlistResponseModel({required this.status, required this.message, this.data});
  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) => _$WishlistResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$WishlistResponseModelToJson(this);
}

@JsonSerializable()
class WishlistItemModel {
  final String id, title, imageCover;
  final num price;
  WishlistItemModel({required this.id, required this.title, required this.imageCover, required this.price});
  factory WishlistItemModel.fromJson(Map<String, dynamic> json) => _$WishlistItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$WishlistItemModelToJson(this);
  WishlistItemEntity toEntity() => WishlistItemEntity(id: id, title: title, imageCover: imageCover, price: price.toDouble());
}