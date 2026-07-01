import 'package:dio/dio.dart';
import 'package:movies/api/model/source_response.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_service.g.dart';

@RestApi(baseUrl: "https://movies-api.accel.li/api/v2")
abstract class RetrofitService {
  factory RetrofitService(Dio dio, {String? baseUrl}) = _RetrofitService;

  @GET("/list_movies.json")
  Future<SourceResponse> getMovies({
    @Query("sort_by") String sortBy = "date_added",
    @Query("query_term") String? queryTerm, // ← أضفنا ده للبحث
    @Query("limit") int limit = 50,
    @Query("page") int page = 1,
  });

  @GET("/movie_suggestions.json")
  Future<SourceResponse> getMovieSuggestions({
    @Query("movie_id") required int movieId,
  });
  @GET("/movie_details.json")
Future<HttpResponse<dynamic>> getMovieDetails({
  @Query("movie_id") required int movieId,
  @Query("with_images") bool withImages = true, 
  @Query("with_cast") bool withCast = true,
});
}
