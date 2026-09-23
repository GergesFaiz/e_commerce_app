import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import '../network/api_service.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';

// Auth
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repos/auth_repo_impl.dart';
import '../../features/auth/domain/repos/i_auth_repo.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/domain/usecases/profile_usecases.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

// Home
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/domain/repos/i_home_repo.dart';
import '../../features/home/domain/usecases/get_categories_usecase.dart';
import '../../features/home/domain/usecases/get_brands_usecase.dart';
import '../../features/home/domain/usecases/get_subcategories_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

// Products
import '../../features/products/data/datasources/products_remote_datasource.dart';
import '../../features/products/data/repos/products_repo_impl.dart';
import '../../features/products/domain/repos/i_products_repo.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/get_product_details_usecase.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';

// Cart
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repos/cart_repo_impl.dart';
import '../../features/cart/domain/repos/i_cart_repo.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';

// Wishlist
import '../../features/wishlist/data/datasources/wishlist_remote_datasource.dart';
import '../../features/wishlist/data/repos/wishlist_repo_impl.dart';
import '../../features/wishlist/domain/repos/i_wishlist_repo.dart';
import '../../features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import '../../features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import '../../features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

// Orders
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repos/orders_repo_impl.dart';
import '../../features/orders/domain/repos/i_orders_repo.dart';
import '../../features/orders/domain/usecases/checkout_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ── Core ──
  final dio = DioFactory.getDio();
  sl.registerLazySingleton<ApiService>(() => ApiService(dio));
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  // ── Auth ──
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<IAuthRepo>(
    () => AuthRepoImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => VerifyTokenUseCase(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));

  // ── Home ──
  sl.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<IHomeRepo>(() => HomeRepoImpl(sl(), sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetSubCategoriesUseCase(sl()));
  sl.registerFactory(() => HomeCubit(sl(), sl(), sl()));

  // ── Products ──
  sl.registerLazySingleton<ProductsRemoteDatasource>(
    () => ProductsRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<IProductsRepo>(
    () => ProductsRepoImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerFactory(() => ProductsCubit(sl(), sl()));

  // ── Cart ──
  sl.registerLazySingleton<CartRemoteDatasource>(
    () => CartRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<ICartRepo>(() => CartRepoImpl(sl(), sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartQuantityUseCase(sl()));
  sl.registerFactory(() => CartCubit(sl(), sl(), sl(), sl()));

  // ── Wishlist ──
  sl.registerLazySingleton<WishlistRemoteDatasource>(
    () => WishlistRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<IWishlistRepo>(
    () => WishlistRepoImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => AddToWishlistUseCase(sl()));
  sl.registerLazySingleton(() => GetWishlistUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUseCase(sl()));
  sl.registerFactory(() => WishlistCubit(sl(), sl(), sl()));

  // ── Orders ──
  sl.registerLazySingleton<OrdersRemoteDatasource>(
    () => OrdersRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<IOrdersRepo>(
    () => OrdersRepoImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => CheckoutUseCase(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerFactory(() => OrdersCubit(sl(), sl()));
}
