import 'package:dio/dio.dart';

class ApiErrorFormatter {
  const ApiErrorFormatter._();

  static String message(Object error) {
    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        final message = data['message'];
        if (message is String && message.trim().isNotEmpty) {
          return message.trim();
        }

        final errors = data['errors'];
        if (errors is Map<String, dynamic>) {
          final flattened = errors.values
              .expand(
                (value) => value is List
                    ? value.whereType<String>()
                    : value is String
                    ? <String>[value]
                    : const <String>[],
              )
              .where((value) => value.trim().isNotEmpty)
              .toList();

          if (flattened.isNotEmpty) {
            return flattened.join('\n');
          }
        }
      }

      if (data is String && data.trim().isNotEmpty) {
        return data.trim();
      }

      if ((error.message ?? '').trim().isNotEmpty) {
        return error.message!.trim();
      }
    }

    return error.toString();
  }
}
