import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_state.dart';

/// App-wide cart. Mutations return an error message (or null on success)
/// so callers can show a toast without replacing the cart view.
class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase _add;
  final GetCartUseCase _get;
  final RemoveFromCartUseCase _remove;
  final UpdateCartQuantityUseCase _update;
  final ClearCartUseCase _clear;
  CartCubit(this._add, this._get, this._remove, this._update, this._clear) : super(CartInitial());

  CartEntity _cart = CartEntity.empty;

  /// Last known cart, kept across loading/failure states.
  CartEntity get cart => _cart;
  int get itemCount => _cart.numOfCartItems;

  void _loaded(CartEntity cart) {
    _cart = cart;
    emit(CartLoaded(cart));
  }

  /// [silent] refreshes without showing a loader or replacing the view on error.
  Future<void> getCart({bool silent = false}) async {
    if (!silent) emit(CartLoading());
    final r = await _get(NoParams());
    r.fold((f) { if (!silent) emit(CartFailure(f.message)); }, _loaded);
  }

  /// Adds [productId]; a [quantity] above 1 sets the line count accordingly.
  Future<String?> addToCart(String productId, {int quantity = 1}) async {
    final r = await _add(productId);
    final failure = r.fold((f) => f, (_) => null);
    if (failure != null) return failure.message;
    final added = r.getOrElse(() => CartEntity.empty);
    if (quantity > 1) {
      final count = added.countOf(productId) + quantity - 1;
      return updateQuantity(productId, count);
    }
    // POST answers with product ids only; fetch the populated cart.
    _cart = CartEntity(
      id: added.id,
      cartOwner: added.cartOwner,
      products: _cart.products,
      totalCartPrice: added.totalCartPrice,
      numOfCartItems: added.numOfCartItems,
    );
    await getCart(silent: true);
    return null;
  }

  Future<String?> removeFromCart(String productId) async {
    final r = await _remove(productId);
    return r.fold((f) => f.message, (c) { _loaded(c); return null; });
  }

  Future<String?> updateQuantity(String productId, int count) async {
    if (count < 1) return removeFromCart(productId);
    final r = await _update(UpdateParams(productId, count));
    return r.fold((f) => f.message, (c) { _loaded(c); return null; });
  }

  Future<void> clear() async {
    emit(CartLoading());
    final r = await _clear(NoParams());
    r.fold((f) => emit(CartFailure(f.message)), (_) => _loaded(CartEntity.empty));
  }

  /// The server empties the cart once an order is placed.
  void markOrdered() => _loaded(CartEntity.empty);

  /// Forget the cart of the signed-out user.
  void reset() {
    _cart = CartEntity.empty;
    emit(CartInitial());
  }
}
