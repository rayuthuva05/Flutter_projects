import 'package:flutter_store_app/src/core/network/store_api_client.dart';
import 'package:flutter_store_app/src/core/storage/session_storage.dart';
import 'package:flutter_store_app/src/shared/models/store_models.dart';

class StoreRepository {
  StoreRepository(this._apiClient, this._sessionStorage);

  final StoreApiClient _apiClient;
  final SessionStorage _sessionStorage;

  Future<StoreHomeData> fetchHome() async {
    final response = await _apiClient.getHome();
    final payload =
        response.data['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return StoreHomeData.fromJson(payload);
  }

  Future<List<StoreCategory>> fetchCategories() async {
    final response = await _apiClient.getCategories();
    final payload = (response.data['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(StoreCategory.fromJson)
        .toList();

    return payload;
  }

  Future<List<StoreBrand>> fetchBrands() async {
    final response = await _apiClient.getBrands();
    final payload = (response.data['data'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(StoreBrand.fromJson)
        .toList();

    return payload;
  }

  Future<PaginatedProducts> fetchProducts({
    String? search,
    int? categoryId,
    int? brandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int perPage = 24,
  }) async {
    final response = await _apiClient.getProducts(
      search: search,
      categoryId: categoryId,
      brandId: brandId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      sort: sort,
      perPage: perPage,
    );

    return PaginatedProducts.fromJson(response.data);
  }

  Future<StoreProduct> fetchProduct(String slug) async {
    final response = await _apiClient.getProduct(slug);
    final payload =
        response.data['data'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return StoreProduct.fromJson(
      payload['product'] as Map<String, dynamic>? ?? const <String, dynamic>{},
    );
  }

  Future<CartSummary> fetchCart() async {
    final response = await _apiClient.getCart();
    return CartSummary.fromJson(response.data);
  }

  Future<CartSummary> addToCart({required int variantId, int qty = 1}) async {
    final response = await _apiClient.addCartItem(<String, dynamic>{
      'variant_id': variantId,
      'qty': qty,
    });

    return CartSummary.fromJson(
      response.data,
      message: response.data['message'] as String?,
    );
  }

  Future<UserSession> register({
    required String name,
    required String email,
    required String mobile,
    required String password,
    String deviceName = 'flutter_store_app',
  }) async {
    final response = await _apiClient.register(<String, dynamic>{
      'name': name,
      'email': email,
      'mobile': mobile,
      'password': password,
      'device_name': deviceName,
    });

    final session = UserSession.fromJson(response.data);
    await _sessionStorage.saveToken(session.token);
    return session;
  }

  Future<UserSession> login({
    required String email,
    required String password,
    String deviceName = 'flutter_store_app',
  }) async {
    final response = await _apiClient.login(<String, dynamic>{
      'email': email,
      'password': password,
      'device_name': deviceName,
    });

    final session = UserSession.fromJson(response.data);
    await _sessionStorage.saveToken(session.token);
    return session;
  }

  Future<void> logout() async {
    try {
      await _apiClient.logout();
    } catch (_) {
      // Always clear local session even if the remote request fails.
    }

    await _sessionStorage.clearToken();
  }

  Future<StoreUser> fetchCurrentUser() async {
    final response = await _apiClient.getCurrentUser();
    return StoreUser.fromJson(response.data);
  }

  Future<CheckoutSummary> fetchCheckoutSummary() async {
    final response = await _apiClient.getCheckoutSummary();
    return CheckoutSummary.fromJson(response.data);
  }

  Future<List<AddressSuggestion>> searchAddressSuggestions({
    required String input,
    String? country,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    final response = await _apiClient.getAddressSuggestions(
      input: input,
      country: country,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );

    return ((response.data['predictions'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(AddressSuggestion.fromJson)
        .toList();
  }

  Future<AddressPlaceDetails> fetchPlaceDetails({
    required String placeId,
    String? country,
  }) async {
    final response = await _apiClient.getPlaceDetails(
      placeId: placeId,
      country: country,
    );

    return AddressPlaceDetails.fromJson(
      placeId,
      response.data['result'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );
  }

  Future<StripePaymentIntentData> createPaymentIntent() async {
    final response = await _apiClient.createPaymentIntent();
    return StripePaymentIntentData.fromJson(response.data);
  }

  Future<List<StoreAddress>> fetchAddresses() async {
    final response = await _apiClient.getAddresses();
    return ((response.data['data'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(StoreAddress.fromJson)
        .toList();
  }

  Future<StoreAddress> createAddress({
    required String name,
    required String mobile,
    required String address,
    String? addressLine1,
    String? zip,
    double? latitude,
    double? longitude,
    String? note,
  }) async {
    final response = await _apiClient.createAddress(
      <String, dynamic>{
        'name': name,
        'mobile': mobile,
        'address': address,
        'address_line_1': addressLine1,
        'zip': zip,
        'latitude': latitude,
        'longitude': longitude,
        'note': note,
      }..removeWhere((key, value) => value == null || value == ''),
    );

    return StoreAddress.fromJson(
      response.data['data'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );
  }

  Future<StoreAddress> updateAddress({
    required int addressId,
    required String name,
    required String mobile,
    required String address,
    String? addressLine1,
    String? zip,
    double? latitude,
    double? longitude,
    String? note,
  }) async {
    final response = await _apiClient.updateAddress(
      addressId,
      <String, dynamic>{
        'name': name,
        'mobile': mobile,
        'address': address,
        'address_line_1': addressLine1,
        'zip': zip,
        'latitude': latitude,
        'longitude': longitude,
        'note': note,
      }..removeWhere((key, value) => value == null || value == ''),
    );

    return StoreAddress.fromJson(
      response.data['data'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );
  }

  Future<void> deleteAddress(int addressId) async {
    await _apiClient.deleteAddress(addressId);
  }

  Future<List<StoreOrder>> fetchOrders() async {
    final response = await _apiClient.getOrders();
    return ((response.data['data'] as List?) ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(StoreOrder.fromJson)
        .toList();
  }

  Future<StoreOrder> fetchOrder(String orderId) async {
    final response = await _apiClient.getOrder(orderId);
    return StoreOrder.fromJson(
      response.data['data'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );
  }

  Future<StoreOrder> placeOrder({
    required int addressId,
    required String paymentMethod,
    String? notes,
    String? paymentIntentId,
  }) async {
    final response = await _apiClient.placeOrder(
      <String, dynamic>{
        'address_id': addressId,
        'payment_method': paymentMethod,
        'notes': notes,
        'payment_intent_id': paymentIntentId,
      }..removeWhere((key, value) => value == null || value == ''),
    );

    return StoreOrder.fromJson(
      response.data['data'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );
  }

  Future<CartSummary> updateCartItem({
    required String cartId,
    required int qty,
  }) async {
    final response = await _apiClient.updateCartItem(cartId, <String, dynamic>{
      'qty': qty,
    });

    return CartSummary.fromJson(
      response.data,
      message: response.data['message'] as String?,
    );
  }

  Future<CartSummary> removeCartItem(String cartId) async {
    final response = await _apiClient.removeCartItem(cartId);
    return CartSummary.fromJson(
      response.data,
      message: response.data['message'] as String?,
    );
  }

  Future<String?> readToken() => _sessionStorage.readToken();

  Future<void> saveToken(String token) => _sessionStorage.saveToken(token);

  Future<void> clearToken() => _sessionStorage.clearToken();
}
