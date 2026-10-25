import 'package:flutter/material.dart';

import 'package:rounder_application/core/theme/app_theme.dart';

/// Cairo type scale of the resident home frame (Figma 108:44).
///
/// The values are ported from the approved home prototype so the dashboard
/// keeps the same sizes, weights and line heights as the design.
abstract final class HomeTextStyles {
  static const String fontFamily = 'Cairo';

  // Brand + context.
  static const TextStyle weather = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );
  static const TextStyle city = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: AppColors.white,
  );

  // Hero.
  static const TextStyle greeting = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.white,
  );
  static const TextStyle heroName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 31,
    fontWeight: FontWeight.w700,
    height: 44 / 31,
    color: AppColors.white,
  );
  static const TextStyle heroQuestion = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.white,
  );
  static const TextStyle talkPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.white,
  );

  // Emergency bar.
  static const TextStyle emergencyHint = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.white,
  );
  static const TextStyle emergencyAction = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.white,
  );

  // Dashboard heading.
  static const TextStyle dashboardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.white,
  );
  static const TextStyle dashboardMeta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.white,
  );

  // Unit selector.
  static const TextStyle unitTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.petrol,
  );
  static const TextStyle unitSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.teal,
  );

  // Cards.
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 1.5,
    color: AppColors.petrol,
  );
  static const TextStyle cardTitleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.45,
    color: AppColors.petrol,
  );
  static const TextStyle balanceAmount = TextStyle(
    fontFamily: fontFamily,
    fontSize: 31,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.white,
  );
  static const TextStyle balanceCaption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.white,
  );
  static const TextStyle balancePeriod = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.white,
  );
  static const TextStyle healthScore = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    color: AppColors.petrol,
  );
  static const TextStyle healthCaption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.teal,
  );
  static const TextStyle healthLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.petrol,
  );
  static const TextStyle healthValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.teal,
  );

  // Visits.
  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.petrol,
  );
  static const TextStyle sectionMeta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.35,
    color: AppColors.teal,
  );
  static const TextStyle chipLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.petrol,
  );
  static const TextStyle serviceName = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.petrol,
  );
  static const TextStyle visitMetaSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.teal,
  );
  static const TextStyle visitMeta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.teal,
  );
  static const TextStyle visitStatus = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.teal,
  );
  static const TextStyle countdownRemaining = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.teal,
  );
  static const TextStyle countdownValue = TextStyle(
    fontFamily: fontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w500,
    height: 1.15,
    color: AppColors.petrol,
  );
  static const TextStyle countdownUnit = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.3,
    color: AppColors.teal,
  );

  // Card action + dock.
  static const TextStyle cardButton = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.35,
    color: AppColors.petrol,
  );
  static const TextStyle dockLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.25,
    color: AppColors.petrol,
  );
  static const TextStyle dockLabelActive = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.petrol,
  );
}
