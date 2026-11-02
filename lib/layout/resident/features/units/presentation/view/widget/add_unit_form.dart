import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/units/data/model/city_model.dart';
import 'package:rounder_application/layout/resident/features/units/validation/units_validators.dart';

/// The form card of the add-unit screen (design 03.3a): confirmed address,
/// residence-type chips, floor/unit row, name, area, city + ownership, footer.
class AddUnitForm extends StatelessWidget {
  const AddUnitForm({
    super.key,
    required this.formKey,
    required this.addressCtrl,
    required this.districtCtrl,
    required this.unitCtrl,
    required this.floorCtrl,
    required this.nameCtrl,
    required this.areaCtrl,
    required this.residenceType,
    required this.onResidenceTypeChanged,
    required this.ownershipType,
    required this.onOwnershipTypeChanged,
    required this.cities,
    required this.isLoadingCities,
    required this.selectedCityId,
    required this.onCityChanged,
    required this.busy,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController addressCtrl;
  final TextEditingController districtCtrl;
  final TextEditingController unitCtrl;
  final TextEditingController floorCtrl;
  final TextEditingController nameCtrl;
  final TextEditingController areaCtrl;
  final String residenceType;
  final ValueChanged<String> onResidenceTypeChanged;
  final String ownershipType;
  final ValueChanged<String> onOwnershipTypeChanged;
  final List<City> cities;
  final bool isLoadingCities;
  final int? selectedCityId;
  final ValueChanged<int?> onCityChanged;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: .96),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Confirmed address
            Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.teal, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    addressCtrl.text.isEmpty
                        ? AppLocaleKey.confirmedAddress.tr()
                        : addressCtrl.text,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.captionRegular.copyWith(color: AppColors.teal, height: 1.4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Address (editable fallback)
            TextFormField(
              controller: addressCtrl,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: AppLocaleKey.address.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              validator: UnitsValidators.required,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: districtCtrl,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: AppLocaleKey.district.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // City picker
            isLoadingCities
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : DropdownButtonFormField<int>(
                    initialValue: selectedCityId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: AppLocaleKey.city.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: cities
                        .map(
                          (c) => DropdownMenuItem<int>(
                            value: c.id,
                            child: Text(c.name, textAlign: TextAlign.start),
                          ),
                        )
                        .toList(),
                    onChanged: onCityChanged,
                    validator: (v) => v == null ? AppLocaleKey.requiredField.tr() : null,
                  ),
            const SizedBox(height: 16),
            Text(
              AppLocaleKey.residenceType.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.bodyBold14.copyWith(color: AppColors.petrol),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _TypeChip(
                  label: AppLocaleKey.residenceTypeFloor.tr(),
                  value: 'floor',
                  selected: residenceType == 'floor',
                  onTap: () => onResidenceTypeChanged('floor'),
                ),
                const SizedBox(width: 10),
                _TypeChip(
                  label: AppLocaleKey.residenceTypeVilla.tr(),
                  value: 'villa',
                  selected: residenceType == 'villa',
                  onTap: () => onResidenceTypeChanged('villa'),
                ),
                const SizedBox(width: 10),
                _TypeChip(
                  label: AppLocaleKey.residenceTypeApartment.tr(),
                  value: 'apartment',
                  selected: residenceType == 'apartment',
                  onTap: () => onResidenceTypeChanged('apartment'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: unitCtrl,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: AppLocaleKey.unitNumber.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    validator: UnitsValidators.required,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: floorCtrl,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      labelText: AppLocaleKey.floorNumberOptional.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: nameCtrl,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                labelText: AppLocaleKey.homeNameOptional.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocaleKey.homeNameHelp.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.captionRegular.copyWith(color: AppColors.teal),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: areaCtrl,
              textAlign: TextAlign.start,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppLocaleKey.unitAreaOptional.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocaleKey.unitAreaHelp.tr(),
              textAlign: TextAlign.start,
              style: AppTextStyles.captionRegular.copyWith(color: AppColors.teal),
            ),
            const SizedBox(height: 12),
            // Ownership type
            Row(
              children: [
                Expanded(
                  child: _TypeChip(
                    label: AppLocaleKey.ownershipTenant.tr(),
                    value: 'tenant',
                    selected: ownershipType == 'tenant',
                    onTap: () => onOwnershipTypeChanged('tenant'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TypeChip(
                    label: AppLocaleKey.ownershipOwner.tr(),
                    value: 'owner',
                    selected: ownershipType == 'owner',
                    onTap: () => onOwnershipTypeChanged('owner'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: busy ? null : onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  foregroundColor: AppColors.petrol,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        AppLocaleKey.saveUnitResidence.tr(),
                        style: AppTextStyles.headingH4,
                      ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: busy ? null : () => Navigator.maybePop(context),
              child: Text(
                AppLocaleKey.completeLater.tr(),
                style: AppTextStyles.captionBold13.copyWith(color: AppColors.petrol),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.petrol : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? AppColors.petrol
                  : AppColors.muted.withValues(alpha: 0.4),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.captionBold13.copyWith(color: selected ? AppColors.white : AppColors.petrol),
            ),
          ),
        ),
      );
}
