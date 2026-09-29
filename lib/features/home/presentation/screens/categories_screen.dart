import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_header.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../domain/entities/category_entity.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Categories tab from the design: left rail + banner + subcategory grid.
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().ensureCategorySelected();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const RouteHeader(),
          Expanded(
            child: BlocConsumer<HomeCubit, HomeState>(
              listener: (ctx, _) => ctx.read<HomeCubit>().ensureCategorySelected(),
              builder: (ctx, state) {
                if (state is HomeFailure) {
                  return CustomErrorWidget(
                      message: state.message,
                      onRetry: () => ctx.read<HomeCubit>().getHomeData());
                }
                if (state is! HomeLoaded) return const CustomLoading();
                if (state.categories.isEmpty) {
                  return const EmptyState(
                      icon: Icons.grid_view_outlined, title: 'No categories found');
                }
                final selected = state.categories.firstWhere(
                  (c) => c.id == state.selectedCategoryId,
                  orElse: () => state.categories.first,
                );
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryRail(
                        categories: state.categories,
                        selectedId: selected.id,
                        onSelect: (c) => ctx.read<HomeCubit>().selectCategory(c.id),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: _CategoryContent(category: selected, state: state)),
                    ],
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

/// Tinted outlined rail; the active item is white with a blue side bar.
class _CategoryRail extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String selectedId;
  final ValueChanged<CategoryEntity> onSelect;
  const _CategoryRail({
    required this.categories,
    required this.selectedId,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 137,
      decoration: BoxDecoration(
        color: AppColors.tint,
        border: Border.all(color: AppColors.outline),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: categories.length,
          itemBuilder: (_, i) {
            final cat = categories[i];
            final active = cat.id == selectedId;
            return InkWell(
              onTap: () => onSelect(cat),
              child: Container(
                color: active ? Colors.white : Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 6,
                      height: 44,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          cat.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.ink,
                            fontWeight: active ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryContent extends StatelessWidget {
  final CategoryEntity category;
  final HomeLoaded state;
  const _CategoryContent({required this.category, required this.state});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Text(category.name,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink)),
        const SizedBox(height: 12),
        _banner(context),
        const SizedBox(height: 16),
        if (state.loadingSubs)
          const Padding(padding: EdgeInsets.all(24), child: CustomLoading())
        else if (state.subError != null)
          CustomErrorWidget(
              message: state.subError!,
              onRetry: () => context.read<HomeCubit>().selectCategory(category.id))
        else if (state.subcategories.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Text('No subcategories yet.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.inkMuted)),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: state.subcategories.length,
            itemBuilder: (_, i) => _SubcategoryTile(
              sub: state.subcategories[i],
              fallbackImage: category.image,
            ),
          ),
      ],
    );
  }

  Widget _banner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(
          AppRouter.productList(title: category.name, categoryId: category.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 110,
          child: Stack(
            fit: StackFit.expand,
            children: [
              RouteImage(category.image),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xE6FFFFFF), Color(0x00FFFFFF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.name,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('Shop Now',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
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

/// Subcategories have no image in the API, so the tile uses the parent's.
class _SubcategoryTile extends StatelessWidget {
  final CategoryEntity sub;
  final String fallbackImage;
  const _SubcategoryTile({required this.sub, required this.fallbackImage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.push(
          AppRouter.productList(title: sub.name, subcategoryId: sub.id)),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RouteImage(sub.image.isNotEmpty ? sub.image : fallbackImage,
                  width: double.infinity),
            ),
          ),
          const SizedBox(height: 6),
          Text(sub.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.ink, height: 1.2)),
        ],
      ),
    );
  }
}
