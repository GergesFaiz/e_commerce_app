import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

class ProductQuery {
  final String? categoryId;
  final String? keyword;
  final String? sort;
  final int page;
  final int limit;
  const ProductQuery({
    this.categoryId,
    this.keyword,
    this.sort,
    this.page = 1,
    this.limit = 10,
  });
}

class ProductPage {
  final List<ProductEntity> items;
  final int currentPage;
  final int totalPages;
  const ProductPage({
    required this.items,
    required this.currentPage,
    required this.totalPages,
  });

  bool get hasMore => currentPage < totalPages;
}

abstract class IProductsRepo {
  Future<Either<Failure, ProductPage>> getProducts(ProductQuery query);
  Future<Either<Failure, ProductEntity>> getProductById(String id);
}
