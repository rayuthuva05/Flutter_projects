// GENERATED CODE - manually checked in for the starter scaffold.

part of 'store_api_client.dart';

class _StoreApiClient implements StoreApiClient {
  _StoreApiClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<HttpResponse<Map<String, dynamic>>> register(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/register',
      data: body,
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> login(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/login',
      data: body,
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<dynamic>> logout() async {
    final response = await _dio.post<dynamic>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/logout',
    );
    return HttpResponse(response.data, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getCurrentUser() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/user',
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getHome() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/store/home',
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getCategories() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/categories',
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getBrands() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/store/brands',
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getAddressSuggestions({
    String? input,
    String? country,
    double? latitude,
    double? longitude,
    int? radius,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/autocomplete',
      queryParameters: <String, dynamic>{
        'input': input,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      }..removeWhere((key, value) => value == null),
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getPlaceDetails({
    String? placeId,
    String? country,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/place_details',
      queryParameters: <String, dynamic>{
        'place_id': placeId,
        'country': country,
      }..removeWhere((key, value) => value == null),
    );
    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getProducts({
    String? search,
    int? categoryId,
    int? brandId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int? perPage,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/products',
      queryParameters: <String, dynamic>{
        'search': search,
        'category_id': categoryId,
        'brand_id': brandId,
        'min_price': minPrice,
        'max_price': maxPrice,
        'sort': sort,
        'per_page': perPage,
      }..removeWhere((key, value) => value == null),
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getProduct(String slug) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/products/$slug',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getCart() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/store/cart',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> addCartItem(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/cart/items',
      data: body,
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> updateCartItem(
    String cartId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/cart/items/$cartId',
      data: body,
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> removeCartItem(
    String cartId,
  ) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/cart/items/$cartId',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getCheckoutSummary() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/checkout/summary',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> createPaymentIntent() async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/checkout/payment-intent',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getAddresses() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/addresses',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> createAddress(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/addresses',
      data: body,
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> updateAddress(
    int addressId,
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/addresses/$addressId',
      data: body,
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> deleteAddress(
    int addressId,
  ) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/addresses/$addressId',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getOrders() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/store/orders',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> getOrder(String orderId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) +
          '/api/v1/store/orders/$orderId',
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  @override
  Future<HttpResponse<Map<String, dynamic>>> placeOrder(
    Map<String, dynamic> body,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _combineBaseUrls(_dio.options.baseUrl, baseUrl) + '/api/v1/store/orders',
      data: body,
    );

    return HttpResponse(response.data ?? <String, dynamic>{}, response);
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    return normalizedBaseUrl;
  }
}
