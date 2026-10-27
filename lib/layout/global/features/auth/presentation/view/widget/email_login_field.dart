import 'package:flutter/material.dart';
import 'package:rounder_application/layout/global/features/auth/validation/auth_validators.dart';

/// Form field of the email register/sign-in screen.
class EmailLoginField extends StatelessWidget {
  const EmailLoginField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.obscure = false,
    this.keyboard,
    this.requiredField = true,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final bool obscure;
  final TextInputType? keyboard;
  final bool requiredField;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      autofillHints: obscure ? const [AutofillHints.password] : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator:
          validator ??
          (value) =>
              AuthValidators.requiredField(value, isRequired: requiredField),
    );
  }
}
