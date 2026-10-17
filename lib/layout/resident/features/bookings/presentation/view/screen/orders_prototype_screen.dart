import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screen/service_journey_screen.dart';

/// Local orders prototype for the Figma list, detail, tracking, and cancel flows.
/// No booking or payment endpoint is called from this screen.
class OrdersPrototypeScreen extends StatelessWidget {
  const OrdersPrototypeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocBuilder<PreviewOrdersCubit, List<PreviewOrder>>(
    bloc: sl<PreviewOrdersCubit>(),
    builder: (context, orders) => DefaultTabController(
    length: 4,
    child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
        child: Row(children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.orange),
          const SizedBox(width: 10),
          Expanded(child: Text(AppLocaleKey.orders.tr(),
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900, color: Colors.white))),
          FilledButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const Scaffold(body: SafeArea(child: ServiceJourneyScreen())))),
            style: FilledButton.styleFrom(backgroundColor: AppColors.mint, foregroundColor: AppColors.petrol),
            child: Text(AppLocaleKey.bookService.tr()),
          ),
        ]),
      ),
      TabBar(
        isScrollable: true,
        labelColor: AppColors.petrol,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        tabs: [
          Tab(text: AppLocaleKey.allOrders.tr()),
          Tab(text: AppLocaleKey.orderActive.tr()),
          Tab(text: AppLocaleKey.orderScheduled.tr()),
          Tab(text: AppLocaleKey.orderHistory.tr()),
        ],
      ),
      Expanded(child: TabBarView(children: [
        _list(orders.map(_OrderData.fromPreview).toList()),
        _list(orders.where((o)=>o.statusKey==AppLocaleKey.orderActive).map(_OrderData.fromPreview).toList()),
        _list(orders.where((o)=>o.statusKey==AppLocaleKey.orderScheduled).map(_OrderData.fromPreview).toList()),
        _list(orders.where((o)=>o.statusKey==AppLocaleKey.serviceComplete||o.statusKey==AppLocaleKey.requestCancelled).map(_OrderData.fromPreview).toList()),
      ])),
    ]),
  ));

  Widget _list(List<_OrderData> orders) {
    if (orders.isEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.receipt_long_outlined, size: 54, color: AppColors.petrol),
          const SizedBox(height: 14),
          Text(AppLocaleKey.noOrdersYet.tr(), textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.petrol, fontSize: 18, fontWeight: FontWeight.w800)),
        ]),
      ));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 118),
      children: orders.map((order) => _OrderCard(
        data: order,
        onTap: (context) => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => OrderDetailsScreen(data: order))),
      )).toList(),
    );
  }
}

class _OrderData {
  const _OrderData(this.titleKey, this.reference, this.statusKey, this.icon, this.amount, this.scheduledAt, this.locationKey, this.preview);
  factory _OrderData.fromPreview(PreviewOrder order) => _OrderData(
    order.serviceKey, order.reference, order.statusKey, Icons.home_repair_service_outlined,
    order.amount.toStringAsFixed(2), order.scheduledAt, order.locationKey, order);
  final PreviewOrder preview;
  final DateTime scheduledAt;
  final String locationKey;
  final String titleKey;
  final String reference;
  final String statusKey;
  final IconData icon;
  final String amount;
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.data, required this.onTap});
  final _OrderData data;
  final void Function(BuildContext) onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white.withValues(alpha: .95),
    margin: const EdgeInsets.only(bottom: 13),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    child: InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => onTap(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            CircleAvatar(backgroundColor: AppColors.mint, child: Icon(data.icon, color: AppColors.petrol)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(data.titleKey.tr(), textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.petrol)),
              const SizedBox(height: 4),
              Text(data.locationKey.tr(),
                textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            ])),
            const Icon(Icons.chevron_left, color: AppColors.petrol),
          ]),
          const Divider(height: 22),
          Row(children: [
            Text(data.reference, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
            const Spacer(),
            Chip(label: Text(data.statusKey.tr()), backgroundColor: AppColors.mint, side: BorderSide.none),
          ]),
          Row(children: [
            Text(data.amount + ' ' + AppLocaleKey.currencySar.tr(),
              style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w900)),
            const Spacer(),
            Text(AppLocaleKey.orderDetails.tr(),
              style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w800)),
          ]),
        ]),
      ),
    ),
  );
}

