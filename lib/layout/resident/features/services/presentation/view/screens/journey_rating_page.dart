import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_action_button.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';

/// Rating step: stars, note, quick-feedback tags and the skip entry. The star
/// selection validates inline under the stars (rounder-validation) — no
/// snackbar. `onSend` carries `{rating, comment, tags}` to the journey.
class JourneyRatingPage extends StatefulWidget {
  const JourneyRatingPage({
    super.key,
    required this.onBack,
    required this.providerLabel,
    required this.stars,
    required this.notes,
    required this.tags,
    required this.selectedTags,
    required this.onStar,
    required this.onTagToggle,
    required this.onSend,
    required this.onLater,
  });

  final VoidCallback onBack;
  final String providerLabel;
  final int stars;
  final TextEditingController notes;

  /// Quick-feedback tag keys (AppLocaleKey) shown as multi-select chips;
  /// what is displayed is what the payload's `tags` carry.
  final List<String> tags;
  final List<String> selectedTags;
  final ValueChanged<int> onStar;
  final ValueChanged<String> onTagToggle;
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
            // The rating design's "Quick feedback" row: three selectable
            // chips — multi-select, sent as the payload's `tags` exactly as
            // they are displayed.
            Row(
              children: [
                for (final String tag in widget.tags) ...[
                  if (tag != widget.tags.first) const SizedBox(width: 8),
                  Expanded(
                    child: _RatingTagChip(
                      labelKey: tag,
                      selected: widget.selectedTags.contains(tag),
                      onTap: () => widget.onTagToggle(tag),
                    ),
                  ),
                ],
              ],
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

/// One quick-feedback chip of the rating step (the design's "Quick feedback"
/// row): outlined neutral, petrol-filled once picked.
class _RatingTagChip extends StatelessWidget {
  const _RatingTagChip({
    required this.labelKey,
    required this.selected,
    required this.onTap,
  });

  final String labelKey;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: selected ? AppColors.petrol : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: selected ? AppColors.petrol : AppColors.mint),
      ),
      child: Text(
        labelKey.tr(),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.captionBold13.copyWith(
          color: selected ? AppColors.white : AppColors.petrol,
        ),
      ),
    ),
  );
}
