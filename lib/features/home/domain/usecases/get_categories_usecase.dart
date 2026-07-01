import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repos/i_home_repo.dart';

class GetCategoriesUseCase extends BaseUseCase<List<CategoryEntity>, NoParams> {
  final IHomeRepo _repo;
  GetCategoriesUseCase(this._repo);
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams p) => _repo.getCategories();
}