import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), backgroundColor: const Color(0xFF3BB77E)),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (ctx, state) {
          if (state is OrdersLoading) return const CustomLoading();
          if (state is OrdersFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<OrdersCubit>().getOrders());
          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) return const Center(child: Text('No orders yet'));
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.orders.length,
              itemBuilder: (_, i) {
                final order = state.orders[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ExpansionTile(
                    title: Text('Order #${order.id.substring(0, 8)}...'),
                    subtitle: Text('EGP ${order.totalOrderPrice}', style: const TextStyle(color: Color(0xFF3BB77E), fontWeight: FontWeight.bold)),
                    trailing: Chip(
                      label: Text(order.isPaid ? 'Paid' : 'Pending', style: const TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: order.isPaid ? Colors.green : Colors.orange,
                    ),
                    children: order.cartItems.map((item) => ListTile(
                      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('x${item.count}'),
                      trailing: Text('EGP ${item.price}'),
                    )).toList(),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}