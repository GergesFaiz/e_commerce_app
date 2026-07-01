import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/order_entity.dart';

abstract class IOrdersRepo {
  Future<Either<Failure, OrderEntity>> checkout(String cartId, Map<String, dynamic> shippingAddress);
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId);
}