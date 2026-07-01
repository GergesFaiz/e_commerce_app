import '../../domain/entities/order_entity.dart';

abstract class OrdersState {}
class OrdersInitial extends OrdersState {}
class OrdersLoading extends OrdersState {}
class OrdersLoaded extends OrdersState { final List<OrderEntity> orders; OrdersLoaded(this.orders); }
class OrderPlaced extends OrdersState { final OrderEntity order; OrderPlaced(this.order); }
class OrdersFailure extends OrdersState { final String message; OrdersFailure(this.message); }