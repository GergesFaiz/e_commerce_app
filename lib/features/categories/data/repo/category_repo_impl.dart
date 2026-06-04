import 'package:dio/dio.dart';
import 'package:e_commerce/core/api_manager/api_result.dart';
import 'package:e_commerce/features/categories/data/datasource/contract/datasource_contract.dart';
import 'package:e_commerce/features/categories/domain/entities/category_entity.dart';
import 'package:e_commerce/features/categories/domain/repo/category_repo_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepoContract)
class CategoryRepoImpl implements CategoryRepoContract {
  DataSourceContract datasource;
  CategoryRepoImpl(
    this.datasource,
  );
  @override
  Future<ApiResult<List<CategoryEntity>>> getCategories() async {
    try {
      final result = await datasource.getCategories();
      List<CategoryEntity> catList =
          result.map((e) => e.toEntity()).toList(); // <CategoryEntity>
      return ApiSuccessResult<List<CategoryEntity>>(catList);
    } on DioException catch (e) {
      return ApiErrorResult<List<CategoryEntity>>(e);
    }
  }
}
