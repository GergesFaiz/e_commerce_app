abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsLoaded extends MovieDetailsState {
  final String likeCount;
  final int runtime;
  final double rating;
  final List<String> genres;
  final List<String> screenshots;
  final List<dynamic> cast;
  final List suggestions;

  MovieDetailsLoaded({
    required this.likeCount,
    required this.runtime,
    required this.rating,
    required this.genres,
    required this.screenshots,
    required this.cast,
    required this.suggestions,
  });
}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError({required this.message});
}
