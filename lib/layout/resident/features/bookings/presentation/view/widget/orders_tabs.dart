import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Status filter tabs of the orders list.
class OrdersTabs extends StatelessWidget {
  const OrdersTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      // Fixed tabs fill the bar evenly; a scrollable bar left empty space on
      // the trailing side once the four labels ran out.
      isScrollable: false,
      labelColor: AppColors.petrol,
      unselectedLabelColor: AppColors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: AppTextStyles.headingH5,
      padding: EdgeInsets.zero,
      dividerColor: Colors.transparent,

      indicator: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
      tabs: [
        Tab(text: AppLocaleKey.allOrders.tr()),
        Tab(text: AppLocaleKey.orderActive.tr()),
        Tab(text: AppLocaleKey.orderScheduled.tr()),
        Tab(text: AppLocaleKey.orderHistory.tr()),
      ],
    );
  }
}
