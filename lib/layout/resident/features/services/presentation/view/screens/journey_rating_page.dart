import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Rating step: stars, note and the skip entry.
class JourneyRatingPage extends StatelessWidget {
  const JourneyRatingPage({
    super.key,
    required this.onBack,
    required this.providerLabel,
    required this.stars,
    required this.notes,
    required this.onStar,
    required this.onSend,
    required this.onLater,
  });

  final VoidCallback onBack;
  final String providerLabel;
  final int stars;
  final TextEditingController notes;
  final ValueChanged<int> onStar;
  final VoidCallback onSend;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.rateExperience,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.ratingPrompt.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Text(providerLabel, textAlign: TextAlign.right),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => onStar(index + 1),
                  icon: Icon(
                    Icons.star_rounded,
                    color: index < stars ? AppColors.orange : AppColors.muted,
                    size: 33,
                  ),
                ),
              ),
            ),
            TextField(
              controller: notes,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: AppLocaleKey.ratingNote.tr(),
              ),
            ),
            const SizedBox(height: 8),
            JourneyActionButton(
              labelKey: AppLocaleKey.sendRating,
              icon: Icons.send_outlined,
              onAction: onSend,
            ),
            TextButton(
              onPressed: onLater,
              child: Text(AppLocaleKey.later.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
