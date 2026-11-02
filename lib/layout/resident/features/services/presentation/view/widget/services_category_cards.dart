import 'package:flutter/material.dart';

import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/services_category_card.dart';
import 'package:rounder_application/logic/service_category_logic.dart';

/// The category cards of the services hub (Figma 298:251): rows of at most
/// two cards with the frame's 12px gutter; odd cards fill the row alone.
///
/// Card subtitles come from the API services list through
/// [serviceCategorySubtitle] (lib/logic).
class ServicesCategoryCards extends StatelessWidget {
  const ServicesCategoryCards({
    super.key,
    required this.categories,
    required this.onCategory,
  });

  final List<ServiceCategory> categories;
  final ValueChanged<ServiceCategory> onCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < categories.length; i += 2) ...[
          _CategoryRow(
            categories: categories.sublist(i, (i + 2).clamp(0, categories.length)),
            onCategory: onCategory,
          ),
          if (i + 2 < categories.length) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.categories, required this.onCategory});

  final List<ServiceCategory> categories;
  final ValueChanged<ServiceCategory> onCategory;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 264),
        child: Row(
          children: [
            for (int i = 0; i < categories.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: ServicesCategoryCard(
                  name: categories[i].name,
                  subtitle: serviceCategorySubtitle(categories[i].services),
                  onTap: () => onCategory(categories[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}