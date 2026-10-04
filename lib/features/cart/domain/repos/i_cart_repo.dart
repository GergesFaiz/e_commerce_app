import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_entity.dart';

abstract class ICartRepo {
  Future<Either<Failure, CartEntity>> addToCart(String productId);
  Future<Either<Failure, CartEntity>> getCart();
  Future<Either<Failure, CartEntity>> removeFromCart(String productId);
  Future<Either<Failure, CartEntity>> updateQuantity(String productId, int count);
  Future<Either<Failure, CartEntity>> clearCart();
}