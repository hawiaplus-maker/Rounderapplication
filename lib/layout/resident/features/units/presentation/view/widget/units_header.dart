import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_theme.dart';

/// Header of units and My Units-style screens (design Back / Account): the
/// screen title on the reading start side with the rounder wordmark behind it,
/// and a back-to-account affordance on the trailing edge.
class UnitsHeader extends StatelessWidget {
  const UnitsHeader({super.key, required this.title, required this.onBack});
  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
            child: _DirectionalBackChevron(),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 23,
              height: 34 / 23,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Image.asset(AppImages.rounderLogo, height: 24, fit: BoxFit.contain),
      ],
    );
  }
}

class _DirectionalBackChevron extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // back affordance on the trailing edge: RTL points right, LTR points left.
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Icon(
      rtl ? Icons.chevron_right : Icons.chevron_left,
      size: 26,
      color: AppColors.white,
    );
  }
}
