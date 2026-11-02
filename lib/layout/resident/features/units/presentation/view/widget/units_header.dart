import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
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
            style: AppTextStyles.headingBold23.copyWith(color: AppColors.white),
          ),
        ),
        SvgPicture.asset(AppImages.rounderIcon, height: 24, fit: BoxFit.contain),
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
      rtl ? Icons.arrow_back_ios_new : Icons.arrow_back_ios_new,
      size: 26,
      color: AppColors.white,
    );
  }
}
