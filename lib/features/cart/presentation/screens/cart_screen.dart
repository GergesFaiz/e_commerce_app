import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../../core/widgets/store_actions.dart';
import '../../../addresses/data/models/address_model.dart';
import '../../../addresses/presentation/cubit/addresses_cubit.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/cubit/orders_state.dart';
import '../../domain/entities/cart_entity.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Products with a request in flight (their controls are disabled).
  final _busy = <String>{};

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().getCart();
  }

  Future<void> _run(String productId, Future<String?> Function() action) async {
    setState(() => _busy.add(productId));
    final error = await action();
    if (!mounted) return;
    setState(() => _busy.remove(productId));
    if (error != null) showToast(error, error: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRouter.home),
        ),
        title: const Text('Cart'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search, color: AppColors.primary, size: 28),
            onPressed: () => context.push(AppRouter.productList()),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) => state is CartLoaded && state.cart.products.isNotEmpty
                ? IconButton(
                    tooltip: 'Clear cart',
                    icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.primary),
                    onPressed: () => _confirmClear(context),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (ctx, state) {
          if (state is CartFailure) {
            return CustomErrorWidget(message: state.message, onRetry: cubit.getCart);
          }
          if (state is! CartLoaded) return const CustomLoading();
          final cart = state.cart;
          if (cart.products.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'Your cart is empty',
              message: 'Browse products and tap + to add them here.',
              actionLabel: 'Start shopping',
              onAction: () => context.go(AppRouter.home),
            );
          }
          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => cubit.getCart(silent: true),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) {
                      final item = cart.products[i];
                      final busy = _busy.contains(item.productId);
                      return _CartItemTile(
                        item: item,
                        busy: busy,
                        onOpen: () => context.push(AppRouter.productDetails(item.productId)),
                        onDelete: () => _run(item.productId,
                            () => cubit.removeFromCart(item.productId)),
                        onMinus: () => _run(item.productId,
                            () => cubit.updateQuantity(item.productId, item.count - 1)),
                        onPlus: () => _run(item.productId,
                            () => cubit.updateQuantity(item.productId, item.count + 1)),
                      );
                    },
                  ),
                ),
              ),
              _CheckoutBar(
                total: cart.totalCartPrice,
                onCheckout: () => _checkoutSheet(context, cart.id),
              ),
            ],
          );
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => BlocProvider(
        create: (_) => sl<AddressesCubit>()..load(),
        child: _AddressPicker(
          cartId: cartId,
          onOrdered: () {
            context.read<CartCubit>().markOrdered();
            context.pushReplacement(AppRouter.orders);
          },
        ),
      ),
    );
  }
}

/// Outlined row: image, title + delete, brand, price and blue stepper.
class _CartItemTile extends StatelessWidget {
  final CartItemEntity item;
  final bool busy;
  final VoidCallback onOpen, onDelete, onMinus, onPlus;
  const _CartItemTile({
    required this.item,
    required this.busy,
    required this.onOpen,
    required this.onDelete,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onOpen,
            child: Container(
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.outline),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: RouteImage(item.imageCover, height: double.infinity),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 8, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ink)),
                      ),
                      IconButton(
                        tooltip: 'Remove',
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.delete_outline, color: AppColors.ink),
                        onPressed: busy ? null : onDelete,
                      ),
                    ],
                  ),
                  if (item.brand.isNotEmpty)
                    Text(item.brand,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: AppColors.inkMuted)),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(egp(item.price),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink)),
                        ),
                      ),
                      busy
                          ? const SizedBox(
                              width: 90,
                              height: 36,
                              child: CustomLoading())
                          : QtyStepper(
                              compact: true,
                              qty: item.count,
                              onMinus: onMinus,
                              onPlus: onPlus,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;
  const _CheckoutBar({required this.total, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total price',
                    style: TextStyle(fontSize: 18, color: AppColors.inkMuted)),
                Text(egp(total),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    textStyle: AppTheme.font(20, FontWeight.w500),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Check Out'),
                      SizedBox(width: 16),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressPicker extends StatefulWidget {
  final String cartId;
  final VoidCallback onOrdered;
  const _AddressPicker({required this.cartId, required this.onOrdered});

  @override
  State<_AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<_AddressPicker> {
  bool _showNew = false;
  bool _placing = false;
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
    if (_showNew || s.addresses.isEmpty) {
      if (_details.text.trim().isEmpty ||
          _phone.text.trim().isEmpty ||
          _city.text.trim().isEmpty) {
        showToast('Please fill the address', error: true);
        return;
      }
      setState(() => _placing = true);
      final ok = await cubit.add(Address(
        id: '',
        name: _name.text.trim().isEmpty ? 'Home' : _name.text.trim(),
        details: _details.text.trim(),
        phone: _phone.text.trim(),
        city: _city.text.trim(),
      ));
      if (!ok) {
        if (mounted) setState(() => _placing = false);
        showToast('Could not save the address', error: true);
        return;
      }
      address = {
        'details': _details.text.trim(),
        'phone': _phone.text.trim(),
        'city': _city.text.trim(),
      };
    } else {
      final found = s.addresses.where((a) => a.id == s.selectedId).toList();
      if (found.isEmpty) {
        showToast('Please select an address', error: true);
        return;
      }
      address = {
        'details': found.first.details,
        'phone': found.first.phone,
        'city': found.first.city,
      };
    }
    setState(() => _placing = true);
    final orders = sl<OrdersCubit>();
    await orders.placeOrder(widget.cartId, address);
    final st = orders.state;
    await orders.close();
    if (!mounted) return;
    setState(() => _placing = false);
    if (st is OrderPlaced) {
      Navigator.pop(context);
      showToast('Order placed successfully');
      widget.onOrdered();
    } else if (st is OrdersFailure) {
      showToast(st.message, error: true);
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
            return const SizedBox(height: 200, child: CustomLoading());
          }
          if (state is AddressesFailure) {
            return SizedBox(
              height: 200,
              child: CustomErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<AddressesCubit>().load()),
            );
          }
          final s = state as AddressesLoaded;
          final showForm = _showNew || s.addresses.isEmpty;
          return SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Shipping address',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink)),
                  const SizedBox(height: 8),
                  if (s.addresses.isNotEmpty)
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
                                  activeColor: AppColors.primary,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text('${a.name} - ${a.city}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.ink)),
                                  subtitle: Text('${a.details}\n${a.phone}'),
                                  isThreeLine: true,
                                ))
                            .toList(),
                      ),
                    ),
                  if (s.addresses.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => setState(() => _showNew = !_showNew),
                      icon: Icon(_showNew ? Icons.remove : Icons.add),
                      label: const Text('New address'),
                    ),
                  if (showForm) ...[
                    TextField(
                        controller: _name,
                        decoration: const InputDecoration(
                            hintText: 'Label (Home, Work...)')),
                    const SizedBox(height: 12),
                    TextField(
                        controller: _details,
                        decoration: const InputDecoration(
                            hintText: 'Address details')),
                    const SizedBox(height: 12),
                    TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(hintText: 'Phone')),
                    const SizedBox(height: 12),
                    TextField(
                        controller: _city,
                        decoration:
                            const InputDecoration(hintText: 'City')),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _placing ? null : () => _confirm(s),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: _placing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('Confirm Order (Cash)'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
