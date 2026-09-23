import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../repos/i_products_repo.dart';

class GetProductsUseCase extends BaseUseCase<ProductPage, ProductQuery> {
  final IProductsRepo _repo;
  GetProductsUseCase(this._repo);
  @override
  Future<Either<Failure, ProductPage>> call(ProductQuery query) =>
      _repo.getProducts(query);
}
