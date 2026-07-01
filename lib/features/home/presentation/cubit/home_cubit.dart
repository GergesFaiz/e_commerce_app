import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_brands_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase _categories;
  final GetBrandsUseCase _brands;
  HomeCubit(this._categories, this._brands) : super(HomeInitial());

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
}