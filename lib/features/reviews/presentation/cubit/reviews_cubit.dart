import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/review_model.dart';
import '../../domain/reviews_repository.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();
  @override
  List<Object?> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<Review> reviews;
  final String? notice;
  const ReviewsLoaded(this.reviews, {this.notice});
  @override
  List<Object?> get props => [reviews, notice];
}

class ReviewsFailure extends ReviewsState {
  final String message;
  const ReviewsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final GetReviewsUseCase _get;
  final AddReviewUseCase _add;
  ReviewsCubit(this._get, this._add) : super(ReviewsInitial());

  Future<void> getReviews(String productId) async {
    emit(ReviewsLoading());
    final r = await _get(productId);
    r.fold((f) => emit(ReviewsFailure(f.message)), (list) => emit(ReviewsLoaded(list)));
  }

  Future<void> addReview({required String productId, required String text, required double rating}) async {
    if (text.trim().isEmpty) {
      emit(const ReviewsFailure('Please write a review first'));
      return;
    }
    final current = state;
    final existing = current is ReviewsLoaded ? current.reviews : const <Review>[];
    emit(ReviewsLoading());
    final r = await _add(AddReviewParams(productId: productId, text: text.trim(), rating: rating));
    await r.fold(
      (f) async => emit(ReviewsFailure(f.message)),
      (_) async {
        final refreshed = await _get(productId);
        refreshed.fold(
          (_) => emit(ReviewsLoaded(existing, notice: 'Review added')),
          (list) => emit(ReviewsLoaded(list, notice: 'Review added')),
        );
      },
    );
  }
}
