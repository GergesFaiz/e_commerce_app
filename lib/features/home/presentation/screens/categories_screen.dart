import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Categories tab from the design: left rail + banner + subcategory grid.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

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
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (ctx, state) {
                  if (state is HomeLoading || state is HomeInitial) {
                    return const CustomLoading();
                  }
                  if (state is HomeFailure) {
                    return CustomErrorWidget(
                        message: state.message,
                        onRetry: () =>
                            ctx.read<HomeCubit>().getHomeData());
                  }
                  final loaded = state as HomeLoaded;
                  if (loaded.categories.isEmpty) {
                    return const Center(
                        child: Text('No categories found.'));
                  }
                  if (loaded.selectedCategoryId == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ctx
                          .read<HomeCubit>()
                          .selectCategory(loaded.categories.first.id);
                    });
                  }
                  final selected = loaded.categories.firstWhere(
                    (c) =>
                        c.id ==
                        (loaded.selectedCategoryId ??
                            loaded.categories.first.id),
                    orElse: () => loaded.categories.first,
                  );
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 130,
                        color: const Color(0xFFF8F9FA),
                        child: ListView.builder(
                          itemCount: loaded.categories.length,
                          itemBuilder: (_, i) {
                            final cat = loaded.categories[i];
                            final isSel = cat.id == selected.id;
                            return GestureDetector(
                              onTap: () => ctx
                                  .read<HomeCubit>()
                                  .selectCategory(cat.id),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isSel
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border(
                                    left: BorderSide(
                                        color: isSel
                                            ? AppColors.primary
                                            : Colors.transparent,
                                        width: 4),
                                  ),
                                ),
                                child: Text(
                                  cat.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSel
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(selected.name,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink)),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => context.go(
                                    '${AppRouter.products}?categoryId=${selected.id}'),
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(15),
                                    color: const Color(0xFFDBE4ED),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: CachedNetworkImage(
                                            imageUrl: selected.image,
                                            fit: BoxFit.cover,
                                            errorWidget: (_, __, ___) =>
                                                const SizedBox(),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(selected.name,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: AppColors
                                                        .primary)),
                                            const SizedBox(height: 8),
                                            Container(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 20,
                                                  vertical: 8),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                              ),
                                              child: const Text(
                                                  'Shop Now',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (loaded.loadingSubs)
                                const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: CustomLoading()))
                              else if (loaded.subError != null)
                                Center(
                                    child: Text(loaded.subError!,
                                        style: const TextStyle(
                                            color: AppColors.error)))
                              else if (loaded.subcategories.isEmpty)
                                const Center(
                                    child: Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Text(
                                            'No subcategories.')))
                              else
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 0.8,
                                  ),
                                  itemCount:
                                      loaded.subcategories.length,
                                  itemBuilder: (_, i) {
                                    final sub =
                                        loaded.subcategories[i];
                                    return GestureDetector(
                                      onTap: () => context.go(
                                          '${AppRouter.products}?q=${Uri.encodeComponent(sub.name)}'),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      12),
                                              child: CachedNetworkImage(
                                                imageUrl: sub.image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                placeholder: (_, __) =>
                                                    Container(
                                                        color: const Color(
                                                            0xFFF0F0F0)),
                                                errorWidget: (_, __,
                                                        ___) =>
                                                    Container(
                                                        color: const Color(
                                                            0xFFF0F0F0),
                                                        child: const Icon(
                                                            Icons
                                                                .category,
                                                            color: AppColors
                                                                .hint)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(sub.name,
                                              maxLines: 1,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.ink)),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
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
          if (i == 1) context.go(AppRouter.categories);
          if (i == 2) context.go(AppRouter.wishlist);
          if (i == 3) context.go(AppRouter.account);
        },
      ),
    );
  }
}
