import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';

import 'movie_details_state.dart';

class MovieDetailsViewModel extends Cubit<MovieDetailsState> {
  MovieDetailsViewModel() : super(MovieDetailsInitial());

  final RetrofitService _apiService = RetrofitService(Dio());
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // ─── Load ────────────────────────────────────────────────────────────────

  Future<void> loadMovieData(int movieId) async {
    emit(MovieDetailsLoading());

    try {
      final detailResponse = await _apiService.getMovieDetails(
          movieId: movieId);
      final movieData = (detailResponse.data as Map<String,
          dynamic>?)?['data']?['movie'];

      String likeCount = '0';
      int runtime = 0;
      double rating = 0.0;
      List<String> genres = [];
      List<String> screenshots = [];
      List<dynamic> cast = [];

      if (movieData != null) {
        likeCount = movieData['like_count']?.toString() ?? '0';
        runtime = movieData['runtime'] ?? 0;
        rating = (movieData['rating'] as num?)?.toDouble() ?? 0.0;
        genres = (movieData['genres'] as List<dynamic>?)
            ?.map((g) => g.toString())
            .toList() ??
            [];

        // screenshots بـ loop بدل hardcoded keys
        for (int i = 1; i <= 3; i++) {
          final url = movieData['medium_screenshot_image$i'];
          if (url != null) screenshots.add(url);
        }

        cast = movieData['cast'] as List<dynamic>? ?? [];
      }

      final suggestionResponse =
      await _apiService.getMovieSuggestions(movieId: movieId);
      final suggestions = suggestionResponse.data?.movies ?? [];

      emit(MovieDetailsLoaded(
        likeCount: likeCount,
        runtime: runtime,
        rating: rating,
        genres: genres,
        screenshots: screenshots,
        cast: cast,
        suggestions: suggestions,
      ));
    } catch (e) {
      emit(MovieDetailsError(
          message: 'Failed to load movie data. Please try again.'));
    }
  }

  // ─── Watchlist ───────────────────────────────────────────────────────────

  Future<void> toggleWatchlist(Movies movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userDoc = _firestore.collection('Users').doc(user.uid);
    final movieData = _buildMovieData(movie);

    // نقرأ الـ watchlist الحالي عشان نعرف نعمل add أو remove
    final snapshot = await userDoc.get();
    final watchlist = List<dynamic>.from(snapshot.data()?['watchlist'] ?? []);
    final existing = watchlist.cast<Map<String, dynamic>>()
        .where((item) => item['id'] == movie.id)
        .toList();

    if (existing.isNotEmpty) {
      await userDoc.update({
        'watchlist': FieldValue.arrayRemove([existing.first]),
      });
    } else {
      await userDoc.set({
        'watchlist': FieldValue.arrayUnion([movieData]),
      }, SetOptions(merge: true));
    }
  }

  Stream<bool> isMovieInWatchlist(int movieId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(false);

    return _firestore
        .collection('Users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return false;
      final watchlist = List<dynamic>.from(snapshot.data()?['watchlist'] ?? []);
      return watchlist.any((item) => item['id'] == movieId);
    });
  }

  // ─── History ─────────────────────────────────────────────────────────────

  Future<void> addToHistory(Movies movie) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('Users').doc(user.uid).set({
      'history': FieldValue.arrayUnion([_buildMovieData(movie)]),
    }, SetOptions(merge: true));
  }

  // ─── Helper ──────────────────────────────────────────────────────────────

  Map<String, dynamic> _buildMovieData(Movies movie) {
    final image = movie.mediumCoverImage ?? movie.largeCoverImage ?? '';
    return {
      'id': movie.id,
      'title': movie.title,
      'rating': movie.rating,
      'image_url': image,
      'poster_path': image,
      'medium_cover_image': image,
    };
  }
}
