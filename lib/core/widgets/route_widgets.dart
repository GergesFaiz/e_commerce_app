import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Shared Route-store widgets matching the Figma design.

class RouteLogo extends StatelessWidget {
  final double fontSize;
  final Color color;
  const RouteLogo({super.key, this.fontSize = 28, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Route',
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

/// Rounded search field with the blue outline ("what do you search for?").
class RouteSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autofocus;
  const RouteSearchField({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: const BorderSide(color: AppColors.primary),
    );
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 14, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: 'what do you search for?',
          hintStyle: const TextStyle(
              fontSize: 14, color: AppColors.inkMuted, fontWeight: FontWeight.w300),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 26),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          filled: true,
          fillColor: Colors.white,
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }
}

/// Dark-blue bottom bar with 4 tabs; the active tab sits in a white circle.
class RouteBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const RouteBottomNav({super.key, required this.currentIndex, required this.onTap});

  static const _icons = [
    Icons.home_outlined,
    Icons.grid_view_outlined,
    Icons.favorite_border,
    Icons.person_outline,
  ];
  static const _activeIcons = [
    Icons.home,
    Icons.grid_view_rounded,
    Icons.favorite,
    Icons.person,
  ];
  static const _labels = ['Home', 'Categories', 'Wishlist', 'Account'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (i) {
              final active = i == currentIndex;
              return Semantics(
                button: true,
                selected: active,
                label: _labels[i],
                child: InkResponse(
                  onTap: () => onTap(i),
                  radius: 28,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active ? Colors.white : Colors.transparent,
                    ),
                    child: Icon(
                      active ? _activeIcons[i] : _icons[i],
                      color: active ? AppColors.primary : Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Blue pill stepper (− qty +) used on details/cart.
class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final bool compact;
  const QtyStepper({
    super.key,
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 24.0 : 28.0;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: compact ? 6 : 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onMinus, size, 'Decrease quantity'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: compact ? 12 : 18),
            child: Text('$qty',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 16 : 18,
                    fontWeight: FontWeight.w500)),
          ),
          _btn(Icons.add, onPlus, size, 'Increase quantity'),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback? onTap, double size, String label) {
    return Semantics(
      button: true,
      label: label,
      child: InkResponse(
        onTap: onTap,
        radius: size,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Icon(icon, color: Colors.white, size: size * 0.65),
        ),
      ),
    );
  }
}

/// White circular heart used on product images and wishlist rows.
class HeartButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;
  final double size;
  const HeartButton({super.key, required this.filled, required this.onTap, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: filled ? 'Remove from wishlist' : 'Add to wishlist',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [BoxShadow(color: Color(0x26000000), blurRadius: 6, offset: Offset(0, 2))],
          ),
          child: Icon(
            filled ? Icons.favorite : Icons.favorite_border,
            color: AppColors.primary,
            size: size * 0.6,
          ),
        ),
      ),
    );
  }
}

/// Section title with an optional "view all" link (Home design).
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  const SectionHeader({super.key, required this.title, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(foregroundColor: AppColors.ink),
              child: const Text('view all', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

class _Promo {
  final String kicker, headline, body;
  final IconData icon;
  final List<Color> colors;
  const _Promo(this.kicker, this.headline, this.body, this.icon, this.colors);
}

/// Auto-playing announcement slider with dot indicator (Home design).
class BannerSlider extends StatefulWidget {
  final VoidCallback? onShopNow;
  const BannerSlider({super.key, this.onShopNow});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  static const _promos = [
    _Promo('UP TO', '25% OFF', 'For all Headphones\n& AirPods', Icons.headphones,
        [Color(0xFFFFE27A), Color(0xFFFDD835)]),
    _Promo('UP TO', '30% OFF', 'For all Laptops\n& Electronics', Icons.laptop_mac,
        [Color(0xFFCFE3F7), Color(0xFF9CC3EA)]),
    _Promo('UP TO', '50% OFF', "For all Women's\nFashion", Icons.checkroom,
        [Color(0xFFF9D6DC), Color(0xFFF2AEBB)]),
  ];

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      final next = (_page + 1) % _promos.length;
      _controller.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _controller,
            itemCount: _promos.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _banner(_promos[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        DotsIndicator(count: _promos.length, index: _page),
      ],
    );
  }

  Widget _banner(_Promo p) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: p.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(p.kicker,
                    style: const TextStyle(color: AppColors.ink, fontSize: 14)),
                Text(p.headline,
                    style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        height: 1.15)),
                Text(p.body,
                    style: const TextStyle(color: AppColors.ink, fontSize: 14)),
                const SizedBox(height: 10),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: widget.onShopNow,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(110, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      textStyle: AppTheme.font(14, FontWeight.w500),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ),
              ],
            ),
          ),
          Icon(p.icon, size: 110, color: AppColors.primary),
        ],
      ),
    );
  }
}

/// Page dots: active dot is a blue pill, others are faint circles.
class DotsIndicator extends StatelessWidget {
  final int count;
  final int index;
  final Color inactiveColor;
  const DotsIndicator({
    super.key,
    required this.count,
    required this.index,
    this.inactiveColor = AppColors.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active ? AppColors.primary : inactiveColor,
          ),
        );
      }),
    );
  }
}

/// Network image with the app's placeholder and error fallback.
class RouteImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width, height;
  const RouteImage(this.url, {super.key, this.fit = BoxFit.cover, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    Widget fallback() => Container(
          width: width,
          height: height,
          color: AppColors.placeholder,
          alignment: Alignment.center,
          child: const Icon(Icons.image_outlined, color: AppColors.outline),
        );
    if (url.isEmpty) return fallback();
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => Container(width: width, height: height, color: AppColors.placeholder),
      errorWidget: (_, __, ___) => fallback(),
    );
  }
}

/// Circular category image with its name below (Home design).
class CategoryCircle extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;
  const CategoryCircle(
      {super.key, required this.imageUrl, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            ClipOval(child: RouteImage(imageUrl, width: 100, height: 100)),
            const SizedBox(height: 8),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.ink, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}

/// Friendly empty/error placeholder used by lists.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(color: AppColors.tint, shape: BoxShape.circle),
              child: Icon(icon, size: 44, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.ink)),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: AppColors.inkMuted)),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(minimumSize: const Size(180, 48)),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
