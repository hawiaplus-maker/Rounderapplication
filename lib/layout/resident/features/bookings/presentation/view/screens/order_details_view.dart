import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/model/order_data.dart';

/// Details, progress and actions of one order.
class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({
    super.key,
    required this.data,
    required this.onBack,
    required this.onTrack,
    required this.onInvoice,
    required this.onWarranty,
    required this.onCancel,
  });

  final OrderData data;
  final VoidCallback onBack;
  final VoidCallback onTrack;
  final VoidCallback onInvoice;
  final VoidCallback onWarranty;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: AppColors.white),
            ),
            const Spacer(),
            Text(
              AppLocaleKey.orderDetails.tr(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _Panel(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.mint,
                  child: Icon(data.icon, color: AppColors.petrol),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data.titleKey.tr(),
                      style: const TextStyle(
                        color: AppColors.petrol,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      data.reference,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            _DetailRow(
              label: AppLocaleKey.orderStatus.tr(),
              value: data.statusKey.tr(),
            ),
            _DetailRow(
              label: AppLocaleKey.orderPlace.tr(),
              value: data.locationKey.tr(),
            ),
            _DetailRow(
              label: AppLocaleKey.orderDate.tr(),
              value: DateFormat.yMd(
                context.locale.toString(),
              ).add_jm().format(data.scheduledAt),
            ),
            _DetailRow(
              label: AppLocaleKey.orderAmount.tr(),
              value: '${data.amount} ${AppLocaleKey.currencySar.tr()}',
            ),
          ],
        ),
        _Panel(
          children: [
            Text(
              AppLocaleKey.orderProgress.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            _ProgressStep(labelKey: AppLocaleKey.requestSent, done: true),
            _ProgressStep(
              labelKey: AppLocaleKey.providerAccepted,
              done: data.statusKey != AppLocaleKey.orderScheduled,
            ),
            _ProgressStep(
              labelKey: AppLocaleKey.technicianOnWay,
              done:
                  data.statusKey == AppLocaleKey.orderActive ||
                  data.statusKey == AppLocaleKey.serviceComplete,
            ),
            _ProgressStep(
              labelKey: AppLocaleKey.serviceComplete,
              done: data.statusKey == AppLocaleKey.serviceComplete,
            ),
          ],
        ),
        FilledButton.icon(
          onPressed: onTrack,
          icon: const Icon(Icons.location_searching_rounded),
          label: Text(AppLocaleKey.trackOrder.tr()),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: AppColors.white,
            minimumSize: const Size.fromHeight(52),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onInvoice,
          icon: const Icon(Icons.receipt_long_outlined),
          label: Text(AppLocaleKey.invoice.tr()),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.petrol,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        if (data.statusKey == AppLocaleKey.serviceComplete) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onWarranty,
            icon: const Icon(Icons.verified_outlined),
            label: Text(AppLocaleKey.warranty.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.teal,
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
        if (data.statusKey != AppLocaleKey.serviceComplete &&
            data.statusKey != AppLocaleKey.requestCancelled) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: onCancel,
            child: Text(
              AppLocaleKey.cancelBooking.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: AppColors.white.withValues(alpha: .96),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(
      children: [
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: AppColors.petrol,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({required this.labelKey, required this.done});

  final String labelKey;
  final bool done;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(
          done ? Icons.check_circle : Icons.radio_button_unchecked,
          color: done ? Colors.green : AppColors.muted,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            labelKey.tr(),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: done ? AppColors.petrol : AppColors.muted,
            ),
          ),
        ),
      ],
    ),
  );
}
