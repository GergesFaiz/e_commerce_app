import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_header.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';

/// Product grid for a category, subcategory, brand or search query.
class ProductsScreen extends StatefulWidget {
  final String? title;
  final String? initialQuery;
  const ProductsScreen({super.key, this.title, this.initialQuery});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late final TextEditingController _searchController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.initialQuery ?? '');
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 300) {
      context.read<ProductsCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            RouteHeader(
              showBack: true,
              controller: _searchController,
              onChanged: (v) => context.read<ProductsCubit>().setSearchQuery(v),
              onSubmitted: (v) => context.read<ProductsCubit>().setSearchQuery(v),
            ),
            _toolbar(),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsFailure) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () => context.read<ProductsCubit>().refresh(),
                    );
                  }
                  if (state is! ProductsLoaded) return const CustomLoading();
                  if (state.products.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off,
                      title: 'No products found',
                      message: 'Try another word or category.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<ProductsCubit>().refresh(),
                    color: AppColors.primary,
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 250,
                      ),
                      itemCount: state.products.length +
                          (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.products.length) {
                          return const CustomLoading();
                        }
                        return ProductCard(product: state.products[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return BlocBuilder<ProductsCubit, ProductsState>(
      buildWhen: (a, b) => b is ProductsLoaded || a.runtimeType != b.runtimeType,
      builder: (context, state) {
        final sort = state is ProductsLoaded ? state.sortByPriceAsc : null;
        final title = widget.title ?? 'All Products';
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
              ),
              TextButton.icon(
                onPressed: () => context.read<ProductsCubit>().toggleSortByPrice(),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                icon: Icon(
                  sort == null
                      ? Icons.swap_vert
                      : sort
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                  size: 18,
                ),
                label: Text(sort == null
                    ? 'Sort by price'
                    : sort
                        ? 'Price: low to high'
                        : 'Price: high to low'),
              ),
            ],
          ),
        );
      },
    );
  }
}
