import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/facility_badge.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_action_button.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_header.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_glass_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// Last completed visit card.
class HomeLastVisitCard extends StatelessWidget {
  const HomeLastVisitCard({super.key, required this.visit, this.onDetails});

  final HomeVisit visit;
  final VoidCallback? onDetails;

  @override
  Widget build(BuildContext context) {
    return HomeGlassPanel(
      height: HomeSizes.visitCardHeight,
      padding: const EdgeInsets.all(HomeSpacing.cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeCardHeader(
            title: visit.title,
            icon: AppImages.homeCircleCheck,
            titleStyle: HomeTextStyles.cardTitleLarge,
            iconColor: AppColors.teal,
            iconSize: 19,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.center,
            child: FacilityBadge(label: visit.badge),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              _IconTile(icon: visit.serviceIcon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  visit.service,
                  style: HomeTextStyles.serviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          if (visit.provider.isNotEmpty)
            Text(
              visit.provider,
              style: HomeTextStyles.visitMetaSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (visit.time.isNotEmpty) ...<Widget>[
            if (visit.provider.isNotEmpty) const SizedBox(height: 2),
            Text(
              visit.time,
              style: HomeTextStyles.visitMetaSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(visit.status, style: HomeTextStyles.visitStatus, maxLines: 1),
              const SizedBox(width: 4),
              const HomeSvgIcon(
                AppImages.homeCheck,
                size: 16,
                color: AppColors.teal,
              ),
            ],
          ),
          const SizedBox(height: 10),
          HomeCardActionButton(
            label: visit.actionLabel,
            fill: AppColors.mintLight,
            labelColor: AppColors.petrol,
            iconColor: AppColors.petrol,
            onTap: onDetails,
          ),
        ],
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.mintLight,
        borderRadius: BorderRadius.circular(HomeRadii.iconTile),
      ),
      alignment: AlignmentDirectional.center,
      child: HomeSvgIcon(icon, size: 25, color: AppColors.petrol),
    );
  }
}
