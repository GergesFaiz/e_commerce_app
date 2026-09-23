import 'package:e_commerce/core/network/api_service.dart';
import 'package:e_commerce/core/utils/cache_helper.dart';
import '../models/review_model.dart';

abstract class ReviewsRemoteDatasource {
  Future<List<Review>> getReviews(String productId);
  Future<String> addReview({required String productId, required String text, required double rating});
}

class ReviewsRemoteDatasourceImpl implements ReviewsRemoteDatasource {
  final ApiService _api;
  ReviewsRemoteDatasourceImpl(this._api);

  @override
  Future<List<Review>> getReviews(String productId) async {
    final res = await _api.getReviews(productId);
    final data = res.data;
    if (data is Map) return Review.listOf(data['data']);
    return const [];
  }

  @override
  Future<String> addReview({required String productId, required String text, required double rating}) async {
    final token = CacheHelper.getToken() ?? '';
    final res = await _api.addReview(
      productId,
      {'review': text, 'rating': rating},
      token,
    );
    final data = res.data;
    if (data is Map && data['message'] is String) return data['message'] as String;
    return 'Review added';
  }
}
