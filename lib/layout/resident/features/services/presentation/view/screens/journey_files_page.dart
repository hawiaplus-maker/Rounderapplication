import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Service files step: uploaded photos/videos and the proof-of-work entry.
class JourneyFilesPage extends StatelessWidget {
  const JourneyFilesPage({
    super.key,
    required this.onBack,
    required this.onAddPhoto,
    required this.onAddVideo,
    required this.onProof,
    required this.photos,
  });

  final VoidCallback onBack;
  final VoidCallback onAddPhoto;
  final VoidCallback onAddVideo;
  final VoidCallback onProof;

  /// Photos attached from the source chooser; the latest one previews here
  /// without leaving the journey.
  final List<XFile> photos;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.serviceFiles,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.uploadHint.tr(),
              textAlign: TextAlign.right,
              style: const TextStyle(color: AppColors.muted),
            ),
            const SizedBox(height: 12),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.mint,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: photos.isEmpty
                  ? const Icon(
                      Icons.image_outlined,
                      size: 42,
                      color: AppColors.petrol,
                    )
                  : Image.file(
                      File(photos.last.path),
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: JourneyActionButton(
                    labelKey: AppLocaleKey.addPhoto,
                    icon: Icons.add_a_photo_outlined,
                    onAction: onAddPhoto,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: JourneyActionButton(
                    labelKey: AppLocaleKey.addVideo,
                    icon: Icons.videocam_outlined,
                    onAction: onAddVideo,
                  ),
                ),
              ],
            ),
          ],
        ),
        JourneyActionButton(
          labelKey: AppLocaleKey.proofOfWork,
          icon: Icons.fact_check_outlined,
          onAction: onProof,
        ),
      ],
    );
  }
}
