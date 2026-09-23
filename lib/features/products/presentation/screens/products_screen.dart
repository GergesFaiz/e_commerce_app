import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  final String? initialQuery;
  const ProductsScreen({super.key, this.initialQuery});

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
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const RouteLogo(),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: Color(0xFF004182), size: 30),
                    onPressed: () => context.push(AppRouter.cart),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'what do you search for?',
                  prefixIcon: Icon(Icons.search,
                      color: Color(0xFF004182), size: 28),
                ).copyWith(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Color(0xFF004182))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Color(0xFF004182))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Color(0xFF004182), width: 1.5)),
                ),
                onChanged: (v) =>
                    context.read<ProductsCubit>().setSearchQuery(v),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const CustomLoading();
                  }
                  if (state is ProductsFailure) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<ProductsCubit>().getProducts(),
                    );
                  }
                  if (state is ProductsLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(
                          child: Text('No products found.'));
                    }
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<ProductsCubit>().getProducts(),
                      color: const Color(0xFF004182),
                      child: GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.62,
                        ),
                        itemCount: state.products.length +
                            (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.products.length) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          return ProductCard(
                              product: state.products[index]);
                        },
                      ),
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
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) context.go(AppRouter.home);
          if (i == 1) context.go(AppRouter.products);
          if (i == 2) context.go(AppRouter.wishlist);
          if (i == 3) context.go(AppRouter.account);
        },
      ),
    );
  }
}
