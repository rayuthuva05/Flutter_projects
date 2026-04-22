import 'package:flutter/foundation.dart';

class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  static String resolvedBaseUrl() {
    if (apiBaseUrl.isNotEmpty) {
      return apiBaseUrl;
    }

    if (kIsWeb) {
      return 'http://192.168.1.27:8000';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://192.168.0.119:8000';
      default:
        return 'http://192.168.1.27:8000';
    }
  }
}
