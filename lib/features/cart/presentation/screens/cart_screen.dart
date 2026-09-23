import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRouter.home),
        ),
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () => context.push(AppRouter.products),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (ctx, state) {
          if (state is CartLoading) return const CustomLoading();
          if (state is CartFailure) {
            return CustomErrorWidget(
                message: state.message,
                onRetry: () => ctx.read<CartCubit>().getCart());
          }
          if (state is CartItemAdded) {
            ctx.read<CartCubit>().getCart();
            return const CustomLoading();
          }
          if (state is CartLoaded) {
            final cart = state.cart;
            if (cart.products.isEmpty) {
              return const Center(child: Text('Your cart is empty'));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.products.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = cart.products[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: AppColors.fieldBorder),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.horizontal(
                                      left: Radius.circular(15)),
                              child: CachedNetworkImage(
                                imageUrl: item.imageCover,
                                width: 110,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    width: 110,
                                    height: 120,
                                    color: const Color(0xFFF0F0F0)),
                                errorWidget: (_, __, ___) =>
                                    const SizedBox(
                                        width: 110,
                                        height: 120,
                                        child: Icon(Icons.image,
                                            color: AppColors.hint)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(item.title,
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight:
                                                    FontWeight.w500,
                                                color: AppColors.ink)),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            color: AppColors.ink),
                                        onPressed: () => ctx
                                            .read<CartCubit>()
                                            .removeFromCart(item.id),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'EGP ${item.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.ink),
                                  ),
                                  const SizedBox(height: 8),
                                  QtyStepper(
                                    qty: item.count,
                                    onMinus: () {
                                      if (item.count > 1) {
                                        ctx
                                            .read<CartCubit>()
                                            .updateQuantity(item.id,
                                                item.count - 1);
                                      } else {
                                        ctx
                                            .read<CartCubit>()
                                            .removeFromCart(item.id);
                                      }
                                    },
                                    onPlus: () => ctx
                                        .read<CartCubit>()
                                        .updateQuantity(item.id,
                                            item.count + 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.fieldBorder)),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Total price',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.hint)),
                          Text(
                            'EGP ${cart.totalCartPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () =>
                                _checkoutSheet(context, cart.id),
                            child: const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Text('Check Out'),
                                SizedBox(width: 12),
                                Icon(Icons.arrow_forward),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _checkoutSheet(BuildContext context, String cartId) {
    final details = TextEditingController();
    final phone = TextEditingController();
    final city = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Shipping address',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink)),
            const SizedBox(height: 12),
            TextField(
                controller: details,
                decoration:
                    const InputDecoration(hintText: 'Address details')),
            const SizedBox(height: 12),
            TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration:
                    const InputDecoration(hintText: 'Phone')),
            const SizedBox(height: 12),
            TextField(
                controller: city,
                decoration:
                    const InputDecoration(hintText: 'City')),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  if (details.text.trim().isEmpty ||
                      phone.text.trim().isEmpty ||
                      city.text.trim().isEmpty) {
                    Fluttertoast.showToast(
                        msg: 'Please fill the address');
                    return;
                  }
                  final orders = sl<OrdersCubit>();
                  await orders.placeOrder(cartId, {
                    'details': details.text.trim(),
                    'phone': phone.text.trim(),
                    'city': city.text.trim(),
                  });
                  if (!ctx.mounted) return;
                  final s = orders.state;
                  if (s is OrderPlaced) {
                    Navigator.pop(ctx);
                    Fluttertoast.showToast(
                        msg: 'Order placed successfully');
                    context.read<CartCubit>().getCart();
                    context.go(AppRouter.orders);
                  } else if (s is OrdersFailure) {
                    Fluttertoast.showToast(msg: s.message);
                  }
                },
                child: const Text('Confirm Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
