import 'package:flutter/material.dart';

import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_balance_card.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_health_card.dart';

/// The two dashboard cards side by side: health on the start side, balance on
/// the end side as drawn in the frame.
class HomeSummaryCards extends StatelessWidget {
  const HomeSummaryCards({
    super.key,
    required this.health,
    required this.balance,
    this.onViewHealth,
    this.onMoreBalance,
  });

  final HomeHealth health;
  final HomeBalance balance;
  final VoidCallback? onViewHealth;
  final VoidCallback? onMoreBalance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: HomeSizes.summaryCardHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: HomeHealthCard(health: health, onView: onViewHealth),
          ),
          const SizedBox(width: HomeSpacing.cardGap),
          Expanded(
            child: HomeBalanceCard(balance: balance, onMore: onMoreBalance),
          ),
        ],
      ),
    );
  }
}
