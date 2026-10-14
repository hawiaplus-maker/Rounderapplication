import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/layout/auth/presentation/auth_cubit.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';
import '../cubit/resident_dashboard_cubit.dart';
import 'account_flow.dart';
import 'emergency_request_screen.dart';
import 'link_home_screen.dart';
import 'orders_prototype_screen.dart';
import 'service_journey_screen.dart';
import 'union_screen.dart';

/// Resident application shell. The selected tab stays alive as a local
/// prototype; each feature owns its own screens and state.
class ResidentHomeScreen extends StatefulWidget {
  const ResidentHomeScreen({super.key});

  @override
  State<ResidentHomeScreen> createState() => _ResidentHomeScreenState();
}

class _ResidentHomeScreenState extends State<ResidentHomeScreen> {
  int _tab = 0;

  static const _background = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, .23, .48, .72, 1],
      colors: [
        Color(0xFF073B43),
        Color(0xFF0F6570),
        Color(0xFF9CCFCB),
        Color(0xFFDDF3EE),
        Color(0xFFFFF9EF),
      ],
    ),
  );

  Future<void> _chooseLanguage() async {
    final locale = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(title: Text(AppLocaleKey.arabic.tr()), onTap: () => Navigator.pop(context, const Locale('ar'))),
          ListTile(title: Text(AppLocaleKey.english.tr()), onTap: () => Navigator.pop(context, const Locale('en'))),
          ListTile(title: Text(AppLocaleKey.urdu.tr()), onTap: () => Navigator.pop(context, const Locale('ur'))),
        ]),
      ),
    );
    if (locale != null && mounted) context.setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _dashboard(),
      const ServiceJourneyScreen(),
      const OrdersPrototypeScreen(),
      const UnionScreen(),
      const AccountFlow(),
    ];
    final labels = <String>[
      AppLocaleKey.home,
      AppLocaleKey.services,
      AppLocaleKey.orders,
      AppLocaleKey.unionTab,
      AppLocaleKey.account,
    ];
    final icons = <IconData>[
      Icons.home_outlined,
      Icons.grid_view_rounded,
      Icons.receipt_long_outlined,
      Icons.apartment_outlined,
      Icons.person_outline_rounded,
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.sand,
        extendBody: true,
        body: SafeArea(
          bottom: false,
          child: DecoratedBox(
            decoration: _background,
            child: IndexedStack(index: _tab, children: pages),
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(18, 4, 18, 12),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .96),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [BoxShadow(color: Color(0x1A073B43), blurRadius: 22, offset: Offset(0, 8))],
            ),
            child: Row(
              children: List.generate(labels.length, (index) {
                final selected = _tab == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tab = index),
                    borderRadius: BorderRadius.circular(22),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 170),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.mint : Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(icons[index], size: 22, color: selected ? AppColors.orange : AppColors.petrol),
                        const SizedBox(height: 3),
                        Text(labels[index].tr(), maxLines: 1,
                          style: TextStyle(fontSize: 10, fontWeight: selected ? FontWeight.w800 : FontWeight.w500, color: AppColors.petrol)),
                      ]),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboard() => BlocBuilder<ResidentDashboardCubit, ResidentDashboardState>(
    builder: (context, state) {
      if (state is DashboardLoading) {
        return const Center(child: CircularProgressIndicator(color: Colors.white));
      }
      if (state is DashboardFailed) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.cloud_off_outlined, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(state.key.tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => context.read<ResidentDashboardCubit>().load(), child: Text(AppLocaleKey.retry.tr())),
            ]),
          ),
        );
      }

      final data = (state as DashboardReady).data;
      if (!data.hasHome) return const LinkHomeScreen();

      return RefreshIndicator(
        onRefresh: () => context.read<ResidentDashboardCubit>().load(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 118),
          children: [
            _brandHeader(data.homeName),
            const SizedBox(height: 13),
            _assistantGreeting(data.residentName),
            const SizedBox(height: 20),
            _emergencyButton(),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: Text(AppLocaleKey.homeOverview.tr(), style: const TextStyle(color: Colors.white70, fontSize: 12))),
              Text(AppLocaleKey.myHome.tr(), style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w900)),
            ]),
            const SizedBox(height: 10),
            _homeSelector(data.homeName),
            const SizedBox(height: 12),
            SizedBox(
              height: 232,
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(child: _balanceCard(data.associationBalance)),
                const SizedBox(width: 12),
                Expanded(child: _healthCard(data.propertyHealthPercent)),
              ]),
            ),
            const SizedBox(height: 18),
            _sectionHeading(AppLocaleKey.upcomingService, AppLocaleKey.orders, () => setState(() => _tab = 2)),
            const SizedBox(height: 8),
            _dynamicInfoCard(
              icon: Icons.calendar_month_outlined,
              title: data.upcomingService?.title ?? AppLocaleKey.noUpcomingService.tr(),
              subtitle: data.upcomingService?.subtitle ?? AppLocaleKey.noUpcomingService.tr(),
              empty: data.upcomingService == null,
            ),
            const SizedBox(height: 18),
            _sectionHeading(AppLocaleKey.recentActivity, AppLocaleKey.orders, () => setState(() => _tab = 2)),
            const SizedBox(height: 8),
            _dynamicInfoCard(
              icon: Icons.history_rounded,
              title: data.recentActivity?.title ?? AppLocaleKey.noActivity.tr(),
              subtitle: data.recentActivity?.subtitle ?? AppLocaleKey.noActivity.tr(),
              empty: data.recentActivity == null,
            ),
          ],
        ),
      );
    },
  );

  Widget _brandHeader(String homeName) => Row(children: [
    IconButton(
      onPressed: _chooseLanguage,
      tooltip: AppLocaleKey.language.tr(),
      icon: const Icon(Icons.language_rounded, color: Colors.white),
    ),
    if (homeName.isNotEmpty) ...[
      const Icon(Icons.location_on_outlined, size: 18, color: Colors.white),
      const SizedBox(width: 4),
      Expanded(child: Text(homeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12))),
    ] else
      const Spacer(),
    const SizedBox(width: 12),
    Image.asset(AppImages.rounderLogo, height: 27, fit: BoxFit.contain),
  ]);

  Widget _assistantGreeting(String residentName) => Row(children: [
    Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(AppLocaleKey.greetingAli.tr(), style: const TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 3),
        Text(residentName.isEmpty ? AppLocaleKey.resident.tr() : residentName,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)),
        const SizedBox(height: 3),
        Text(AppLocaleKey.aliHelps.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => setState(() => _tab = 1),
          icon: const Icon(Icons.mic_none_rounded, size: 18),
          label: Text(AppLocaleKey.chat.tr()),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white70),
            backgroundColor: Colors.white.withValues(alpha: .14),
          ),
        ),
      ]),
    ),
    const SizedBox(width: 12),
    Container(
      width: 132, height: 142,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: .12),
        border: Border.all(color: Colors.white24),
      ),
      child: const Icon(Icons.support_agent_rounded, size: 82, color: Colors.white),
    ),
  ]);

  Widget _emergencyButton() => Material(
    color: const Color(0xFFE32F3B),
    borderRadius: BorderRadius.circular(28),
    child: InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const EmergencyRequestScreen())),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        child: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white),
          const SizedBox(width: 9),
          Expanded(child: Text(AppLocaleKey.emergency.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
          Text(AppLocaleKey.emergencySafety.tr(), style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ]),
      ),
    ),
  );

  Widget _homeSelector(String homeName) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .94), borderRadius: BorderRadius.circular(28)),
    child: Row(children: [
      const Icon(Icons.expand_more_rounded, color: AppColors.petrol),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(homeName.isEmpty ? AppLocaleKey.myHome.tr() : homeName, maxLines: 1, overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w800)),
        Text(AppLocaleKey.currentUnit.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      ])),
      const SizedBox(width: 10),
      const Icon(Icons.apartment_outlined, color: AppColors.petrol),
    ]),
  );

  Widget _balanceCard(double amount) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: AppColors.petrol, borderRadius: BorderRadius.circular(25)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(children: [
        const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 20),
        const Spacer(),
        Flexible(child: Text(AppLocaleKey.associationBalance.tr(), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
      ]),
      const SizedBox(height: 18),
      Text(amount.toStringAsFixed(0), textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)),
      Text(AppLocaleKey.currencySar.tr(), style: const TextStyle(color: Colors.white70, fontSize: 12)),
      const Spacer(),
      SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: () => setState(() => _tab = 3),
          style: FilledButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white),
          child: Text(AppLocaleKey.financialDetails.tr(), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    ]),
  );

  Widget _healthCard(int percent) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .95), borderRadius: BorderRadius.circular(25)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(children: [
        const Icon(Icons.home_work_outlined, color: AppColors.petrol, size: 20),
        const Spacer(),
        Flexible(child: Text(AppLocaleKey.propertyHealth.tr(), textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w800))),
      ]),
      const SizedBox(height: 12),
      Center(
        child: SizedBox(
          width: 82, height: 82,
          child: Stack(alignment: Alignment.center, children: [
            CircularProgressIndicator(value: (percent.clamp(0, 100)) / 100, strokeWidth: 8, backgroundColor: AppColors.mint, color: const Color(0xFF4EA576)),
            Text('$percent%', style: const TextStyle(color: AppColors.petrol, fontSize: 19, fontWeight: FontWeight.w900)),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      Text(AppLocaleKey.goodCondition.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 11)),
      const Spacer(),
      SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: () => setState(() => _tab = 3),
          style: FilledButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: AppColors.petrol),
          child: Text(AppLocaleKey.viewRating.tr(), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    ]),
  );

  Widget _sectionHeading(String titleKey, String actionKey, VoidCallback onTap) => Row(children: [
    TextButton(onPressed: onTap, child: Text(actionKey.tr(), style: const TextStyle(color: Colors.white70, fontSize: 11))),
    const Spacer(),
    Text(titleKey.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 17, fontWeight: FontWeight.w900)),
  ]);

  Widget _dynamicInfoCard({required IconData icon, required String title, required String subtitle, required bool empty}) => Material(
    color: Colors.white.withValues(alpha: .94),
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => setState(() => _tab = 2),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(children: [
          CircleAvatar(backgroundColor: AppColors.mint, child: Icon(icon, color: AppColors.petrol)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(title, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Text(subtitle, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          ])),
          if (empty) const Icon(Icons.chevron_left, color: AppColors.petrol),
        ]),
      ),
    ),
  );
}
