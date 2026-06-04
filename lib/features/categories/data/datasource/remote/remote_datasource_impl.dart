import 'package:injectable/injectable.dart';

import '../../../../../config/constants.dart';
import '../../../../../core/api_manager/api_manager.dart';
import '../../models/category_model.dart';
import '../contract/datasource_contract.dart';

@Singleton(as: DataSourceContract)
class RemoteDataSourceImpl implements DataSourceContract {
  ApiManager apiManager;
  RemoteDataSourceImpl(this.apiManager);
  @override
  Future<List<CategoryModel>> getCategories() async {
    final res =
        await apiManager.getData(endpoint: AppConstants.getCategoriesEndpoint);
    final resBody = res.data;
    CategoryResponse categoryResponse =
        CategoryResponse.fromJson(resBody ?? {});
    return categoryResponse.data;
  }
}
