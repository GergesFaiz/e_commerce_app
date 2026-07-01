import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_entity.dart';
import '../repos/i_cart_repo.dart';

class AddToCartUseCase extends BaseUseCase<CartEntity, String> {
  final ICartRepo _repo;
  AddToCartUseCase(this._repo);
  @override
  Future<Either<Failure, CartEntity>> call(String productId) => _repo.addToCart(productId);
}