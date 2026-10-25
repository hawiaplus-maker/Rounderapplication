import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/countdown_gauge.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/facility_badge.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_header.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_glass_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Upcoming service card with the countdown gauge.
class HomeNextServiceCard extends StatelessWidget {
  const HomeNextServiceCard({super.key, required this.service});

  final HomeNextService service;

  @override
  Widget build(BuildContext context) {
    return HomeGlassPanel(
      height: HomeSizes.visitCardHeight,
      padding: const EdgeInsets.all(HomeSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeCardHeader(
            title: service.title,
            icon: AppImages.homeClock,
            titleStyle: HomeTextStyles.cardTitle,
            iconColor: AppColors.petrol,
            iconSize: 19,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.center,
            child: FacilityBadge(label: service.badge),
          ),
          const SizedBox(height: 8),
          Text(
            service.remainingLabel,
            style: HomeTextStyles.countdownRemaining,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CountdownGauge(
              value: service.countdown,
              unitLabel: service.countdownUnit,
            ),
          ),
          const Spacer(),
          Row(
            children: <Widget>[
              HomeSvgIcon(
                service.serviceIcon,
                size: 19,
                color: AppColors.petrol,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  service.service,
                  style: HomeTextStyles.serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (service.time.isNotEmpty)
            Text(
              service.time,
              style: HomeTextStyles.visitMeta,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
