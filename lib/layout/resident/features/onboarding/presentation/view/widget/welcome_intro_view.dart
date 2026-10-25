import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_copy.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_footer.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_header.dart';
import 'package:rounder_application/layout/resident/features/onboarding/presentation/view/widget/welcome_intro_hero.dart';

/// Intro slides of the welcome flow.
class WelcomeIntroView extends StatelessWidget {
  const WelcomeIntroView({
    super.key,
    required this.slide,
    required this.onSkip,
    required this.onNext,
  });

  final int slide;
  final VoidCallback onSkip;
  final VoidCallback onNext;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
      child: Column(
        children: [
          WelcomeIntroHeader(onSkip: onSkip),
          const SizedBox(height: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: KeyedSubtree(
                key: ValueKey('intro-hero-$slide'),
                child: WelcomeIntroHero(slide: WelcomeSlide.values[slide]),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey('intro-copy-$slide'),
              child: WelcomeIntroCopy(
                headline: _titles[slide].tr(),
                body: _bodies[slide].tr(),
              ),
            ),
          ),
          const SizedBox(height: 28),
          WelcomeIntroFooter(
            step: slide + 1,
            ctaLabel: (slide == 2 ? AppLocaleKey.startUsingRounder : AppLocaleKey.next).tr(),
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}
