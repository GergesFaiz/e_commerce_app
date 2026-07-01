import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/cart_entity.dart';
import '../repos/i_cart_repo.dart';

class UpdateParams { final String itemId; final int count; const UpdateParams(this.itemId, this.count); }

class UpdateCartQuantityUseCase extends BaseUseCase<CartEntity, UpdateParams> {
  final ICartRepo _repo;
  UpdateCartQuantityUseCase(this._repo);
  @override
  Future<Either<Failure, CartEntity>> call(UpdateParams p) => _repo.updateQuantity(p.itemId, p.count);
}