import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';

/// Cart icon with the number of items in the shared cart.
class CartIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const CartIconButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, _) {
        final count = context.read<CartCubit>().itemCount;
        return IconButton(
          tooltip: 'Cart',
          onPressed: onPressed ?? () => context.push(AppRouter.cart),
          icon: Badge(
            isLabelVisible: count > 0,
            backgroundColor: AppColors.danger,
            label: Text(count > 99 ? '99+' : '$count'),
            child: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.primary, size: 28),
          ),
        );
      },
    );
  }
}
