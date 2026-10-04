import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../../core/widgets/custom_loading.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../../core/widgets/store_actions.dart';
import '../../../cart/presentation/widgets/cart_icon_button.dart';
import '../../../reviews/presentation/cubit/reviews_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_state.dart';
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
  int _color = 0;
  bool _expanded = false;
  bool _adding = false;
  final _pageCtrl = PageController();

  // Size/colour pickers from the design (the API has no product variants).
  static const _sizes = [38, 39, 40, 41, 42];
  static const _colors = [
    Color(0xFF2F2929),
    Color(0xFFBC3018),
    Color(0xFF0066FF),
    Color(0xFF02B935),
    Color(0xFFFF6B6B),
  ];

  static const _title = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink);

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _addToCart(ProductEntity p) async {
    setState(() => _adding = true);
    await addToCart(context, p.id, quantity: _qty);
    if (mounted) setState(() => _adding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go(AppRouter.home),
        ),
        title: const Text('Product Details'),
        actions: [
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search, color: AppColors.primary, size: 28),
            onPressed: () => context.push(AppRouter.productList()),
          ),
          const CartIconButton(),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (ctx, state) {
          if (state is ProductsFailure) {
            return CustomErrorWidget(
                message: state.message,
                onRetry: () => ctx
                    .read<ProductsCubit>()
                    .getProductDetails(widget.id));
          }
          if (state is! ProductDetailsLoaded) return const CustomLoading();
          final p = state.product;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    _gallery(p),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(p.title, style: _title)),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(egp(p.finalPrice), style: _title),
                            if (p.hasDiscount)
                              Text(egp(p.price),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.oldPrice,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColors.oldPrice)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Text('${groupThousands(p.sold)} Sold',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 22, color: AppColors.star),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  '${p.ratingsAverage} (${groupThousands(p.ratingsQuantity)})',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        QtyStepper(
                          qty: _qty,
                          onMinus: _qty > 1
                              ? () => setState(() => _qty--)
                              : null,
                          onPlus: p.quantity == 0 || _qty < p.quantity
                              ? () => setState(() => _qty++)
                              : null,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('Description', style: _title),
                    const SizedBox(height: 8),
                    _description(p),
                    const SizedBox(height: 24),
                    const Text('Size', style: _title),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: _sizes
                          .map((s) => ChoiceChip(
                                label: Text('$s'),
                                selected: _size == s,
                                showCheckmark: false,
                                shape: const StadiumBorder(),
                                side: BorderSide.none,
                                backgroundColor: Colors.white,
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _size == s
                                        ? Colors.white
                                        : AppColors.ink),
                                onSelected: (_) => setState(() => _size = s),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text('Color', style: _title),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(
                        _colors.length,
                        (i) => Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: InkResponse(
                            onTap: () => setState(() => _color = i),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: _colors[i],
                              child: _color == i
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 20)
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _ReviewsSection(productId: p.id),
                  ],
                ),
              ),
              _bottomBar(p),
            ],
          );
        },
      ),
    );
  }

  Widget _gallery(ProductEntity p) {
    final images = p.images.isEmpty ? [p.imageCover] : p.images;
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageCtrl,
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (_, i) =>
                  RouteImage(images[i], width: double.infinity, height: 300),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: BlocSelector<WishlistCubit, WishlistState, bool>(
                selector: (s) => s.ids.contains(p.id),
                builder: (context, wished) => HeartButton(
                  filled: wished,
                  onTap: () => toggleWishlist(context, p.id),
                ),
              ),
            ),
            if (images.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: DotsIndicator(
                  count: images.length,
                  index: _page,
                  inactiveColor: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(ProductEntity p) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total price',
                    style: TextStyle(fontSize: 18, color: AppColors.inkMuted)),
                Text(egp(p.finalPrice * _qty),
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink)),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _adding ? null : () => _addToCart(p),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    textStyle: AppTheme.font(20, FontWeight.w500),
                  ),
                  icon: _adding
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to cart'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _description(ProductEntity p) {
    const max = 140;
    const style =
        TextStyle(fontSize: 14, color: AppColors.inkMuted, height: 1.5);
    final text = p.description.trim();
    if (text.length <= max) return Text(text, style: style);
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Text.rich(
        TextSpan(
          style: style,
          children: [
            TextSpan(text: _expanded ? '$text ' : '${text.substring(0, max)}... '),
            TextSpan(
              text: _expanded ? 'Show Less' : 'Read More',
              style: const TextStyle(
                  color: AppColors.ink, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
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
  int _rating = 5;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) {
      showToast('Please write a review first', error: true);
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<ReviewsCubit>().addReview(
        productId: widget.productId, text: text, rating: _rating.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewsLoaded && state.notice != null) {
          showToast(state.notice!);
          _ctrl.clear();
        }
        if (state is ReviewsFailure) showToast(state.message, error: true);
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ratings & Reviews',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink)),
            const SizedBox(height: 8),
            if (state is ReviewsLoading)
              const Padding(
                  padding: EdgeInsets.all(16), child: CustomLoading())
            else if (state is ReviewsLoaded && state.reviews.isEmpty)
              const Text('No reviews yet. Be the first to review!',
                  style: TextStyle(color: AppColors.inkMuted))
            else if (state is ReviewsLoaded)
              ...state.reviews.take(5).map((r) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                  r.userName.isEmpty ? 'User' : r.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.ink)),
                            ),
                            ...List.generate(
                              5,
                              (i) => Icon(
                                i < r.rating.round()
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 16,
                                color: AppColors.star,
                              ),
                            ),
                          ],
                        ),
                        if (r.text.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(r.text,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.inkMuted)),
                        ],
                      ],
                    ),
                  )),
            const SizedBox(height: 12),
            Row(
              children: List.generate(
                5,
                (i) => IconButton(
                  tooltip: '${i + 1} stars',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => setState(() => _rating = i + 1),
                  icon: Icon(
                    i < _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.star,
                    size: 28,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    decoration: const InputDecoration(
                        hintText: 'Write a review...'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Send review',
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary),
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: state is ReviewsLoading ? null : _submit,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
