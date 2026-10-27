import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Which intro step's artwork the hero renders (maps to the artboard's
/// 00.1 services / 002 Ali / 00.3 quality frames).
enum WelcomeSlide { services, ali, quality }

/// Hero artwork slot of an intro step: concentric orbit rings + floating
/// lights behind the slide's approved artwork and glass panels.
class WelcomeIntroHero extends StatelessWidget {
  const WelcomeIntroHero({super.key, required this.slide});
  final WelcomeSlide slide;

  /// Artboard-tuned light positions as fractions of the hero slot
  /// (decorative atoms — identical for both languages by design).
  static const _lightPoints = [Alignment(-.67, -.63), Alignment(.81, -.31), Alignment(-.7, .51)];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        const _Orbits(),
        for (final lightPoint in _lightPoints)
          Align(alignment: lightPoint, child: const _OrbitLight()),
        switch (slide) {
          WelcomeSlide.services => const _ServicesArtwork(),
          WelcomeSlide.ali => const _AliArtwork(),
          WelcomeSlide.quality => const _QualityArtwork(),
        },
      ],
    );
  }
}

class _Orbits extends StatelessWidget {
  const _Orbits();

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          _Ring(size: 296, color: AppColors.mintLight.withValues(alpha: .24)),
          _Ring(size: 352, color: AppColors.mintLight.withValues(alpha: .12)),
        ],
      ),
    ),
  );
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(width: .7, color: color),
    ),
  );
}

class _OrbitLight extends StatelessWidget {
  const _OrbitLight();

  @override
  Widget build(BuildContext context) => Container(
    width: 4,
    height: 4,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.mintLight.withValues(alpha: .9),
      boxShadow: [
        BoxShadow(color: AppColors.mintLight.withValues(alpha: .5), blurRadius: 7, spreadRadius: 1),
      ],
    ),
  );
}

class _ServicesArtwork extends StatelessWidget {
  const _ServicesArtwork();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Center(child: Image.asset(AppImages.aliWave, width: 162, height: 265, fit: BoxFit.contain)),
      Align(
        alignment: const Alignment(-.99, .11),
        child: _GlassChip(label: AppLocaleKey.maintenanceServices.tr()),
      ),
      Align(
        alignment: const Alignment(.99, .11),
        child: _GlassChip(label: AppLocaleKey.generalServices.tr()),
      ),
    ],
  );
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => _GlassPanel(
    radius: BorderRadius.circular(16),
    width: 80,
    minHeight: 80,
    padding: const EdgeInsets.all(8),
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.white,
        fontSize: 15,
        height: 26 / 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _AliArtwork extends StatelessWidget {
  const _AliArtwork();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Align(
        alignment: const Alignment(-.80, .13),
        child: Image.asset(AppImages.aliListen, width: 148, height: 270, fit: BoxFit.contain),
      ),
      Align(
        alignment: const Alignment(.99, .13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ChatBubble(message: AppLocaleKey.chatUserIntent.tr(), user: true),
            const SizedBox(height: 28),
            _ChatBubble(message: AppLocaleKey.chatAliReply.tr(), user: false),
          ],
        ),
      ),
    ],
  );
}

// Bubble tail corners follow the approved Arabic artboard (user tail bottom,
// reading side): the bubbles are fixed artwork shells, not mirrored text UI.
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, required this.user});

  final String message;
  final bool user;

  @override
  Widget build(BuildContext context) => _GlassPanel(
    radius: user
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(5),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(5),
          ),
    width: 158,
    minHeight: 70,
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.petrol, fontSize: 14, height: 24 / 14),
    ),
  );
}

class _QualityArtwork extends StatelessWidget {
  const _QualityArtwork();

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Align(
        alignment: Alignment(.87, .24),
        child: Image.asset(AppImages.aliTablet, width: 153, height: 308, fit: BoxFit.contain),
      ),
      const Align(alignment: Alignment(-.99, .24), child: _QualityCard()),
    ],
  );
}

class _QualityCard extends StatelessWidget {
  const _QualityCard();

  @override
  Widget build(BuildContext context) => _GlassPanel(
    radius: BorderRadius.circular(16),
    width: 138,
    padding: const EdgeInsets.fromLTRB(8, 14, 8, 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocaleKey.qualityFollowUp.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 15,
            height: 26 / 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: AppColors.white.withValues(alpha: .5)),
        const SizedBox(height: 8),
        Text(
          AppLocaleKey.followExecution.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.petrol, fontSize: 14, height: 26 / 14),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocaleKey.reviewResult.tr(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.petrol, fontSize: 14, height: 26 / 14),
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(minHeight: 42),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.mintLight.withValues(alpha: .68),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            AppLocaleKey.rateService.tr(),
            style: const TextStyle(
              color: AppColors.petrol,
              fontSize: 15,
              height: 26 / 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Shared glass treatment of the hero panels: transparent white fill, thin
/// white stroke, backdrop blur and a soft petrol shadow (design: bg-blur 16,
/// shadow 0 8 20 petrol .08). Boxes hug their padding; heights stay minimums
/// so translated labels can grow instead of clipping.
///
/// The child is centered with `heightFactor: 1` (not `Container.alignment`,
/// which would expand to the bounded slot height inside the hero `Stack` and
/// stretch the panel to the whole artwork).
class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.radius,
    required this.child,
    this.width,
    this.minHeight,
    this.padding,
  });

  final BorderRadius radius;
  final Widget child;
  final double? width;
  final double? minHeight;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: radius,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        width: width,
        constraints: BoxConstraints(minHeight: minHeight ?? 0),
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: .2),
          borderRadius: radius,
          border: Border.all(color: AppColors.white.withValues(alpha: .65), width: .8),
          boxShadow: [
            BoxShadow(
              color: AppColors.petrol.withValues(alpha: .08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(heightFactor: 1, child: child),
      ),
    ),
  );
}
