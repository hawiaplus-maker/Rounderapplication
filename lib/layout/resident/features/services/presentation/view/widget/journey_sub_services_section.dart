import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';

/// Issue-type panel of the service details step: the service's sub-services
/// as choice chips, plus a load-more button while further paginated pages
/// may exist.
class JourneySubServicesSection extends StatelessWidget {
  const JourneySubServicesSection({
    super.key,
    required this.subServices,
    required this.selectedSubServiceId,
    required this.onSubServiceChanged,
    required this.hasMore,
    required this.loading,
    required this.onLoadMore,
  });

  final List<ServiceSubItem> subServices;
  final int? selectedSubServiceId;
  final ValueChanged<int?>? onSubServiceChanged;
  final bool hasMore;
  final bool loading;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    return JourneyPanel(
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
        if (hasMore && onLoadMore != null)
          _JourneyLoadMoreButton(loading: loading, onLoadMore: onLoadMore!),
      ],
    );
  }
}

class _JourneyLoadMoreButton extends StatelessWidget {
  const _JourneyLoadMoreButton({required this.loading, required this.onLoadMore});

  final bool loading;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonalIcon(
      onPressed: loading ? null : onLoadMore,
      icon: loading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.expand_more),
      label: Text(AppLocaleKey.loadMore.tr()),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mint,
        foregroundColor: AppColors.petrol,
        disabledBackgroundColor: AppColors.mint.withValues(alpha: .55),
        alignment: AlignmentDirectional.center,
      ),
    );
  }
}
