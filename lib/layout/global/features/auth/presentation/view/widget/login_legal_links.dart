import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/constants/legal_urls.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/legal_document_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/legal_document_page.dart';

/// Approved legal row (design `Legal / Links`): privacy policy and terms,
/// 12/22, separated by a 16px-high rule. Each label opens the hosted
/// document in the system browser; the URLs live in [LegalUrls] and must be
/// filled in before submission (both stores require a reachable policy).
class LoginLegalLinks extends StatelessWidget {
  const LoginLegalLinks({super.key});

  static final _labelStyle = AppTextStyles.captionRegular.copyWith(color: AppColors.petrol, height: 22 / 12);

  Future<void> _open(BuildContext context, String slug) async {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<LegalDocumentCubit>(),
          child: LegalDocumentPage(slug: slug),
        ),
      ),
    );
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
                onPressed: () => _open(context, 'privacy'),
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
                onPressed: () => _open(context, 'terms'),
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
