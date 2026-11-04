import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Filled form field used by the emergency request form.
class EmergencyInput extends StatelessWidget {
  const EmergencyInput({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.petrol),
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
