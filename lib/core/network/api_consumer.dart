import 'package:dio/dio.dart';
abstract interface class ApiConsumer {
  Future<Response<T>> get<T>(String path);
  Future<Response<T>> post<T>(String path,{Object? data});
}
