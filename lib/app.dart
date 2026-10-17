import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/auth/presentation/auth_cubit.dart';
import 'package:rounder_application/layout/auth/presentation/screens/login_screen.dart';
import 'package:rounder_application/layout/resident/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/presentation/screens/resident_home_screen.dart';
class RounderApp extends StatelessWidget {
 const RounderApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'Rounder',debugShowCheckedModeBanner:false,theme:AppTheme.light,
  locale:context.locale,supportedLocales:context.supportedLocales,localizationsDelegates:context.localizationDelegates,
  home:BlocBuilder<AuthCubit,AuthState>(builder:(context,state){
   if(state is Authenticated)return BlocProvider(create:(_)=>sl<ResidentDashboardCubit>()..load(),child:const ResidentHomeScreen());
   if(state is AuthChecking)return const Scaffold(body:Center(child:CircularProgressIndicator()));
   return const LoginScreen();
  }));
}
