import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/services/data/model/service_option_model.dart';
import 'package:rounder_application/layout/resident/features/services/presentation/cubit/services_cubit.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});

  final ServiceOption service;

  Future<void> book(BuildContext context) async {
    final dashboard = context.read<ResidentDashboardCubit>().state;
    if (dashboard is! DashboardReady || dashboard.data.homeId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocaleKey.linkHomeFirst.tr())));
      return;
    }
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    try {
      await context.read<ServicesCubit>().book(
        homeId: dashboard.data.homeId!,
        serviceId: service.id,
        date: DateTime(date.year, date.month, date.day, 12),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocaleKey.bookingCreated.tr())),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocaleKey.bookingFailed.tr())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    child: ListTile(
      tileColor: Colors.white,
      contentPadding: const EdgeInsets.all(14),
      leading: const CircleAvatar(
        backgroundColor: AppColors.mint,
        child: Icon(
          Icons.home_repair_service_outlined,
          color: AppColors.petrol,
        ),
      ),
      title: Text(
        service.name,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        '${service.categoryName}\n'
        '${service.price.toStringAsFixed(0)} '
        '${AppLocaleKey.currencyEgp.tr()}',
      ),
      isThreeLine: true,
      trailing: IconButton(
        onPressed: () => book(context),
        icon: const Icon(Icons.add_circle_outline, color: AppColors.orange),
        tooltip: AppLocaleKey.bookNow.tr(),
      ),
    ),
  );
}
