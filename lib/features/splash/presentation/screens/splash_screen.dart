import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../../core/widgets/route_widgets.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

/// Splash from the design: verifies the cached token, then routes on.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _route();
  }

  Future<void> _route() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final valid = await sl<AuthCubit>().isSessionValid();
    if (!mounted) return;
    if (valid) {
      context.go(AppRouter.home);
    } else {
      await CacheHelper.removeToken();
      await CacheHelper.removeUserId();
      if (mounted) context.go(AppRouter.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(child: RouteLogo(fontSize: 72, color: Colors.white)),
    );
  }
}
