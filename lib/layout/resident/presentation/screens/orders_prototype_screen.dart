import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';
import 'service_journey_screen.dart';

/// Local prototype orders allow the full resident journey to be reviewed
/// before the API is connected.
class OrdersPrototypeScreen extends StatelessWidget {
  const OrdersPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Row(
            children: [
              const Icon(Icons.receipt_long, color: AppColors.orange),
              const SizedBox(width: 10),
              Expanded(child: Text(AppLocaleKey.orders.tr(), style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: AppColors.petrol))),
              IconButton(onPressed: () {}, tooltip: AppLocaleKey.prototypeData.tr(), icon: const Icon(Icons.more_horiz)),
            ],
          ),
        ),
        TabBar(
          labelColor: AppColors.petrol,
          indicatorColor: AppColors.orange,
          tabs: [
            Tab(text: AppLocaleKey.orderActive.tr()),
            Tab(text: AppLocaleKey.orderHistory.tr()),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _OrderCard(
                    title: AppLocaleKey.activeOrderOne,
                    reference: 'RD-240815',
                    status: AppLocaleKey.orderActive,
                    icon: Icons.plumbing,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: SafeArea(child: ServiceJourneyScreen(startOnTracking: true))),
                    )),
                  ),
                  _OrderCard(
                    title: AppLocaleKey.activeOrderTwo,
                    reference: 'RD-240792',
                    status: AppLocaleKey.orderScheduled,
                    icon: Icons.cleaning_services_outlined,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: SafeArea(child: ServiceJourneyScreen(startOnTracking: true))),
                    )),
                  ),
                ],
              ),
              ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  _OrderCard(title: AppLocaleKey.activeOrderOne, reference: 'RD-239401', status: AppLocaleKey.serviceComplete, icon: Icons.check_circle_outline, onTap: () {}),
                  Center(child: Text(AppLocaleKey.prototypeData.tr(), style: const TextStyle(color: AppColors.muted))),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.title, required this.reference, required this.status, required this.icon, required this.onTap});
  final String title;
  final String reference;
  final String status;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 14),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(backgroundColor: AppColors.mint, child: Icon(icon, color: AppColors.petrol)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(title.tr(), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.petrol)),
                const SizedBox(height: 4),
                Text(reference, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
              ])),
              const Icon(Icons.chevron_right, color: AppColors.petrol),
            ]),
            const Divider(height: 22),
            Row(children: [
              Text(AppLocaleKey.trackOrder.tr(), style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
              const Spacer(),
              Chip(label: Text(status.tr()), backgroundColor: AppColors.mint, side: BorderSide.none),
            ]),
          ],
        ),
      ),
    ),
  );
}
