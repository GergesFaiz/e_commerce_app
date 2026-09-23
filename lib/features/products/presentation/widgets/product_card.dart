import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/product_entity.dart';

/// Product card matching the Figma grid (image, heart, title, prices, rating, +).
class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final double width;
  final bool wishlisted;
  final Future<void> Function()? onHeart;
  const ProductCard({
    super.key,
    required this.product,
    this.width = double.infinity,
    this.wishlisted = false,
    this.onHeart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                  child: CachedNetworkImage(
                    imageUrl: product.imageCover,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                        height: 150, color: const Color(0xFFF0F0F0)),
                    errorWidget: (_, __, ___) => const SizedBox(
                        height: 150,
                        child: Icon(Icons.image, color: AppColors.hint)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: HeartButton(
                    filled: wishlisted,
                    onTap: () => onHeart?.call(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.ink,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'EGP ${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.ink,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      if (product.priceAfterDiscount != null)
                        Text(
                          '${product.priceAfterDiscount!.toStringAsFixed(0)} EGP',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.oldPrice,
                              decoration: TextDecoration.lineThrough),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Review (${product.ratingsAverage})',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.ink),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.star,
                                size: 14, color: AppColors.star),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final cubit = sl<CartCubit>();
                          await cubit.addToCart(product.id);
                          Fluttertoast.showToast(msg: 'Added to cart');
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary,
                          ),
                          child: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
