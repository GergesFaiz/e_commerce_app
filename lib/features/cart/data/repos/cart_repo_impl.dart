import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repos/i_cart_repo.dart';
import '../datasources/cart_remote_datasource.dart';

class CartRepoImpl implements ICartRepo {
  final CartRemoteDatasource _remote;
  final NetworkInfo _network;
  CartRepoImpl(this._remote, this._network);

  Future<Either<Failure, CartEntity>> _exec(Future<dynamic> Function() fn) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try { final r = await fn(); return Right(r.toEntity()); }
    on DioException catch (e) { return Left(ServerFailure.fromDioException(e)); }
  }

  @override Future<Either<Failure, CartEntity>> addToCart(String productId) => _exec(() => _remote.addToCart(productId));
  @override Future<Either<Failure, CartEntity>> getCart() => _exec(() => _remote.getCart());
  @override Future<Either<Failure, CartEntity>> removeFromCart(String itemId) => _exec(() => _remote.removeFromCart(itemId));
  @override Future<Either<Failure, CartEntity>> updateQuantity(String itemId, int count) => _exec(() => _remote.updateQuantity(itemId, count));
  @override Future<Either<Failure, CartEntity>> clearCart() => _exec(() => _remote.clearCart());
}