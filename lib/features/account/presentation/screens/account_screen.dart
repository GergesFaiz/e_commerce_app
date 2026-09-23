import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/widgets/route_widgets.dart';

/// Profile screen from the design (display fields + logout).
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await CacheHelper.removeToken();
    await CacheHelper.removeUserId();
    if (context.mounted) context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink)),
              const SizedBox(height: 24),
              _field('Your full name', 'Mohamed Mohamed Nabil'),
              _field('Your E-mail', 'mohamed.N@gmail.com'),
              _field('Your password', '••••••••••••••', obscure: true),
              _field('Your mobile number', '01122118855'),
              _field('Your Address', '6th October, street 11....'),              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => _logout(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Logout',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: RouteBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 0) context.go(AppRouter.home);
          if (i == 1) context.go(AppRouter.products);
          if (i == 2) context.go(AppRouter.wishlist);
        },
      ),
    );
  }

  Widget _field(String label, String hint, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink)),
          const SizedBox(height: 8),
          TextField(
            readOnly: true,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon:
                  const Icon(Icons.edit_outlined, color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }
}
