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
import '../../../products/presentation/cubit/products_cubit.dart';
import '../../../products/presentation/cubit/products_state.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.all(16),
                child: RouteSearchBar(
                  onSubmitted: (q) {
                    if (q.trim().isNotEmpty) {
                      context.go('${AppRouter.products}?q=${Uri.encodeComponent(q.trim())}');
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PromoBanner(
                    onShopNow: () => context.go(AppRouter.products)),
              ),
              const SizedBox(height: 16),
              _sectionHeader(context, 'Categories',
                  onViewAll: () => context.go(AppRouter.products)),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (ctx, state) {
                  if (state is HomeLoading) {
                    return const SizedBox(
                        height: 120,
                        child: Center(child: CustomLoading()));
                  }
                  if (state is HomeFailure) {
                    return CustomErrorWidget(
                        message: state.message,
                        onRetry: () =>
                            ctx.read<HomeCubit>().getHomeData());
                  }
                  if (state is HomeLoaded) {
                    return SizedBox(
                      height: 130,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.categories.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final cat = state.categories[i];
                          return CategoryCircle(
                            imageUrl: cat.image,
                            label: cat.name,
                            onTap: () => context.go(
                                '${AppRouter.products}?categoryId=${cat.id}'),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox(height: 130);
                },
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Home Appliance',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink)),
              ),
              const SizedBox(height: 12),
              BlocBuilder<ProductsCubit, ProductsState>(
                builder: (ctx, state) {
                  if (state is ProductsLoaded) {
                    final items = state.products.take(6).toList();
                    return SizedBox(
                      height: 290,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (_, i) => ProductCard(
                          product: items[i],
                          width: 170,
                          onHeart: () async {
                            await sl<WishlistCubit>()
                                .toggleWishlist(items[i].id);
                            Fluttertoast.showToast(
                                msg: 'Added to wishlist');
                          },
                        ),
                      ),
                    );
                  }
                  return const SizedBox(
                      height: 290,
                      child: Center(child: CustomLoading()));
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RouteBottomNav(
        currentIndex: 0,
        onTap: (i) => _onNav(context, i),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title,
      {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink)),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('view all',
                  style: TextStyle(
                      fontSize: 14, color: AppColors.ink)),
            ),
        ],
      ),
    );
  }
}

void _onNav(BuildContext context, int i) {
  switch (i) {
    case 0:
      context.go(AppRouter.home);
      break;
    case 1:
      context.go(AppRouter.categories);
      break;
    case 2:
      context.go(AppRouter.wishlist);
      break;
    case 3:
      context.go(AppRouter.account);
      break;
  }
}
