import '../../../../core/network/api_service.dart';
import '../../domain/repos/i_products_repo.dart' show ProductQuery;
import '../models/products_response_model.dart';

abstract class ProductsRemoteDatasource {
  Future<ProductsResponseModel> getProducts(ProductQuery query);
  Future<ProductDetailsResponseModel> getProductById(String id);
}

class ProductsRemoteDatasourceImpl implements ProductsRemoteDatasource {
  final ApiService _api;
  ProductsRemoteDatasourceImpl(this._api);
  @override
  Future<ProductsResponseModel> getProducts(ProductQuery query) => _api.getProducts(
        keyword: query.keyword?.isEmpty == true ? null : query.keyword,
        sort: query.sort,
        page: query.page,
        limit: query.limit,
        categoryId: query.categoryId,
      );
  @override
  Future<ProductDetailsResponseModel> getProductById(String id) => _api.getProductById(id);
}
