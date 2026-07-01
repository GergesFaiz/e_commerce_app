import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';
import '../repos/i_products_repo.dart';

class GetProductDetailsUseCase extends BaseUseCase<ProductEntity, String> {
  final IProductsRepo _repo;
  GetProductDetailsUseCase(this._repo);
  @override
  Future<Either<Failure, ProductEntity>> call(String id) => _repo.getProductById(id);
}