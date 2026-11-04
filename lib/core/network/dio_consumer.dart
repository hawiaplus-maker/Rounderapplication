import 'package:dio/dio.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
import 'package:rounder_application/core/services/app_toast.dart';

class DioConsumer implements ApiConsumer {
  DioConsumer(this.dio);

  final Dio dio;

  /// Reads stay silent: a listing response's `message` is not user feedback.
  @override
  Future<Response<T>> get<T>(String path) => dio.get<T>(path);

  @override
  Future<Response<T>> post<T>(String path, {Object? data}) =>
      _withApiMessage(dio.post<T>(path, data: data));

  @override
  Future<Response<T>> put<T>(String path, {Object? data}) =>
      _withApiMessage(dio.put<T>(path, data: data));

  @override
  Future<Response<T>> delete<T>(String path) =>
      _withApiMessage(dio.delete<T>(path));

  /// Write-request feedback: every successful POST/PUT/DELETE carrying the
  /// `{status, message, data}` envelope's `message` is surfaced once here,
  /// instead of being repeated in each cubit/screen.
  Future<Response<T>> _withApiMessage<T>(Future<Response<T>> request) async {
    final Response<T> response = await request;
    final int? status = response.statusCode;
    final Object? body = response.data;
    if (status != null && status >= 200 && status < 300 && body is Map) {
      // A 200 with `status: false` is a business failure, not a success.
      if (body['status'] == false) return response;
      final Object? message = body['message'];
      if (message is String) showApiToast(message);
    }
    return response;
  }
}
