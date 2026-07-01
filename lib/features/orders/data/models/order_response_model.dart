import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';

part 'order_response_model.g.dart';

@JsonSerializable()
class OrderResponseModel {
  final String status;
  final OrderModel data;
  OrderResponseModel({required this.status, required this.data});
  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => _$OrderResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResponseModelToJson(this);
  OrderEntity toEntity() => data.toEntity();
}

@JsonSerializable()
class OrdersListResponseModel {
  final List<OrderModel> data;
  OrdersListResponseModel({required this.data});
  factory OrdersListResponseModel.fromJson(Map<String, dynamic> json) => _$OrdersListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrdersListResponseModelToJson(this);
}

@JsonSerializable()
class OrderModel {
  final String id;
  final int totalOrderPrice;
  final bool isPaid, isDelivered;
  final String createdAt;
  final List<OrderItemModel> cartItems;
  OrderModel({required this.id, required this.totalOrderPrice, required this.isPaid, required this.isDelivered, required this.createdAt, required this.cartItems});
  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
  OrderEntity toEntity() => OrderEntity(id: id, totalOrderPrice: totalOrderPrice, isPaid: isPaid, isDelivered: isDelivered, createdAt: DateTime.parse(createdAt), cartItems: cartItems.map((e) => e.toEntity()).toList());
}

@JsonSerializable()
class OrderItemModel {
  final String id;
  final int count, price;
  final OrderProductRef product;
  OrderItemModel({required this.id, required this.count, required this.price, required this.product});
  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
  OrderItemEntity toEntity() => OrderItemEntity(productId: product.id, title: product.title, imageCover: product.imageCover, count: count, price: price);
}

@JsonSerializable()
class OrderProductRef {
  final String id, title, imageCover;
  OrderProductRef({required this.id, required this.title, required this.imageCover});
  factory OrderProductRef.fromJson(Map<String, dynamic> json) => _$OrderProductRefFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductRefToJson(this);
}