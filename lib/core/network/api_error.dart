import 'package:dio/dio.dart';

/// A 2xx response that still states a business failure (`status: false`):
/// Dio does not reject it, so the repository raises it instead.
class ApiFailure implements Exception {
  ApiFailure(this.message);

  /// The backend's user-facing text (already localized by `Accept-Language`).
  final String message;

  @override
  String toString() => message;
}

/// The backend's own user-facing text for a failed request: the first field
/// error of a Laravel 422, else the envelope's `message`, else an [ApiFailure]
/// message. Null when the failure has no server text (offline, timeout), so
/// the caller keeps its localized fallback.
String? apiErrorMessage(Object error) {
  if (error is ApiFailure) {
    return error.message.trim().isEmpty ? null : error.message.trim();
  }
  if (error is! DioException) return null;
  final Object? data = error.response?.data;
  if (data is! Map) return null;

  final Object? errors = data['errors'];
  if (errors is Map) {
    for (final Object? value in errors.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
  }
  final Object? message = data['message'];
  if (message is String && message.trim().isNotEmpty) return message.trim();
  return null;
}
