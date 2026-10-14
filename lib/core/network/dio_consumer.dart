import 'package:dio/dio.dart';
import 'api_consumer.dart';
class DioConsumer implements ApiConsumer {
  DioConsumer(this.dio);
  final Dio dio;
  @override Future<Response<T>> get<T>(String path)=>dio.get<T>(path);
}
