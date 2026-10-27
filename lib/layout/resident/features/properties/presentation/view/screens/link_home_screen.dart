import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/resident/features/dashboard/data/repo/resident_repo.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/cubit/resident_dashboard_cubit.dart';
import 'package:rounder_application/layout/resident/features/properties/presentation/view/widget/link_home_form.dart';

class LinkHomeScreen extends StatefulWidget {
  const LinkHomeScreen({super.key});

  @override
  State<LinkHomeScreen> createState() => _LinkHomeScreenState();
}

class _LinkHomeScreenState extends State<LinkHomeScreen> {
  final form = GlobalKey<FormState>();
  final code = TextEditingController();
  final unit = TextEditingController();
  bool busy = false;

  @override
  void dispose() {
    code.dispose();
    unit.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      if (context.read<ResidentDashboardCubit>().isPreview) {
        context.read<ResidentDashboardCubit>().previewHome(
          '${code.text.trim()} • ${unit.text.trim()}',
        );
        if (mounted) Navigator.maybePop(context);
        return;
      }
      await sl<ResidentRepository>().linkHome(
        propertyCode: code.text.trim(),
        unitLabel: unit.text.trim(),
      );
      if (mounted) await context.read<ResidentDashboardCubit>().load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocaleKey.homeLinkFailed.tr())),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => LinkHomeForm(
    formKey: form,
    code: code,
    unit: unit,
    busy: busy,
    onSubmit: submit,
  );
}
