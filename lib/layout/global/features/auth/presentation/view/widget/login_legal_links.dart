import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rounder_application/core/constants/legal_urls.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Approved legal row (design `Legal / Links`): privacy policy and terms,
/// 12/22, separated by a 16px-high rule. Each label opens the hosted
/// document in the system browser; the URLs live in [LegalUrls] and must be
/// filled in before submission (both stores require a reachable policy).
class LoginLegalLinks extends StatelessWidget {
  const LoginLegalLinks({super.key});

  static final _labelStyle = AppTextStyles.captionRegular.copyWith(color: AppColors.petrol, height: 22 / 12);

  Future<void> _open(BuildContext context, String url) async {
    if (!LegalUrls.isConfigured(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocaleKey.comingSoon.tr())),
      );
      return;
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocaleKey.comingSoon.tr())),
        );
      }
    }
  }

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
              child: TextButton(
                onPressed: () => _open(context, LegalUrls.privacyPolicy),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(AppLocaleKey.privacyPolicy.tr(), textAlign: TextAlign.center, style: _labelStyle),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 16, color: AppColors.stroke),
          const SizedBox(width: 16),
          Expanded(
            child: Center(
              child: TextButton(
                onPressed: () => _open(context, LegalUrls.termsConditions),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(AppLocaleKey.termsConditions.tr(), textAlign: TextAlign.center, style: _labelStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
