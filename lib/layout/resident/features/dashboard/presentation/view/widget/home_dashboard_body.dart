import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
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
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_unit_picker_sheet.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_unit_selector.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_visit_cards.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_visits_heading.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/homes_repo.dart';
import 'package:rounder_application/layout/resident/features/units/data/repo/selected_home_store.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/add_unit_screen.dart';
import 'package:rounder_application/core/services/services_locator.dart';

/// The resident dashboard tab: resolves the dashboard state into the approved
/// home sections (hero, emergency bar, balance/health cards, visits).
class HomeDashboardBody extends StatefulWidget {
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
  State<HomeDashboardBody> createState() => _HomeDashboardBodyState();
}

class _HomeDashboardBodyState extends State<HomeDashboardBody> {
  /// The unit picked locally on the unit selector: overrides the dashboard's
  /// displayed home and leads the booking journey's unit choice.
  ResidentHome? _pickedHome;

  @override
  void initState() {
    super.initState();
    _restorePickedHome();
  }

  /// The displayed unit mirrors the linked-homes API like the design: a pick
  /// made in an earlier session (if it still exists) leads, otherwise the
  /// resident's primary home fills the selector; on failure the dashboard's
  /// own home keeps showing.
  Future<void> _restorePickedHome() async {
    final int? stored = sl<SelectedHomeStore>().readId();
    try {
      final List<ResidentHome> homes = await sl<HomesRepository>().list();
      if (!mounted || homes.isEmpty) return;
      final List<ResidentHome> matches = stored == null
          ? const <ResidentHome>[]
          : homes.where((ResidentHome h) => h.id == stored).toList();
      final ResidentHome displayed = matches.isEmpty
          ? homes.firstWhere(
              (ResidentHome h) => h.isPrimary,
              orElse: () => homes.first,
            )
          : matches.first;
      setState(() => _pickedHome = displayed);
    } catch (_) {
      /* keep the dashboard's own home on display */
    }
  }

