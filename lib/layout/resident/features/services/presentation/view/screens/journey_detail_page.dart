import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';

/// Service details step: problem description, issue type and photos entry.
class JourneyDetailPage extends StatelessWidget {
  const JourneyDetailPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    this.subServices = const [],
    this.selectedSubServiceId,
    this.onSubServiceChanged,
    required this.issue,
    required this.issueType,
    required this.onIssueTypeChanged,
    required this.onAddPhotos,
    required this.photos,
    required this.onNext,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final List<ServiceSubItem> subServices;
  final int? selectedSubServiceId;
  final ValueChanged<int?>? onSubServiceChanged;
  final TextEditingController issue;
  final String issueType;
  final ValueChanged<String> onIssueTypeChanged;
  final VoidCallback onAddPhotos;

  /// Photos the resident already attached through the source chooser; shown
  /// as thumbnails on this same step (no page change).
  final List<XFile> photos;
  final VoidCallback onNext;

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
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.petrol,
                        ),
                      ),
                      Text(
                        AppLocaleKey.describeProblem.tr(),
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              serviceKey,
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold18.copyWith(color: AppColors.petrol),
            ),
            if (subServices.isNotEmpty) ...[
              const SizedBox(height: 10),
              JourneyPanel(
                children: [
                  Text(
                    AppLocaleKey.issueType.tr(),
                    textAlign: TextAlign.start,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.petrol,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: subServices
                        .map(
                          (s) => ChoiceChip(
                            label: Text(s.name ?? ''),
                            selected: selectedSubServiceId == s.id,
                            onSelected: (_) => onSubServiceChanged?.call(s.id),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        JourneyPanel(
          children: [
            TextField(
              controller: issue,
              maxLines: 3,
              textAlign: TextAlign.start,
              decoration: InputDecoration(hintText: AppLocaleKey.problemHint.tr()),
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.addPhotos,
          icon: Icons.add_a_photo_outlined,
          onAction: onAddPhotos,
        ),
        if (photos.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final photo in photos)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(File(photo.path), width: 72, height: 72, fit: BoxFit.cover),
                ),
            ],
          ),
        ],
        JourneyNextButton(labelKey: AppLocaleKey.nextProviders, onPressed: onNext),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
      ],
    );
  }
}
