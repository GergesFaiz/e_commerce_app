import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import '../../domain/usecases/get_subcategories_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase _categories;
  final GetBrandsUseCase _brands;
  final GetSubCategoriesUseCase _subCategories;
  HomeCubit(this._categories, this._brands, this._subCategories)
      : super(HomeInitial());

  Future<void> getHomeData() async {
    emit(HomeLoading());
    final cats = await _categories(NoParams());
    final brds = await _brands(NoParams());
    cats.fold(
      (f) => emit(HomeFailure(f.message)),
      (c) => brds.fold(
        (f) => emit(HomeFailure(f.message)),
        (b) => emit(HomeLoaded(categories: c, brands: b)),
      ),
    );
  }

  Future<void> selectCategory(String categoryId) async {
    final current = state;
    if (current is! HomeLoaded) return;
    emit(current.copyWith(
        selectedCategoryId: categoryId, loadingSubs: true, subError: null));
    final res = await _subCategories(categoryId);
    final latest = state;
    if (latest is! HomeLoaded) return;
    res.fold(
      (f) => emit(latest.copyWith(loadingSubs: false, subError: f.message)),
      (subs) => emit(latest.copyWith(
          subcategories: subs, loadingSubs: false, subError: null)),
    );
  }
}
