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
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_sub_services_section.dart';
import 'package:rounder_application/layout/resident/features/services/validation/services_validators.dart';

/// Service details step: problem description, issue type and photos entry.
/// The problem text validates inline under the field (rounder-validation) —
/// no snackbar.
class JourneyDetailPage extends StatefulWidget {
  const JourneyDetailPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    this.subServices = const [],
    this.selectedSubServiceId,
    this.onSubServiceChanged,
    this.subServicesHasMore = false,
    this.subServicesLoading = false,
    this.onLoadMoreSubServices,
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

  /// Further pages of [subServices] may exist — [onLoadMoreSubServices]
  /// fetches the next one while [subServicesLoading] is in flight.
  final bool subServicesHasMore;
  final bool subServicesLoading;
  final VoidCallback? onLoadMoreSubServices;
  final TextEditingController issue;
  final String issueType;
  final ValueChanged<String> onIssueTypeChanged;
  final VoidCallback onAddPhotos;

  /// Photos the resident already attached through the source chooser; shown
  /// as thumbnails on this same step (no page change).
  final List<XFile> photos;
  final VoidCallback onNext;

  @override
  State<JourneyDetailPage> createState() => _JourneyDetailPageState();
}

class _JourneyDetailPageState extends State<JourneyDetailPage> {
  /// Inline validation of the problem description: the first failed
  /// "next" reveals the message under the field, then typing re-validates
  /// live so the note disappears as the text becomes valid.
  final _formKey = GlobalKey<FormState>();
  bool _submitted = false;

  void _next() {
    setState(() => _submitted = true);
    final ok = _formKey.currentState?.validate() ?? false;
    if (ok) widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.serviceDetails,
      onBack: widget.onBack,
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
                        style: AppTextStyles.extraBold16.copyWith(
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
              widget.serviceKey,
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold18.copyWith(color: AppColors.petrol),
            ),
            const SizedBox(height: 10),
            JourneyPanel(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: widget.issue,
                    maxLines: 3,
                    textAlign: TextAlign.start,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    decoration: InputDecoration(hintText: AppLocaleKey.problemHint.tr()),
                    validator: ServicesValidators.issue,
                  ),
                ),
              ],
            ),
            JourneyActionButton(
              labelKey: AppLocaleKey.addPhotos,
              icon: Icons.add_a_photo_outlined,
              onAction: widget.onAddPhotos,
            ),
            if (widget.photos.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final photo in widget.photos)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(photo.path), width: 72, height: 72, fit: BoxFit.cover),
                    ),
                ],
              ),
            ],

            if (widget.subServices.isNotEmpty) ...[
              const SizedBox(height: 10),
              JourneySubServicesSection(
                subServices: widget.subServices,
                selectedSubServiceId: widget.selectedSubServiceId,
                onSubServiceChanged: widget.onSubServiceChanged,
                hasMore: widget.subServicesHasMore,
                loading: widget.subServicesLoading,
                onLoadMore: widget.onLoadMoreSubServices,
              ),
            ],
          ],
        ),

        JourneyNextButton(labelKey: AppLocaleKey.nextProviders, onPressed: _next),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
      ],
    );
  }
}
