import '../../domain/entities/wishlist_entity.dart';

abstract class WishlistState {}
class WishlistInitial extends WishlistState {}
class WishlistLoading extends WishlistState {}
class WishlistLoaded extends WishlistState { final List<WishlistItemEntity> items; WishlistLoaded(this.items); }
class WishlistFailure extends WishlistState { final String message; WishlistFailure(this.message); }