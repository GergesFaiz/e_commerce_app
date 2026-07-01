import '../../../../core/network/api_service.dart';
import '../models/categories_response_model.dart';
import '../models/brands_response_model.dart';

abstract class HomeRemoteDatasource {
  Future<CategoriesResponseModel> getCategories();
  Future<BrandsResponseModel> getBrands();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final ApiService _api;
  HomeRemoteDatasourceImpl(this._api);
  @override Future<CategoriesResponseModel> getCategories() => _api.getCategories();
  @override Future<BrandsResponseModel> getBrands() => _api.getBrands();
}