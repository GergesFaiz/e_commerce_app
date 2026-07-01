import '../../domain/entities/product_entity.dart';

abstract class ProductsState {}
class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsLoaded extends ProductsState {
  final List<ProductEntity> products;
  ProductsLoaded(this.products);
}
class ProductDetailsLoaded extends ProductsState {
  final ProductEntity product;
  ProductDetailsLoaded(this.product);
}
class ProductsFailure extends ProductsState {
  final String message;
  ProductsFailure(this.message);
}