import 'package:flutter/material.dart';

/// Cairo (and Roboto Mono for the mono style) type scale mirroring the Figma
/// text styles of "Rounder — Design System & MVP". Use these instead of
/// ad-hoc `TextStyle(...)` so the app stays in sync with the design.
abstract final class AppTextStyles {
  static const String cairo = 'Cairo';
  static const String mono = 'Roboto Mono';

  // Display
  static const TextStyle displayHero = TextStyle(
    fontFamily: cairo,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 44 / 32,
  );
  static const TextStyle displayLarge = TextStyle(
    fontFamily: cairo,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 40 / 28,
  );
  static const TextStyle displayRegular27 = TextStyle(
    fontFamily: cairo,
    fontSize: 27,
    fontWeight: FontWeight.w400,
    height: 38 / 27,
  );
  static const TextStyle displayBold27 = TextStyle(
    fontFamily: cairo,
    fontSize: 27,
    fontWeight: FontWeight.w700,
    height: 38 / 27,
  );
  static const TextStyle displayRegular30 = TextStyle(
    fontFamily: cairo,
    fontSize: 30,
    fontWeight: FontWeight.w400,
    height: 42 / 30,
  );
  static const TextStyle displayBold30 = TextStyle(
    fontFamily: cairo,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 42 / 30,
  );
  static const TextStyle displayBold40 = TextStyle(
    fontFamily: cairo,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 52 / 40,
  );
  static const TextStyle displayBold46 = TextStyle(
    fontFamily: cairo,
    fontSize: 46,
    fontWeight: FontWeight.w700,
    height: 56 / 46,
  );
  static const TextStyle displayBold48 = TextStyle(
    fontFamily: cairo,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 58 / 48,
  );

  // Headings
  static const TextStyle headingH1 = TextStyle(
    fontFamily: cairo,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 36 / 24,
  );
  static const TextStyle headingH2 = TextStyle(
    fontFamily: cairo,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 30 / 20,
  );
  static const TextStyle headingH3 = TextStyle(
    fontFamily: cairo,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 28 / 18,
  );
  static const TextStyle headingH4 = TextStyle(
    fontFamily: cairo,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 24 / 16,
  );
  static const TextStyle headingRegular20 = TextStyle(
    fontFamily: cairo,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 30 / 20,
  );
  static const TextStyle headingRegular22 = TextStyle(
    fontFamily: cairo,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 32 / 22,
  );
  static const TextStyle headingBold22 = TextStyle(
    fontFamily: cairo,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 32 / 22,
  );
  static const TextStyle headingRegular23 = TextStyle(
    fontFamily: cairo,
    fontSize: 23,
    fontWeight: FontWeight.w400,
    height: 34 / 23,
  );
  static const TextStyle headingBold23 = TextStyle(
    fontFamily: cairo,
    fontSize: 23,
    fontWeight: FontWeight.w700,
    height: 34 / 23,
  );
  static const TextStyle headingRegular24 = TextStyle(
    fontFamily: cairo,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 34 / 24,
  );
  static const TextStyle headingRegular26 = TextStyle(
    fontFamily: cairo,
    fontSize: 26,
    fontWeight: FontWeight.w400,
    height: 36 / 26,
  );
  static const TextStyle headingBold26 = TextStyle(
    fontFamily: cairo,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 36 / 26,
  );
  static const TextStyle headingBold31 = TextStyle(
    fontFamily: cairo,
    fontSize: 31,
    fontWeight: FontWeight.w700,
    height: 42 / 31,
  );
  static const TextStyle headingBold34 = TextStyle(
    fontFamily: cairo,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 44 / 34,
  );
  static const TextStyle headingBold36 = TextStyle(
    fontFamily: cairo,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 46 / 36,
  );
  static const TextStyle headingBold38 = TextStyle(
    fontFamily: cairo,
    fontSize: 38,
    fontWeight: FontWeight.w700,
    height: 48 / 38,
  );
  static const TextStyle headingBold40 = TextStyle(
    fontFamily: cairo,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 50 / 40,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: cairo,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 30 / 18,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: cairo,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 26 / 16,
  );
  static const TextStyle bodySmall = TextStyle(
    fontFamily: cairo,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 22 / 14,
  );
  static const TextStyle bodyBold14 = TextStyle(
    fontFamily: cairo,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 22 / 14,
  );
  static const TextStyle bodyRegular15 = TextStyle(
    fontFamily: cairo,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 24 / 15,
  );
  static const TextStyle bodyBold15 = TextStyle(
    fontFamily: cairo,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 24 / 15,
  );
  static const TextStyle bodyMedium15 = TextStyle(
    fontFamily: cairo,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 24 / 15,
  );
  static const TextStyle bodyRegular17 = TextStyle(
    fontFamily: cairo,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 26 / 17,
  );
  static const TextStyle bodyBold17 = TextStyle(
    fontFamily: cairo,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 26 / 17,
  );
  static const TextStyle bodyRegular19 = TextStyle(
    fontFamily: cairo,
    fontSize: 19,
    fontWeight: FontWeight.w400,
    height: 28 / 19,
  );
  static const TextStyle bodyBold19 = TextStyle(
    fontFamily: cairo,
    fontSize: 19,
    fontWeight: FontWeight.w700,
    height: 28 / 19,
  );
  static const TextStyle bodyRegular21 = TextStyle(
    fontFamily: cairo,
    fontSize: 21,
    fontWeight: FontWeight.w400,
    height: 30 / 21,
  );
  static const TextStyle bodyBold21 = TextStyle(
    fontFamily: cairo,
    fontSize: 21,
    fontWeight: FontWeight.w700,
    height: 30 / 21,
  );
  static const TextStyle bodyBold25 = TextStyle(
    fontFamily: cairo,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 34 / 25,
  );
  static const TextStyle bodySemiBold11 = TextStyle(
    fontFamily: cairo,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 18 / 11,
  );
  static const TextStyle bodySemiBold12 = TextStyle(
    fontFamily: cairo,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 20 / 12,
  );
  static const TextStyle bodySemiBold15 = TextStyle(
    fontFamily: cairo,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 24 / 15,
  );

