import 'package:e_commerce/features/categories/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';

class HomeStates extends Equatable {
  bool isCatLoading;
  bool isProductLoading;
  List<CategoryEntity> catList;
  List<CategoryEntity> productList;
  String? error;
  String? noRebuild;
  HomeStates({
    this.isCatLoading = false,
    this.isProductLoading = false,
    this.catList = const [],
    this.productList = const [],
    this.error,
    this.noRebuild,
  });
  @override
  List<Object?> get props => [
        isCatLoading,
        isProductLoading,
        catList,
        productList,
        error,
      ];

  HomeStates copyWith({
    bool? isCatLoading,
    bool? isProductLoading,
    List<CategoryEntity>? catList,
    List<CategoryEntity>? productList,
    String? error,
    String? noRebuild,
  }) {
    return HomeStates(
      isCatLoading: isCatLoading ?? this.isCatLoading,
      isProductLoading: isProductLoading ?? this.isProductLoading,
      catList: catList ?? this.catList,
      productList: productList ?? this.productList,
      error: error ?? this.error,
      noRebuild: noRebuild ?? this.noRebuild,
    );
  }
}

// sealed class HomeStates {}

// class HomeInitialState extends HomeStates {}

// class HomeLoadingState extends HomeStates {}

// class HomeSuccessState extends HomeStates {
//   List<CategoryEntity> categories;
//   HomeSuccessState(this.categories);
// }

// class HomeProductSuccessState extends HomeStates {
//   List<CategoryEntity> categories;
//   HomeSuccessState(this.categories);
// }

// class HomeErrorState extends HomeStates {
//   String error;
//   HomeErrorState({required this.error});
// }
