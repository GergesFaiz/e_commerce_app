import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_details_usecase.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProducts;
  final GetProductDetailsUseCase _getDetails;
  ProductsCubit(this._getProducts, this._getDetails) : super(ProductsInitial());

  List<ProductEntity> _all = [];
  String _query = '';
  bool? _sortByPriceAsc;
  static const int _pageSize = 10;
  int _currentPage = 1;

  Future<void> getProducts({String? categoryId}) async {
    emit(ProductsLoading());
    final result = await _getProducts(categoryId);
    result.fold(
      (f) => emit(ProductsFailure(f.message)),
      (p) {
        _all = p;
        _query = '';
        _sortByPriceAsc = null;
        _currentPage = 1;
        emit(_pageState());
      },
    );
  }

  void setSearchQuery(String query) {
    if (state is! ProductsLoaded) {
      _query = query;
      return;
    }
    _query = query;
    _currentPage = 1;
    emit(_pageState());
  }

  void toggleSortByPrice() {
    if (state is! ProductsLoaded) return;
    _sortByPriceAsc = _sortByPriceAsc == null
        ? true
        : _sortByPriceAsc == true
            ? false
            : null;
    _currentPage = 1;
    emit(_pageState());
  }

  void loadMore() {
    final s = state;
    if (s is! ProductsLoaded || !s.hasMore) return;
    _currentPage++;
    emit(_pageState());
  }

  ProductsLoaded _pageState() {
    final filtered = _filtered();
    final end = (_currentPage * _pageSize).clamp(0, filtered.length);
    return ProductsLoaded(
      filtered.take(end).toList(),
      query: _query,
      sortByPriceAsc: _sortByPriceAsc,
      currentPage: _currentPage,
      pageSize: _pageSize,
      totalCount: filtered.length,
    );
  }

  List<ProductEntity> _filtered() {
    var list = List<ProductEntity>.of(_all);
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.categoryName.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q))
          .toList();
    }
    if (_sortByPriceAsc != null) {
      list.sort((a, b) => _sortByPriceAsc!
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
    }
    return list;
  }

  Future<void> getProductDetails(String id) async {
    emit(ProductsLoading());
    final result = await _getDetails(id);
    result.fold((f) => emit(ProductsFailure(f.message)), (p) => emit(ProductDetailsLoaded(p)));
  }
}