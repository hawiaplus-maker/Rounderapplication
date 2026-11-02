import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Conversation card of the Ali assist page (Figma 382:448): Ali greeting
/// bubble over the description field, the clarifying question with its two
/// reply chips, the photo hint, the chat composer and the technician note.
///
/// The description is the booking note (`issue`); chips toggle the request
/// kind; `onPrototypeAction` reports the out-of-prototype actions (sending a
/// chat message / recording voice) so the page can toast.
class AliAssistPanel extends StatelessWidget {
  const AliAssistPanel({
    super.key,
    required this.issue,
    required this.issueType,
    required this.onIssueTypeChanged,
    required this.onAddPhotos,
    this.photoCount = 0,
    required this.onPrototypeAction,
  });

  final TextEditingController issue;
  final String issueType;
  final ValueChanged<String> onIssueTypeChanged;
  final VoidCallback onAddPhotos;

  /// Photos already attached on this step (count badge only).
  final int photoCount;
  final VoidCallback onPrototypeAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassCardFill,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassCardStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocaleKey.aliAssistant.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.captionBold.copyWith(color: AppColors.teal),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocaleKey.aliProblemBubble.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold17.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 12),
          _DescriptionField(issue: issue),
          const SizedBox(height: 12),
          Text(
            AppLocaleKey.aliClarify.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold15.copyWith(color: AppColors.petrol),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ReplyChip(
                label: AppLocaleKey.problemCheck.tr(),
                selected: issueType == AppLocaleKey.problemCheck,
                onSelected: (_) => onIssueTypeChanged(AppLocaleKey.problemCheck),
              ),
              _ReplyChip(
                label: AppLocaleKey.periodicService.tr(),
                selected: issueType == AppLocaleKey.periodicService,
                onSelected: (_) => onIssueTypeChanged(AppLocaleKey.periodicService),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _PhotoHint(onAddPhotos: onAddPhotos, photoCount: photoCount),
          const SizedBox(height: 12),
          _MessageComposer(onPrototypeAction: onPrototypeAction),
          const SizedBox(height: 12),
          Text(
            AppLocaleKey.aliTechNote.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.captionRegular.copyWith(color: AppColors.teal),
          ),
        ],
      ),
    );
  }
}

/// Mint multi-line description box (Figma 382:483): what the resident noticed.
class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.issue});

  final TextEditingController issue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 6),
      constraints: const BoxConstraints(minHeight: 68),
      decoration: BoxDecoration(
        color: AppColors.mintLight,
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: TextField(
        controller: issue,
        minLines: 2,
        maxLines: 4,
        textAlign: TextAlign.start,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.petrol),
        decoration: InputDecoration(
          isCollapsed: true,
          border: InputBorder.none,
          hintText: AppLocaleKey.problemHint.tr(),
          hintStyle: AppTextStyles.bodySmall.copyWith(
            color: AppColors.petrol.withValues(alpha: .55),
          ),
        ),
      ),
    );
  }
}

/// Reply chip (Figma 382:487 / 382:489): mint plate; the selected one scores
/// an orange outline with a coral label, the idle one stays petrol.
class _ReplyChip extends StatelessWidget {
  const _ReplyChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mintLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: selected
            ? const BorderSide(color: AppColors.coral)
            : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => onSelected(true),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 12, vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyBold17.copyWith(
              color: selected ? AppColors.coral : AppColors.petrol,
            ),
          ),
        ),
      ),
    );
  }
}

/// Photo row (Figma 382:491): camera glyph plus the hint, and the picked
/// photo names re-shown as compact thumbnails of this step.
class _PhotoHint extends StatelessWidget {
  const _PhotoHint({required this.onAddPhotos, required this.photoCount});

  final VoidCallback onAddPhotos;
  final int photoCount;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAddPhotos,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(
              AppImages.homeCamera,
              size: 24,
              color: AppColors.petrol,
              semanticLabel: AppLocaleKey.addPhotos.tr(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocaleKey.aliPhotoHint.tr(),
                textAlign: TextAlign.start,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.petrol),
              ),
            ),
            if (photoCount > 0) ...[
              const SizedBox(width: 12),
              Text(
                photoCount.toString(),
                style: AppTextStyles.bodyBold15.copyWith(color: AppColors.coral),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chat composer (Figma 385:462): white message field with hint plus the mint
/// voice button. Owns its private controller; sending/voice are prototype
/// actions reported through [AliAssistPanel.onPrototypeAction].
class _MessageComposer extends StatefulWidget {
  const _MessageComposer({required this.onPrototypeAction});

  final VoidCallback onPrototypeAction;

  @override
  State<_MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<_MessageComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 56,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.glassCardStroke),
            ),
            alignment: AlignmentDirectional.centerStart,
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => widget.onPrototypeAction(),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.petrol),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                hintText: AppLocaleKey.aliMessageHint.tr(),
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.petrol.withValues(alpha: .65),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppColors.mintLight,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPrototypeAction,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Center(
                child: SvgIcon(AppImages.homeMic, size: 20, color: AppColors.petrol),
              ),
            ),
          ),
        ),
      ],
    );
  }
}