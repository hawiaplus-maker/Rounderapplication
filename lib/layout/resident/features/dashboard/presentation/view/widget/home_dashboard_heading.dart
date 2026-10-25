import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';

/// "ملخص يومك" heading with the current-unit hint on the far side.
class HomeDashboardHeading extends StatelessWidget {
  const HomeDashboardHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.sectionHeadingHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppLocaleKey.homeDashboardTitle.tr(),
              style: HomeTextStyles.dashboardTitle,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppLocaleKey.currentUnit.tr(),
            style: HomeTextStyles.dashboardMeta,
            textAlign: TextAlign.end,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
