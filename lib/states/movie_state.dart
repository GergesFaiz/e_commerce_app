import '../api/model/movies.dart';

abstract class MoviesState {}

class MoviesInitial extends MoviesState {}
class CategoryChangedState extends MoviesState {
  final String categoryName;
  final List<Movies> filteredMovies;
  CategoryChangedState(this.categoryName, this.filteredMovies);
}