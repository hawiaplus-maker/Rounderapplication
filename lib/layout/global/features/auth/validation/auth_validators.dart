import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/logic/email_logic.dart';
import 'package:rounder_application/logic/phone_number_logic.dart';

/// Form validators of the auth journeys (rounder-validation): the single home
/// of the field rules — the local checks the client can own (required/name,
/// email shape, empty passwords, the matched pair) — so screens compose them
/// instead of re-inlining copies. Every message is an `AppLocaleKey` value;
/// the validators themselves stay locale-agnostic.
abstract final class AuthValidators {
  /// Non-empty (after trim) when `isRequired`; never fires otherwise.
  static String? requiredField(String? value, {bool isRequired = true}) {
    if (!isRequired) return null;
    return value != null && value.trim().isNotEmpty
        ? null
        : AppLocaleKey.requiredField.tr();
  }

  /// Name rule of the journey: at least two letters on the trimmed value.
  static String? name(String? value) =>
      (value ?? '').trim().length < 2 ? AppLocaleKey.requiredField.tr() : null;

  /// Email shape: present, ≤254 chars, address-shaped.
  static String? email(String? value) =>
      isEmail(value ?? '') ? null : AppLocaleKey.emailInvalid.tr();

  /// The local password check: emptiness only. The password policy —
  /// length and character classes — belongs to the register API; its
  /// rejection message travels to the UI as-is through the failure
  /// states (`PhoneAuthFailure` on the phone journey), so the client
  /// never re-implements the rule it can't own.
  static String? password(String? value) =>
      value != null && value.trim().isNotEmpty
      ? null
      : AppLocaleKey.requiredField.tr();

  /// Optional international phone of the email screens: empty passes, any
  /// non-empty value must be `+<digits>` shaped.
  static String? optionalIntlPhone(String? value) {
    if (value == null || value.isEmpty) return null;
    return isIntlPhone(value) ? null : AppLocaleKey.phoneFormat.tr();
  }

  /// Cross-field factory: the confirm field must still equal the password's
  /// live text when validation runs, so the rule closes over the password
  /// field and is handed to the confirm field's `validator`.
  static String? Function(String?) confirm(TextEditingController password) =>
      (value) =>
          value == password.text ? null : AppLocaleKey.passwordMismatch.tr();
}
