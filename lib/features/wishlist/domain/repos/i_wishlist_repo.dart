import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/wishlist_entity.dart';

abstract class IWishlistRepo {
  Future<Either<Failure, List<WishlistItemEntity>>> getWishlist();
  Future<Either<Failure, String>> addToWishlist(String productId);
  Future<Either<Failure, String>> removeFromWishlist(String productId);
}