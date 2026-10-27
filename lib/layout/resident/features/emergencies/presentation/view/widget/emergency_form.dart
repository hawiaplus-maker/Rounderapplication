import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_input.dart';
import 'package:rounder_application/layout/resident/features/emergencies/validation/emergency_validators.dart';

/// The emergency request form: warning notice, type picker, contact/location
/// details and the SOS submit action.
class EmergencyForm extends StatelessWidget {
  const EmergencyForm({
    super.key,
    required this.formKey,
    required this.phone,
    required this.location,
    required this.details,
    required this.selectedType,
    required this.onTypeChanged,
    required this.confirmed,
    required this.onConfirmedChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phone;
  final TextEditingController location;
  final TextEditingController details;
  final String? selectedType;
  final ValueChanged<String?> onTypeChanged;
  final bool confirmed;
  final ValueChanged<bool> onConfirmedChanged;
  final VoidCallback onSubmit;

  static const _types = <(String, IconData)>[
    (AppLocaleKey.emergencyTypeFire, Icons.local_fire_department_outlined),
    (AppLocaleKey.emergencyTypeMedical, Icons.medical_services_outlined),
    (AppLocaleKey.emergencyTypeGas, Icons.local_gas_station_outlined),
    (AppLocaleKey.emergencyTypeElectrical, Icons.electrical_services_outlined),
    (AppLocaleKey.emergencyTypeWater, Icons.water_damage_outlined),
    (AppLocaleKey.emergencyTypeElevator, Icons.elevator_outlined),
    (AppLocaleKey.emergencyTypeSecurity, Icons.shield_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: RadioGroup<String>(
        groupValue: selectedType,
        onChanged: onTypeChanged,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEE5),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: .35),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.orange,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocaleKey.emergencyIntro.tr(),
                      style: const TextStyle(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocaleKey.emergencySafety.tr(),
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            const SizedBox(height: 22),
            Text(
              AppLocaleKey.emergencyType.tr(),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.petrol,
              ),
            ),
            const SizedBox(height: 10),
            ..._types.map((item) {
              final selected = selectedType == item.$1;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  tileColor: Colors.white,
                  value: item.$1,
                  secondary: Icon(
                    item.$2,
                    color: selected ? AppColors.orange : AppColors.petrol,
                  ),
                  title: Text(item.$1.tr()),
                  activeColor: AppColors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            }),
            const SizedBox(height: 10),
            EmergencyInput(
              controller: phone,
              label: AppLocaleKey.emergencyContact.tr(),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: EmergencyValidators.contactPhone,
            ),
            const SizedBox(height: 12),
            EmergencyInput(
              controller: location,
              label: AppLocaleKey.emergencyLocation.tr(),
              icon: Icons.location_on_outlined,
              validator: EmergencyValidators.location,
              maxLength: 255,
            ),
            const SizedBox(height: 12),
            EmergencyInput(
              controller: details,
              label: AppLocaleKey.emergencyDetails.tr(),
              icon: Icons.notes_outlined,
              validator: EmergencyValidators.details,
              maxLength: 3000,
              maxLines: 4,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              value: confirmed,
              onChanged: (value) => onConfirmedChanged(value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.petrol,
              title: Text(
                AppLocaleKey.confirmEmergency.tr(),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
              ),
              icon: const Icon(Icons.sos),
              label: Text(
                AppLocaleKey.sendEmergency.tr(),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
