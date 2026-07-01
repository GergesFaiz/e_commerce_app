import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/base_usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_quantity_usecase.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase _add;
  final GetCartUseCase _get;
  final RemoveFromCartUseCase _remove;
  final UpdateCartQuantityUseCase _update;
  CartCubit(this._add, this._get, this._remove, this._update) : super(CartInitial());

  Future<void> addToCart(String productId) async {
    final r = await _add(productId);
    r.fold((f) => emit(CartFailure(f.message)), (_) => emit(CartItemAdded('Added to cart!')));
  }

  Future<void> getCart() async {
    emit(CartLoading());
    final r = await _get(NoParams());
    r.fold((f) => emit(CartFailure(f.message)), (c) => emit(CartLoaded(c)));
  }

  Future<void> removeFromCart(String itemId) async {
    final r = await _remove(itemId);
    r.fold((f) => emit(CartFailure(f.message)), (c) => emit(CartLoaded(c)));
  }

  Future<void> updateQuantity(String itemId, int count) async {
    final r = await _update(UpdateParams(itemId, count));
    r.fold((f) => emit(CartFailure(f.message)), (c) => emit(CartLoaded(c)));
  }
}