import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'layout/resident/presentation/screens/resident_home_screen.dart';
class RounderApp extends StatelessWidget {
 const RounderApp({super.key});
 @override Widget build(BuildContext context)=>MaterialApp(title:'Rounder',debugShowCheckedModeBanner:false,theme:AppTheme.light,
   locale:context.locale,supportedLocales:context.supportedLocales,localizationsDelegates:context.localizationDelegates,home:const ResidentHomeScreen());
}
