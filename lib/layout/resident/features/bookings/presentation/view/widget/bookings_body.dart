import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/cubit/bookings_cubit.dart';
import 'package:rounder_application/layout/resident/features/bookings/presentation/view/widget/booking_tile.dart';

class BookingsBody extends StatelessWidget {
  const BookingsBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<BookingsCubit, BookingsState>(
        builder: (context, state) {
          if (state is BookingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookingsFailure) {
            return Center(
              child: TextButton(
                onPressed: () => context.read<BookingsCubit>().load(),
                child: Text(AppLocaleKey.retry.tr()),
              ),
            );
          }
          final items = (state as BookingsReady).items;
          if (items.isEmpty) {
            return Center(child: Text(AppLocaleKey.noBookings.tr()));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                AppLocaleKey.myBookings.tr(),
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppColors.petrol,
                ),
              ),
              const SizedBox(height: 12),
              ...items.map((item) => BookingTile(item: item)),
            ],
          );
        },
      );
}
