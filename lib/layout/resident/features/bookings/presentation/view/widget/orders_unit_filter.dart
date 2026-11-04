import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// One selectable unit of the orders unit filter.
class OrdersUnitOption {
  const OrdersUnitOption({required this.id, required this.name});

  final int id;
  final String name;
}

/// Unit dropdown at the top of the orders screen: picks which unit's orders
/// the four status tabs show. A null selection keeps every unit on display,
/// which is also the only place the session preview orders appear in (they
/// carry no unit).
class OrdersUnitFilter extends StatelessWidget {
  const OrdersUnitFilter({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onChanged,
  });

  final List<OrdersUnitOption> options;
  final int? selectedId;
  final ValueChanged<int?> onChanged;

  /// A DropdownButton cannot hold a null value, so the every-unit default
  /// rides a 0 sentinel — no home id is ever 0.
  static const int _allUnits = 0;

  @override
  Widget build(BuildContext context) {
    // DropdownButton asserts exactly one item per value: a selected id that
    // no longer has an option falls back to the every-unit row instead of
    // throwing.
    final int value = options.any((o) => o.id == selectedId)
        ? selectedId!
        : _allUnits;
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      // Field text sits on the glass pill, so it is white; every menu row
      // carries its own petrol style to stay readable on the white menu.
      style: AppTextStyles.bodyBold15.copyWith(color: AppColors.white),
      dropdownColor: AppColors.white,
      iconEnabledColor: AppColors.white,
      decoration: InputDecoration(
        labelText: AppLocaleKey.filterUnit.tr(),
        labelStyle: AppTextStyles.captionRegular.copyWith(
          color: AppColors.white.withValues(alpha: .7),
        ),
        floatingLabelStyle: AppTextStyles.captionRegular.copyWith(
          color: AppColors.white.withValues(alpha: .7),
        ),
        filled: true,
        // Same glass fill as the status tabs' pill right below.
        fillColor: AppColors.mintDeep.withAlpha(30),
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.mint),
        ),
      ),
      items: [
        DropdownMenuItem<int>(
          value: _allUnits,
          child: Text(
            AppLocaleKey.allUnits.tr(),
            textAlign: TextAlign.start,
            style: AppTextStyles.bodyBold15.copyWith(color: AppColors.petrol),
          ),
        ),
        for (final option in options)
          DropdownMenuItem<int>(
            value: option.id,
            child: Text(
              option.name,
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyBold15.copyWith(color: AppColors.petrol),
            ),
          ),
      ],
      onChanged: (value) => onChanged(value == _allUnits ? null : value),
    );
  }
}
