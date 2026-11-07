import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_provider_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/service_providers_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/screens/journey_sub_page.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/journey_panel.dart';

/// Providers step: available providers for the selected service, loaded from
/// `/resident/service-providers` filtered by service, sub-service, and home.
class JourneyProvidersPage extends StatelessWidget {
  const JourneyProvidersPage({
    super.key,
    required this.onBack,
    required this.serviceKey,
    required this.serviceId,
    required this.subServiceId,
    required this.homeId,
    required this.onViewCompany,
    required this.onSelectProvider,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final int? serviceId;
  final int? subServiceId;
  final int? homeId;
  final VoidCallback onViewCompany;
  final void Function(int id, String name, double? price, int? priceId)
      onSelectProvider;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ServiceProvidersCubit>()..load(
        serviceId: serviceId ?? 0,
        subServiceId: subServiceId,
        homeId: homeId,
      ),
      child: _JourneyProvidersBody(
        onBack: onBack,
        serviceKey: serviceKey,
        onViewCompany: onViewCompany,
        onSelectProvider: onSelectProvider,
      ),
    );
  }
}

class _JourneyProvidersBody extends StatelessWidget {
  const _JourneyProvidersBody({
    required this.onBack,
    required this.serviceKey,
    required this.onViewCompany,
    required this.onSelectProvider,
  });

  final VoidCallback onBack;
  final String serviceKey;
  final VoidCallback onViewCompany;
  final void Function(int id, String name, double? price, int? priceId)
      onSelectProvider;

  @override
  Widget build(BuildContext context) {
    return JourneySubPage(
      titleKey: AppLocaleKey.availableProviders,
      onBack: onBack,
      children: [
        JourneyPanel(
          children: [
            Text(
              serviceKey,
              textAlign: TextAlign.start,
              style: AppTextStyles.extraBold16.copyWith(color: AppColors.petrol),
            ),
          ],
        ),
        BlocBuilder<ServiceProvidersCubit, ServiceProvidersState>(
          builder: (context, state) {
            if (state is ServiceProvidersLoading) {
              return const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (state is ServiceProvidersFailure) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.key.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
                ),
              );
            }
            if (state is ServiceProvidersReady) {
              if (state.providers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppLocaleKey.noServices.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
                  ),
                );
              }
              return Column(
                children: state.providers
                    .map(
                      (p) => _ProviderCard(
                        provider: p,
                        onViewCompany: onViewCompany,
                        onSelect: () =>
                            onSelectProvider(p.id, p.name, p.price, p.priceId),
                      ),
                    )
                    .toList(),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.provider,
    required this.onViewCompany,
    required this.onSelect,
  });

  final ServiceProvider provider;
  final VoidCallback onViewCompany;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return JourneyPanel(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.petrol,
              backgroundImage: provider.imageUrl != null ? NetworkImage(provider.imageUrl!) : null,
              child: provider.imageUrl == null
                  ? const Icon(Icons.home_repair_service, color: AppColors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    provider.name,
                    style: AppTextStyles.extraBold18.copyWith(color: AppColors.petrol),
                  ),
                  if (provider.rating != null)
                    Text(
                      provider.rating!,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.muted),
                    ),
                  if (provider.meta != null)
                    Text(
                      provider.meta!,
                      style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (provider.price != null)
          Text(
            '${provider.price!.toStringAsFixed(0)} ${AppLocaleKey.currencyEgp.tr()}',
            textAlign: TextAlign.start,
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Expanded(
            //   child: OutlinedButton(
            //     onPressed: onViewCompany,
            //     child: Text(AppLocaleKey.viewCompany.tr()),
            //   ),
            // ),
            // const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: onSelect,
                style: FilledButton.styleFrom(backgroundColor: AppColors.orange),
                child: Text(
                  AppLocaleKey.selectProvider.tr(),
                  style: AppTextStyles.headingH4.copyWith(color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
