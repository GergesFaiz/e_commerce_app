import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/products/data/models/products_response_model.dart';
import '../../features/cart/data/models/cart_response_model.dart';
import '../../features/wishlist/data/models/wishlist_response_model.dart';
import '../../features/orders/data/models/order_response_model.dart';
import '../../features/home/data/models/categories_response_model.dart';
import '../../features/home/data/models/brands_response_model.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // ── Auth ──────────────────────────────────────────────────────────────────
  @POST('auth/signup')
  Future<UserModel> register(@Body() Map<String, dynamic> body);

  @POST('auth/signin')
  Future<UserModel> login(@Body() Map<String, dynamic> body);

// بعد
  @POST('auth/forgotPasswords')
  Future<HttpResponse<dynamic>> forgotPassword(@Body() Map<String, dynamic> body);
  @PUT('auth/updateMyPassword')
  Future<UserModel> updatePassword(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  // ── Products ──────────────────────────────────────────────────────────────
  @GET('products')
  Future<ProductsResponseModel> getProducts();

  @GET('products/{id}')
  Future<ProductDetailsResponseModel> getProductById(@Path('id') String id);

  // ── Categories ────────────────────────────────────────────────────────────
  @GET('categories')
  Future<CategoriesResponseModel> getCategories();

  @GET('categories/{id}/subcategories')
  Future<CategoriesResponseModel> getSubCategories(@Path('id') String id);

  // ── Brands ────────────────────────────────────────────────────────────────
  @GET('brands')
  Future<BrandsResponseModel> getBrands();

  // ── Cart ──────────────────────────────────────────────────────────────────
  @POST('cart')
  Future<CartResponseModel> addToCart(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  @GET('cart')
  Future<CartResponseModel> getCart(@Header('token') String token);

  @DELETE('cart/{id}')
  Future<CartResponseModel> removeFromCart(
    @Path('id') String id,
    @Header('token') String token,
  );

  @PUT('cart/{id}')
  Future<CartResponseModel> updateCartQuantity(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  // ── Wishlist ──────────────────────────────────────────────────────────────
  @POST('wishlist')
  Future<WishlistResponseModel> addToWishlist(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  @GET('wishlist')
  Future<WishlistResponseModel> getWishlist(@Header('token') String token);

  @DELETE('wishlist/{id}')
  Future<WishlistResponseModel> removeFromWishlist(
    @Path('id') String id,
    @Header('token') String token,
  );

  // ── Orders ────────────────────────────────────────────────────────────────
  @POST('orders/{cartId}')
  Future<OrderResponseModel> checkout(
    @Path('cartId') String cartId,
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

// بعد
  @GET('orders/user/{userId}')
  Future<List<OrderResponseModel>> getUserOrders(
      @Path('userId') String userId,
      @Header('token') String token,
      );
}
