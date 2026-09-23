import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/service_locator.dart';
import '../utils/cache_helper.dart';
import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/screens/categories_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../../features/wishlist/presentation/screens/wishlist_screen.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';

class AppRouter {
  static const String splash    = '/splash';
  static const String login     = '/login';
  static const String register  = '/register';
  static const String home      = '/home';
  static const String categories = '/categories';
  static const String products  = '/products';
  static const String product   = '/product/:id';
  static const String cart      = '/cart';
  static const String wishlist  = '/wishlist';
  static const String orders    = '/orders';
  static const String account   = '/account';

  static final router = GoRouter(
    initialLocation: splash,
    redirect: (context, state) {
      final token = CacheHelper.getToken();
      final isLoggedIn = token != null && token.isNotEmpty;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == login || loc == register || loc == splash;

      // Not logged in -> force to login for protected routes.
      if (!isLoggedIn && !isAuthRoute) return login;
      // Logged in -> don't stay on login/register.
      if (isLoggedIn && (loc == login || loc == register)) return home;
      return null;
    },
    routes: [
      GoRoute(
        path: splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: register,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<AuthCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: home,
        builder: (_, __) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<HomeCubit>()..getHomeData()),
            BlocProvider(create: (_) => sl<ProductsCubit>()..getProducts()),
          ],
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: categories,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<HomeCubit>()..getHomeData(),
          child: const CategoriesScreen(),
        ),
      ),
      GoRoute(
        path: products,
        builder: (_, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          final q = state.uri.queryParameters['q'];
          return BlocProvider(
            create: (_) {
              final cubit = sl<ProductsCubit>();
              cubit.getProducts(categoryId: categoryId).then((_) {
                if (q != null && q.isNotEmpty) cubit.setSearchQuery(q);
              });
              return cubit;
            },
            child: ProductsScreen(initialQuery: q),
          );
        },
      ),
      GoRoute(
        path: product,
        builder: (_, state) => BlocProvider(
          create: (_) => sl<ProductsCubit>()
            ..getProductDetails(state.pathParameters['id']!),
          child: ProductDetailsScreen(id: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: cart,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<CartCubit>()..getCart(),
          child: const CartScreen(),
        ),
      ),
      GoRoute(
        path: wishlist,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<WishlistCubit>()..getWishlist(),
          child: const WishlistScreen(),
        ),
      ),
      GoRoute(
        path: orders,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<OrdersCubit>()..getOrders(),
          child: const OrdersScreen(),
        ),
      ),
      GoRoute(
        path: account,
        builder: (_, __) => const AccountScreen(),
      ),
    ],
  );
}
