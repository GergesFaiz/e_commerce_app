import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_entity.dart';
import '../repos/i_cart_repo.dart';

class GetCartUseCase extends BaseUseCase<CartEntity, NoParams> {
  final ICartRepo _repo;
  GetCartUseCase(this._repo);
  @override
  Future<Either<Failure, CartEntity>> call(NoParams p) => _repo.getCart();
}