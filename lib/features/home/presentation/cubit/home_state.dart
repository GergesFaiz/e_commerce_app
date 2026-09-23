import '../../domain/entities/category_entity.dart';

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  final String? selectedCategoryId;
  final List<CategoryEntity> subcategories;
  final bool loadingSubs;
  final String? subError;
  HomeLoaded({
    required this.categories,
    required this.brands,
    this.selectedCategoryId,
    this.subcategories = const [],
    this.loadingSubs = false,
    this.subError,
  });

  HomeLoaded copyWith({
    String? selectedCategoryId,
    List<CategoryEntity>? subcategories,
    bool? loadingSubs,
    String? subError,
  }) {
    return HomeLoaded(
      categories: categories,
      brands: brands,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      subcategories: subcategories ?? this.subcategories,
      loadingSubs: loadingSubs ?? this.loadingSubs,
      subError: subError,
    );
  }
}
class HomeFailure extends HomeState {
  final String message;
  HomeFailure(this.message);
}
