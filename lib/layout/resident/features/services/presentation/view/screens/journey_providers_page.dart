import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Providers step: the available providers for the selected service.
class JourneyProvidersPage extends StatelessWidget {
  const JourneyProvidersPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    required this.onViewCompany,
    required this.onSelectProvider,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final VoidCallback onViewCompany;
  final void Function(String nameKey, double price) onSelectProvider;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.availableProviders,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              serviceKey.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(
              '${AppLocaleKey.myUnit.tr()} • ${AppLocaleKey.flatNumber.tr()}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
          ],
        ),
        _ProviderCard(
          nameKey: AppLocaleKey.providerOne,
          rating: AppLocaleKey.providerOneMeta.tr(),
          price: '150',
          icon: Icons.home_repair_service,
          onViewCompany: onViewCompany,
          onSelect: () => onSelectProvider(AppLocaleKey.providerOne, 150),
        ),
        _ProviderCard(
          nameKey: AppLocaleKey.providerTwo,
          rating: AppLocaleKey.providerTwoMeta.tr(),
          price: '180',
          icon: Icons.handyman_outlined,
          onViewCompany: onViewCompany,
          onSelect: () => onSelectProvider(AppLocaleKey.providerTwo, 180),
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.nameKey,
    required this.rating,
    required this.price,
    required this.icon,
    required this.onViewCompany,
    required this.onSelect,
  });

  final String nameKey;
  final String rating;
  final String price;
  final IconData icon;
  final VoidCallback onViewCompany;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return JourneyPanel(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.petrol,
              child: Icon(icon, color: Colors.white),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  nameKey.tr(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.petrol,
                  ),
                ),
                Text(
                  rating,
                  style: const TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$price ${AppLocaleKey.currencySar.tr()} • ${AppLocaleKey.serviceType.tr()}',
          textAlign: TextAlign.right,
        ),
        Text(
          AppLocaleKey.arrivalInThreeHours.tr(),
          textAlign: TextAlign.right,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onViewCompany,
                child: Text(AppLocaleKey.viewCompany.tr()),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: onSelect,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.orange,
                ),
                child: Text(AppLocaleKey.selectProvider.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
