import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_type_model.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_input.dart';
import 'package:rounder_application/layout/resident/features/emergencies/validation/emergency_validators.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

/// The emergency request form: warning notice, type picker, contact/location
/// details and the SOS submit action. Missing type/confirmation feedback is
/// rendered inline under each control (rounder-validation) — no snackbar.
class EmergencyForm extends StatelessWidget {
  const EmergencyForm({
    super.key,
    required this.formKey,
    required this.phone,
    required this.location,
    required this.details,
    required this.types,
    required this.selectedType,
    required this.typeMissing,
    required this.onTypeChanged,
    required this.confirmed,
    required this.confirmMissing,
    required this.onConfirmedChanged,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phone;
  final TextEditingController location;
  final TextEditingController details;
  final List<EmergencyType> types;
  final String? selectedType;
  final bool typeMissing;
  final ValueChanged<String?> onTypeChanged;
  final bool confirmed;
  final bool confirmMissing;
  final ValueChanged<bool> onConfirmedChanged;
  final VoidCallback onSubmit;

  static IconData _icon(String code) => switch (code) {
    'fire' => Icons.local_fire_department_outlined,
    'medical' => Icons.medical_services_outlined,
    'gas_leak' => Icons.local_gas_station_outlined,
    'electrical_hazard' => Icons.electrical_services_outlined,
    'water_leak' => Icons.water_damage_outlined,
    'elevator' => Icons.elevator_outlined,
    'security' => Icons.shield_outlined,
    _ => Icons.warning_outlined,
  };

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
                color: AppColors.emergencyWash,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.orange.withValues(alpha: .35)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.orange),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocaleKey.emergencyIntro.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocaleKey.emergencySafety.tr(),
              style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            Text(
              AppLocaleKey.emergencyType.tr(),
              style: AppTextStyles.extraBold17.copyWith(color: AppColors.petrol),
            ),
            const SizedBox(height: 10),
            ...types.map((type) {
              final selected = selectedType == type.id.toString();
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  tileColor: AppColors.white,
                  value: type.id.toString(),
                  secondary: Icon(
                    _icon(type.code),
                    color: selected ? AppColors.orange : AppColors.petrol,
                  ),
                  title: Text(type.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  activeColor: AppColors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              );
            }),
            if (typeMissing)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _InlineError(message: AppLocaleKey.requiredField.tr()),
              ),
            const SizedBox(height: 10),
            EmergencyInput(
              controller: phone,
              label: AppLocaleKey.emergencyContact.tr(),
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (_) => null,
              inputFormatters: [_SaudiLocalMobileFormatter()],
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
              tileColor: AppColors.white,
              contentPadding: EdgeInsets.zero,
              value: confirmed,
              onChanged: (value) => onConfirmedChanged(value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.petrol,
              title: Text(
                AppLocaleKey.confirmEmergency.tr(),
                style: AppTextStyles.captionRegular13,
              ),
            ),
            if (confirmMissing)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: _InlineError(message: AppLocaleKey.requiredField.tr()),
              ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.white,
                minimumSize: const Size.fromHeight(54),
              ),
              icon: const Icon(Icons.sos),
              label: Text(
                AppLocaleKey.sendEmergency.tr(),
                style: AppTextStyles.labelAction.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small inline validation note used by this form (rounder-validation):
/// one line, red, start-aligned.
class _InlineError extends StatelessWidget {
  const _InlineError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    textAlign: TextAlign.start,
    style: AppTextStyles.tinyRegular.copyWith(color: AppColors.emergency),
  );
}

class _SaudiLocalMobileFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = digitsOnly(newValue.text);
    if (!saudiLocalMobileAllows(digits)) return oldValue;
    return digits == newValue.text
        ? newValue
        : TextEditingValue(
            text: digits,
            selection: TextSelection.collapsed(offset: digits.length),
          );
  }
}
