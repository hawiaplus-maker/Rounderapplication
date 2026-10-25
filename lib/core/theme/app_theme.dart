import 'package:flutter/material.dart';
abstract final class AppColors {
  static const petrol=Color(0xFF073B43), orange=Color(0xFFFF7A1A), sand=Color(0xFFFFF9EF);
  static const mint=Color(0xFFDDF3EE), ink=Color(0xFF17343A), muted=Color(0xFF75868A), canvas=Color(0xFFF7F9F8);
  // Rounder design-system tokens (onboarding 00.1–00.3): brand/teal, brand/mint-light,
  // brand/orange-coral — added because no existing token matched these exact values.
  static const white=Color(0xFFFFFFFF), black=Color(0xFF000000);
  static const teal=Color(0xFF0F6570), mintLight=Color(0xFFE8F3F0), coral=Color(0xFFF2763C);
  // Design-system border of the auth fields / rules (login frame 168:2).
  static const stroke=Color(0xFFB9C8C6);
  // Resident home (Figma 108:44): exact glass alphas, shadows, emergency red,
  // gauge tones and the four-stop page gradient of the dashboard frame.
  static const emergency=Color(0xFFD42E33);
  static const shadowSoft=Color(0x0D073B43);
  static const shadowDock=Color(0x17073B43);
  static const glassDockFill=Color(0xC7FFFFFF);
  static const glassDockStroke=Color(0xF2FFFFFF);
  static const glassCardFill=Color(0xE0FFFFFF);
  static const glassCardStroke=Color(0x99FFFFFF);
  static const glassPillFill=Color(0x2BFFFFFF);
  static const glassPillStroke=Color(0x7AFFFFFF);
  static const glassChipFill=Color(0x1AFFFFFF);
  static const glassChipStroke=Color(0x3BFFFFFF);
  static const glassOrbitStroke=Color(0x1CFFFFFF);
  static const glassTintFill=Color(0x24FFFFFF);
  static const glassBalanceStroke=Color(0x24FFFFFF);
  static const gaugeTrack=Color(0xFFDDF3EE);
  static const healthGaugeStart=Color(0xFF0B5960);
  static const healthGaugeMid=Color(0xFF1D877C);
  static const healthGaugeEnd=Color(0xFF79B96B);
  static const countdownMid=Color(0xFF0B8078);
  static const balanceCard=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[petrol,teal]);
  static const homeBackground=LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,colors:[petrol,teal,mintLight,canvas],stops:[0,.28,.54,1]);
}
abstract final class AppTheme {
  static ThemeData get light=>ThemeData(useMaterial3:true,
    fontFamily:'Cairo',
    scaffoldBackgroundColor:AppColors.canvas,
    colorScheme:ColorScheme.fromSeed(seedColor:AppColors.petrol,primary:AppColors.petrol,secondary:AppColors.orange),
    appBarTheme:const AppBarTheme(backgroundColor:AppColors.canvas,foregroundColor:AppColors.ink,elevation:0),
    cardTheme:CardThemeData(elevation:0,color:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(20))));
}
