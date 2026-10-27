import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/assessment_card.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/property_rating_facilities_button.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/property_rating_header.dart';

/// Property rating (تقييم العقار — design 536:949). Local prototype: renders
/// the approved summary card with the design score. Reached from the units
/// screen's view-unit pill. The facilities entry leads back to account routes
/// in the live app; here it returns to the previous screen.
class PropertyRatingScreen extends StatelessWidget {
  const PropertyRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrandGradientBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            children: [
              PropertyRatingHeader(onBack: () => Navigator.maybePop(context)),
              const SizedBox(height: 14),
              AssessmentCard(
                unitLine:
                    '${AppLocaleKey.unitTitle.tr()} • ${AppLocaleKey.unitRowPalm.tr()}',
                score: AppLocaleKey.unitScore87.tr(),
                summaryTitle: AppLocaleKey.ratingSummaryTitle.tr(),
                residentialLine:
                    '${AppLocaleKey.residentialStatePrefix.tr()} ${AppLocaleKey.stateExcellent.tr()}',
                facilitiesLine:
                    '${AppLocaleKey.facilityStatePrefix.tr()} ${AppLocaleKey.stateGood.tr()}',
                pendingNote: AppLocaleKey.ratingPendingNote.tr(),
              ),
              const SizedBox(height: 14),
              PropertyRatingFacilitiesButton(
                onPressed: () => Navigator.maybePop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
