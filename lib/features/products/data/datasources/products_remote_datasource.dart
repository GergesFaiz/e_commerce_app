import '../../../../core/network/api_service.dart';
import '../models/products_response_model.dart';

abstract class ProductsRemoteDatasource {
  Future<ProductsResponseModel> getProducts();
  Future<ProductDetailsResponseModel> getProductById(String id);
}

class ProductsRemoteDatasourceImpl implements ProductsRemoteDatasource {
  final ApiService _api;
  ProductsRemoteDatasourceImpl(this._api);
  @override Future<ProductsResponseModel> getProducts() => _api.getProducts();
  @override Future<ProductDetailsResponseModel> getProductById(String id) => _api.getProductById(id);
}