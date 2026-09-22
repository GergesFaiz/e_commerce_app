// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponseModel _$OrderResponseModelFromJson(Map<String, dynamic> json) =>
    OrderResponseModel(
      status: json['status'] as String,
      data: OrderModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderResponseModelToJson(OrderResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data.toJson(),
    };

OrdersListResponseModel _$OrdersListResponseModelFromJson(
        Map<String, dynamic> json) =>
    OrdersListResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrdersListResponseModelToJson(
        OrdersListResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      totalOrderPrice: (json['totalOrderPrice'] as num).toInt(),
      isPaid: json['isPaid'] as bool,
      isDelivered: json['isDelivered'] as bool,
      createdAt: json['createdAt'] as String,
      cartItems: (json['cartItems'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'totalOrderPrice': instance.totalOrderPrice,
      'isPaid': instance.isPaid,
      'isDelivered': instance.isDelivered,
      'createdAt': instance.createdAt,
      'cartItems': instance.cartItems.map((e) => e.toJson()).toList(),
    };

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String,
      count: (json['count'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      product:
          OrderProductRef.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'count': instance.count,
      'price': instance.price,
      'product': instance.product.toJson(),
    };

OrderProductRef _$OrderProductRefFromJson(Map<String, dynamic> json) =>
    OrderProductRef(
      id: json['id'] as String,
      title: json['title'] as String,
      imageCover: json['imageCover'] as String,
    );

Map<String, dynamic> _$OrderProductRefToJson(OrderProductRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'imageCover': instance.imageCover,
    };
