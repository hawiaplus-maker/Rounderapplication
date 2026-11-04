import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_layout.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_category_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/service_catalog_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/services_category_cards.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/services_hub_hero.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/services_search_entry.dart';

/// Services hub (Figma 298:251 — "03 — الخدمات • OPTION 02"): centered page
/// title, Ali hero with the command pill, the glass search entry and the two
/// category choices fed by `/resident/service-categories`.
///
/// Tapping a card moves to that category's service list, the search entry
/// opens all services, and the mic pill opens the Ali assisted booking.
class ServicesHubPage extends StatelessWidget {
  const ServicesHubPage({
    super.key,
    required this.onCategory,
    required this.onAllServices,
    required this.onAliAssist,
  });

  final ValueChanged<ServiceCategory> onCategory;
  final ValueChanged<List<ServiceCategory>> onAllServices;
  final VoidCallback onAliAssist;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceCatalogCubit>()..load(),
      child: _ServicesHubBody(
        onCategory: onCategory,
        onAllServices: onAllServices,
        onAliAssist: onAliAssist,
      ),
    );
  }
}

class _ServicesHubBody extends StatelessWidget {
  const _ServicesHubBody({
    required this.onCategory,
    required this.onAllServices,
    required this.onAliAssist,
  });

  final ValueChanged<ServiceCategory> onCategory;
  final ValueChanged<List<ServiceCategory>> onAllServices;
  final VoidCallback onAliAssist;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey('services-hub'),
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 14),
        Text(
          AppLocaleKey.services.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.headingH2.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: ServicesHubHero(onAliCommand: onAliAssist),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: ServicesSearchEntry(
            // Snapshot rides along with the tap so the flow screen opens all
            // services from the loaded catalog without a refetch.
            onTap: () {
              final state = context.read<ServiceCatalogCubit>().state;
              if (state is ServiceCatalogReady) onAllServices(state.categories);
            },
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<ServiceCatalogCubit, ServiceCatalogState>(
          builder: (context, state) {
            if (state is ServiceCatalogLoading) {
              return const Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: StatePanel(message: '', loading: true, margin: EdgeInsets.zero),
              );
            }
            if (state is ServiceCatalogFailure) {
              return Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: StatePanel(
                  message: state.key.tr(),
                  margin: EdgeInsets.zero,
                  onRetry: () => context.read<ServiceCatalogCubit>().load(),
                ),
              );
            }
            final categories = (state as ServiceCatalogReady).categories;
            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: ServicesCategoryCards(categories: categories, onCategory: onCategory),
            );
          },
        ),
        const SizedBox(height: HomeSizes.pageBottomClearance),
      ],
    );
  }
}
