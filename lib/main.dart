import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/cache_helper.dart';

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
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Route E-Commerce',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

// Exposed for widget tests without requiring ScreenUtil binding.
@visibleForTesting
Widget buildAppRouter() {
  return MaterialApp.router(
    title: 'Route E-Commerce',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.lightTheme,
    routerConfig: AppRouter.router,
  );
}
