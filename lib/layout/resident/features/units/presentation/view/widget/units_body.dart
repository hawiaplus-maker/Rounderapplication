import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/resident_home_model.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_emblem.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_empty_state.dart';
import 'package:rounder_application/layout/resident/features/units/presentation/view/widget/units_linked_list.dart';

/// Loaded body of the units page (design 536:943): the linked count, the home
/// cards and the add-unit action, or the empty journey when nothing is linked.
/// The dashboard's single home stands in while the endpoint list is empty.
class UnitsBody extends StatelessWidget {
  const UnitsBody({
    super.key,
    required this.homes,
    required this.homeName,
    required this.unitLabel,
    required this.onOpenUnit,
    required this.onAddUnit,
    required this.onDeleteUnit,
    this.busyId,
  });

  final List<ResidentHome> homes;
  final String homeName, unitLabel;
  final VoidCallback onOpenUnit, onAddUnit;
  final ValueChanged<ResidentHome> onDeleteUnit;

  /// The unit whose deletion is in flight (null when none).
  final int? busyId;

  @override
  Widget build(BuildContext context) {
    final List<ResidentHome> linked = _linkedHomes();
    if (linked.isEmpty) {
      return UnitsEmptyState(
        title: AppLocaleKey.unitsEmptyTitle.tr(),
        body: AppLocaleKey.unitsEmptyBody.tr(),
        hint: AppLocaleKey.unitsEmptyHint.tr(),
        actionLabel: AppLocaleKey.unitsAddUnit.tr(),
        onAction: onAddUnit,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UnitsEmblem(count: linked.length),
        const SizedBox(height: 20),
        UnitsLinkedList(
          homes: linked,
          onOpenUnit: (_) => onOpenUnit(),
          onAddUnit: onAddUnit,
          onDeleteUnit: onDeleteUnit,
          busyId: busyId,
        ),
      ],
    );
  }

  /// The endpoint's homes, or the dashboard's single home while the list is
  /// empty so a linked residence never disappears from the page.
  List<ResidentHome> _linkedHomes() {
    if (homes.isNotEmpty) return homes;
    if (homeName.trim().isEmpty) return const <ResidentHome>[];
    return <ResidentHome>[
      ResidentHome(name: homeName, unitLabel: unitLabel, isPrimary: true),
    ];
  }
}
