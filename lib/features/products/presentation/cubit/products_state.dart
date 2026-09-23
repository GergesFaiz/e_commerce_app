import '../../domain/entities/product_entity.dart';

abstract class ProductsState {}
class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  final String query;
  final bool? sortByPriceAsc;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  bool get hasMore => currentPage < totalPages;
  ProductsLoaded(
    this.products, {
    this.query = '',
    this.sortByPriceAsc,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalPages = 1,
  });
}
class ProductDetailsLoaded extends ProductsState {
  final ProductEntity product;
  ProductDetailsLoaded(this.product);
}
class ProductsFailure extends ProductsState {
  final String message;
  ProductsFailure(this.message);
}
