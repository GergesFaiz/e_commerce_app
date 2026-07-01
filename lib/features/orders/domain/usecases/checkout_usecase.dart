import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/order_entity.dart';
import '../repos/i_orders_repo.dart';

class CheckoutParams {
  final String cartId;
  final Map<String, dynamic> shippingAddress;
  const CheckoutParams({required this.cartId, required this.shippingAddress});
}

class CheckoutUseCase extends BaseUseCase<OrderEntity, CheckoutParams> {
  final IOrdersRepo _repo;
  CheckoutUseCase(this._repo);
  @override
  Future<Either<Failure, OrderEntity>> call(CheckoutParams p) => _repo.checkout(p.cartId, p.shippingAddress);
}