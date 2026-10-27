import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_header.dart';

/// Service catalog: greeting, search and the two service categories.
class JourneyCatalogPage extends StatelessWidget {
  const JourneyCatalogPage({
    super.key,
    required this.query,
    required this.onQueryChanged,
    required this.onSelectService,
  });

  final TextEditingController query;
  final VoidCallback onQueryChanged;
  final ValueChanged<String> onSelectService;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('service-catalog'),
      padding: EdgeInsets.zero,
      children: [
        const JourneyHeader(
          titleKey: AppLocaleKey.catalogTitle,
          backButton: false,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Text(
            AppLocaleKey.greetingAli.tr(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: query,
            onChanged: (_) => onQueryChanged(),
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: AppLocaleKey.searchHint.tr(),
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: _CategoryCard(
                  titleKey: AppLocaleKey.maintenance,
                  icon: Icons.build_outlined,
                  choices: const [
                    AppLocaleKey.plumbing,
                    AppLocaleKey.electrical,
                    AppLocaleKey.airConditioning,
                  ],
                  query: query.text,
                  onSelect: onSelectService,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CategoryCard(
                  titleKey: AppLocaleKey.generalServices,
                  icon: Icons.grid_view_outlined,
                  choices: const [
                    AppLocaleKey.cleaning,
                    AppLocaleKey.fixedPriceService,
                  ],
                  query: query.text,
                  onSelect: onSelectService,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            AppLocaleKey.prototypeData.tr(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.titleKey,
    required this.icon,
    required this.choices,
    required this.query,
    required this.onSelect,
  });

  final String titleKey;
  final IconData icon;
  final List<String> choices;
  final String query;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final normalizedQuery = query.trim().toLowerCase();
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Icon(icon, color: AppColors.orange, size: 27),
          const SizedBox(height: 12),
          Text(
            titleKey.tr(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.petrol,
            ),
          ),
          const Divider(),
          ...choices
              .where(
                (key) => key.tr().toLowerCase().contains(normalizedQuery),
              )
              .map(
                (key) => TextButton(
                  onPressed: () => onSelect(key),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      key.tr(),
                      style: const TextStyle(color: AppColors.petrol),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
