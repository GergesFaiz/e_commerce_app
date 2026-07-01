import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProducts;
  final GetProductDetailsUseCase _getDetails;
  ProductsCubit(this._getProducts, this._getDetails) : super(ProductsInitial());

  Future<void> getProducts({String? categoryId}) async {
    emit(ProductsLoading());
    final result = await _getProducts(categoryId);
    result.fold((f) => emit(ProductsFailure(f.message)), (p) => emit(ProductsLoaded(p)));
  }

  Future<void> getProductDetails(String id) async {
    emit(ProductsLoading());
    final result = await _getDetails(id);
    result.fold((f) => emit(ProductsFailure(f.message)), (p) => emit(ProductDetailsLoaded(p)));
  }
}