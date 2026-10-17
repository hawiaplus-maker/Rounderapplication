import 'package:dio/dio.dart';
import 'package:rounder_application/core/network/api_consumer.dart';
class DioConsumer implements ApiConsumer {
 DioConsumer(this.dio); final Dio dio;
 @override Future<Response<T>> get<T>(String path)=>dio.get<T>(path);
 @override Future<Response<T>> post<T>(String path,{Object? data})=>dio.post<T>(path,data:data);
}
