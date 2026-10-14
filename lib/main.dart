import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'core/di/injection.dart';
import 'layout/resident/presentation/cubit/resident_dashboard_cubit.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); await EasyLocalization.ensureInitialized(); configureDependencies();
  runApp(EasyLocalization(path:'assets/i18n',supportedLocales:const[Locale('ar'),Locale('en'),Locale('ur')],
    fallbackLocale:const Locale('ar'),startLocale:const Locale('ar'),saveLocale:true,
    child:BlocProvider(create:(_)=>sl<ResidentDashboardCubit>()..load(),child:const RounderApp())));
}
