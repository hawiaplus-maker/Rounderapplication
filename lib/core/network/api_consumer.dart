import 'package:dio/dio.dart';
abstract interface class ApiConsumer {
  Future<Response<T>> get<T>(String path);
}
