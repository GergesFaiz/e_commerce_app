import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_header.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../../core/widgets/store_actions.dart';
import '../../domain/entities/wishlist_entity.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const RouteHeader(),
          Expanded(
            child: BlocBuilder<WishlistCubit, WishlistState>(
              builder: (ctx, state) {
                final cubit = ctx.read<WishlistCubit>();
                if (state.items.isEmpty) {
                  if (state.loading) return const CustomLoading();
                  if (state.error != null) {
                    return CustomErrorWidget(
                        message: state.error!, onRetry: cubit.getWishlist);
                  }
                  return EmptyState(
                    icon: Icons.favorite_border,
                    title: 'Your wishlist is empty',
                    message: 'Tap the heart on a product to save it here.',
                    actionLabel: 'Browse products',
                    onAction: () => context.push(AppRouter.productList()),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () => cubit.getWishlist(silent: true),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _WishlistTile(item: state.items[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Outlined row: image, title, prices, filled heart and "Add to Cart".
class _WishlistTile extends StatelessWidget {
  final WishlistItemEntity item;
  const _WishlistTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = item.priceAfterDiscount != null &&
        item.priceAfterDiscount! < item.price;
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.outline),
      ),
      child: InkWell(
        onTap: () => context.push(AppRouter.productDetails(item.id)),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Container(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(item.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ink,
                                    height: 1.25)),
                          ),
                          const SizedBox(width: 8),
                          HeartButton(
                            filled: true,
                            size: 30,
                            onTap: () => toggleWishlist(context, item.id),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      egp(hasDiscount
                                          ? item.priceAfterDiscount!
                                          : item.price),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.ink)),
                                ),
                                if (hasDiscount)
                                  Text(egp(item.price),
                                      maxLines: 1,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.oldPrice,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          decorationColor: AppColors.oldPrice)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 36,
                            child: ElevatedButton(
                              onPressed: () => addToCart(context, item.id),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 36),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                textStyle: AppTheme.font(14, FontWeight.w500),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Add to Cart'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
