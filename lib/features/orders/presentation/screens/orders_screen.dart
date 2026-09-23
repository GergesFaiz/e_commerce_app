import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/orders_cubit.dart';
import '../cubit/orders_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('My Orders'),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (ctx, state) {
          if (state is OrdersLoading) return const CustomLoading();
          if (state is OrdersFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<OrdersCubit>().getOrders());
          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) return const Center(child: Text('No orders yet'));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (_, i) {
                final order = state.orders[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.fieldBorder),
                  ),
                  child: ExpansionTile(
                    title: Text('Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}...',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: AppColors.ink)),
                    subtitle: Text('EGP ${order.totalOrderPrice}',
                        style: const TextStyle(
                            color: AppColors.primary, fontWeight: FontWeight.bold)),
                    trailing: Chip(
                      label: Text(order.isPaid ? 'Paid' : 'Pending',
                          style: const TextStyle(color: Colors.white, fontSize: 11)),
                      backgroundColor: order.isPaid ? AppColors.success : Colors.orange,
                    ),
                    children: order.cartItems.map((item) => ListTile(
                      title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.ink)),
                      subtitle: Text('x${item.count}',
                          style: const TextStyle(color: AppColors.hint)),
                      trailing: Text('EGP ${item.price}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, color: AppColors.ink)),
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