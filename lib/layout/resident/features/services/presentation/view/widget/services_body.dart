import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/screens/bookings_screen.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/view/widget/service_card.dart';

class ServicesBody extends StatelessWidget {
  const ServicesBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ServicesCubit, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ServicesFailure) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.key.tr()),
                  TextButton(
                    onPressed: () => context.read<ServicesCubit>().load(),
                    child: Text(AppLocaleKey.retry.tr()),
                  ),
                ],
              ),
            );
          }
          final services = (state as ServicesReady).services;
          if (services.isEmpty) {
            return Center(child: Text(AppLocaleKey.noServices.tr()));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocaleKey.serviceCatalog.tr(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.petrol,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BookingsScreen(),
                      ),
                    ),
                    child: Text(AppLocaleKey.myBookings.tr()),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...services.map((service) => ServiceCard(service: service)),
            ],
          );
        },
      );
}
