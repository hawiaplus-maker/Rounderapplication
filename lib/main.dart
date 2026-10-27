import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/features/auth/data/repo/auth_repo.dart'
    show authBoxName;
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // The auth session lives in a plain Hive box — opened once at boot,
  // before any dependency (repository or request interceptor) touches it.
  await Hive.initFlutter();
  await Hive.openBox<String>(authBoxName);
  configureDependencies();
  runApp(
    EasyLocalization(
      path: 'assets/i18n',
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('ur')],
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      saveLocale: true,
      child: BlocProvider(
        create: (_) => sl<AuthCubit>()..restoreSession(),
        child: const RounderApp(),
      ),
    ),
  );
}
