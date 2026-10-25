import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Confirmation state of the emergency request with the generated reference.
class EmergencySuccessView extends StatelessWidget {
  const EmergencySuccessView({
    super.key,
    required this.reference,
    required this.onClose,
  });

  final String reference;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircleAvatar(radius: 44, backgroundColor: AppColors.mint, child: Icon(Icons.mark_email_read_outlined, color: AppColors.petrol, size: 42)),
          const SizedBox(height: 18),
          Text(AppLocaleKey.emergencyReceived.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.petrol)),
          const SizedBox(height: 8),
          Text(AppLocaleKey.emergencyReference.tr(), style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(reference, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 24),
          FilledButton(onPressed: onClose, child: Text(AppLocaleKey.emergencyClose.tr())),
        ]),
      ),
    );
  }
}
