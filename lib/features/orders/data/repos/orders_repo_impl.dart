import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repos/i_orders_repo.dart';
import '../datasources/orders_remote_datasource.dart';

class OrdersRepoImpl implements IOrdersRepo {
  final OrdersRemoteDatasource _remote;
  final NetworkInfo _network;

  OrdersRepoImpl(this._remote, this._network);

  @override
  Future<Either<Failure, OrderEntity>> checkout(
      String cartId, Map<String, dynamic> address) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final r = await _remote.checkout(cartId, address);
      return Right(r.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(
      String userId) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());
    try {
      final r = await _remote.getUserOrders(userId);
      return Right(r.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    }
  }
}
