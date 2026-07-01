import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Shop'),
        backgroundColor: const Color(0xFF3BB77E),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () => context.go(AppRouter.cart)),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () => context.go(AppRouter.wishlist)),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (ctx, state) {
          if (state is HomeLoading) return const CustomLoading();
          if (state is HomeFailure) return CustomErrorWidget(message: state.message, onRetry: () => ctx.read<HomeCubit>().getHomeData());
          if (state is HomeLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.categories.length,
                      itemBuilder: (_, i) {
                        final cat = state.categories[i];
                        return GestureDetector(
                          onTap: () => context.go('${AppRouter.products}?categoryId=${cat.id}'),
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                ClipRRect(borderRadius: BorderRadius.circular(8), child: CachedNetworkImage(imageUrl: cat.image, height: 60, width: 80, fit: BoxFit.cover)),
                                const SizedBox(height: 4),
                                Text(cat.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Brands', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.2),
                    itemCount: state.brands.length,
                    itemBuilder: (_, i) {
                      final brand = state.brands[i];
                      return Card(
                        child: Center(child: CachedNetworkImage(imageUrl: brand.image, height: 60, fit: BoxFit.contain)),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => context.go(AppRouter.products),
                      icon: const Icon(Icons.grid_view),
                      label: const Text('Browse All Products'),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3BB77E), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}