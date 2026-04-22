import 'package:dio/dio.dart';

import 'package:flutter_store_app/src/core/config/app_config.dart';
import 'package:flutter_store_app/src/core/storage/session_storage.dart';
import 'package:flutter_store_app/src/core/network/store_api_client.dart';

class ApiClientFactory {
  ApiClientFactory(this._sessionStorage);

  final SessionStorage _sessionStorage;

  StoreApiClient createStoreApiClient() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.resolvedBaseUrl(),
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: const <String, dynamic>{
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _sessionStorage.readToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

    return StoreApiClient(dio);
  }
}
