import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../wishlist/presentation/cubit/wishlist_cubit.dart';
import '../cubit/home_cubit.dart';

/// Hosts the Home / Categories / Wishlist / Account tabs and the blue
/// bottom bar. Categories are loaded once and shared by Home and Categories.
class MainShell extends StatefulWidget {
  final StatefulNavigationShell shell;
  const MainShell({super.key, required this.shell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const _wishlistTab = 2;

  late final HomeCubit _home = sl<HomeCubit>()..getHomeData();

  @override
  void initState() {
    super.initState();
    // Badge count and heart states for the signed-in user.
    context.read<CartCubit>().getCart(silent: true);
    context.read<WishlistCubit>().getWishlist(silent: true);
  }

  @override
  void dispose() {
    _home.close();
    super.dispose();
  }

  void _onTap(int index) {
    if (index == _wishlistTab) {
      context.read<WishlistCubit>().getWishlist(silent: true);
    }
    widget.shell.goBranch(index, initialLocation: index == widget.shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _home,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: widget.shell,
        bottomNavigationBar: RouteBottomNav(
          currentIndex: widget.shell.currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}
