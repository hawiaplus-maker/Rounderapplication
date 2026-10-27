import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:rounder_application/layout/global/features/auth/data/repo/auth_repo.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/repo/bookings_repo.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/onboarding/data/repo/onboarding_repository.dart';
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
        // Relative feature paths (`/resident/...`) resolve against the live
        // backend; EndPoints' absolute auth URLs override this base.
        defaultValue: 'https://rounder-sa.com/api/v1',
      ),
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept-Language'] = Intl.getCurrentLocale()
            .split('_')
            .first;
        final token = Hive.box<String>(authBoxName).get(accessTokenKey);
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
    ),
  );
  // Terminal request/response logs of debug runs only; added after the
  // wrapper so the logged request headers are the final outgoing ones.
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        maxWidth: 90,
      ),
    );
  }
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio));
  sl.registerLazySingleton(
    () => AuthRepository(sl<ApiConsumer>(), Hive.box<String>(authBoxName)),
  );
  sl.registerLazySingleton(() => OnboardingRepository(tokenStorage));
  sl.registerFactory(() => AuthCubit(sl<AuthRepository>()));
  // The validated-phone journey runs one instance per screen (login,register,otp).
  sl.registerFactory(() => PhoneAuthCubit(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResidentRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => ServicesRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => BookingsRepository(sl<ApiConsumer>()));
  sl.registerFactory(() => ResidentDashboardCubit(sl<ResidentRepository>()));
  sl.registerFactory(() => ServicesCubit(sl<ServicesRepository>()));
  sl.registerFactory(() => BookingsCubit(sl<BookingsRepository>()));
}
