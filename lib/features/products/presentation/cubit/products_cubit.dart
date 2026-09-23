import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repos/i_products_repo.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'products_state.dart';

/// Server-driven listing: keyword search (debounced), price sort,
/// category filter and page-based pagination, per the API docs.
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProducts;
  final GetProductDetailsUseCase _getDetails;
  ProductsCubit(this._getProducts, this._getDetails) : super(ProductsInitial());

  static const int pageSize = 10;

  String? _categoryId;
  String _query = '';
  bool? _sortByPriceAsc;
  Timer? _debounce;

  Future<void> getProducts({String? categoryId}) async {
    _categoryId = categoryId;
    _query = '';
    _sortByPriceAsc = null;
    await _fetch(page: 1, append: false);
  }

  void setSearchQuery(String query) {
    _query = query;
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      _fetch(page: 1, append: false);
      return;
    }
    emit(ProductsLoading());
    _debounce = Timer(const Duration(milliseconds: 450), () {
      _fetch(page: 1, append: false);
    });
  }

  void toggleSortByPrice() {
    if (state is! ProductsLoaded && state is! ProductsLoading) return;
    _sortByPriceAsc = _sortByPriceAsc == null
        ? true
        : _sortByPriceAsc == true
            ? false
            : null;
    _fetch(page: 1, append: false);
  }

  void loadMore() {
    final s = state;
    if (s is! ProductsLoaded || !s.hasMore) return;
    _fetch(page: s.currentPage + 1, append: true);
  }

  String? get _sortParam {
    if (_sortByPriceAsc == null) return null;
    return _sortByPriceAsc! ? 'price' : '-price';
  }

  Future<void> _fetch({required int page, required bool append}) async {
    final previous = state;
    if (!append) emit(ProductsLoading());
    final result = await _getProducts(ProductQuery(
      categoryId: _categoryId,
      keyword: _query.trim().isEmpty ? null : _query.trim(),
      sort: _sortParam,
      page: page,
      limit: pageSize,
    ));
    result.fold(
      (f) => emit(ProductsFailure(f.message)),
      (p) {
        final items = append && previous is ProductsLoaded
            ? [...previous.products, ...p.items]
            : p.items;
        emit(ProductsLoaded(
          items,
          query: _query,
          sortByPriceAsc: _sortByPriceAsc,
          currentPage: p.currentPage,
          pageSize: pageSize,
          totalPages: p.totalPages,
        ));
      },
    );
  }

  Future<void> getProductDetails(String id) async {
    emit(ProductsLoading());
    final result = await _getDetails(id);
    result.fold((f) => emit(ProductsFailure(f.message)), (p) => emit(ProductDetailsLoaded(p)));
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
