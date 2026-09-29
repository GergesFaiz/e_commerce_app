import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_header.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../products/presentation/cubit/products_cubit.dart';
import '../../../products/presentation/cubit/products_state.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../domain/entities/category_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Home tab: header, promo slider, categories (2 rows), brands and
/// best-selling products.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _categoriesTab = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await Future.wait([
            context.read<HomeCubit>().getHomeData(),
            context.read<ProductsCubit>().refresh(),
          ]);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const RouteHeader(),
            const SizedBox(height: 8),
            BannerSlider(onShopNow: () => context.push(AppRouter.productList())),
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Categories',
              onViewAll: () => StatefulNavigationShell.of(context).goBranch(_categoriesTab),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (ctx, state) {
                if (state is HomeFailure) {
                  return SizedBox(
                    height: 310,
                    child: CustomErrorWidget(
                        message: state.message,
                        onRetry: () => ctx.read<HomeCubit>().getHomeData()),
                  );
                }
                if (state is! HomeLoaded) {
                  return const SizedBox(height: 310, child: CustomLoading());
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CategoriesGrid(
                      categories: state.categories,
                      onTap: (cat) {
                        ctx.read<HomeCubit>().selectCategory(cat.id);
                        StatefulNavigationShell.of(context).goBranch(_categoriesTab);
                      },
                    ),
                    if (state.brands.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const SectionHeader(title: 'Brands'),
                      const SizedBox(height: 4),
                      _BrandsRow(brands: state.brands),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            SectionHeader(
              title: 'Most Selling Products',
              onViewAll: () => context.push(AppRouter.productList()),
            ),
            const SizedBox(height: 4),
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (ctx, state) {
                if (state is ProductsFailure) {
                  return SizedBox(
                    height: 260,
                    child: CustomErrorWidget(
                        message: state.message,
                        onRetry: () => ctx.read<ProductsCubit>().refresh()),
                  );
                }
                if (state is! ProductsLoaded) {
                  return const SizedBox(height: 260, child: CustomLoading());
                }
                return SizedBox(
                  height: 260,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.products.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, i) =>
                        ProductCard(product: state.products[i], width: 180),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Two rows of round category images that scroll sideways.
class _CategoriesGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onTap;
  const _CategoriesGrid({required this.categories, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 8,
          mainAxisExtent: 100,
        ),
        itemCount: categories.length,
        itemBuilder: (_, i) => CategoryCircle(
          imageUrl: categories[i].image,
          label: categories[i].name,
          onTap: () => onTap(categories[i]),
        ),
      ),
    );
  }
}

/// Brand logos in outlined tiles; tapping opens that brand's products.
class _BrandsRow extends StatelessWidget {
  final List<BrandEntity> brands;
  const _BrandsRow({required this.brands});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: brands.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final brand = brands[i];
          return InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () => context.push(
                AppRouter.productList(title: brand.name, brandId: brand.id)),
            child: Container(
              width: 120,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: AppColors.outline),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RouteImage(brand.image, fit: BoxFit.contain),
              ),
            ),
          );
        },
      ),
    );
  }
}
