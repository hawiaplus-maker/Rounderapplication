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

/// True when the request never reached the backend — offline, a DNS failure,
/// a connect/send/receive timeout or a TLS certificate problem. Callers map
/// these to their localized "connection" message instead of a generic
/// failure (a timeout is not a rejected credential).
bool isConnectionFailure(Object error) {
  if (error is! DioException) return false;
  return switch (error.type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.badCertificate => true,
    _ => false,
  };
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
