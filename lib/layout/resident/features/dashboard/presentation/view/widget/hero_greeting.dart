import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';

/// Greeting block: line, resident name and the assistant question.
class HeroGreeting extends StatelessWidget {
  const HeroGreeting({super.key, required this.residentName});

  final String residentName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          AppLocaleKey.homeGreeting.tr(),
          style: HomeTextStyles.greeting,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        Text(
          residentName,
          style: HomeTextStyles.heroName,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          AppLocaleKey.homeHeroQuestion.tr(),
          style: HomeTextStyles.heroQuestion,
          textAlign: TextAlign.start,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
