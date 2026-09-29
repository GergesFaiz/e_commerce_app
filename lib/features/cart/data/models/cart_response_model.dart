import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/cart_entity.dart';

/// Cart payload from `/cart`.
///
/// GET/PUT/DELETE return populated products; POST returns product ids only;
/// clearing the cart returns just `{message}`.
class CartResponseModel {
  final String status;
  final int numOfCartItems;
  final String cartId;
  final CartDataModel data;
  CartResponseModel({required this.status, required this.numOfCartItems, required this.cartId, required this.data});

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = JsonUtils.map(json['data']);
    final data = raw == null ? CartDataModel.empty() : CartDataModel.fromJson(raw);
    return CartResponseModel(
      status: JsonUtils.string(json['status'] ?? json['message']),
      numOfCartItems: JsonUtils.toInt(json['numOfCartItems']),
      cartId: JsonUtils.string(json['cartId'], data.id),
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'numOfCartItems': numOfCartItems,
        'cartId': cartId,
        'data': data.toJson(),
      };

  CartEntity toEntity() => CartEntity(
    id: cartId, cartOwner: data.cartOwner,
    products: data.products.map((e) => e.toEntity()).toList(),
    totalCartPrice: data.totalCartPrice.toDouble(),
    numOfCartItems: numOfCartItems,
  );
}

class CartDataModel {
  final String id, cartOwner;
  final List<CartItemModel> products;
  final num totalCartPrice;
  CartDataModel({required this.id, required this.cartOwner, required this.products, required this.totalCartPrice});

  factory CartDataModel.empty() => CartDataModel(id: '', cartOwner: '', products: const [], totalCartPrice: 0);

  factory CartDataModel.fromJson(Map<String, dynamic> json) => CartDataModel(
        id: JsonUtils.id(json),
        cartOwner: JsonUtils.string(json['cartOwner']),
        products: JsonUtils.list(json['products'])
            .whereType<Map>()
            .map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        totalCartPrice: JsonUtils.toDouble(json['totalCartPrice']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'cartOwner': cartOwner,
        'products': products.map((e) => e.toJson()).toList(),
        'totalCartPrice': totalCartPrice,
      };
}

class CartItemModel {
  final String id;
  final int count;
  final num price;
  final CartProductRef product;
  CartItemModel({required this.id, required this.count, required this.price, required this.product});

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: JsonUtils.id(json),
        count: JsonUtils.toInt(json['count']),
        price: JsonUtils.toDouble(json['price']),
        product: CartProductRef.fromJson(json['product']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'count': count,
        'price': price,
        'product': product.toJson(),
      };

  CartItemEntity toEntity() => CartItemEntity(
        id: id,
        productId: product.id,
        title: product.title,
        imageCover: product.imageCover,
        price: price.toDouble(),
        count: count,
        brand: product.brand,
      );
}

class CartProductRef {
  final String id, title, imageCover, brand;
  CartProductRef({required this.id, required this.title, required this.imageCover, this.brand = ''});

  /// Accepts a populated product object or a bare product id.
  factory CartProductRef.fromJson(dynamic json) {
    final map = JsonUtils.map(json);
    if (map == null) return CartProductRef(id: JsonUtils.id(json), title: '', imageCover: '');
    final brand = JsonUtils.map(map['brand']);
    return CartProductRef(
      id: JsonUtils.id(map),
      title: JsonUtils.string(map['title']),
      imageCover: JsonUtils.string(map['imageCover']),
      brand: JsonUtils.string(brand?['name']),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'imageCover': imageCover,
        'brand': {'name': brand},
      };
}
