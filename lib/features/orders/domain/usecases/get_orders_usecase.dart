import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/order_entity.dart';
import '../repos/i_orders_repo.dart';

class GetOrdersUseCase extends BaseUseCase<List<OrderEntity>, String> {
  final IOrdersRepo _repo;
  GetOrdersUseCase(this._repo);
  @override
  Future<Either<Failure, List<OrderEntity>>> call(String userId) => _repo.getUserOrders(userId);
}