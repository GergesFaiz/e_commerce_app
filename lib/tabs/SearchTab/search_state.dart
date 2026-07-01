import 'package:movies/api/model/movies.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movies> movies;

  SearchLoaded({required this.movies});
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
