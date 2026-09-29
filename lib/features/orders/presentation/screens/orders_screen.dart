import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../domain/entities/order_entity.dart';
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
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRouter.home),
        ),
        title: const Text('My Orders'),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (ctx, state) {
          if (state is OrdersFailure) {
            return CustomErrorWidget(
                message: state.message,
                onRetry: () => ctx.read<OrdersCubit>().getOrders());
          }
          if (state is! OrdersLoaded) return const CustomLoading();
          if (state.orders.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No orders yet',
              message: 'Your orders will show up here after checkout.',
              actionLabel: 'Start shopping',
              onAction: () => context.go(AppRouter.home),
            );
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ctx.read<OrdersCubit>().getOrders(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _OrderCard(order: state.orders[i]),
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final d = order.createdAt.toLocal();
    final date = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    final status = order.isDelivered
        ? ('Delivered', AppColors.success)
        : order.isPaid
            ? ('Paid', AppColors.primary)
            : ('Pending', const Color(0xFFE08A00));
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.primary,
          title: Text(
              order.number > 0 ? 'Order #${order.number}' : 'Order',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.ink)),
          subtitle: Text(
            '$date · ${order.paymentMethodType}${order.city.isEmpty ? '' : ' · ${order.city}'}\n${egp(order.totalOrderPrice)}',
            style: const TextStyle(color: AppColors.inkMuted, height: 1.4),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.$2.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(status.$1,
                style: TextStyle(
                    color: status.$2, fontSize: 12, fontWeight: FontWeight.w500)),
          ),
          children: order.cartItems
              .map((item) => Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: RouteImage(item.imageCover, width: 52, height: 52),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.title.isEmpty ? 'Product' : item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: AppColors.ink),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('x${item.count}  ${egp(item.price)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, color: AppColors.ink)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
