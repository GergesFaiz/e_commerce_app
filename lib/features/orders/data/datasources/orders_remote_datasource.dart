import '../../../../core/network/api_service.dart';
import '../../../../core/utils/cache_helper.dart';
import '../models/order_response_model.dart';

abstract class OrdersRemoteDatasource {
  Future<OrderResponseModel> checkout(
      String cartId, Map<String, dynamic> shippingAddress);
  Future<List<OrderResponseModel>> getUserOrders(String userId);
}

class OrdersRemoteDatasourceImpl implements OrdersRemoteDatasource {
  final ApiService _api;
  OrdersRemoteDatasourceImpl(this._api);

  String get _token => CacheHelper.getToken() ?? '';

  @override
  Future<OrderResponseModel> checkout(
      String cartId, Map<String, dynamic> address) =>
      _api.checkout(cartId, {'shippingAddress': address}, _token);

  @override
  Future<List<OrderResponseModel>> getUserOrders(String userId) =>
      _api.getUserOrders(userId, _token);
}