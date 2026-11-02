import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_header.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/ali_assist_hero.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/ali_assist_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_next_button.dart';

/// Ali assisted-booking step (Figma 382:448 "علي يساعدك"): the listening
/// artwork, the problem conversation (description + replies + photos +
/// composer over the technician note) and the fixed "جهّز ملخص الطلب" action.
///
/// The Ali summary step (Booking 01.B/01.C) stays in the design: booking needs
/// a real service id, so preparing the summary hands the conversation over to
/// the service picking screen (all services → booking journey) with the
/// description already typed.
class JourneyAliAssistPage extends StatelessWidget {
  const JourneyAliAssistPage({
    super.key,
    required this.onBack,
    required this.onPrepareSummary,
    required this.onPrototypeAction,
    required this.issue,
    required this.issueType,
    required this.onIssueTypeChanged,
    required this.onAddPhotos,
    required this.photoCount,
  });

  final VoidCallback onBack;
  final VoidCallback onPrepareSummary;
  final VoidCallback onPrototypeAction;
  final TextEditingController issue;
  final String issueType;
  final ValueChanged<String> onIssueTypeChanged;
  final VoidCallback onAddPhotos;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('ali-assist'),
      padding: EdgeInsets.zero,
      children: [
        JourneyHeader(titleKey: AppLocaleKey.aliAtYourCommand, onBack: onBack),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AliAssistHero(),
              const SizedBox(height: 12),
              AliAssistPanel(
                issue: issue,
                issueType: issueType,
                onIssueTypeChanged: onIssueTypeChanged,
                onAddPhotos: onAddPhotos,
                photoCount: photoCount,
                onPrototypeAction: onPrototypeAction,
              ),
              const SizedBox(height: 12),
              JourneyNextButton(
                labelKey: AppLocaleKey.prepareSummary,
                onPressed: onPrepareSummary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}