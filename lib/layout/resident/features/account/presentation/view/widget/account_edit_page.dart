import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_input.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_sub_page.dart';

/// Edit profile page: photo, name, phone, email and save action.
class AccountEditPage extends StatelessWidget {
  const AccountEditPage({
    super.key,
    required this.onBack,
    required this.nameController,
    required this.phoneController,
    required this.emailController,
    required this.onChangePhoto,
    required this.onChangePhone,
    required this.onSave,
  });

  final VoidCallback onBack;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final VoidCallback onChangePhoto;
  final VoidCallback onChangePhone;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return AccountSubPage(
      titleKey: AppLocaleKey.editProfile,
      onBack: onBack,
      children: [
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 39,
                backgroundColor: AppColors.mint,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.petrol,
                  size: 36,
                ),
              ),
              TextButton.icon(
                onPressed: onChangePhoto,
                icon: const Icon(Icons.photo_camera_outlined),
                label: Text(AppLocaleKey.changePhoto.tr()),
              ),
            ],
          ),
        ),
        AccountPanel(
          children: [
            AccountInput(
              labelKey: AppLocaleKey.fullName,
              controller: nameController,
              keyboard: TextInputType.name,
            ),
            const SizedBox(height: 14),
            ListTile(
              tileColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              title: Text(AppLocaleKey.phoneNumber.tr()),
              subtitle: Text(
                phoneController.text,
                textDirection: TextDirection.ltr,
              ),
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
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: onSave,
            child: Text(AppLocaleKey.saveChanges.tr()),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            AppLocaleKey.contactUse.tr(),
            style: const TextStyle(color: AppColors.petrol, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
