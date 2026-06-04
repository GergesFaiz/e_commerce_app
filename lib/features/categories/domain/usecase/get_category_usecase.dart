import 'package:e_commerce/core/api_manager/api_result.dart';
import 'package:e_commerce/features/categories/domain/entities/category_entity.dart';
import 'package:e_commerce/features/categories/domain/repo/category_repo_contract.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCategoriesUseCase {
  CategoryRepoContract categoryRepo;
  GetCategoriesUseCase({required this.categoryRepo});
  Future<ApiResult<List<CategoryEntity>>> call() => categoryRepo.getCategories();
}
