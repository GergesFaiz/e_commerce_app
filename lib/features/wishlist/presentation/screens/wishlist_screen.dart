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
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../cubit/wishlist_cubit.dart';
import '../cubit/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const RouteLogo(),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.primary, size: 30),
                    onPressed: () => context.push(AppRouter.cart),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: RouteSearchBar(),
            ),
            Expanded(
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (ctx, state) {
                  if (state is WishlistLoading) {
                    return const CustomLoading();
                  }
                  if (state is WishlistFailure) {
                    return CustomErrorWidget(
                        message: state.message,
                        onRetry: () =>
                            ctx.read<WishlistCubit>().getWishlist());
                  }
                  if (state is WishlistLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(
                          child: Text('Wishlist is empty'));
                    }
                    return ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final item = state.items[i];
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
                                borderRadius: const BorderRadius.horizontal(
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
                                    Text(item.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.ink)),
                                    const SizedBox(height: 4),
                                    const Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 6,
                                            backgroundColor:
                                                AppColors.ink),
                                        SizedBox(width: 4),
                                        Text('Black color',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.ink)),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          'EGP ${item.price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.ink),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await sl<CartCubit>()
                                                .addToCart(item.id);
                                            Fluttertoast.showToast(
                                                msg: 'Added to cart');
                                          },
                                          style:
                                              ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size(110, 40),
                                            textStyle: const TextStyle(
                                                fontSize: 13),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                          ),
                                          child:
                                              const Text('Add to Cart'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 8, bottom: 70),
                                child: HeartButton(
                                  filled: true,
                                  onTap: () => ctx
                                      .read<WishlistCubit>()
                                      .remove(item.id),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: RouteBottomNav(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) context.go(AppRouter.home);
          if (i == 1) context.go(AppRouter.categories);
          if (i == 2) context.go(AppRouter.wishlist);
          if (i == 3) context.go(AppRouter.account);
        },
      ),
    );
  }
}
