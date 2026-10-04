import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../theme/app_colors.dart';

void showToast(String message, {bool error = false}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: error ? AppColors.danger : AppColors.ink,
    textColor: Colors.white,
  );
}

/// Adds to the shared cart and reports the real outcome.
Future<void> addToCart(BuildContext context, String productId, {int quantity = 1}) async {
  final error = await context.read<CartCubit>().addToCart(productId, quantity: quantity);
  if (error != null) {
    showToast(error, error: true);
  } else {
    showToast(quantity > 1 ? 'Added $quantity items to cart' : 'Added to cart');
  }
}

/// Adds/removes from the shared wishlist and reports the real outcome.
Future<void> toggleWishlist(BuildContext context, String productId) async {
  final cubit = context.read<WishlistCubit>();
  final adding = !cubit.contains(productId);
  final error = await cubit.toggle(productId);
  if (error != null) {
    showToast(error, error: true);
  } else {
    showToast(adding ? 'Added to wishlist' : 'Removed from wishlist');
  }
}
