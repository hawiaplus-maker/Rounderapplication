import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/email_login_field.dart';

/// Real email/password authentication (register + sign in) of the app, kept
/// behind the approved login's prototype link. When the cubit emits
/// [Authenticated] we pop to the root route so the boot gate swaps to the
/// resident home.
class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();
  bool creating = false;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(creating ? AppLocaleKey.createAccount.tr() : AppLocaleKey.signIn.tr())),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        AppImages.rounderWordmark,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        creating ? AppLocaleKey.createAccount.tr() : AppLocaleKey.welcome.tr(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 28),
                      if (creating) ...[
                        EmailLoginField(
                          controller: name,
                          label: AppLocaleKey.fullName.tr(),
                          icon: Icons.person_outline,
                          validator: (value) =>
                              value == null || value.trim().length < 2
                              ? AppLocaleKey.requiredField.tr()
                              : null,
                        ),
                        const SizedBox(height: 12),
                        EmailLoginField(
                          controller: phone,
                          label: AppLocaleKey.phone.tr(),
                          icon: Icons.phone_outlined,
                          keyboard: TextInputType.phone,
                          requiredField: false,
                          validator: (value) =>
                              value != null &&
                                  value.isNotEmpty &&
                                  !RegExp(r'^\+[1-9][0-9]{7,14}$').hasMatch(value)
                              ? AppLocaleKey.phoneFormat.tr()
                              : null,
                        ),
                        const SizedBox(height: 12),
                      ],
                      EmailLoginField(
                        controller: email,
                        label: AppLocaleKey.email.tr(),
                        icon: Icons.email_outlined,
                        keyboard: TextInputType.emailAddress,
                        validator: (value) =>
                            value == null ||
                                value.trim().length > 254 ||
                                !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())
                            ? AppLocaleKey.emailInvalid.tr()
                            : null,
                      ),
                      const SizedBox(height: 12),
                      EmailLoginField(
                        controller: password,
                        label: AppLocaleKey.password.tr(),
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (value) =>
                            value == null ||
                                value.length < 10 ||
                                value.length > 72 ||
                                !RegExp(r'[a-z]').hasMatch(value) ||
                                !RegExp(r'[A-Z]').hasMatch(value) ||
                                !RegExp(r'[0-9]').hasMatch(value)
                            ? AppLocaleKey.passwordRule.tr()
                            : null,
                      ),
                      if (creating) ...[
                        const SizedBox(height: 12),
                        EmailLoginField(
                          controller: confirm,
                          label: AppLocaleKey.confirmPassword.tr(),
                          icon: Icons.lock_reset,
                          obscure: true,
                          validator: (value) =>
                              value != password.text ? AppLocaleKey.passwordMismatch.tr() : null,
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
                                onPressed: state is AuthChecking ? null : submit,
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
                        onPressed: () => setState(() => creating = !creating),
                        child: Text(
                          creating
                              ? AppLocaleKey.haveAccount.tr()
                              : AppLocaleKey.createAccount.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    final cubit = context.read<AuthCubit>();
    if (creating) {
      await cubit.register(
        name: name.text,
        email: email.text,
        phone: phone.text,
        password: password.text,
        locale: context.locale.languageCode,
      );
    } else {
      await cubit.signIn(email.text, password.text);
    }
  }
}
