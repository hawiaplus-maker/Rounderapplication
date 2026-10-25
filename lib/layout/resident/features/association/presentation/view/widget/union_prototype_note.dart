import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Footer note marking the association screens as prototype data.
class UnionPrototypeNote extends StatelessWidget {
  const UnionPrototypeNote({
    super.key,
    this.padding = const EdgeInsets.all(20),
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        AppLocaleKey.prototypeData.tr(),
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppColors.muted, fontSize: 11),
      ),
    );
  }
}
