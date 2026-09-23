import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

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

class RouteSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSubmittedTap;
  const RouteSearchBar(
      {super.key, this.onChanged, this.onSubmitted, this.onSubmittedTap});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: 'what do you search for?',
        prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 28),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      onTap: onSubmittedTap,
    );
  }
}

/// Dark-blue bottom bar with 4 tabs; active tab sits in a white circle.
class RouteBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const RouteBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.home_outlined, Icons.grid_view, Icons.favorite_border, Icons.person_outline];
    const filled = [Icons.home, Icons.grid_view_rounded, Icons.favorite, Icons.person];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(4, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? Colors.white : Colors.transparent,
                ),
                child: Icon(
                  active ? filled[i] : icons[i],
                  color: active ? AppColors.primary : Colors.white,
                  size: 30,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/// Blue pill stepper (− qty +) used on details/cart.
class QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const QtyStepper({super.key, required this.qty, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('$qty',
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          _btn(Icons.add, onPlus),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class HeartButton extends StatelessWidget {
  final bool filled;
  final VoidCallback onTap;
  const HeartButton({super.key, required this.filled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Icon(
          filled ? Icons.favorite : Icons.favorite_border,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}

/// Yellow promo banner from the home design.
class PromoBanner extends StatelessWidget {
  final VoidCallback? onShopNow;
  const PromoBanner({super.key, this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [AppColors.bannerStart, AppColors.bannerEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('UP TO',
                    style: TextStyle(color: AppColors.primary, fontSize: 16)),
                const Text('25% OFF',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.1)),
                const Text('For all Headphones\n& AirPods',
                    style: TextStyle(color: AppColors.primary, fontSize: 14)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onShopNow,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, 40),
                    textStyle: const TextStyle(fontSize: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
          const Icon(Icons.headphones, size: 110, color: AppColors.primary),
        ],
      ),
    );
  }
}

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
        width: 95,
        child: Column(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(width: 80, height: 80, color: const Color(0xFFF0F0F0)),
                errorWidget: (_, __, ___) => Container(
                    width: 80,
                    height: 80,
                    color: const Color(0xFFF0F0F0),
                    child: const Icon(Icons.category, color: AppColors.hint)),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
          ],
        ),
      ),
    );
  }
}
