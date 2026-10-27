import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/properties/presentation/view/screen/link_home_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screen/property_rating_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_emblem.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_empty_state.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_header.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_linked_list.dart';

/// My Units journey (وحداتي — design 536:943). This is a local prototype
/// screen: the two design units render from approved copy and it is reached
/// from the account profile. No units endpoint is called.
class UnitsScreen extends StatelessWidget {
  const UnitsScreen({
    super.key,
    required this.hasUnits,
    required this.dashboard,
  });
  final bool hasUnits;
  final ResidentDashboardCubit dashboard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, .25, .42, .6, .78, 1],
            colors: [
              AppColors.petrol,
              AppColors.petrol,
              AppColors.teal,
              AppColors.mintLight,
              AppColors.canvas,
              AppColors.sand,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              UnitsHeader(
                title: AppLocaleKey.back.tr(),
                onBack: () => Navigator.maybePop(context),
              ),
              const SizedBox(height: 22),
              Text(
                AppLocaleKey.units.tr(),
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 34,
                  height: 48 / 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocaleKey.unitsSubtitle.tr(),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: .8),
                  fontSize: 14,
                  height: 22 / 14,
                ),
              ),
              const SizedBox(height: 16),
              if (hasUnits) const UnitsEmblem(),
              const SizedBox(height: 20),
              switch (hasUnits) {
                true => UnitsLinkedList(
                  onOpenUnit: () => _openPropertyRating(context),
                  onAddUnit: () => _openLinkHome(context),
                ),
                false => UnitsEmptyState(
                  title: AppLocaleKey.unitsEmptyTitle.tr(),
                  body: AppLocaleKey.unitsEmptyBody.tr(),
                  hint: AppLocaleKey.unitsEmptyHint.tr(),
                  actionLabel: AppLocaleKey.unitsAddUnit.tr(),
                  onAction: () => _openLinkHome(context),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }

  void _openPropertyRating(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PropertyRatingScreen()),
    );
  }

  /// Reuses the account flow's exact wrap for LinkHomeScreen: a value-provider
  /// carrying this dashboard cubit so its preview link stays in place.
  void _openLinkHome(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: dashboard,
          child: Scaffold(
            appBar: AppBar(),
            body: SafeArea(child: LinkHomeScreen()),
          ),
        ),
      ),
    );
  }
}
