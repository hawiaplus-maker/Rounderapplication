import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get_it/get_it.dart';
import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../../layout/resident/data/repositories/resident_repository.dart';
import '../../layout/resident/presentation/cubit/resident_dashboard_cubit.dart';
final sl=GetIt.instance;
void configureDependencies(){
  final dio=Dio(BaseOptions(baseUrl:const String.fromEnvironment('API_BASE_URL',defaultValue:'https://api.rounder.app/api/v1'),
    connectTimeout:const Duration(seconds:15),receiveTimeout:const Duration(seconds:20),headers:{'Accept':'application/json'}));
  dio.interceptors.add(InterceptorsWrapper(onRequest:(options,handler){
    options.headers['Accept-Language']=Intl.getCurrentLocale().split('_').first; handler.next(options);
  }));
  sl.registerLazySingleton<ApiConsumer>(()=>DioConsumer(dio));
  sl.registerLazySingleton(()=>ResidentRepository(sl<ApiConsumer>()));
  sl.registerFactory(()=>ResidentDashboardCubit(sl<ResidentRepository>()));
}
