import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';
import '../repos/i_home_repo.dart';

class GetBrandsUseCase extends BaseUseCase<List<BrandEntity>, NoParams> {
  final IHomeRepo _repo;
  GetBrandsUseCase(this._repo);
  @override
  Future<Either<Failure, List<BrandEntity>>> call(NoParams p) => _repo.getBrands();
}