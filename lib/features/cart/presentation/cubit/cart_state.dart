import '../../domain/entities/cart_entity.dart';

abstract class CartState {}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  final CartEntity cart;
  CartLoaded(this.cart);
}
class CartItemAdded extends CartState { final String message; CartItemAdded(this.message); }
class CartFailure extends CartState { final String message; CartFailure(this.message); }