import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/order_entity.dart';

/// Response of `POST /orders/{cartId}`: `{status, data: order}`.
class OrderResponseModel {
  final String status;
  final OrderModel data;
  OrderResponseModel({required this.status, required this.data});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) => OrderResponseModel(
        status: JsonUtils.string(json['status']),
        data: OrderModel.fromJson(JsonUtils.map(json['data']) ?? const {}),
      );

  Map<String, dynamic> toJson() => {'status': status, 'data': data.toJson()};

  OrderEntity toEntity() => data.toEntity();
}

/// An order as returned by `GET /orders/user/{userId}` (a bare JSON array).
///
/// `_id` is the document id; `id` is the numeric order number.
class OrderModel {
  final String id;
  final int number;
  final num totalOrderPrice;
  final String paymentMethodType;
  final bool isPaid, isDelivered;
  final String createdAt;
  final String city, details, phone;
  final List<OrderItemModel> cartItems;
  OrderModel({
    required this.id,
    required this.number,
    required this.totalOrderPrice,
    required this.paymentMethodType,
    required this.isPaid,
    required this.isDelivered,
    required this.createdAt,
    required this.cartItems,
    this.city = '',
    this.details = '',
    this.phone = '',
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final address = JsonUtils.map(json['shippingAddress']) ?? const {};
    return OrderModel(
      id: JsonUtils.string(json['_id']),
      number: JsonUtils.toInt(json['id']),
      totalOrderPrice: JsonUtils.toDouble(json['totalOrderPrice']),
      paymentMethodType: JsonUtils.string(json['paymentMethodType'], 'cash'),
      isPaid: json['isPaid'] == true,
      isDelivered: json['isDelivered'] == true,
      createdAt: JsonUtils.string(json['createdAt']),
      city: JsonUtils.string(address['city']),
      details: JsonUtils.string(address['details']),
      phone: JsonUtils.string(address['phone']),
      cartItems: JsonUtils.list(json['cartItems'])
          .whereType<Map>()
          .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'id': number,
        'totalOrderPrice': totalOrderPrice,
        'paymentMethodType': paymentMethodType,
        'isPaid': isPaid,
        'isDelivered': isDelivered,
        'createdAt': createdAt,
        'shippingAddress': {'city': city, 'details': details, 'phone': phone},
        'cartItems': cartItems.map((e) => e.toJson()).toList(),
      };

  OrderEntity toEntity() => OrderEntity(
        id: id,
        number: number,
        totalOrderPrice: totalOrderPrice.toDouble(),
        paymentMethodType: paymentMethodType,
        isPaid: isPaid,
        isDelivered: isDelivered,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.fromMillisecondsSinceEpoch(0),
        city: city,
        cartItems: cartItems.map((e) => e.toEntity()).toList(),
      );
}

class OrderItemModel {
  final String id;
  final int count;
  final num price;
  final OrderProductRef product;
  OrderItemModel({required this.id, required this.count, required this.price, required this.product});

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        id: JsonUtils.id(json),
        count: JsonUtils.toInt(json['count']),
        price: JsonUtils.toDouble(json['price']),
        product: OrderProductRef.fromJson(json['product']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'count': count,
        'price': price,
        'product': product.toJson(),
      };

  OrderItemEntity toEntity() => OrderItemEntity(
        productId: product.id,
        title: product.title,
        imageCover: product.imageCover,
        count: count,
        price: price.toDouble(),
      );
}

class OrderProductRef {
  final String id, title, imageCover;
  OrderProductRef({required this.id, required this.title, required this.imageCover});

  /// Accepts a populated product object or a bare product id.
  factory OrderProductRef.fromJson(dynamic json) {
    final map = JsonUtils.map(json);
    if (map == null) return OrderProductRef(id: JsonUtils.id(json), title: '', imageCover: '');
    return OrderProductRef(
      id: JsonUtils.id(map),
      title: JsonUtils.string(map['title']),
      imageCover: JsonUtils.string(map['imageCover']),
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'title': title, 'imageCover': imageCover};
}
