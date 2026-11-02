import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_intro_card.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_service_pill.dart';

/// All services of the catalog (Figma 554:1006 "الخدمات / جميع الخدمات"):
/// back header, intro card, then one glass card grouping every API category
/// (its name as the section label, its services as mint pills).
class JourneyAllServicesPage extends StatelessWidget {
  const JourneyAllServicesPage({
    super.key,
    required this.categories,
    required this.onBack,
    required this.onSelectService,
  });

  final List<ServiceCategory> categories;
  final VoidCallback onBack;
  final ValueChanged<ServiceItem> onSelectService;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.allServices,
      onBack: onBack,
      children: [
        JourneyIntroCard(message: AppLocaleKey.chooseServiceNeed.tr()),
        if (categories.isEmpty)
          StatePanel(message: AppLocaleKey.noServices.tr())
        else
          JourneyPanel(
            children: [
              for (final category in categories) ..._categorySectionWidgets(
                category: category,
                onSelectService: onSelectService,
              ),
            ],
          ),
      ],
    );
  }
}

/// List of section widgets for one category inside the shared glass card:
/// its label and its pills; empty categories are skipped, and a 24px tail
/// separates sections (0 after the last one is absorbed by panel padding).
List<Widget> _categorySectionWidgets({
  required ServiceCategory category,
  required ValueChanged<ServiceItem> onSelectService,
}) {
  if (category.services.isEmpty) return const <Widget>[];
  return <Widget>[
    const SizedBox(height: 4),
    Text(
      category.name,
      textAlign: TextAlign.start,
      style: AppTextStyles.bodyBold15.copyWith(color: AppColors.petrol),
    ),
    for (final service in category.services) ...[
      const SizedBox(height: 12),
      JourneyServicePill(
        label: service.name,
        onTap: () => onSelectService(service),
      ),
    ],
    const SizedBox(height: 24),
  ];
}