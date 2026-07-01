import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

abstract class IProductsRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts({String? categoryId});
  Future<Either<Failure, ProductEntity>> getProductById(String id);
}