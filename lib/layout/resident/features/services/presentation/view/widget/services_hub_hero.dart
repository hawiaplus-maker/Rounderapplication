import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/widgets/svg_icon.dart';

/// Top section of the services hub (Figma 298:251): the Ali "salute" artwork
/// facing the invitation ("وش تحتاج اليوم؟") and the glass "علي تحت أمرك"
/// command pill with its mic glyph.
///
/// The intro sits on the directional start; the artwork hugs the end, so the
/// pair mirrors naturally between ar/en.
class ServicesHubHero extends StatelessWidget {
  const ServicesHubHero({super.key, required this.onAliCommand});

  /// Opens the Ali assisted-booking step (design 382:448).
  final VoidCallback onAliCommand;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(top: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocaleKey.whatDoYouNeedToday.tr(),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  style: AppTextStyles.displayBold30.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: 20),
                _AliCommandPill(onTap: onAliCommand),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const _AliPortrait(),
      ],
    );
  }
}

class _AliPortrait extends StatelessWidget {
  const _AliPortrait();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.aliHomePresenting,
      width: 170,
      height: 236,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}

class _AliCommandPill extends StatelessWidget {
  const _AliCommandPill({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.glassPillFill,
      shape: StadiumBorder(side: BorderSide(color: AppColors.glassPillStroke)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 13),
            child: Row(
              children: [
                SvgIcon(
                  AppImages.homeMic,
                  size: 23,
                  color: AppColors.orange,
                  semanticLabel: AppLocaleKey.aliAtYourCommand.tr(),
                ),

                Expanded(
                  child: Text(
                    AppLocaleKey.aliAtYourCommand.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium15.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
