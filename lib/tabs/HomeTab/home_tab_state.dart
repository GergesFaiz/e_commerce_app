import 'package:movies/api/model/movies.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movies> carouselMovies;
  final List<Movies> categoryMovies;
  final String currentCategory;

  HomeLoaded({
    required this.carouselMovies,
    required this.categoryMovies,
    required this.currentCategory,
  });

  HomeLoaded copyWith({
    List<Movies>? carouselMovies,
    List<Movies>? categoryMovies,
    String? currentCategory,
  }) {
    return HomeLoaded(
      carouselMovies: carouselMovies ?? this.carouselMovies,
      categoryMovies: categoryMovies ?? this.categoryMovies,
      currentCategory: currentCategory ?? this.currentCategory,
    );
  }
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
