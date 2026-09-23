import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repos/i_home_repo.dart';

class GetSubCategoriesUseCase extends BaseUseCase<List<CategoryEntity>, String> {
  final IHomeRepo _repo;
  GetSubCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(String categoryId) =>
      _repo.getSubCategories(categoryId);
}
