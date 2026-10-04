import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../../core/widgets/store_actions.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/product_entity.dart';

/// Product card matching the Figma grid (image, heart, title, prices, rating, +).
/// Fills the height its parent gives it; the image takes the free space.
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final double? width;
  const ProductCard({super.key, required this.product, this.width});

  @override
  Widget build(BuildContext context) {
    final wished = context.select<WishlistCubit, bool>(
        (c) => c.state.ids.contains(product.id));
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppColors.outline, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRouter.productDetails(product.id)),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: RouteImage(product.imageCover)),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: HeartButton(
                        filled: wished,
                        size: 30,
                        onTap: () => toggleWishlist(context, product.id),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, color: AppColors.ink, height: 1.3),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(egp(product.finalPrice),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14, color: AppColors.ink)),
                        ),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${groupThousands(product.price)} EGP',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.oldPrice,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: AppColors.oldPrice),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text('Review (${product.ratingsAverage})',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, color: AppColors.ink)),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.star_rounded, size: 17, color: AppColors.star),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        _AddButton(onTap: () => addToCart(context, product.id)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add to cart',
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
