import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/di/base_usecase.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/core/network/network_info.dart';
import '../data/datasources/reviews_remote_datasource.dart';
import '../data/models/review_model.dart';

abstract class IReviewsRepo {
  Future<Either<Failure, List<Review>>> getReviews(String productId);
  Future<Either<Failure, String>> addReview({required String productId, required String text, required double rating});
}

class ReviewsRepoImpl implements IReviewsRepo {
  final ReviewsRemoteDatasource _remote;
  final NetworkInfo _network;
  ReviewsRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, List<Review>>> getReviews(String productId) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.getReviews(productId));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, String>> addReview({required String productId, required String text, required double rating}) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      return Right(await _remote.addReview(productId: productId, text: text, rating: rating));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }
}

class GetReviewsUseCase extends BaseUseCase<List<Review>, String> {
  final IReviewsRepo _repo;
  GetReviewsUseCase(this._repo);
  @override
  Future<Either<Failure, List<Review>>> call(String productId) => _repo.getReviews(productId);
}

class AddReviewParams {
  final String productId;
  final String text;
  final double rating;
  const AddReviewParams({required this.productId, required this.text, required this.rating});
}

class AddReviewUseCase extends BaseUseCase<String, AddReviewParams> {
  final IReviewsRepo _repo;
  AddReviewUseCase(this._repo);
  @override
  Future<Either<Failure, String>> call(AddReviewParams p) =>
      _repo.addReview(productId: p.productId, text: p.text, rating: p.rating);
}
