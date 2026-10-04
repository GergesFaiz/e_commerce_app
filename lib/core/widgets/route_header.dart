import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/cart/presentation/widgets/cart_icon_button.dart';
import '../router/app_router.dart';
import '../theme/app_colors.dart';
import 'route_widgets.dart';

/// Top of the store tabs: Route logo, then search field + cart icon.
class RouteHeader extends StatelessWidget {
  final bool showBack;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  /// Defaults to opening the products list for the typed query.
  final ValueChanged<String>? onSubmitted;
  final bool showSearch;
  const RouteHeader({
    super.key,
    this.showBack = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (showBack)
                IconButton(
                  tooltip: 'Back',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                  onPressed: () =>
                      context.canPop() ? context.pop() : context.go(AppRouter.home),
                ),
              const RouteLogo(fontSize: 26),
            ],
          ),
          if (showSearch) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RouteSearchField(
                    controller: controller,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted ?? (q) => _search(context, q),
                  ),
                ),
                const SizedBox(width: 8),
                const CartIconButton(),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _search(BuildContext context, String q) {
    final query = q.trim();
    if (query.isEmpty) return;
    context.push(Uri(path: AppRouter.products, queryParameters: {'q': query}).toString());
  }
}
