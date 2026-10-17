import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:rounder_application/core/services/services_locator.dart';

/// Preserve the original initialization order before mounting the app.
Future<void> serviceInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  configureDependencies();
}
