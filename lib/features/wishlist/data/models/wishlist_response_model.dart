import '../../../../core/utils/json_utils.dart';
import '../../domain/entities/wishlist_entity.dart';

/// Wishlist payload from `/wishlist`.
///
/// GET returns `{status, count, data: [product...]}`; POST/DELETE return
/// `{status, message, data: [productId...]}`.
class WishlistResponseModel {
  final String status, message;
  final List<WishlistItemModel> data;
  final List<String> ids;
  WishlistResponseModel({required this.status, required this.message, required this.data, required this.ids});

  factory WishlistResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = JsonUtils.list(json['data']);
    final items = raw
        .whereType<Map>()
        .map((e) => WishlistItemModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    final ids = raw.map(JsonUtils.id).where((id) => id.isNotEmpty).toList();
    return WishlistResponseModel(
      status: JsonUtils.string(json['status']),
      message: JsonUtils.string(json['message']),
      data: items,
      ids: ids,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class WishlistItemModel {
  final String id, title, imageCover;
  final num price;
  final num? priceAfterDiscount;
  final num ratingsAverage;
  WishlistItemModel({
    required this.id,
    required this.title,
    required this.imageCover,
    required this.price,
    this.priceAfterDiscount,
    this.ratingsAverage = 0,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) => WishlistItemModel(
        id: JsonUtils.id(json),
        title: JsonUtils.string(json['title']),
        imageCover: JsonUtils.string(json['imageCover']),
        price: JsonUtils.toDouble(json['price']),
        priceAfterDiscount: json['priceAfterDiscount'] == null
            ? null
            : JsonUtils.toDouble(json['priceAfterDiscount']),
        ratingsAverage: JsonUtils.toDouble(json['ratingsAverage']),
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'imageCover': imageCover,
        'price': price,
        if (priceAfterDiscount != null) 'priceAfterDiscount': priceAfterDiscount,
        'ratingsAverage': ratingsAverage,
      };

  WishlistItemEntity toEntity() => WishlistItemEntity(
        id: id,
        title: title,
        imageCover: imageCover,
        price: price.toDouble(),
        priceAfterDiscount: priceAfterDiscount?.toDouble(),
        ratingsAverage: ratingsAverage.toDouble(),
      );
}
