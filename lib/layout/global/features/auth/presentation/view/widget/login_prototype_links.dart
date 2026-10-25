import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Prototype-only links kept below the approved login layout: the working
/// email/password sign-in, the welcome-steps preview and the language picker.
/// They live under the fold (the approved frame fills the screen) and never
/// alter the approved composition.
class LoginPrototypeLinks extends StatelessWidget {
  const LoginPrototypeLinks({
    super.key,
    required this.onEmailSignIn,
    required this.onWelcomeSteps,
    required this.onLanguage,
  });
  final VoidCallback onEmailSignIn;
  final VoidCallback onWelcomeSteps;
  final VoidCallback onLanguage;

  static const _linkStyle = TextStyle(color: AppColors.petrol, fontSize: 13);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocaleKey.prototypeData.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.petrol.withValues(alpha: .55), fontSize: 11, height: 20 / 11),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4,
          children: [
            TextButton(
              onPressed: onEmailSignIn,
              child: Text(AppLocaleKey.emailSignIn.tr(), style: _linkStyle),
            ),
            TextButton(
              onPressed: onWelcomeSteps,
              child: Text(AppLocaleKey.welcomeSteps.tr(), style: _linkStyle),
            ),
            TextButton(
              onPressed: onLanguage,
              child: Text('🌐  ${AppLocaleKey.language.tr()}', style: _linkStyle),
            ),
          ],
        ),
      ],
    );
  }
}
