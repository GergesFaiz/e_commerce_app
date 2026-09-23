import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/reviews/data/models/review_model.dart';
import 'package:e_commerce/features/reviews/domain/reviews_repository.dart';
import 'package:e_commerce/features/reviews/presentation/cubit/reviews_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeReviewsRepo implements IReviewsRepo {
  FakeReviewsRepo(this.items);
  List<Review> items;

  @override
  Future<Either<Failure, List<Review>>> getReviews(String productId) async {
    return Right(List.of(items));
  }

  @override
  Future<Either<Failure, String>> addReview(
      {required String productId, required String text, required double rating}) async {
    items = [
      ...items,
      Review(id: 'r${items.length}', text: text, rating: rating, userName: 'Me', createdAt: '')
    ];
    return const Right('Review added');
  }
}

void main() {
  const review = Review(
      id: 'r1', text: 'Great!', rating: 5, userName: 'Ali', createdAt: '');

  ReviewsCubit buildCubit(List<Review> items) {
    final repo = FakeReviewsRepo(items);
    return ReviewsCubit(GetReviewsUseCase(repo), AddReviewUseCase(repo));
  }

  test('loads reviews', () async {
    final cubit = buildCubit([review]);
    final expected = expectLater(
      cubit.stream,
      emitsInOrder([isA<ReviewsLoading>(), isA<ReviewsLoaded>()]),
    );

    await cubit.getReviews('p1');
    await expected;
    expect((cubit.state as ReviewsLoaded).reviews.length, 1);
  });

  test('rejects empty review text', () async {
    final cubit = buildCubit([review]);

    await cubit.addReview(productId: 'p1', text: '  ', rating: 5);

    expect(cubit.state, isA<ReviewsFailure>());
  });

  test('adds a review and shows a notice', () async {
    final cubit = buildCubit([review]);

    await cubit.addReview(productId: 'p1', text: 'Nice', rating: 4);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final state = cubit.state as ReviewsLoaded;
    expect(state.reviews.length, 2);
    expect(state.notice, 'Review added');
  });
}
