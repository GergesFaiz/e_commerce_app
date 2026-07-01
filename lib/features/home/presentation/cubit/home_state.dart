import '../../domain/entities/category_entity.dart';

abstract class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<CategoryEntity> categories;
  final List<BrandEntity> brands;
  HomeLoaded({required this.categories, required this.brands});
}
class HomeFailure extends HomeState {
  final String message;
  HomeFailure(this.message);
}