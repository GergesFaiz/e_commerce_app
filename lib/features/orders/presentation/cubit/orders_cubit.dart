import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../domain/usecases/checkout_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final CheckoutUseCase _checkout;
  final GetOrdersUseCase _getOrders;
  OrdersCubit(this._checkout, this._getOrders) : super(OrdersInitial());

  Future<void> getOrders() async {
    emit(OrdersLoading());
    final userId = CacheHelper.getUserId() ?? '';
    final r = await _getOrders(userId);
    r.fold((f) => emit(OrdersFailure(f.message)), (orders) => emit(OrdersLoaded(orders)));
  }

  Future<void> placeOrder(String cartId, Map<String, dynamic> address) async {
    emit(OrdersLoading());
    final r = await _checkout(CheckoutParams(cartId: cartId, shippingAddress: address));
    r.fold((f) => emit(OrdersFailure(f.message)), (order) => emit(OrderPlaced(order)));
  }
}