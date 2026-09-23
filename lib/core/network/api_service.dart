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

  @POST('auth/verifyResetCode')
  Future<HttpResponse<dynamic>> verifyResetCode(@Body() Map<String, dynamic> body);

  @PUT('auth/resetPassword')
  Future<HttpResponse<dynamic>> resetPassword(@Body() Map<String, dynamic> body);

  @GET('auth/verifyToken')
  Future<HttpResponse<dynamic>> verifyToken(@Header('token') String token);

  @PUT('users/changeMyPassword')
  Future<HttpResponse<dynamic>> updatePassword(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  @PUT('users/updateMe/')
  Future<HttpResponse<dynamic>> updateMe(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  // ── Products (server search/sort/filter/pagination per docs) ──────────────
  @GET('products')
  Future<ProductsResponseModel> getProducts({
    @Query('keyword') String? keyword,
    @Query('sort') String? sort,
    @Query('page') int? page,
    @Query('limit') int? limit,
    @Query('category[in]') String? categoryId,
    @Query('brand') String? brandId,
    @Query('price[gte]') num? minPrice,
    @Query('price[lte]') num? maxPrice,
  });

  @GET('products/{id}')
  Future<ProductDetailsResponseModel> getProductById(@Path('id') String id);

  @GET('products/{id}/reviews')
  Future<HttpResponse<dynamic>> getReviews(@Path('id') String id);

  @POST('products/{id}/reviews')
  Future<HttpResponse<dynamic>> addReview(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

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

  @DELETE('cart')
  Future<CartResponseModel> clearCart(@Header('token') String token);

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

  // ── Addresses ─────────────────────────────────────────────────────────────
  @GET('addresses')
  Future<HttpResponse<dynamic>> getAddresses(@Header('token') String token);

  @POST('addresses')
  Future<HttpResponse<dynamic>> addAddress(
    @Body() Map<String, dynamic> body,
    @Header('token') String token,
  );

  @DELETE('addresses/{id}')
  Future<HttpResponse<dynamic>> deleteAddress(
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
