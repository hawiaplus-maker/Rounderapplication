import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:rounder_application/layout/global/features/auth/data/repo/auth_repo.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/repo/bookings_repo.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';

import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';

final sl = GetIt.instance;
const tokenStorage = FlutterSecureStorage();
void configureDependencies() {
  sl.registerLazySingleton(() => PreviewOrdersCubit());
  final dio = Dio(
    BaseOptions(
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.rounder.app/api/v1',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept-Language'] = Intl.getCurrentLocale().split('_').first;
        final token = await tokenStorage.read(key: 'rounder_access_token');
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ),
  );
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio));
  sl.registerLazySingleton(() => AuthRepository(sl<ApiConsumer>(), tokenStorage));
  sl.registerFactory(() => AuthCubit(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResidentRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => ServicesRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => BookingsRepository(sl<ApiConsumer>()));
  sl.registerFactory(() => ResidentDashboardCubit(sl<ResidentRepository>()));
  sl.registerFactory(() => ServicesCubit(sl<ServicesRepository>()));
  sl.registerFactory(() => BookingsCubit(sl<BookingsRepository>()));
}
