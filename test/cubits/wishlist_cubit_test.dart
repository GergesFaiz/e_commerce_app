import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:e_commerce/features/wishlist/domain/repos/i_wishlist_repo.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'package:e_commerce/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWishlistRepo implements IWishlistRepo {
  final ids = <String>['p1'];
  Failure? failure;

  WishlistItemEntity _item(String id) =>
      WishlistItemEntity(id: id, title: 'Product $id', imageCover: '', price: 10);

  @override
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist() async =>
      failure != null ? Left(failure!) : Right(ids.map(_item).toList());

  @override
  Future<Either<Failure, List<String>>> addToWishlist(String productId) async {
    if (failure != null) return Left(failure!);
    ids.add(productId);
    return Right(List.of(ids));
  }

  @override
  Future<Either<Failure, List<String>>> removeFromWishlist(String productId) async {
    if (failure != null) return Left(failure!);
    ids.remove(productId);
    return Right(List.of(ids));
  }
}

void main() {
  late FakeWishlistRepo repo;

  WishlistCubit buildCubit() {
    repo = FakeWishlistRepo();
    return WishlistCubit(
      GetWishlistUseCase(repo),
      AddToWishlistUseCase(repo),
      RemoveFromWishlistUseCase(repo),
    );
  }

  test('getWishlist loads items and their ids', () async {
    final cubit = buildCubit();

    await cubit.getWishlist();

    expect(cubit.state.loading, isFalse);
    expect(cubit.state.items.single.id, 'p1');
    expect(cubit.contains('p1'), isTrue);
  });

  test('toggle adds an unknown product and reloads the list', () async {
    final cubit = buildCubit();
    await cubit.getWishlist();

    final error = await cubit.toggle('p2');

    expect(error, isNull);
    expect(cubit.contains('p2'), isTrue);
    expect(cubit.state.items.map((i) => i.id), ['p1', 'p2']);
  });

  test('toggle removes a saved product right away', () async {
    final cubit = buildCubit();
    await cubit.getWishlist();

    final pending = cubit.toggle('p1');
    // Optimistic: the heart empties before the server answers.
    expect(cubit.contains('p1'), isFalse);
    expect(cubit.state.items, isEmpty);

    expect(await pending, isNull);
    expect(repo.ids, isEmpty);
  });

  test('toggle rolls back and reports a failure', () async {
    final cubit = buildCubit();
    await cubit.getWishlist();
    repo.failure = const ServerFailure('Invalid Token');

    final error = await cubit.toggle('p1');

    expect(error, 'Invalid Token');
    expect(cubit.contains('p1'), isTrue);
    expect(cubit.state.items.single.id, 'p1');
  });

  test('reset forgets the signed-out user', () async {
    final cubit = buildCubit();
    await cubit.getWishlist();

    cubit.reset();

    expect(cubit.state.items, isEmpty);
    expect(cubit.state.ids, isEmpty);
  });
}
