import 'movie.details.dart';

class Data {
  int? movieCount;
  int? limit;
  int? pageNumber;
  List<Moviesdetails>? movies; 
  Data({
    this.movieCount,
    this.limit,
    this.pageNumber,
    this.movies,
  });

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      movieCount: map['movie_count'] as int?,
      limit: map['limit'] as int?,
      pageNumber: map['page_number'] as int?,
      // التربيط الذكي مع كلاس Movie
      movies: map['movies'] == null
          ? null
          : (map['movies'] as List)
              .map((m) => Moviesdetails.fromMap(m as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movie_count': movieCount,
      'limit': limit,
      'page_number': pageNumber,
      'movies': movies?.map((m) => m.toMap()).toList(),
    };
  }
}