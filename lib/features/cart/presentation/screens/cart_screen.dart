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
import '../../../addresses/data/models/address_model.dart';
import '../../../addresses/presentation/cubit/addresses_cubit.dart';
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
            icon: const Icon(Icons.delete_sweep_outlined,
                color: AppColors.primary),
            tooltip: 'Clear cart',
            onPressed: () => _confirmClear(context),
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

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear cart?'),
        content: const Text('All items will be removed from your cart.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CartCubit>().clear();
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(120, 48)),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _checkoutSheet(BuildContext context, String cartId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => BlocProvider(
        create: (_) => sl<AddressesCubit>()..load(),
        child: _AddressPicker(cartId: cartId),
      ),
    );
  }
}

class _AddressPicker extends StatefulWidget {
  final String cartId;
  const _AddressPicker({required this.cartId});

  @override
  State<_AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<_AddressPicker> {
  bool _showNew = false;
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _details.dispose();
    _phone.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _confirm(AddressesLoaded s) async {
    final cubit = context.read<AddressesCubit>();
    Map<String, String>? address;
    if (_showNew) {
      if (_details.text.trim().isEmpty ||
          _phone.text.trim().isEmpty ||
          _city.text.trim().isEmpty) {
        Fluttertoast.showToast(msg: 'Please fill the address');
        return;
      }
      final ok = await cubit.add(Address(
        id: '',
        name: _name.text.trim().isEmpty ? 'Home' : _name.text.trim(),
        details: _details.text.trim(),
        phone: _phone.text.trim(),
        city: _city.text.trim(),
      ));
      if (!ok) {
        Fluttertoast.showToast(msg: 'Could not save the address');
        return;
      }
      final latest = cubit.state;
      if (latest is AddressesLoaded && latest.addresses.isNotEmpty) {
        final a = latest.addresses.last;
        address = {'details': a.details, 'phone': a.phone, 'city': a.city};
      }
    } else {
      final found = s.addresses.where((a) => a.id == s.selectedId).toList();
      if (found.isEmpty) {
        Fluttertoast.showToast(msg: 'Please select an address');
        return;
      }
      address = {
        'details': found.first.details,
        'phone': found.first.phone,
        'city': found.first.city,
      };
    }
    if (address == null) return;
    final orders = sl<OrdersCubit>();
    await orders.placeOrder(widget.cartId, address);
    if (!mounted) return;
    final st = orders.state;
    if (st is OrderPlaced) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Order placed successfully');
      context.read<CartCubit>().getCart();
      context.go(AppRouter.orders);
    } else if (st is OrdersFailure) {
      Fluttertoast.showToast(msg: st.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16),
      child: BlocBuilder<AddressesCubit, AddressesState>(
        builder: (context, state) {
          if (state is AddressesLoading || state is AddressesInitial) {
            return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()));
          }
          if (state is AddressesFailure) {
            return SizedBox(
              height: 160,
              child: Center(child: Text(state.message)),
            );
          }
          final s = state as AddressesLoaded;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Shipping address',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink)),
                const SizedBox(height: 8),
                RadioGroup<String>(
                  groupValue: _showNew ? null : s.selectedId,
                  onChanged: (v) {
                    setState(() => _showNew = false);
                    context.read<AddressesCubit>().select(v);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: s.addresses
                        .map((a) => RadioListTile<String>(
                              value: a.id,
                              title: Text('${a.name} - ${a.city}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle:
                                  Text('${a.details}\n${a.phone}'),
                              isThreeLine: true,
                            ))
                        .toList(),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _showNew = !_showNew),
                  icon: Icon(_showNew ? Icons.remove : Icons.add),
                  label: const Text('New address'),
                ),
                if (_showNew) ...[
                  TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                          hintText: 'Label (Home, Work...)')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: _details,
                      decoration: const InputDecoration(
                          hintText: 'Address details')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(hintText: 'Phone')),
                  const SizedBox(height: 8),
                  TextField(
                      controller: _city,
                      decoration:
                          const InputDecoration(hintText: 'City')),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _confirm(s),
                    child: const Text('Confirm Order'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
