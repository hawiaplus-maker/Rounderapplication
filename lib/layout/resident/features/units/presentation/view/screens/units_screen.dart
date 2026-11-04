import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/widgets/brand_gradient_backdrop.dart';
import 'package:rounder_application/layout/global/widgets/state_panel.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/cubit/homes_cubit.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/add_unit_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/screens/property_rating_screen.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/delete_unit_dialog.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_body.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_header.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_title_block.dart';

/// My Units journey (وحداتي — design 536:943): the linked homes come from
/// `GET /resident/homes`, with the dashboard's current home as the fallback
/// when the endpoint has not returned a list yet.
class UnitsScreen extends StatelessWidget {
  const UnitsScreen({
    super.key,
    required this.dashboard,
    this.homeName = '',
    this.unitLabel = '',
  });

  final ResidentDashboardCubit dashboard;
  final String homeName, unitLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BrandGradientBackdrop(
        child: SafeArea(
          child: BlocProvider(
            create: (_) => sl<HomesCubit>()..load(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              children: [
                UnitsHeader(
                  title: AppLocaleKey.back.tr(),
                  onBack: () => Navigator.maybePop(context),
                ),
                const SizedBox(height: 22),
                const UnitsTitleBlock(),
                const SizedBox(height: 16),
                BlocBuilder<HomesCubit, HomesState>(
                  builder: (context, state) => switch (state) {
                    HomesLoading() => const StatePanel(
                      message: '',
                      loading: true,
                      margin: EdgeInsets.zero,
                    ),
                    HomesFailure(:final String message) => StatePanel(
                      message: message,
                      margin: EdgeInsets.zero,
                      onRetry: () => context.read<HomesCubit>().load(),
                    ),
                    HomesReady(:final homes) => UnitsBody(
                      homes: homes,
                      homeName: homeName,
                      unitLabel: unitLabel,
                      onOpenUnit: () => _openPropertyRating(context),
                      onAddUnit: () => _openAddUnit(context),
                      onDeleteUnit: (ResidentHome home) =>
                          _deleteUnit(context, home),
                    ),
                    HomesDeleting(:final homes, :final deletingId) => UnitsBody(
                      homes: homes,
                      homeName: homeName,
                      unitLabel: unitLabel,
                      onOpenUnit: () => _openPropertyRating(context),
                      onAddUnit: () => _openAddUnit(context),
                      onDeleteUnit: (ResidentHome home) =>
                          _deleteUnit(context, home),
                      busyId: deletingId,
                    ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPropertyRating(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const PropertyRatingScreen()),
    );
  }

  Future<void> _openAddUnit(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const AddUnitScreen()));
    if (!context.mounted) return;
    final homes = context.read<HomesCubit>();
    await homes.load();
  }

  /// Removes the unit behind the confirm dialog: the backend's refusal (or
  /// offline failure) reaches the snackbar, and the row refreshes in place
  /// without the page flashing a loading panel.
  Future<void> _deleteUnit(BuildContext context, ResidentHome home) async {
    final bool approved = await confirmDeleteUnit(context);
    if (!approved || !context.mounted) return;
    final String? failure = await context.read<HomesCubit>().deleteUnit(home);
    if (!context.mounted || failure == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(failure)));
  }
}
