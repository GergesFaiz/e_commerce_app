import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/wishlist_entity.dart';

abstract class IWishlistRepo {
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist();

  /// Returns the product ids now in the wishlist.
  Future<Either<Failure, List<String>>> addToWishlist(String productId);

  /// Returns the product ids now in the wishlist.
  Future<Either<Failure, List<String>>> removeFromWishlist(String productId);
}
