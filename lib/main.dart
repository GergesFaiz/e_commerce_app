import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/cache_helper.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/wishlist/presentation/cubit/wishlist_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await setupServiceLocator();
  runApp(const RouteEcommerceApp());
}

class RouteEcommerceApp extends StatelessWidget {
  const RouteEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => _providers(
        MaterialApp.router(
          title: 'Route E-Commerce',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}

/// Cart and wishlist live for the whole app so every screen sees one state.
Widget _providers(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CartCubit>.value(value: sl<CartCubit>()),
      BlocProvider<WishlistCubit>.value(value: sl<WishlistCubit>()),
    ],
    child: child,
  );
}

// Exposed for widget tests without requiring ScreenUtil binding.
@visibleForTesting
Widget buildAppRouter() {
  return _providers(
    MaterialApp.router(
      title: 'Route E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    ),
  );
}