/// Details state includes the review, tracking, cancellation confirmation,
/// and cancellation result screens represented in Resident App.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.data});
  final _OrderData data;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _cancelled = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.sand,
    body: Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        stops: [0, .3, .65, 1],
        colors: [Color(0xFF073B43), Color(0xFF0F6570), Color(0xFFDDF3EE), Color(0xFFFFF9EF)],
      )),
      child: SafeArea(child: _cancelled ? _cancelResult(context) : _details(context)),
    ),
  );

  Widget _details(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
    children: [
      Row(children: [
        IconButton(onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.chevron_left, color: Colors.white)),
        const Spacer(),
        Text(AppLocaleKey.orderDetails.tr(), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
      ]),
      const SizedBox(height: 12),
      _panel([
        Row(children: [
          CircleAvatar(backgroundColor: AppColors.mint, child: Icon(widget.data.icon, color: AppColors.petrol)),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(widget.data.titleKey.tr(), style: const TextStyle(color: AppColors.petrol, fontSize: 18, fontWeight: FontWeight.w900)),
            Text(widget.data.reference, style: const TextStyle(color: AppColors.muted)),
          ]),
        ]),
        const Divider(height: 24),
        _row(AppLocaleKey.orderStatus.tr(), widget.data.statusKey.tr()),
        _row(AppLocaleKey.orderPlace.tr(), widget.data.locationKey.tr()),
        _row(AppLocaleKey.orderDate.tr(), DateFormat.yMd(context.locale.toString()).add_jm().format(widget.data.scheduledAt)),
        _row(AppLocaleKey.orderAmount.tr(), widget.data.amount + ' ' + AppLocaleKey.currencySar.tr()),
      ]),
      _panel([
        Text(AppLocaleKey.orderProgress.tr(), textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.petrol, fontSize: 17, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        _progressStep(AppLocaleKey.requestSent, true),
        _progressStep(AppLocaleKey.providerAccepted, widget.data.statusKey != AppLocaleKey.orderScheduled),
        _progressStep(AppLocaleKey.technicianOnWay, widget.data.statusKey == AppLocaleKey.orderActive || widget.data.statusKey == AppLocaleKey.serviceComplete),
        _progressStep(AppLocaleKey.serviceComplete, widget.data.statusKey == AppLocaleKey.serviceComplete),
      ]),
      FilledButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => Scaffold(body: SafeArea(child: ServiceJourneyScreen(startOnTracking: true, order: widget.data.preview))))),
        icon: const Icon(Icons.location_searching_rounded),
        label: Text(AppLocaleKey.trackOrder.tr()),
        style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52)),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => Scaffold(body: SafeArea(child: ServiceJourneyScreen(startOnInvoice: true, order: widget.data.preview))))),
        icon: const Icon(Icons.receipt_long_outlined),
        label: Text(AppLocaleKey.invoice.tr()),
        style: OutlinedButton.styleFrom(foregroundColor: AppColors.petrol, minimumSize: const Size.fromHeight(50)),
      ),
      if (widget.data.statusKey != AppLocaleKey.serviceComplete && widget.data.statusKey != AppLocaleKey.requestCancelled) ...[
        const SizedBox(height: 8),
        TextButton(
          onPressed: _confirmCancel,
          child: Text(AppLocaleKey.cancelBooking.tr(), style: const TextStyle(color: Colors.red)),
        ),
      ],
    ],
  );

  Widget _cancelResult(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(28),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      const CircleAvatar(radius: 44, backgroundColor: AppColors.mint, child: Icon(Icons.check_rounded, size: 42, color: AppColors.petrol)),
      const SizedBox(height: 18),
      Text(AppLocaleKey.bookingCancelled.tr(), textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.petrol, fontSize: 22, fontWeight: FontWeight.w900)),
      const SizedBox(height: 20),
      FilledButton(onPressed: () => Navigator.maybePop(context), child: Text(AppLocaleKey.close.tr())),
    ]),
  ));

  Widget _panel(List<Widget> children) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .96), borderRadius: BorderRadius.circular(22)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(children: [
      Expanded(child: Text(value, textAlign: TextAlign.left, style: const TextStyle(color: AppColors.petrol, fontWeight: FontWeight.w700))),
      const SizedBox(width: 10),
      Text(label, textAlign: TextAlign.right, style: const TextStyle(color: AppColors.muted)),
    ]),
  );

  Widget _progressStep(String labelKey, bool done) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(done ? Icons.check_circle : Icons.radio_button_unchecked, color: done ? Colors.green : AppColors.muted, size: 18),
      const SizedBox(width: 10),
      Expanded(child: Text(labelKey.tr(), textAlign: TextAlign.right, style: TextStyle(color: done ? AppColors.petrol : AppColors.muted))),
    ]),
  );

  Future<void> _confirmCancel() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocaleKey.cancelOrderTitle.tr()),
        content: Text(AppLocaleKey.cancelOrderQuestion.tr()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocaleKey.keepBooking.tr())),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocaleKey.cancel.tr())),
        ],
      ),
    );
    if (approved == true && mounted) {
      sl<PreviewOrdersCubit>().cancel(widget.data.reference);
      setState(() => _cancelled = true);
    }
  }
}