  /// Opens the saved-homes sheet from the repo's cache — the endpoint is not
  /// re-fetched per tap; `addUnit`/`deleteHome` invalidate the cache, so the
  /// list refreshes exactly after an add or a delete. Without any home yet
  /// the resident is taken straight to the add-unit screen, and the first
  /// newly added unit becomes the local pick, mirroring the booking
  /// journey's behavior.
  Future<void> _pickUnit() async {
    List<ResidentHome> homes;
    try {
      homes = await sl<HomesRepository>().list();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocaleKey.unitsLoadFailed.tr())),
      );
      return;
    }
    if (!mounted) return;
    if (homes.isEmpty) {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => const AddUnitScreen()),
      );
      try {
        homes = await sl<HomesRepository>().list();
      } catch (_) {
        return;
      }
      if (!mounted || homes.isEmpty || homes.first.id == null) return;
      await sl<SelectedHomeStore>().writeId(homes.first.id);
      if (!mounted) return;
      setState(() => _pickedHome = homes.first);
      return;
    }
    final ResidentHome? picked = await showHomeUnitPicker(
      context,
      homes: homes,
      selectedId: _pickedHome?.id ?? sl<SelectedHomeStore>().readId(),
    );
    if (!mounted || picked == null || picked.id == null) return;
    await sl<SelectedHomeStore>().writeId(picked.id);
    if (!mounted) return;
    setState(() => _pickedHome = picked);
  }

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
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () =>
                        context.read<ResidentDashboardCubit>().load(),
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
        final cubit = context.read<ResidentDashboardCubit>();
        final HomeVisit lastVisit = _lastVisit(data);
        final HomeNextService nextService = _nextService(context, data);

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
                    residentName: _textOrPlaceholder(data.residentName),
                    onTalk: widget.onTalkToAli,
                  ),
                  const SizedBox(height: HomeSpacing.block),
                  HomeEmergencyBar(onTap: widget.onEmergency),
                  const SizedBox(height: HomeSpacing.block),
                  const HomeDashboardHeading(),
                  const SizedBox(height: HomeSpacing.block),
                  HomeUnitSelector(
                    unit: _unit(context, data, _pickedHome),
                    onTap: _pickUnit,
                  ),
                  const SizedBox(height: HomeSpacing.block),
                  HomeSummaryCards(
                    health: _health(context, data),
                    balance: _balance(context, data),
                    onViewHealth: widget.onViewAssessment,
                    onMoreBalance: widget.onMoreBalance,
                  ),
                  const SizedBox(height: HomeSpacing.block),
                  const HomeVisitsHeading(),
                  const SizedBox(height: HomeSpacing.block),
                  HomeVisitCards(
                    lastVisit: lastVisit,
                    nextService: nextService,
                    onDetails: widget.onVisitDetails,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

HomeUnit _unit(
  BuildContext context,
  ResidentDashboard data,
  ResidentHome? pickedHome,
) {
  final String name = _textOrPlaceholder(
    pickedHome?.name ?? data.homeName,
  );
  final String rawUnit = pickedHome != null &&
          pickedHome.unitLabel.trim().isNotEmpty
      ? pickedHome.unitLabel
      : data.unitLabel.trim();
  final String code = rawUnit.isEmpty
      ? ''
      : '${AppLocaleKey.homeUnitWord.tr()} '
          '${_formatUnitLabel(context, rawUnit)}';
  return HomeUnit(name: name, code: code);
}

HomeBalance _balance(BuildContext context, ResidentDashboard data) {
  final double? balance = data.associationBalance;
  final double? periodStart = data.periodStartBalance;
  final String period = periodStart == null || periodStart <= 0
      ? ''
      : '${AppLocaleKey.homePeriodStart.tr()} '
            '${_formatNumber(context, periodStart)} '
            '${AppLocaleKey.currencySar.tr()}';
  return HomeBalance(
    title: AppLocaleKey.associationBalance.tr(),
    amount: balance == null ? '' : _formatNumber(context, balance),
    currency: balance == null ? '' : AppLocaleKey.homeBalanceRemaining.tr(),
    period: period,
    actionLabel: AppLocaleKey.homeMore.tr(),
  );
}

HomeHealth _health(BuildContext context, ResidentDashboard data) {
  final int? percent = data.propertyHealthPercent?.clamp(0, 100).toInt();
  return HomeHealth(
    title: AppLocaleKey.homeHealthTitle.tr(),
    percent: percent,
    score: percent == null ? '' : _formatPercent(context, percent),
    caption: AppLocaleKey.homeHealthCaption.tr(),
    metrics: <HomeHealthMetric>[
      HomeHealthMetric(
        label: AppLocaleKey.homeHealthUnitLabel.tr(),
        value: DisplayPlaceholder.text,
      ),
      HomeHealthMetric(
        label: AppLocaleKey.homeHealthFacilitiesLabel.tr(),
        value: DisplayPlaceholder.text,
      ),
    ],
    actionLabel: AppLocaleKey.homeViewAssessment.tr(),
  );
}

HomeVisit _lastVisit(ResidentDashboard data) {
  final DashboardItem? item = data.recentActivity;
  final List<String> lines = item?.subtitle.split('\n') ?? const <String>[];
  final String provider = lines.isEmpty ? '' : lines.first.trim();
  final String time = lines.length > 1 ? lines.sublist(1).join(' ').trim() : '';
  return HomeVisit(
    title: AppLocaleKey.homeLastVisitTitle.tr(),
    badge: DisplayPlaceholder.text,
    service: _textOrPlaceholder(item?.title),
    serviceIcon: AppImages.homeElevator,
    provider: _textOrPlaceholder(provider),
    time: _textOrPlaceholder(time),
    status: DisplayPlaceholder.text,
    actionLabel: AppLocaleKey.homeDetails.tr(),
  );
}

HomeNextService _nextService(BuildContext context, ResidentDashboard data) {
  final DashboardItem? item = data.upcomingService;
  return HomeNextService(
    title: AppLocaleKey.upcomingService.tr(),
    badge: DisplayPlaceholder.text,
    remainingLabel: AppLocaleKey.homeRemaining.tr(),
    countdown: '',
    countdownUnit: '',
    service: _textOrPlaceholder(item?.title),
    serviceIcon: AppImages.homeSpray,
    time: _textOrPlaceholder(item?.subtitle),
  );
}

String _textOrPlaceholder(String? value) =>
    value == null || value.trim().isEmpty
    ? DisplayPlaceholder.text
    : value.trim();

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
