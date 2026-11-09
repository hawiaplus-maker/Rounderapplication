import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Primary and secondary actions of the contact success page.
class AccountContactSuccessActions extends StatelessWidget {
  const AccountContactSuccessActions({
    super.key,
    required this.onBackToHelp,
    required this.onSendAnother,
  });

  final VoidCallback onBackToHelp;
  final VoidCallback onSendAnother;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.all(15),
          ),
          onPressed: onBackToHelp,
          icon: const Icon(Icons.close_rounded, size: 18),
          label: Text(AppLocaleKey.contactBackToHelp.tr()),
        ),
        const SizedBox(height: 4),
        TextButton.icon(
          onPressed: onSendAnother,
          icon: const Icon(Icons.send_outlined, size: 18),
          iconAlignment: IconAlignment.end,
          style: TextButton.styleFrom(foregroundColor: AppColors.petrol),
          label: Text(
            AppLocaleKey.contactSendAnother.tr(),
            style: AppTextStyles.bodyBold15,
          ),
        ),
      ],
    );
  }
}
