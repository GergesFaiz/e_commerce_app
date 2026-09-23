import '../../../../core/network/api_service.dart';
import '../../../../core/utils/cache_helper.dart';
import '../models/cart_response_model.dart';

abstract class CartRemoteDatasource {
  Future<CartResponseModel> addToCart(String productId);
  Future<CartResponseModel> getCart();
  Future<CartResponseModel> removeFromCart(String itemId);
  Future<CartResponseModel> updateQuantity(String itemId, int count);
  Future<CartResponseModel> clearCart();
}

class CartRemoteDatasourceImpl implements CartRemoteDatasource {
  final ApiService _api;
  CartRemoteDatasourceImpl(this._api);

  String get _token => CacheHelper.getToken() ?? '';

  @override Future<CartResponseModel> addToCart(String productId) => _api.addToCart({'productId': productId}, _token);
  @override Future<CartResponseModel> getCart() => _api.getCart(_token);
  @override Future<CartResponseModel> removeFromCart(String itemId) => _api.removeFromCart(itemId, _token);
  @override Future<CartResponseModel> updateQuantity(String itemId, int count) => _api.updateCartQuantity(itemId, {'count': count}, _token);
  @override Future<CartResponseModel> clearCart() => _api.clearCart(_token);
}