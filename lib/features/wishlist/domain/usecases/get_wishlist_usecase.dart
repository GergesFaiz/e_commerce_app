import 'package:dartz/dartz.dart';
import '../../../../core/di/base_usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/wishlist_entity.dart';
import '../repos/i_wishlist_repo.dart';

class GetWishlistUseCase extends BaseUseCase<List<WishlistItemEntity>, NoParams> {
  final IWishlistRepo _repo;
  GetWishlistUseCase(this._repo);
  @override
  Future<Either<Failure, List<WishlistItemEntity>>> call(NoParams p) => _repo.getWishlist();
}