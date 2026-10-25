import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_action_button.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_card_header.dart';

/// Union balance card: dark gradient panel with the amount and the "more"
/// action pinned to the bottom.
class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({super.key, required this.balance, this.onMore});

  final HomeBalance balance;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HomeSizes.summaryCardHeight,
      padding: const EdgeInsets.all(HomeSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: AppColors.balanceCard,
        borderRadius: BorderRadius.circular(HomeRadii.card),
        border: Border.all(color: AppColors.glassBalanceStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          HomeCardHeader(
            title: balance.title,
            icon: AppImages.homeWallet,
            titleStyle: HomeTextStyles.cardTitle.copyWith(
              color: AppColors.white,
            ),
            iconColor: AppColors.white,
          ),
          const SizedBox(height: 14),
          Text(
            balance.amount,
            style: HomeTextStyles.balanceAmount,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
          Text(
            balance.currency,
            style: HomeTextStyles.balanceCaption,
            textAlign: TextAlign.start,
            maxLines: 1,
          ),
          if (balance.period.isNotEmpty) ...<Widget>[
            const SizedBox(height: 18),
            Text(
              balance.period,
              style: HomeTextStyles.balancePeriod,
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          ],
          const Spacer(),
          HomeCardActionButton(
            label: balance.actionLabel,
            fill: AppColors.glassTintFill,
            labelColor: AppColors.white,
            iconColor: AppColors.white,
            onTap: onMore,
          ),
        ],
      ),
    );
  }
}
