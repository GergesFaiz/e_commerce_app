import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_entity.dart';

part 'cart_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartResponseModel {
  final String status;
  final int numOfCartItems;
  final String cartId;
  final CartDataModel data;
  CartResponseModel({required this.status, required this.numOfCartItems, required this.cartId, required this.data});
  factory CartResponseModel.fromJson(Map<String, dynamic> json) => _$CartResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartResponseModelToJson(this);

  CartEntity toEntity() => CartEntity(
    id: cartId, cartOwner: data.cartOwner,
    products: data.products.map((e) => e.toEntity()).toList(),
    totalCartPrice: data.totalCartPrice.toDouble(),
    numOfCartItems: numOfCartItems,
  );
}

@JsonSerializable(explicitToJson: true)
class CartDataModel {
  final String id, cartOwner;
  final List<CartItemModel> products;
  final num totalCartPrice;
  CartDataModel({required this.id, required this.cartOwner, required this.products, required this.totalCartPrice});
  factory CartDataModel.fromJson(Map<String, dynamic> json) => _$CartDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartDataModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CartItemModel {
  final String id;
  final int count;
  final num price;
  final CartProductRef product;
  CartItemModel({required this.id, required this.count, required this.price, required this.product});
  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
  CartItemEntity toEntity() => CartItemEntity(id: id, productId: product.id, title: product.title, imageCover: product.imageCover, price: price.toDouble(), count: count);
}

@JsonSerializable(explicitToJson: true)
class CartProductRef {
  final String id, title, imageCover;
  CartProductRef({required this.id, required this.title, required this.imageCover});
  factory CartProductRef.fromJson(Map<String, dynamic> json) => _$CartProductRefFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductRefToJson(this);
}