import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/error/failure.dart';
import 'package:e_commerce/features/cart/domain/entities/cart_entity.dart';
import 'package:e_commerce/features/cart/domain/repos/i_cart_repo.dart';
import 'package:e_commerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'package:e_commerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:e_commerce/features/cart/presentation/cubit/cart_state.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCartRepo implements ICartRepo {
  FakeCartRepo(this.cart);
  final CartEntity cart;

  @override
  Future<Either<Failure, CartEntity>> addToCart(String productId) async => Right(cart);
  @override
  Future<Either<Failure, CartEntity>> getCart() async => Right(cart);
  @override
  Future<Either<Failure, CartEntity>> removeFromCart(String itemId) async => Right(cart);
  @override
  Future<Either<Failure, CartEntity>> updateQuantity(String itemId, int count) async => Right(cart);
}

void main() {
  const cart = CartEntity(
    id: 'c1',
    cartOwner: 'u1',
    products: [],
    totalCartPrice: 0,
    numOfCartItems: 0,
  );

  CartCubit buildCubit() {
    final repo = FakeCartRepo(cart);
    return CartCubit(
      AddToCartUseCase(repo),
      GetCartUseCase(repo),
      RemoveFromCartUseCase(repo),
      UpdateCartQuantityUseCase(repo),
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

  test('addToCart emits item added', () async {
    final cubit = buildCubit();
    await cubit.addToCart('p1');
    expect(cubit.state, isA<CartItemAdded>());
  });
}
