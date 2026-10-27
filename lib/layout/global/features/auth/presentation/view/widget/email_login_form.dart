import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/email_login_field.dart';
import 'package:rounder_application/layout/global/features/auth/validation/auth_validators.dart';

/// Email/password form of the alternate sign-in: brand mark, mode title, the
/// register/sign-in fields, the cubit error/loading button and the mode toggle.
class EmailLoginForm extends StatelessWidget {
  const EmailLoginForm({
    super.key,
    required this.formKey,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirm,
    required this.creating,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController phone;
  final TextEditingController password;
  final TextEditingController confirm;
  final bool creating;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SvgPicture.asset(
          AppImages.rounderIcon,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          creating
              ? AppLocaleKey.createAccount.tr()
              : AppLocaleKey.welcome.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 28),
        if (creating) ...[
          EmailLoginField(
            controller: name,
            label: AppLocaleKey.fullName.tr(),
            icon: Icons.person_outline,
            validator: AuthValidators.name,
          ),
          const SizedBox(height: 12),
          EmailLoginField(
            controller: phone,
            label: AppLocaleKey.phone.tr(),
            icon: Icons.phone_outlined,
            keyboard: TextInputType.phone,
            requiredField: false,
            validator: AuthValidators.optionalIntlPhone,
          ),
          const SizedBox(height: 12),
        ],
        EmailLoginField(
          controller: email,
          label: AppLocaleKey.email.tr(),
          icon: Icons.email_outlined,
          keyboard: TextInputType.emailAddress,
          validator: AuthValidators.email,
        ),
        const SizedBox(height: 12),
        EmailLoginField(
          controller: password,
          label: AppLocaleKey.password.tr(),
          icon: Icons.lock_outline,
          obscure: true,
          validator: AuthValidators.password,
        ),
        if (creating) ...[
          const SizedBox(height: 12),
          EmailLoginField(
            controller: confirm,
            label: AppLocaleKey.confirmPassword.tr(),
            icon: Icons.lock_reset,
            obscure: true,
            validator: AuthValidators.confirm(password),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              AppLocaleKey.passwordRule.tr(),
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ),
        ],
        const SizedBox(height: 18),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) => Column(
            children: [
              if (state is AuthFailure)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    state.messageKey.tr(),
                    style: const TextStyle(color: AppColors.coral),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state is AuthChecking ? null : onSubmit,
                  child: state is AuthChecking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          creating
                              ? AppLocaleKey.createAccount.tr()
                              : AppLocaleKey.signIn.tr(),
                        ),
                ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: onToggleMode,
          child: Text(
            creating
                ? AppLocaleKey.haveAccount.tr()
                : AppLocaleKey.createAccount.tr(),
          ),
        ),
      ],
    ),
  );
}
