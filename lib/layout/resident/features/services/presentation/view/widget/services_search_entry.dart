import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Tappable glass search entry of the services hub (Figma 298:251 -> 554:1006):
/// the whole field opens the "جميع الخدمات" list, exactly like the prototype's
/// Navigate-on-click input.
class ServicesSearchEntry extends StatelessWidget {
  const ServicesSearchEntry({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glassCardFill,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 22, 10),
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                SvgIcon(
                  AppImages.homeSearch,
                  size: 24,
                  color: AppColors.petrol,
                  semanticLabel: AppLocaleKey.browseAllServices.tr(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppLocaleKey.browseAllServices.tr(),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.petrol.withValues(alpha: .65),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}