import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_form.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_success_view.dart';

/// Standalone local emergency-request flow; it does not use the service booking API.
class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({super.key});
  @override State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _details = TextEditingController();
  String? _type;
  bool _confirmed = false;
  String? _reference;

  @override
  void dispose() {
    _phone.dispose();
    _location.dispose();
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.canvas,
    appBar: AppBar(
      title: Text(AppLocaleKey.emergencyTitle.tr()),
      leading: IconButton(onPressed: () => Navigator.maybePop(context), icon: const Icon(Icons.arrow_back), tooltip: AppLocaleKey.back.tr()),
    ),
    body: SafeArea(
      child: _reference == null
          ? EmergencyForm(
              formKey: _formKey,
              phone: _phone,
              location: _location,
              details: _details,
              selectedType: _type,
              onTypeChanged: (value) => setState(() => _type = value),
              confirmed: _confirmed,
              onConfirmedChanged: (value) => setState(() => _confirmed = value),
              onSubmit: _submit,
            )
          : EmergencySuccessView(
              reference: _reference!,
              onClose: () => Navigator.maybePop(context),
            ),
    ),
  );

  void _submit() {
    if (_type == null || !_confirmed || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocaleKey.emergencyRequired.tr())));
      return;
    }
    setState(() => _reference = 'EM-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
  }
}
