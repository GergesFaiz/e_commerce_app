import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/states/movie_state.dart';

import '../api/model/movies.dart';
 

class MoviesCubit extends Cubit<MoviesState> {
  MoviesCubit() : super(MoviesInitial());

  
  final List<String> categories = ['Action', 'Comedy', 'Drama', 'Romance', 'Sci-Fi', 'Horror'];

  
  void changeCategoryRandomly(List<Movies> allMovies) {
    
  
    final randomCategory = categories[Random().nextInt(categories.length)];
    List<Movies> filtered = allMovies.where((movie) {
      return movie.genres?.contains(randomCategory) ?? false;
    }).toList();
    if (filtered.isEmpty) {
      filtered = allMovies; 
    }
    emit(CategoryChangedState(randomCategory, filtered));
  }
}