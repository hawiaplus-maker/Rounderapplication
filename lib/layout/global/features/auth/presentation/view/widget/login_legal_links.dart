import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Approved legal row (design `Legal / Links`): privacy policy and terms,
/// 12/22, separated by a 16px-high rule. No policy content exists in the app
/// or the design yet, so the labels are informational for now.
class LoginLegalLinks extends StatelessWidget {
  const LoginLegalLinks({super.key});

  static const _labelStyle = TextStyle(color: AppColors.petrol, fontSize: 12, height: 22 / 12);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        // Approved frame order: privacy on the physical left, terms on the
        // right (both labels stay centered).
        textDirection: ui_direction.TextDirection.ltr,
        children: [
          Expanded(
            child: Center(
              child: Text(AppLocaleKey.privacyPolicy.tr(), textAlign: TextAlign.center, style: _labelStyle),
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 16, color: AppColors.stroke),
          const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: Text(AppLocaleKey.termsConditions.tr(), textAlign: TextAlign.center, style: _labelStyle),
            ),
          ),
        ],
      ),
    );
  }
}
