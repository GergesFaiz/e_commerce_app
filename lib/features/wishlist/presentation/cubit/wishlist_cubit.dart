import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistUseCase _get;
  final AddToWishlistUseCase _add;
  final RemoveFromWishlistUseCase _remove;
  WishlistCubit(this._get, this._add, this._remove) : super(WishlistInitial());

  Future<void> getWishlist() async {
    emit(WishlistLoading());
    final r = await _get(NoParams());
    r.fold((f) => emit(WishlistFailure(f.message)), (items) => emit(WishlistLoaded(items)));
  }

  Future<void> toggleWishlist(String productId) async {
    final r = await _add(productId);
    r.fold((f) => emit(WishlistFailure(f.message)), (_) => getWishlist());
  }

  Future<void> remove(String productId) async {
    final r = await _remove(productId);
    r.fold((f) => emit(WishlistFailure(f.message)), (_) => getWishlist());
  }
}