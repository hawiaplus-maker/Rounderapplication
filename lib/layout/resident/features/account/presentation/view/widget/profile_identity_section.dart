import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rounder_application/core/constants/display_placeholder.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/resident_profile_model.dart';

/// Identity block of the account page (design 511:812): the avatar initial,
/// the resident's name from the profile endpoint, and the edit link.
class ProfileIdentitySection extends StatelessWidget {
  const ProfileIdentitySection({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  final ResidentProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final String name = profile.name;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(22, 12, 22, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.white.withValues(alpha: .15),
            child: Text(
              name.isEmpty ? '' : name.substring(0, 1),
              style: AppTextStyles.displayLarge.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name.isEmpty ? DisplayPlaceholder.text : name,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.extraBold26.copyWith(color: AppColors.white),
                ),
                Text(
                  AppLocaleKey.profileSubtitle.tr(),
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white.withValues(alpha: .7)),
                ),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 17,
                    color: AppColors.white,
                  ),
                  label: Text(
                    AppLocaleKey.editProfile.tr(),
                    style: AppTextStyles.labelAction.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
