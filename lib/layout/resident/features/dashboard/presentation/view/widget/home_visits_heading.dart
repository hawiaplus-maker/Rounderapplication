import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';

/// "زياراتك" section heading with its meta line.
class HomeVisitsHeading extends StatelessWidget {
  const HomeVisitsHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.visitsHeadingHeight,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              AppLocaleKey.homeVisitsTitle.tr(),
              style: HomeTextStyles.sectionTitle,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppLocaleKey.homeVisitsSubtitle.tr(),
            style: HomeTextStyles.sectionMeta,
            textAlign: TextAlign.end,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
