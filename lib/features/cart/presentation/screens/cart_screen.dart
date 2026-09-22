import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: const Color(0xFF3BB77E)),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (ctx, state) {
          if (state is CartLoading) return const CustomLoading();
          if (state is CartFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<CartCubit>().getCart());
          if (state is CartLoaded) {
            final cart = state.cart;
            if (cart.products.isEmpty) return const Center(child: Text('Your cart is empty'));
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.products.length,
                    itemBuilder: (_, i) {
                      final item = cart.products[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: ClipRRect(borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(imageUrl: item.imageCover, width: 60, height: 60, fit: BoxFit.cover)),
                          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text('EGP ${item.price}', style: const TextStyle(color: Color(0xFF3BB77E), fontWeight: FontWeight.bold)),
                          trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
                              if (item.count > 1) {
                                ctx.read<CartCubit>().updateQuantity(item.id, item.count - 1);
                              } else {
                                ctx.read<CartCubit>().removeFromCart(item.id);
                              }
                            }),
                            Text('${item.count}'),
                            IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => ctx.read<CartCubit>().updateQuantity(item.id, item.count + 1)),
                          ]),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, -2))]),
                  child: Row(
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Total', style: TextStyle(color: Colors.grey)),
                        Text('EGP ${cart.totalCartPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3BB77E))),
                      ]),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3BB77E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14)),
                        child: const Text('Checkout'),
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
}