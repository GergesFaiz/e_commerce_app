import '../../../../core/network/api_service.dart';
import '../../../../core/utils/cache_helper.dart';
import '../models/wishlist_response_model.dart';

abstract class WishlistRemoteDatasource {
  Future<WishlistResponseModel> getWishlist();
  Future<WishlistResponseModel> addToWishlist(String productId);
  Future<WishlistResponseModel> removeFromWishlist(String productId);
}

class WishlistRemoteDatasourceImpl implements WishlistRemoteDatasource {
  final ApiService _api;
  WishlistRemoteDatasourceImpl(this._api);
  String get _token => CacheHelper.getToken() ?? '';
  @override Future<WishlistResponseModel> getWishlist() => _api.getWishlist(_token);
  @override Future<WishlistResponseModel> addToWishlist(String id) => _api.addToWishlist({'productId': id}, _token);
  @override Future<WishlistResponseModel> removeFromWishlist(String id) => _api.removeFromWishlist(id, _token);
}