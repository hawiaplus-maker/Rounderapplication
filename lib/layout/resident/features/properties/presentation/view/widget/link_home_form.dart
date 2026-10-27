import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/properties/validation/properties_validators.dart';

/// Link-home form: brand emblem, copy, property-code and unit-number fields,
/// then the submit button with its inline progress state.
class LinkHomeForm extends StatelessWidget {
  const LinkHomeForm({
    super.key,
    required this.formKey,
    required this.code,
    required this.unit,
    required this.busy,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController code;
  final TextEditingController unit;
  final bool busy;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.mint,
                child: Icon(Icons.apartment, color: AppColors.petrol, size: 38),
              ),
              const SizedBox(height: 22),
              Text(
                AppLocaleKey.linkYourHome.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.petrol,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocaleKey.linkHomeHelp.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: code,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: AppLocaleKey.propertyCode.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: PropertiesValidators.propertyCode,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: unit,
                decoration: InputDecoration(
                  labelText: AppLocaleKey.unitNumber.tr(),
                  border: const OutlineInputBorder(),
                ),
                validator: PropertiesValidators.unitNumber,
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: busy ? null : onSubmit,
                child: busy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(AppLocaleKey.linkHome.tr()),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
