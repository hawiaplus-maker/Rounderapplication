import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Top bar of the welcome flow with the close action.
class WelcomeFlowHeader extends StatelessWidget {
  const WelcomeFlowHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Text(
            AppLocaleKey.welcome.tr(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            tooltip: AppLocaleKey.close.tr(),
            icon: const Icon(Icons.close, color: AppColors.white),
          ),
        ],
      ),
    );
  }
}
