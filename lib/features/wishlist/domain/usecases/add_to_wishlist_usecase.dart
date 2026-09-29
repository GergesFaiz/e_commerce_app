import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../repos/i_wishlist_repo.dart';

class AddToWishlistUseCase extends BaseUseCase<List<String>, String> {
  final IWishlistRepo _repo;
  AddToWishlistUseCase(this._repo);
  @override
  Future<Either<Failure, List<String>>> call(String productId) => _repo.addToWishlist(productId);
}