  // Caption / label
  static const TextStyle labelAction = TextStyle(
    fontFamily: cairo,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 22 / 14,
  );
  static const TextStyle captionRegular = TextStyle(
    fontFamily: cairo,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 20 / 12,
  );
  static const TextStyle captionBold = TextStyle(
    fontFamily: cairo,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 20 / 12,
  );
  static const TextStyle captionMedium12 = TextStyle(
    fontFamily: cairo,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 20 / 12,
  );
  static const TextStyle captionRegular13 = TextStyle(
    fontFamily: cairo,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 20 / 13,
  );
  static const TextStyle captionBold13 = TextStyle(
    fontFamily: cairo,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    height: 20 / 13,
  );
  static const TextStyle captionMedium13 = TextStyle(
    fontFamily: cairo,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 20 / 13,
  );
  static const TextStyle captionSemiBold13 = TextStyle(
    fontFamily: cairo,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 20 / 13,
  );

  // Tiny
  static const TextStyle tinyRegular = TextStyle(
    fontFamily: cairo,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 18 / 11,
  );
  static const TextStyle tinyBold = TextStyle(
    fontFamily: cairo,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 18 / 11,
  );
  static const TextStyle tinyRegular10 = TextStyle(
    fontFamily: cairo,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 16 / 10,
  );
  static const TextStyle tinyBold10 = TextStyle(
    fontFamily: cairo,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 16 / 10,
  );
  static const TextStyle tinyMedium10 = TextStyle(
    fontFamily: cairo,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 16 / 10,
  );
  static const TextStyle tinyMedium11 = TextStyle(
    fontFamily: cairo,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 18 / 11,
  );
  static const TextStyle tinyRegular8 = TextStyle(
    fontFamily: cairo,
    fontSize: 8,
    fontWeight: FontWeight.w400,
    height: 14 / 8,
  );
  static const TextStyle tinyRegular9 = TextStyle(
    fontFamily: cairo,
    fontSize: 9,
    fontWeight: FontWeight.w400,
    height: 14 / 9,
  );

  // ExtraBold
  static const TextStyle extraBold16 = TextStyle(
    fontFamily: cairo,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 24 / 16,
  );
  static const TextStyle extraBold21 = TextStyle(
    fontFamily: cairo,
    fontSize: 21,
    fontWeight: FontWeight.w800,
    height: 30 / 21,
  );
  static const TextStyle extraBold27 = TextStyle(
    fontFamily: cairo,
    fontSize: 27,
    fontWeight: FontWeight.w800,
    height: 38 / 27,
  );
  static const TextStyle extraBold28 = TextStyle(
    fontFamily: cairo,
    fontSize: 28,
    fontWeight: FontWeight.w800,
    height: 40 / 28,
  );
  static const TextStyle extraBold30 = TextStyle(
    fontFamily: cairo,
    fontSize: 30,
    fontWeight: FontWeight.w800,
    height: 42 / 30,
  );
  static const TextStyle extraBold40 = TextStyle(
    fontFamily: cairo,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 52 / 40,
  );
  // Extensions used by the pulled MVP screens (pending design-system review):
  // no baked height — Equal to the null-height render of the original inline styles.
  static const TextStyle extraBold15 = TextStyle(
    fontFamily: cairo,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold17 = TextStyle(
    fontFamily: cairo,
    fontSize: 17,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold18 = TextStyle(
    fontFamily: cairo,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold19 = TextStyle(
    fontFamily: cairo,
    fontSize: 19,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold20 = TextStyle(
    fontFamily: cairo,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold22 = TextStyle(
    fontFamily: cairo,
    fontSize: 22,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold23 = TextStyle(
    fontFamily: cairo,
    fontSize: 23,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold24 = TextStyle(
    fontFamily: cairo,
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );
  static const TextStyle extraBold26 = TextStyle(
    fontFamily: cairo,
    fontSize: 26,
    fontWeight: FontWeight.w800,
  );

  // Medium (larger)
  static const TextStyle medium16 = TextStyle(
    fontFamily: cairo,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );
  static const TextStyle medium21 = TextStyle(
    fontFamily: cairo,
    fontSize: 21,
    fontWeight: FontWeight.w500,
    height: 30 / 21,
  );
  static const TextStyle medium22 = TextStyle(
    fontFamily: cairo,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 32 / 22,
  );
  static const TextStyle medium23 = TextStyle(
    fontFamily: cairo,
    fontSize: 23,
    fontWeight: FontWeight.w500,
    height: 34 / 23,
  );
  static const TextStyle medium25 = TextStyle(
    fontFamily: cairo,
    fontSize: 25,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle medium26 = TextStyle(
    fontFamily: cairo,
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 36 / 26,
  );

  // Mono
  static const TextStyle monoMedium25 = TextStyle(
    fontFamily: mono,
    fontSize: 25,
    fontWeight: FontWeight.w500,
    height: 34 / 25,
  );
}
