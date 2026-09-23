import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';

abstract class IHomeRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<BrandEntity>>> getBrands();
  Future<Either<Failure, List<CategoryEntity>>> getSubCategories(String categoryId);
}