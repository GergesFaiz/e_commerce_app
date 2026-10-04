import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entities/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repos/i_cart_repo.dart';
import 'package:e_commerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory cart that behaves like the API: POST adds one unit and answers
/// with the new counts, PUT/DELETE take the product id.
class FakeCartRepo implements ICartRepo {
  final counts = <String, int>{};
  final calls = <String>[];
  Failure? failure;

  CartEntity get _cart => CartEntity(
        id: 'c1',
        cartOwner: 'u1',
        products: counts.entries
            .map((e) => CartItemEntity(
                id: 'item-${e.key}',
                productId: e.key,
                title: 'Product ${e.key}',
                imageCover: '',
                price: 10,
                count: e.value))
            .toList(),
        totalCartPrice: counts.values.fold(0, (a, b) => a + b * 10),
        numOfCartItems: counts.length,
      );

  Future<Either<Failure, CartEntity>> _answer(String call, void Function() apply) async {
    calls.add(call);
    if (failure != null) return Left(failure!);
    apply();
    return Right(_cart);
  }

  @override
  Future<Either<Failure, CartEntity>> addToCart(String productId) =>
      _answer('POST $productId', () => counts[productId] = (counts[productId] ?? 0) + 1);
  @override
  Future<Either<Failure, CartEntity>> getCart() => _answer('GET', () {});
  @override
  Future<Either<Failure, CartEntity>> removeFromCart(String productId) =>
      _answer('DELETE $productId', () => counts.remove(productId));
  @override
  Future<Either<Failure, CartEntity>> updateQuantity(String productId, int count) =>
      _answer('PUT $productId $count', () => counts[productId] = count);
  @override
  Future<Either<Failure, CartEntity>> clearCart() => _answer('CLEAR', counts.clear);
}

void main() {
  late FakeCartRepo repo;

  CartCubit buildCubit() {
    repo = FakeCartRepo();
    return CartCubit(
      AddToCartUseCase(repo),
      GetCartUseCase(repo),
      RemoveFromCartUseCase(repo),
      UpdateCartQuantityUseCase(repo),
      ClearCartUseCase(repo),
    );
  }

  test('getCart emits loading then loaded', () async {
    final cubit = buildCubit();
    final expected = expectLater(
      cubit.stream,
      emitsInOrder([isA<CartLoading>(), isA<CartLoaded>()]),
    );

    await cubit.getCart();
    await expected;
  });

  test('silent getCart keeps the view on failure', () async {
    final cubit = buildCubit();
    await cubit.getCart();
    repo.failure = const ServerFailure('boom');

    await cubit.getCart(silent: true);

    expect(cubit.state, isA<CartLoaded>());
  });

  test('addToCart posts once and refreshes the populated cart', () async {
    final cubit = buildCubit();

    final error = await cubit.addToCart('p1');

    expect(error, isNull);
    expect(repo.calls, ['POST p1', 'GET']);
    expect(cubit.state, isA<CartLoaded>());
    expect(cubit.itemCount, 1);
    expect(cubit.cart.countOf('p1'), 1);
  });

  test('addToCart with a quantity sets the line count with PUT', () async {
    final cubit = buildCubit();
    repo.counts['p1'] = 2;

    final error = await cubit.addToCart('p1', quantity: 3);

    expect(error, isNull);
    expect(repo.calls, ['POST p1', 'PUT p1 5']);
    expect(cubit.cart.countOf('p1'), 5);
  });

  test('addToCart reports the failure and keeps the state', () async {
    final cubit = buildCubit();
    repo.failure = const ServerFailure('Invalid Token');

    final error = await cubit.addToCart('p1');

    expect(error, 'Invalid Token');
    expect(cubit.state, isA<CartInitial>());
  });

  test('updateQuantity below one removes the product', () async {
    final cubit = buildCubit();
    repo.counts['p1'] = 1;

    await cubit.updateQuantity('p1', 0);

    expect(repo.calls, ['DELETE p1']);
    expect(cubit.cart.products, isEmpty);
  });

  test('clear emits loading then an empty cart', () async {
    final cubit = buildCubit();
    repo.counts['p1'] = 1;
    final expected = expectLater(
      cubit.stream,
      emitsInOrder([isA<CartLoading>(), isA<CartLoaded>()]),
    );

    await cubit.clear();
    await expected;
    expect(cubit.itemCount, 0);
  });

  test('markOrdered empties the cart and reset forgets it', () async {
    final cubit = buildCubit();
    await cubit.addToCart('p1');

    cubit.markOrdered();
    expect(cubit.itemCount, 0);
    expect((cubit.state as CartLoaded).cart.products, isEmpty);

    await cubit.addToCart('p2');
    cubit.reset();
    expect(cubit.itemCount, 0);
    expect(cubit.state, isA<CartInitial>());
  });
}
