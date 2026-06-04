import 'package:e_commerce/core/api_manager/api_result.dart';

import '../entities/category_entity.dart';

abstract class CategoryRepoContract {
  Future<ApiResult<List<CategoryEntity>>> getCategories();
}
