import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';

import 'home_tab_state.dart';

class HomeTabViewModel extends Cubit<HomeState> {
  HomeTabViewModel() : super(HomeInitial());

  final RetrofitService _apiService = RetrofitService(Dio());

  List<Movies> _allMovies = [];

  Future<void> loadHomeData() async {
    if (_allMovies.isNotEmpty) {
      _emitRandomCategory();
      return;
    }

    emit(HomeLoading());

    try {
      final response = await _apiService.getMovies(limit: 100);
      _allMovies = response.data?.movies ?? [];
      _emitRandomCategory();
    } catch (e) {
      emit(HomeError(message: 'Failed to load movies. Please try again.'));
    }
  }

  void changeCategory(String category) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;

    emit(
      current.copyWith(
        categoryMovies: _filterByCategory(category),
        currentCategory: category,
      ),
    );
  }

  void changeCategoryRandomly() => _emitRandomCategory();

  void refresh() {
    _allMovies.clear();
    loadHomeData();
  }

  void _emitRandomCategory() {
    if (_allMovies.isEmpty) return;

    final allGenres = <String>{};
    for (final movie in _allMovies) {
      for (final g in movie.genres ?? []) {
        allGenres.add(g.toString());
      }
    }

    String selectedGenre;
    if (allGenres.isEmpty) {
      selectedGenre = 'All';
    } else {
      final list = allGenres.toList();
      selectedGenre = list[Random().nextInt(list.length)];
    }

    final displayName =
        selectedGenre[0].toUpperCase() +
        selectedGenre.substring(1).toLowerCase();

    emit(
      HomeLoaded(
        carouselMovies: _allMovies.take(10).toList(),
        categoryMovies: _filterByCategory(selectedGenre),
        currentCategory: displayName,
      ),
    );
  }

  List<Movies> _filterByCategory(String category) {
    if (category.toLowerCase() == 'all') return _allMovies;
    return _allMovies.where((movie) {
      final genres =
          movie.genres?.map((g) => g.toString().toLowerCase()).toList() ?? [];
      return genres.contains(category.toLowerCase());
    }).toList();
  }
}
