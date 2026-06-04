import 'package:e_commerce/core/api_manager/api_result.dart';
import 'package:e_commerce/features/categories/domain/entities/category_entity.dart';
import 'package:e_commerce/features/categories/domain/usecase/get_category_usecase.dart';
import 'package:e_commerce/features/categories/presentation/view_model/states.dart';
import 'package:e_commerce/features/products/domain/usecases/get_products_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeStates> {
  List<CategoryEntity> catLis222t = [];
  HomeViewModel(
    this.getCategoriesUseCase,
    this.getProductsUseCase,
  ) : super(HomeStates()) {
    getCategories();
    getProducts();
  }
  GetCategoriesUseCase getCategoriesUseCase;
  GetProductsUseCase getProductsUseCase;

  Future<void> getCategories() async {
    emit(state.copyWith(
      isCatLoading: true,
      error: null,
    ));
    //For simulation
    await Future.delayed(Duration(seconds: 2));
    ApiResult<List<CategoryEntity>> result = await getCategoriesUseCase.call();
    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        emit(state.copyWith(
          catList: result.data,
          isCatLoading: false,
        ));

      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.copyWith(
          error: result.exception.toString(),
          isCatLoading: false,
        ));
    }
  }

  Future<void> getProducts() async {
    emit(state.copyWith(
      isProductLoading: true,
      error: null,
    ));

    ApiResult<List<CategoryEntity>> result = await getCategoriesUseCase.call();
    switch (result) {
      case ApiSuccessResult<List<CategoryEntity>>():
        emit(state.copyWith(productList: result.data, isProductLoading: false));

      case ApiErrorResult<List<CategoryEntity>>():
        emit(state.copyWith(
          error: result.exception.toString(),
          isProductLoading: false,
        ));
    }
  }
}
