import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/emergencies/data/model/emergency_type_model.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/cubit/emergency_cubit.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_form.dart';
import 'package:rounder_application/layout/resident/features/emergencies/presentation/view/widget/emergency_success_view.dart';

/// Standalone emergency-request flow: picks a type fetched from the backend,
/// then submits to `/resident/emergency-requests`.
class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({super.key, required this.residentHomeId});

  final int? residentHomeId;
  @override
  State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _details = TextEditingController();
  String? _typeId;
  bool _confirmed = false;
  String? _reference;

  /// Inline rule flags (rounder-validation): true while the type/confirm
  /// is outstanding — rendered under the controls, no snackbar.
  bool _typeMissing = false;
  bool _confirmMissing = false;

  /// Shared, long-lived cubit: loading it here also triggers the types fetch.
  final EmergencyCubit _cubit = sl<EmergencyCubit>()..load();

  @override
  void dispose() {
    _phone.dispose();
    _location.dispose();
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final bool formValid = _formKey.currentState?.validate() ?? false;
    if (!formValid || _typeId == null || !_confirmed) {
      setState(() {
        _typeMissing = _typeId == null;
        _confirmMissing = !_confirmed;
      });
      return;
    }
    final homeId = widget.residentHomeId;
    if (homeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocaleKey.loginRequired.tr())),
      );
      return;
    }

    final body = await _cubit.submit(
      residentHomeId: homeId,
      emergencyTypeId: int.tryParse(_typeId!) ?? 0,
      contactPhone: _phone.text.trim(),
      locationDetails: _location.text.trim(),
      description: _details.text.trim(),
      confirmEmergency: _confirmed,
    );

    if (!mounted) return;
    if (body == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocaleKey.emergencyFailed.tr())),
      );
      return;
    }
    setState(() => _reference = _referenceFrom(body));
  }

  String? _referenceFrom(Map<String, dynamic> body) {
    final Object? data = body['data'];
    final Map target = data is Map ? data : body;
    return (target['reference'] ??
            target['reference_no'] ??
            target['request_reference'] ??
            target['id'])?.toString();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.canvas,
    appBar: AppBar(
      title: Text(AppLocaleKey.emergencyTitle.tr()),
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: const Icon(Icons.arrow_back),
        tooltip: AppLocaleKey.back.tr(),
      ),
    ),
    body: SafeArea(
      child: BlocBuilder<EmergencyCubit, EmergencyState>(
        bloc: _cubit,
        builder: (context, state) {
          final types = state is EmergencyReady ? state.types : const <EmergencyType>[];
          return _reference == null
              ? EmergencyForm(
                  formKey: _formKey,
                  phone: _phone,
                  location: _location,
                  details: _details,
                  types: types,
                  selectedType: _typeId,
                  typeMissing: _typeMissing,
                  onTypeChanged: (value) => setState(() {
                    _typeId = value;
                    // A pick clears the inline type error.
                    _typeMissing = false;
                  }),
                  confirmed: _confirmed,
                  confirmMissing: _confirmMissing,
                  onConfirmedChanged: (value) => setState(() {
                    _confirmed = value;
                    _confirmMissing = !value;
                  }),
                  onSubmit: _submit,
                )
              : EmergencySuccessView(
                  reference: _reference!,
                  onClose: () => Navigator.maybePop(context),
                );
        },
      ),
    ),
  );
}
