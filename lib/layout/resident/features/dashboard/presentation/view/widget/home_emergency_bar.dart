import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Red on-call emergency bar. Tapping opens the emergency flow.
class HomeEmergencyBar extends StatelessWidget {
  const HomeEmergencyBar({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.emergencyHeight,
      child: Material(
        color: AppColors.emergency,
        borderRadius: BorderRadius.circular(HomeRadii.pill),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                const HomeSvgIcon(
                  AppImages.homeAlert,
                  size: 18,
                  color: AppColors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocaleKey.emergency.tr(),
                  style: HomeTextStyles.emergencyAction,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    AppLocaleKey.homeEmergencyHint.tr(),
                    style: HomeTextStyles.emergencyHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
