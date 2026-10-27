import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_copy.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_footer.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_header.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_hero.dart';

/// First-launch step of the onboarding journey (design frames 00.1–00.3,
/// nodes 177:2/177:3/177:4): the three intro slides, then on to
/// authentication. Completions and skips are persisted by the caller.
class OnboardingIntroScreen extends StatefulWidget {
  const OnboardingIntroScreen({super.key, required this.onDone});
  final VoidCallback onDone;

  @override
  State<OnboardingIntroScreen> createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends State<OnboardingIntroScreen> {
  int _slide = 0;

  static const _titles = [
    AppLocaleKey.introTitleServices,
    AppLocaleKey.introTitleAli,
    AppLocaleKey.introTitleQuality,
  ];
  static const _bodies = [
    AppLocaleKey.introBodyServices,
    AppLocaleKey.introBodyAli,
    AppLocaleKey.introBodyQuality,
  ];

  void _next() {
    if (_slide < WelcomeSlide.values.length - 1) {
      setState(() => _slide++);
    } else {
      widget.onDone();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.petrol,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .19, .34, .57, .76, 1],
            colors: [
              AppColors.petrol,
              AppColors.petrol,
              AppColors.teal,
              AppColors.mintLight,
              AppColors.canvas,
              AppColors.sand,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
            child: Column(
              children: [
                WelcomeIntroHeader(onSkip: widget.onDone),
                const SizedBox(height: 12),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey('onboarding-hero-$_slide'),
                      child: WelcomeIntroHero(slide: WelcomeSlide.values[_slide]),
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: KeyedSubtree(
                    key: ValueKey('onboarding-copy-$_slide'),
                    child: WelcomeIntroCopy(headline: _titles[_slide].tr(), body: _bodies[_slide].tr()),
                  ),
                ),
                const SizedBox(height: 28),
                WelcomeIntroFooter(
                  step: _slide + 1,
                  ctaLabel: (_slide == 2 ? AppLocaleKey.startUsingRounder : AppLocaleKey.next).tr(),
                  onNext: _next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
