import 'package:movies/api/model/movies.dart';

abstract class BrowseState {}

class BrowseInitial extends BrowseState {}

class BrowseLoading extends BrowseState {}

class BrowseLoaded extends BrowseState {
  final List<Movies> movies;
  final List<String> genres;
  final String selectedGenre;

  BrowseLoaded({
    required this.movies,
    required this.genres,
    required this.selectedGenre,
  });
}

class BrowseError extends BrowseState {
  final String message;

  BrowseError({required this.message});
}
