import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/model/resident_dashboard_model.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/model/home_view_models.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_dashboard_heading.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_emergency_bar.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_hero_section.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_summary_cards.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_top_bar.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_unit_selector.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_visit_cards.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_visits_heading.dart';
import 'package:rounder_application/layout/resident/features/properties/presentation/view/screen/link_home_screen.dart';

/// The resident dashboard tab: resolves the dashboard state into the approved
/// home sections (hero, emergency bar, balance/health cards, visits).
class HomeDashboardBody extends StatelessWidget {
  const HomeDashboardBody({
    super.key,
    required this.onTalkToAli,
    required this.onMoreBalance,
    required this.onVisitDetails,
    required this.onEmergency,
    required this.onViewAssessment,
  });

  final VoidCallback onTalkToAli;
  final VoidCallback onMoreBalance;
  final VoidCallback onVisitDetails;
  final VoidCallback onEmergency;
  final VoidCallback onViewAssessment;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResidentDashboardCubit, ResidentDashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          );
        }
        if (state is DashboardFailed) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.cloud_off_outlined,
                    size: 48,
                    color: AppColors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.key.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.read<ResidentDashboardCubit>().load(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.petrol,
                    ),
                    child: Text(AppLocaleKey.retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        final data = (state as DashboardReady).data;
        if (!data.hasHome) return const LinkHomeScreen();

        final cubit = context.read<ResidentDashboardCubit>();
        final isPreview = cubit.isPreview;
        final HomeVisit? lastVisit = _lastVisit(context, data, isPreview);
        final HomeNextService? nextService = _nextService(context, data, isPreview);
        final showVisits = isPreview || (lastVisit != null && nextService != null);

        return RefreshIndicator(
          onRefresh: cubit.load,
          color: AppColors.petrol,
          backgroundColor: AppColors.white,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: HomeSizes.maxContentWidth,
              ),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsetsDirectional.fromSTEB(
                  HomeSpacing.page,
                  12,
                  HomeSpacing.page,
                  HomeSizes.pageBottomClearance +
                      MediaQuery.paddingOf(context).bottom,
                ),
                children: <Widget>[
                  const HomeTopBar(),
                  const SizedBox(height: HomeSpacing.block),
                  HomeHeroSection(
                    residentName: data.residentName.isEmpty
                        ? AppLocaleKey.resident.tr()
                        : data.residentName,
                    onTalk: onTalkToAli,
                  ),
                  const SizedBox(height: HomeSpacing.block),
                  HomeEmergencyBar(onTap: onEmergency),
                  const SizedBox(height: HomeSpacing.block),
                  const HomeDashboardHeading(),
                  const SizedBox(height: HomeSpacing.block),
                  HomeUnitSelector(unit: _unit(context, data, isPreview)),
                  const SizedBox(height: HomeSpacing.block),
                  HomeSummaryCards(
                    health: _health(context, data),
                    balance: _balance(context, data),
                    onViewHealth: onViewAssessment,
                    onMoreBalance: onMoreBalance,
                  ),
                  if (showVisits && lastVisit != null && nextService != null) ...<Widget>[
                    const SizedBox(height: HomeSpacing.block),
                    const HomeVisitsHeading(),
                    const SizedBox(height: HomeSpacing.block),
                    HomeVisitCards(
                      lastVisit: lastVisit,
                      nextService: nextService,
                      onDetails: onVisitDetails,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

HomeUnit _unit(BuildContext context, ResidentDashboard data, bool isPreview) {
  final String name = data.homeName.isNotEmpty
      ? data.homeName
      : (isPreview ? AppLocaleKey.unitTitle.tr() : AppLocaleKey.myHome.tr());
  final String rawUnit = data.unitLabel;
  final String code = rawUnit.isEmpty
      ? ''
      : '${AppLocaleKey.homeUnitWord.tr()} ${_formatUnitLabel(context, rawUnit)}';
  return HomeUnit(name: name, code: code);
}

HomeBalance _balance(BuildContext context, ResidentDashboard data) {
  final double? periodStart = data.periodStartBalance;
  final String period = periodStart == null || periodStart <= 0
      ? ''
      : '${AppLocaleKey.homePeriodStart.tr()} '
          '${_formatNumber(context, periodStart)} '
          '${AppLocaleKey.currencySar.tr()}';
  return HomeBalance(
    title: AppLocaleKey.associationBalance.tr(),
    amount: _formatNumber(context, data.associationBalance),
    currency: AppLocaleKey.homeBalanceRemaining.tr(),
    period: period,
    actionLabel: AppLocaleKey.homeMore.tr(),
  );
}

HomeHealth _health(BuildContext context, ResidentDashboard data) {
  final int percent = data.propertyHealthPercent.clamp(0, 100).toInt();
  return HomeHealth(
    title: AppLocaleKey.homeHealthTitle.tr(),
    percent: percent,
    score: _formatPercent(context, percent),
    caption: AppLocaleKey.homeHealthCaption.tr(),
    metrics: <HomeHealthMetric>[
      HomeHealthMetric(
        label: AppLocaleKey.homeHealthUnitLabel.tr(),
        value: AppLocaleKey.stateExcellent.tr(),
      ),
      HomeHealthMetric(
        label: AppLocaleKey.homeHealthFacilitiesLabel.tr(),
        value: AppLocaleKey.stateGood.tr(),
      ),
    ],
    actionLabel: AppLocaleKey.homeViewAssessment.tr(),
  );
}

HomeVisit? _lastVisit(
  BuildContext context,
  ResidentDashboard data,
  bool isPreview,
) {
  if (isPreview) {
    return HomeVisit(
      title: AppLocaleKey.homeLastVisitTitle.tr(),
      badge: AppLocaleKey.sharedFacilities.tr(),
      service: AppLocaleKey.homeLastVisitService.tr(),
      serviceIcon: AppImages.homeElevator,
      provider: AppLocaleKey.homeLastVisitProvider.tr(),
      time: AppLocaleKey.homeLastVisitTime.tr(),
      status: AppLocaleKey.homeStatusCompleted.tr(),
      actionLabel: AppLocaleKey.homeDetails.tr(),
    );
  }

  final DashboardItem? item = data.recentActivity;
  if (item == null) return null;
  final List<String> lines = item.subtitle.split('\n');
  final String provider = lines.isEmpty ? '' : lines.first.trim();
  final String time = lines.length > 1 ? lines.sublist(1).join(' ').trim() : '';
  return HomeVisit(
    title: AppLocaleKey.homeLastVisitTitle.tr(),
    badge: AppLocaleKey.sharedFacilities.tr(),
    service: item.title,
    serviceIcon: AppImages.homeElevator,
    provider: provider,
    time: time,
    status: AppLocaleKey.homeStatusCompleted.tr(),
    actionLabel: AppLocaleKey.homeDetails.tr(),
  );
}

HomeNextService? _nextService(
  BuildContext context,
  ResidentDashboard data,
  bool isPreview,
) {
  if (isPreview) {
    return HomeNextService(
      title: AppLocaleKey.upcomingService.tr(),
      badge: AppLocaleKey.sharedFacilities.tr(),
      remainingLabel: AppLocaleKey.homeRemaining.tr(),
      countdown: AppLocaleKey.homeCountdownValue.tr(),
      countdownUnit: AppLocaleKey.homeCountdownUnit.tr(),
      service: AppLocaleKey.homeNextServiceName.tr(),
      serviceIcon: AppImages.homeSpray,
      time: AppLocaleKey.homeNextServiceTime.tr(),
    );
  }

  final DashboardItem? item = data.upcomingService;
  if (item == null) return null;
  return HomeNextService(
    title: AppLocaleKey.upcomingService.tr(),
    badge: AppLocaleKey.sharedFacilities.tr(),
    remainingLabel: AppLocaleKey.homeRemaining.tr(),
    countdown: AppLocaleKey.homeCountdownValue.tr(),
    countdownUnit: AppLocaleKey.homeCountdownUnit.tr(),
    service: item.title,
    serviceIcon: AppImages.homeSpray,
    time: item.subtitle,
  );
}

/// Home numbers follow the app language: Arabic-Indic digits with the Arabic
/// separators in Arabic, Latin digits and commas in English/Urdu.
String _formatNumber(BuildContext context, num value) {
  final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
  final int rounded = value.round();
  final String digits = rounded.abs().toString();
  final StringBuffer grouped = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      grouped.write(isArabic ? '٬' : ',');
    }
    grouped.write(digits[i]);
  }
  final String text = '${rounded < 0 ? '-' : ''}$grouped';
  if (!isArabic) return text;

  const String western = '0123456789';
  const String eastern = '٠١٢٣٤٥٦٧٨٩';
  final StringBuffer converted = StringBuffer();
  for (final String char in text.split('')) {
    final int index = western.indexOf(char);
    converted.write(index == -1 ? char : eastern[index]);
  }
  return converted.toString();
}

String _formatPercent(BuildContext context, int value) {
  final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
  return '${_formatNumber(context, value)}${isArabic ? '٪' : '%'}';
}

String _formatUnitLabel(BuildContext context, String raw) {
  final int? numeric = int.tryParse(raw);
  return numeric == null ? raw : _formatNumber(context, numeric);
}
