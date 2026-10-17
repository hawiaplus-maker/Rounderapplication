import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/theme/app_theme.dart';

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
    body: SafeArea(child: _reference == null ? _formView() : _successView()),
  );

  Widget _formView() => Form(
    key: _formKey,
    child: RadioGroup<String>(
      groupValue: _type,
      onChanged: (value) => setState(() => _type = value),
      child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: const Color(0xFFFFEEE5), borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.orange.withValues(alpha: .35))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.orange),
            const SizedBox(width: 10),
            Expanded(child: Text(AppLocaleKey.emergencyIntro.tr(), style: const TextStyle(height: 1.45))),
          ]),
        ),
        const SizedBox(height: 12),
        Text(AppLocaleKey.emergencySafety.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        const SizedBox(height: 22),
        Text(AppLocaleKey.emergencyType.tr(), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.petrol)),
        const SizedBox(height: 10),
        ..._types.map((item) {
          final selected = _type == item.$1;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: RadioListTile<String>(
              value: item.$1,
              secondary: Icon(item.$2, color: selected ? AppColors.orange : AppColors.petrol),
              title: Text(item.$1.tr()),
              activeColor: AppColors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          );
        }),
        const SizedBox(height: 10),
        _input(controller: _phone, label: AppLocaleKey.emergencyContact.tr(), icon: Icons.phone_outlined, keyboardType: TextInputType.phone,
          validator: (value) => value == null || !RegExp(r'^\+[1-9][0-9]{7,14}$').hasMatch(value.trim()) ? AppLocaleKey.invalidPhone.tr() : null),
        const SizedBox(height: 12),
        _input(controller: _location, label: AppLocaleKey.emergencyLocation.tr(), icon: Icons.location_on_outlined,
          validator: (value) => value == null || value.trim().length < 4 ? AppLocaleKey.requiredField.tr() : null, maxLength: 255),
        const SizedBox(height: 12),
        _input(controller: _details, label: AppLocaleKey.emergencyDetails.tr(), icon: Icons.notes_outlined,
          validator: (value) => value == null || value.trim().length < 10 ? AppLocaleKey.requiredField.tr() : null, maxLength: 3000, maxLines: 4),
        const SizedBox(height: 8),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _confirmed,
          onChanged: (value) => setState(() => _confirmed = value ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.petrol,
          title: Text(AppLocaleKey.confirmEmergency.tr(), style: const TextStyle(fontSize: 13)),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(54)),
          icon: const Icon(Icons.sos),
          label: Text(AppLocaleKey.sendEmergency.tr(), style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
      ],
      ),
    ),
  );

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    maxLength: maxLength,
    textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppColors.petrol),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
    ),
  );

  void _submit() {
    if (_type == null || !_confirmed || !_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocaleKey.emergencyRequired.tr())));
      return;
    }
    setState(() => _reference = 'EM-' + DateTime.now().millisecondsSinceEpoch.toString().substring(7));
  }

  Widget _successView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const CircleAvatar(radius: 44, backgroundColor: AppColors.mint, child: Icon(Icons.mark_email_read_outlined, color: AppColors.petrol, size: 42)),
        const SizedBox(height: 18),
        Text(AppLocaleKey.emergencyReceived.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.petrol)),
        const SizedBox(height: 8),
        Text(AppLocaleKey.emergencyReference.tr(), style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 4),
        Text(_reference!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 24),
        FilledButton(onPressed: () => Navigator.maybePop(context), child: Text(AppLocaleKey.emergencyClose.tr())),
      ]),
    ),
  );
}
