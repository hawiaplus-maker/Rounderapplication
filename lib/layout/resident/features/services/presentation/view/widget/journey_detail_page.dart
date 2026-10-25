import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_page.dart';

/// Service details step: problem description, issue type and photos entry.
class JourneyDetailPage extends StatelessWidget {
  const JourneyDetailPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    required this.issue,
    required this.issueType,
    required this.onIssueTypeChanged,
    required this.onAddPhotos,
    required this.onNext,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final TextEditingController issue;
  final String issueType;
  final ValueChanged<String> onIssueTypeChanged;
  final VoidCallback onAddPhotos;
  final VoidCallback onNext;

  static const _issueTypes = <String>[
    AppLocaleKey.waterLeak,
    AppLocaleKey.drainBlock,
    AppLocaleKey.installation,
    AppLocaleKey.notSure,
  ];

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.serviceDetails,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.mint,
                  child: Icon(Icons.support_agent, color: AppColors.petrol),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        AppLocaleKey.greetingAli.tr(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.petrol,
                        ),
                      ),
                      Text(
                        AppLocaleKey.describeProblem.tr(),
                        style: const TextStyle(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              serviceKey.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextField(
              controller: issue,
              maxLines: 3,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: AppLocaleKey.problemHint.tr(),
              ),
            ),
          ],
        ),
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.issueType.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: _issueTypes
                  .map(
                    (key) => ChoiceChip(
                      label: Text(key.tr()),
                      selected: issueType == key,
                      onSelected: (_) => onIssueTypeChanged(key),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.addPhotos,
          icon: Icons.add_a_photo_outlined,
          onAction: onAddPhotos,
        ),
        JourneyNextButton(
          labelKey: AppLocaleKey.nextProviders,
          onPressed: onNext,
        ),
      ],
    );
  }
}
