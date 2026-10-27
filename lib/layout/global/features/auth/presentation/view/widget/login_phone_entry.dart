import 'dart:ui' as ui_direction show TextDirection;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

/// Approved phone entry (design `Phone number / Entry`): label, the Saudi
/// number field (country block + divider + the dialable local number — `05…`
/// with 10 digits or `5…` with 9) and the helper line — replaced by the
/// validation message when the shape is rejected.
class LoginPhoneEntry extends StatelessWidget {
  const LoginPhoneEntry({
    super.key,
    required this.controller,
    required this.onContinue,
    this.errorText,
  });
  final TextEditingController controller;
  final VoidCallback onContinue;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppLocaleKey.phoneNumber.tr(),
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: AppColors.petrol,
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: .45),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.stroke),
          ),
          child: Row(
            // Approved frame keeps the country chip on the physical left and
            // the number on the right in every locale (the field is an
            // international-number component, not mirrored UI).
            textDirection: ui_direction.TextDirection.ltr,
            children: [
              const _CountryBlock(),
              Container(width: 1, height: 56, color: AppColors.stroke),
              Expanded(
                child: _NumberField(
                  controller: controller,
                  onSubmitted: onContinue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          errorText ?? AppLocaleKey.phoneVerifyHint.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: errorText == null
                ? AppColors.ink.withValues(alpha: .7)
                : AppColors.coral,
            fontSize: 12,
            height: 22 / 12,
          ),
        ),
      ],
    );
  }
}

class _CountryBlock extends StatelessWidget {
  const _CountryBlock();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 8, 0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: ui_direction.TextDirection.ltr,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocaleKey.saudiArabia.tr(),
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.petrol,
                fontSize: 10,
                height: 18 / 10,
              ),
            ),
            const Text(
              '+966',
              maxLines: 1,
              // Dial codes are LTR data even inside an Arabic layout; without
              // this the leading "+" is reordered to the end.
              textDirection: ui_direction.TextDirection.ltr,
              style: TextStyle(
                color: AppColors.petrol,
                fontSize: 15,
                height: 24 / 15,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 14,
          color: AppColors.petrol,
        ),
      ],
    ),
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.done,
    onSubmitted: (_) => onSubmitted(),
    inputFormatters: [_SaudiLocalMobileFormatter()],
    textDirection: ui_direction.TextDirection.ltr,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: AppColors.petrol,
      fontSize: 16,
      height: 26 / 16,
    ),
    decoration: InputDecoration(
      isDense: true,
      border: InputBorder.none,
      contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      hintText: AppLocaleKey.phonePlaceholder.tr(),
      hintStyle: TextStyle(
        color: AppColors.ink.withValues(alpha: .6),
        fontSize: 16,
        height: 26 / 16,
      ),
    ),
  );
}

/// Digits-only entry that grows exactly like the journey's helper: the two
/// accepted Saudi local shapes are the only text this field can hold —
/// `0…` reaches 10 digits, `5…` stops at 9 and any other leading digit is
/// rejected at the keystroke, so `0512345670` and `512345670` stay typeable
/// as the same number from entry to submit.
class _SaudiLocalMobileFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
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
