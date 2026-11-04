import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Rating step: stars, note and the skip entry. The star selection validates
/// inline under the stars (rounder-validation) — no snackbar.
class JourneyRatingPage extends StatefulWidget {
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
  State<JourneyRatingPage> createState() => _JourneyRatingPageState();
}

class _JourneyRatingPageState extends State<JourneyRatingPage> {
  bool _sendPressed = false;

  void _send() {
    if (widget.stars == 0) {
      setState(() => _sendPressed = true);
      return;
    }
    widget.onSend();
  }

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.rateExperience,
      onBack: widget.onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              AppLocaleKey.ratingPrompt.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold22.copyWith(color: AppColors.petrol),
            ),
            Text(widget.providerLabel, textAlign: TextAlign.start),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => widget.onStar(index + 1),
                  icon: Icon(
                    Icons.star_rounded,
                    color: index < widget.stars ? AppColors.orange : AppColors.muted,
                    size: 33,
                  ),
                ),
              ),
            ),
            // Inline star-rule message: shown after the first failed send and
            // gone as soon as a star is picked (the count re-evaluates).
            if (_sendPressed && widget.stars == 0)
              Text(
                AppLocaleKey.requiredField.tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.tinyRegular.copyWith(color: AppColors.emergency),
              ),
            TextField(
              controller: widget.notes,
              maxLines: 3,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                hintText: AppLocaleKey.ratingNote.tr(),
              ),
            ),
            const SizedBox(height: 8),
            JourneyActionButton(
              labelKey: AppLocaleKey.sendRating,
              icon: Icons.send_outlined,
              onAction: _send,
            ),
            TextButton(
              onPressed: widget.onLater,
              child: Text(AppLocaleKey.later.tr()),
            ),
          ],
        ),
      ],
    );
  }
}
