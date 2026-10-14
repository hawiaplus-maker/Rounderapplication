import 'package:flutter/material.dart';
abstract final class AppColors {
  static const petrol=Color(0xFF073B43), orange=Color(0xFFFF7A1A), sand=Color(0xFFFFF9EF);
  static const mint=Color(0xFFDDF3EE), ink=Color(0xFF17343A), muted=Color(0xFF75868A), canvas=Color(0xFFF7F9F8);
}
abstract final class AppTheme {
  static ThemeData get light=>ThemeData(useMaterial3:true,scaffoldBackgroundColor:AppColors.canvas,
    colorScheme:ColorScheme.fromSeed(seedColor:AppColors.petrol,primary:AppColors.petrol,secondary:AppColors.orange),
    appBarTheme:const AppBarTheme(backgroundColor:AppColors.canvas,foregroundColor:AppColors.ink,elevation:0),
    cardTheme:CardThemeData(elevation:0,color:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))));
}
