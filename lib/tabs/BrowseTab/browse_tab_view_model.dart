import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';

import 'browse_state.dart';

class BrowseTabViewModel extends Cubit<BrowseState> {
  BrowseTabViewModel() : super(BrowseInitial());

  final RetrofitService _apiService = RetrofitService(Dio());

  List<Movies> allMovies = [];
  List<String> allGenres = ["All"];
  String selectedGenre = "All";

  Future<void> loadMovies() async {
    emit(BrowseLoading());

    try {
      print(" Loading movies from API..."); // للdebug

      final response = await _apiService.getMovies(
        limit: 250,
        sortBy: "rating",
      );

      allMovies = response.data?.movies ?? [];

      print(" Movies loaded: ${allMovies.length}"); // debug

      final Set<String> genresSet = {};
      for (var movie in allMovies) {
        if (movie.genres != null && movie.genres!.isNotEmpty) {
          genresSet.addAll(movie.genres!);
        }
      }

      allGenres = ["All", ...genresSet.toList()..sort()];

      print(" Genres found: ${allGenres.length}");

      emit(
        BrowseLoaded(
          movies: allMovies,
          genres: allGenres,
          selectedGenre: selectedGenre,
        ),
      );
    } catch (e) {
      print(" Error loading movies: $e");
      emit(BrowseError(message: "Failed to load movies: $e"));
    }
  }

  void selectGenre(String genre) {
    selectedGenre = genre;
    emit(
      BrowseLoaded(
        movies: allMovies,
        genres: allGenres,
        selectedGenre: selectedGenre,
      ),
    );
  }

  List<Movies> get filteredMovies {
    if (selectedGenre == "All") return allMovies;
    return allMovies
        .where((movie) => movie.genres?.contains(selectedGenre) ?? false)
        .toList();
  }
}
