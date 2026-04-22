import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'store_api_client.g.dart';

@RestApi()
abstract class StoreApiClient {
  factory StoreApiClient(Dio dio, {String baseUrl}) = _StoreApiClient;

  @POST('/api/v1/register')
  Future<HttpResponse<Map<String, dynamic>>> register(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/login')
  Future<HttpResponse<Map<String, dynamic>>> login(
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/logout')
  Future<HttpResponse<dynamic>> logout();

  @GET('/api/v1/user')
  Future<HttpResponse<Map<String, dynamic>>> getCurrentUser();

  @GET('/api/v1/store/home')
  Future<HttpResponse<Map<String, dynamic>>> getHome();

  @GET('/api/v1/store/categories')
  Future<HttpResponse<Map<String, dynamic>>> getCategories();

  @GET('/api/v1/store/brands')
  Future<HttpResponse<Map<String, dynamic>>> getBrands();

  @GET('/api/v1/autocomplete')
  Future<HttpResponse<Map<String, dynamic>>> getAddressSuggestions({
    @Query('input') String? input,
    @Query('country') String? country,
    @Query('latitude') double? latitude,
    @Query('longitude') double? longitude,
    @Query('radius') int? radius,
  });

  @GET('/api/v1/place_details')
  Future<HttpResponse<Map<String, dynamic>>> getPlaceDetails({
    @Query('place_id') String? placeId,
    @Query('country') String? country,
  });

  @GET('/api/v1/store/products')
  Future<HttpResponse<Map<String, dynamic>>> getProducts({
    @Query('search') String? search,
    @Query('category_id') int? categoryId,
    @Query('brand_id') int? brandId,
    @Query('min_price') double? minPrice,
    @Query('max_price') double? maxPrice,
    @Query('sort') String? sort,
    @Query('per_page') int? perPage,
  });

  @GET('/api/v1/store/products/{slug}')
  Future<HttpResponse<Map<String, dynamic>>> getProduct(
    @Path('slug') String slug,
  );

  @GET('/api/v1/store/cart')
  Future<HttpResponse<Map<String, dynamic>>> getCart();

  @POST('/api/v1/store/cart/items')
  Future<HttpResponse<Map<String, dynamic>>> addCartItem(
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/api/v1/store/cart/items/{id}')
  Future<HttpResponse<Map<String, dynamic>>> updateCartItem(
    @Path('id') String cartId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/v1/store/cart/items/{id}')
  Future<HttpResponse<Map<String, dynamic>>> removeCartItem(
    @Path('id') String cartId,
  );

  @GET('/api/v1/store/checkout/summary')
  Future<HttpResponse<Map<String, dynamic>>> getCheckoutSummary();

  @POST('/api/v1/store/checkout/payment-intent')
  Future<HttpResponse<Map<String, dynamic>>> createPaymentIntent();

  @GET('/api/v1/store/addresses')
  Future<HttpResponse<Map<String, dynamic>>> getAddresses();

  @POST('/api/v1/store/addresses')
  Future<HttpResponse<Map<String, dynamic>>> createAddress(
    @Body() Map<String, dynamic> body,
  );

  @PUT('/api/v1/store/addresses/{id}')
  Future<HttpResponse<Map<String, dynamic>>> updateAddress(
    @Path('id') int addressId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/api/v1/store/addresses/{id}')
  Future<HttpResponse<Map<String, dynamic>>> deleteAddress(
    @Path('id') int addressId,
  );

  @GET('/api/v1/store/orders')
  Future<HttpResponse<Map<String, dynamic>>> getOrders();

  @GET('/api/v1/store/orders/{id}')
  Future<HttpResponse<Map<String, dynamic>>> getOrder(
    @Path('id') String orderId,
  );

  @POST('/api/v1/store/orders')
  Future<HttpResponse<Map<String, dynamic>>> placeOrder(
    @Body() Map<String, dynamic> body,
  );
}
