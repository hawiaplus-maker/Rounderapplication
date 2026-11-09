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
import 'package:rounder_application/layout/resident/features/account/data/repo/notifications_repo.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/legal_repo.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/profile_repo.dart';
import 'package:rounder_application/layout/resident/features/account/data/repo/support_repository.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/notifications_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/profile_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/legal_document_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/phone_change_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/support_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/data/repo/bookings_repo.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/weather_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/weather_cubit.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/repo/emergency_repository.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/cubit/emergency_cubit.dart';
import 'package:rounder_application/layout/resident/features/onboarding/data/repo/onboarding_repository.dart';
import 'package:rounder_application/layout/resident/features/services/data/repo/services_repo.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/service_catalog_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/service_providers_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/add_unit_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/homes_cubit.dart';

import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../network/end_points.dart';

final sl = GetIt.instance;
const tokenStorage = FlutterSecureStorage();
final _publicAuthPaths = {
  EndPoints.login,
  EndPoints.register,
  EndPoints.validateMobile,
  EndPoints.sendOtp,
  EndPoints.verifyOtp,
  EndPoints.social,
}.map((url) => Uri.parse(url).path).toSet();

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
      // Mobile data can take longer to establish the TLS connection; allow
      // 30 seconds before treating the host as unreachable.
      connectTimeout: const Duration(seconds: 30),
      // A slow server response (large dashboard payloads) gets 60 seconds.
      receiveTimeout: const Duration(seconds: 60),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept-Language'] = Intl.getCurrentLocale()
            .split('_')
            .first;
        if (_publicAuthPaths.contains(options.uri.path)) {
          // These endpoints start or continue authentication and must work
          // before a session exists (or while a previous token is stale).
          options.headers.remove('Authorization');
        } else {
          final token = Hive.box<String>(authBoxName).get(accessTokenKey);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
    ),
  );
  // Terminal request/response logs of debug runs only; added after the
  // wrapper so the logged request headers are the final outgoing ones.
  if (kDebugMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        // Headers can include bearer credentials; keep them out of logs.
        requestHeader: false,
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
  // Weather is a long-lived read: one instance so tab switches never refetch.
  sl.registerLazySingleton(() => WeatherRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => WeatherCubit(sl<WeatherRepository>()));
  sl.registerLazySingleton(() => ServicesRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => BookingsRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => ProfileRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => LegalRepository(sl<ApiConsumer>()));
  sl.registerFactory(() => LegalDocumentCubit(sl<LegalRepository>()));
  sl.registerLazySingleton(() => NotificationsRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => SupportRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => HomesRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(
    () => SelectedHomeStore(Hive.box<String>(authBoxName)),
  );
  sl.registerFactory(() => ResidentDashboardCubit(sl<ResidentRepository>()));
  sl.registerLazySingleton(() => ServicesCubit(sl<ServicesRepository>()));
  sl.registerFactory(() => ServiceCatalogCubit(sl<ServicesRepository>()));
  sl.registerFactory(() => ServiceProvidersCubit(sl<ServicesRepository>()));
  sl.registerLazySingleton(() => BookingsCubit(sl<BookingsRepository>()));
  sl.registerFactory(() => ProfileCubit(sl<ProfileRepository>()));
  sl.registerFactory(() => PhoneChangeCubit(sl<ProfileRepository>()));
  sl.registerLazySingleton(
    () => NotificationsCubit(sl<NotificationsRepository>()),
  );
  // Support channels are static content: one instance serves every visit.
  sl.registerLazySingleton(() => SupportCubit(sl<SupportRepository>()));
  sl.registerFactory(
    () => HomesCubit(sl<HomesRepository>(), sl<SelectedHomeStore>()),
  );
  sl.registerFactory(() => AddUnitCubit(sl<HomesRepository>()));
  sl.registerLazySingleton(() => EmergencyRepository(sl<ApiConsumer>()));
  sl.registerLazySingleton(() => EmergencyCubit(sl<EmergencyRepository>()));
}
