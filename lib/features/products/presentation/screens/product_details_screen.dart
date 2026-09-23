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
import '../../../reviews/presentation/cubit/reviews_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String id;
  const ProductDetailsScreen({super.key, required this.id});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _qty = 1;
  int _page = 0;
  int _size = 40;
  int _color = 1;
  bool _expanded = false;
  final _pageCtrl = PageController();

  static const _sizes = [38, 39, 40, 41, 42];
  static const _colors = [
    Color(0xFF2F2929),
    Color(0xFFBC3018),
    Color(0xFF0066FF),
    Color(0xFF02B935),
    Color(0xFFFF6B6B),
  ];

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.primary),
            onPressed: () => context.push(AppRouter.products),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: AppColors.primary),
            onPressed: () => context.push(AppRouter.cart),
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (ctx, state) {
          if (state is ProductsLoading) return const CustomLoading();
          if (state is ProductsFailure) {
            return CustomErrorWidget(
                message: state.message,
                onRetry: () => ctx
                    .read<ProductsCubit>()
                    .getProductDetails(widget.id));
          }
          if (state is! ProductDetailsLoaded) return const SizedBox();
          final p = state.product;
          final images =
              p.images.isEmpty ? [p.imageCover] : p.images;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: AppColors.fieldBorder),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: SizedBox(
                                height: 300,
                                child: PageView.builder(
                                  controller: _pageCtrl,
                                  itemCount: images.length,
                                  onPageChanged: (i) =>
                                      setState(() => _page = i),
                                  itemBuilder: (_, i) =>
                                      CachedNetworkImage(
                                    imageUrl: images[i],
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) =>
                                        const Icon(Icons.image,
                                            size: 80,
                                            color: AppColors.hint),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: HeartButton(
                                filled: false,
                                onTap: () async {
                                  await sl<WishlistCubit>()
                                      .toggleWishlist(p.id);
                                  Fluttertoast.showToast(
                                      msg: 'Added to wishlist');
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 3),
                            width: i == _page ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: i == _page
                                  ? AppColors.primary
                                  : AppColors.fieldBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Text(p.title,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.ink)),
                          ),
                          Text(
                            'EGP ${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.fieldBorder),
                            ),
                            child: Text('${p.sold} Sold',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.ink)),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star,
                              size: 18, color: AppColors.star),
                          Text(
                            ' ${p.ratingsAverage} (${p.ratingsQuantity})',
                            style: const TextStyle(
                                fontSize: 13, color: AppColors.ink),
                          ),
                          const Spacer(),
                          QtyStepper(
                            qty: _qty,
                            onMinus: () => setState(
                                () => _qty = _qty > 1 ? _qty - 1 : 1),
                            onPlus: () =>
                                setState(() => _qty++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Description',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink)),
                      const SizedBox(height: 4),
                      _description(p),
                      const SizedBox(height: 12),
                      const Text('Size',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink)),
                      const SizedBox(height: 8),
                      Row(
                        children: _sizes
                            .map((s) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _size = s),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    margin: const EdgeInsets.only(
                                        right: 12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _size == s
                                          ? AppColors.primary
                                          : Colors.transparent,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('$s',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: _size == s
                                                ? Colors.white
                                                : AppColors.ink)),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 12),
                      const Text('Color',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink)),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          _colors.length,
                          (i) => GestureDetector(
                            onTap: () =>
                                setState(() => _color = i),
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _colors[i],
                              ),
                              child: _color == i
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 22)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ReviewsSection(productId: p.id),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: AppColors.fieldBorder)),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total price',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.hint)),
                        Text(
                          'EGP ${(p.price * _qty).toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await sl<CartCubit>()
                                .addToCart(p.id);
                            Fluttertoast.showToast(
                                msg: 'Added to cart');
                          },
                          icon: const Icon(
                              Icons.shopping_cart_outlined),
                          label: const Text('Add to cart'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _description(ProductEntity p) {    const max = 120;
    final text = p.description;
    if (text.length <= max) {
      return Text(text,
          style:
              const TextStyle(fontSize: 14, color: AppColors.ink));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_expanded ? text : '${text.substring(0, max)}...',
            style:
                const TextStyle(fontSize: 14, color: AppColors.ink)),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Show Less' : 'Read More',
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatefulWidget {
  final String productId;
  const _ReviewsSection({required this.productId});

  @override
  State<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<_ReviewsSection> {
  final _ctrl = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewsLoaded && state.notice != null) {
          Fluttertoast.showToast(msg: state.notice!);
          _ctrl.clear();
        }
        if (state is ReviewsFailure) {
          Fluttertoast.showToast(msg: state.message);
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('"'"'Ratings & Reviews'"'"',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink)),
            const SizedBox(height: 8),
            if (state is ReviewsLoading)
              const Center(child: CircularProgressIndicator())
            else if (state is ReviewsLoaded && state.reviews.isEmpty)
              const Text('"'"'No reviews yet. Be the first to review!'"'"',
                  style: TextStyle(color: AppColors.hint))
            else if (state is ReviewsLoaded)
              ...state.reviews.take(5).map((r) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(r.userName.isEmpty ? '"'"'User'"'"' : r.userName,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(r.text),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(r.rating.toStringAsFixed(0)),
                          const Icon(Icons.star,
                              size: 16, color: AppColors.star),
                        ],
                      ),
                    ),
                  )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                        hintText: '"'"'Write a review...'"'"'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<double>(
                  value: _rating,
                  items: [5, 4, 3, 2, 1]
                      .map((v) => DropdownMenuItem(
                          value: v.toDouble(), child: Text('"'"'$v'"'"')))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => _rating = v ?? 5),
                ),
                IconButton(
                  icon: const Icon(Icons.send,
                      color: AppColors.primary),
                  onPressed: () => context
                      .read<ReviewsCubit>()
                      .addReview(
                          productId: widget.productId,
                          text: _ctrl.text,
                          rating: _rating),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
