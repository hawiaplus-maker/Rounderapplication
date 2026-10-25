import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/health_gauge.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_action_button.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_header.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_glass_panel.dart';

/// Property health card: gauge with the score inside, caption, the two metric
/// rows and the assessment action.
class HomeHealthCard extends StatelessWidget {
  const HomeHealthCard({super.key, required this.health, this.onView});

  final HomeHealth health;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return HomeGlassPanel(
      height: HomeSizes.summaryCardHeight,
      padding: const EdgeInsets.all(HomeSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeCardHeader(
            title: health.title,
            icon: AppImages.homeHouseSmall,
            titleStyle: HomeTextStyles.cardTitle,
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 73,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                HealthGauge(percent: health.percent),
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 10),
                  child: Text(health.score, style: HomeTextStyles.healthScore),
                ),
              ],
            ),
          ),
          Text(
            health.caption,
            style: HomeTextStyles.healthCaption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          for (final HomeHealthMetric metric in health.metrics) ...<Widget>[
            SizedBox(
              height: 18,
              child: Row(
                children: <Widget>[
                  Text(
                    metric.label,
                    style: HomeTextStyles.healthLabel,
                    maxLines: 1,
                  ),
                  const Spacer(),
                  Text(
                    metric.value,
                    style: HomeTextStyles.healthValue,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
          const Spacer(),
          HomeCardActionButton(
            label: health.actionLabel,
            fill: AppColors.mintLight,
            labelColor: AppColors.petrol,
            iconColor: AppColors.petrol,
            onTap: onView,
          ),
        ],
      ),
    );
  }
}
