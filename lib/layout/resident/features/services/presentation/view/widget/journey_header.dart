import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Title bar shared by all service journey pages.
class JourneyHeader extends StatelessWidget {
  const JourneyHeader({
    super.key,
    required this.titleKey,
    this.onBack,
    this.backButton = true,
  }) : assert(!backButton || onBack != null);

  final String titleKey;
  final VoidCallback? onBack;
  final bool backButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
      child: Row(
        children: [
          if (backButton)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left, color: Colors.white),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          Text(
            titleKey.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          if (!backButton)
            const Icon(
              Icons.home_repair_service_outlined,
              color: Colors.white,
            ),
        ],
      ),
    );
  }
}
