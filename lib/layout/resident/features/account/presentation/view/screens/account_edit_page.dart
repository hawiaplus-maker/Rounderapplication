import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_input.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Edit profile page: photo, name, phone, email and save action.
class AccountEditPage extends StatelessWidget {
  const AccountEditPage({
    super.key,
    required this.onBack,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.saving,
    required this.error,
    required this.onChangePhoto,
    required this.onChangePhone,
    required this.onSave,
  });

  final VoidCallback onBack;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;

  /// A save is in flight; the action is disabled and shows its progress.
  final bool saving;

  /// The server's text of the last rejected save, empty when there is none.
  final String error;
  final VoidCallback onChangePhoto;
  final VoidCallback onChangePhone;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.editProfile,
      onBack: onBack,
      children: [
        const SizedBox(height: 120),
        // Center(
        //   child: Column(
        //     children: [
        //       const CircleAvatar(
        //         radius: 39,
        //         backgroundColor: AppColors.mint,
        //         child: Icon(
        //           Icons.person_outline,
        //           color: AppColors.petrol,
        //           size: 36,
        //         ),
        //       ),
        //       TextButton.icon(
        //         onPressed: onChangePhoto,
        //         icon: const Icon(Icons.photo_camera_outlined),
        //         label: Text(AppLocaleKey.changePhoto.tr()),
        //       ),
        //     ],
        //   ),
        // ),
        AccountPanel(
          children: [
            AccountInput(
              labelKey: AppLocaleKey.fullName,
              controller: nameController,
              keyboard: TextInputType.name,
            ),
            const SizedBox(height: 14),
            ListTile(
              tileColor: AppColors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.phoneNumber.tr()),
              subtitle: Text(phoneController.text, textDirection: TextDirection.ltr),
              trailing: TextButton(
                onPressed: onChangePhone,
                child: Text(AppLocaleKey.changePhone.tr()),
              ),
            ),
            const SizedBox(height: 14),
            AccountInput(
              labelKey: AppLocaleKey.emailAddress,
              controller: emailController,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 4),
            Text(
              AppLocaleKey.optional.tr(),
              style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (error.isNotEmpty)
          Padding(
            padding: const EdgeInsetsDirectional.only(bottom: 8),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.captionRegular13.copyWith(color: AppColors.emergency),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: saving ? null : onSave,
            child: saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.white),
                  )
                : Text(AppLocaleKey.saveChanges.tr()),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            AppLocaleKey.contactUse.tr(),
            style: AppTextStyles.captionRegular.copyWith(color: AppColors.petrol),
          ),
        ),
      ],
    );
  }
}
