import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import 'wishlist_state.dart';

/// App-wide wishlist; [WishlistState.ids] drives the heart on every card.
class WishlistCubit extends Cubit<WishlistState> {
  final GetWishlistUseCase _get;
  final AddToWishlistUseCase _add;
  final RemoveFromWishlistUseCase _remove;
  WishlistCubit(this._get, this._add, this._remove) : super(const WishlistState());

  bool contains(String productId) => state.ids.contains(productId);

  /// [silent] refreshes without showing a loader.
  Future<void> getWishlist({bool silent = false}) async {
    if (!silent) emit(state.copyWith(loading: true));
    final r = await _get(NoParams());
    r.fold(
      (f) => emit(state.copyWith(loading: false, error: f.message)),
      (items) => emit(WishlistState(items: items, ids: {for (final i in items) i.id})),
    );
  }

  /// Adds or removes [productId] (optimistically). Returns an error message,
  /// or null on success.
  Future<String?> toggle(String productId) async {
    final before = state;
    final adding = !contains(productId);
    emit(state.copyWith(
      ids: adding ? {...state.ids, productId} : ({...state.ids}..remove(productId)),
      items: adding ? state.items : state.items.where((i) => i.id != productId).toList(),
      error: state.error,
    ));
    final r = adding ? await _add(productId) : await _remove(productId);
    final failure = r.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(before);
      return failure.message;
    }
    emit(state.copyWith(ids: r.getOrElse(() => const []).toSet(), error: state.error));
    // Add answers with ids only; load the product details for the list.
    if (adding) await getWishlist(silent: true);
    return null;
  }

  /// Forget the wishlist of the signed-out user.
  void reset() => emit(const WishlistState());
}
