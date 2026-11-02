import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_intro_card.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_service_pill.dart';

/// A single category's service list (Figma 511:814 "الخدمات / العامة" and
/// 511:813 "الخدمات / الصيانة"): back header, intro card, then one glass
/// panel of mint service pills; a pill starts the booking journey.
///
/// Items are the API services of [category], already localized there, so a
/// real sub-service pick lands on the detail step with its id.
class JourneyCategoryPage extends StatelessWidget {
  const JourneyCategoryPage({
    super.key,
    required this.category,
    required this.onBack,
    required this.onSelectService,
  });

  final ServiceCategory category;
  final VoidCallback onBack;
  final ValueChanged<ServiceItem> onSelectService;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      // The API-localized category name is not an AppLocaleKey; `JourneySubPage`
      // runs the title through tr(), which passes unknown keys unchanged.
      titleKey: category.name,
      onBack: onBack,
      children: [
        JourneyIntroCard(message: AppLocaleKey.chooseServiceDetails.tr()),
        if (category.services.isEmpty)
          StatePanel(message: AppLocaleKey.noServices.tr())
        else
          JourneyPanel(
            children: category.services.map((service) {
              return JourneyServicePill(
                label: service.name,
                onTap: () => onSelectService(service),
              );
            }).toList(),
          ),
      ],
    );
  }
}
