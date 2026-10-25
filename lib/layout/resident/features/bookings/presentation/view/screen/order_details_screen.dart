import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/preview_orders_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/order_cancel_result.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/order_details_view.dart';
import 'package:rounder_application/layout/resident/features/post_service/presentation/view/screen/aftercare_flow.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screen/service_journey_screen.dart';

/// Details state includes the review, tracking, cancellation confirmation,
/// and cancellation result screens represented in Resident App.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.data});

  final OrderData data;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool _cancelled = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.sand,
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .3, .65, 1],
          colors: [
            AppColors.petrol,
            AppColors.teal,
            AppColors.mint,
            AppColors.sand,
          ],
        ),
      ),
      child: SafeArea(
        child: _cancelled
            ? OrderCancelResult(onClose: () => Navigator.maybePop(context))
            : OrderDetailsView(
                data: widget.data,
                onBack: () => Navigator.maybePop(context),
                onTrack: _openTracking,
                onInvoice: _openInvoice,
                onWarranty: _openWarranty,
                onCancel: _confirmCancel,
              ),
      ),
    ),
  );

  void _openTracking() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: SafeArea(
            child: ServiceJourneyScreen(
              startOnTracking: true,
              order: widget.data.preview,
            ),
          ),
        ),
      ),
    );
  }

  void _openInvoice() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: SafeArea(
            child: ServiceJourneyScreen(
              startOnInvoice: true,
              order: widget.data.preview,
            ),
          ),
        ),
      ),
    );
  }

  void _openWarranty() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(
          body: SafeArea(child: AftercareFlowScreen()),
        ),
      ),
    );
  }

  Future<void> _confirmCancel() async {
    final approved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocaleKey.cancelOrderTitle.tr()),
        content: Text(AppLocaleKey.cancelOrderQuestion.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocaleKey.keepBooking.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocaleKey.cancel.tr()),
          ),
        ],
      ),
    );
    if (approved == true && mounted) {
      sl<PreviewOrdersCubit>().cancel(widget.data.reference);
      setState(() => _cancelled = true);
    }
  }
}
