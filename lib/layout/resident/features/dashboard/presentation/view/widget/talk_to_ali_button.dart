import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/style/home_text_styles.dart';
import 'package:rounder_application/layout/resident/features/dashboard/presentation/view/widget/home_svg_icon.dart';

/// "تحدث مع علي" voice pill: translucent glass with the coral mic disc on the
/// start side.
class TalkToAliButton extends StatelessWidget {
  const TalkToAliButton({super.key, this.onTap});

  final VoidCallback? onTap;

  static const double _height = 46;
  static const double _width = 190;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_height / 2),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.glassPillFill,
              borderRadius: BorderRadius.circular(_height / 2),
              border: Border.all(color: AppColors.glassPillStroke),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, end: 7),
              child: Row(
                children: <Widget>[
                  const _MicDisc(),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocaleKey.homeTalkToAli.tr(),
                      style: HomeTextStyles.talkPill,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MicDisc extends StatelessWidget {
  const _MicDisc();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: AppColors.coral,
        shape: BoxShape.circle,
      ),
      alignment: AlignmentDirectional.center,
      child: const HomeSvgIcon(AppImages.homeMic, size: 19, color: AppColors.white),
    );
  }
}
