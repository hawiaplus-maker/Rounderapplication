import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_locale_key.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../resident/data/repositories/resident_repository.dart';
import '../../../resident/presentation/cubit/resident_dashboard_cubit.dart';
import '../../../resident/presentation/screens/resident_home_screen.dart';
import '../../../resident/presentation/screens/resident_welcome_flow.dart';
import '../auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return Scaffold(
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
                    Image.asset(AppImages.rounderLogo, height: 78, fit: BoxFit.contain),
                    const SizedBox(height: 12),
                    const SizedBox(height: 8),
                    Text(
                      creating ? AppLocaleKey.createAccount.tr() : AppLocaleKey.welcome.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 28),
                    if (creating) ...[
                      _field(
                        name,
                        AppLocaleKey.fullName.tr(),
                        icon: Icons.person_outline,
                        validator: (value) => value == null || value.trim().length < 2
                            ? AppLocaleKey.requiredField.tr()
                            : null,
                      ),
                      const SizedBox(height: 12),
                      _field(
                        phone,
                        AppLocaleKey.phone.tr(),
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
                    _field(
                      email,
                      AppLocaleKey.email.tr(),
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
                    _field(
                      password,
                      AppLocaleKey.password.tr(),
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
                      _field(
                        confirm,
                        AppLocaleKey.confirmPassword.tr(),
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
                                style: const TextStyle(color: Colors.red),
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
                                        color: Colors.white,
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
                        creating ? AppLocaleKey.haveAccount.tr() : AppLocaleKey.createAccount.tr(),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => BlocProvider(
                            create: (_) => ResidentDashboardCubit.preview(sl<ResidentRepository>()),
                            child: const ResidentHomeScreen(),
                          ),
                        ),
                      ),
                      child: Text(AppLocaleKey.exploreRounder.tr()),
                    ),
                    Text(AppLocaleKey.prototypeData.tr(), textAlign: TextAlign.center),
                    TextButton(
                      onPressed: () => Navigator.of(
                        context,
                      ).push(MaterialPageRoute<void>(builder: (_) => const ResidentWelcomeFlow())),
                      child: Text(AppLocaleKey.welcomeSteps.tr()),
                    ),
                    TextButton(
                      onPressed: chooseLanguage,
                      child: Text('🌐  ${AppLocaleKey.language.tr()}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    IconData? icon,
    bool obscure = false,
    TextInputType? keyboard,
    bool requiredField = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      autofillHints: obscure ? const [AutofillHints.password] : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon == null ? null : Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      validator:
          validator ??
          (value) => requiredField && (value == null || value.isEmpty)
              ? AppLocaleKey.requiredField.tr()
              : null,
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

  Future<void> chooseLanguage() async {
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: Colors.white,
              title: Text(AppLocaleKey.arabic.tr()),
              onTap: () => Navigator.pop(context, const Locale('ar')),
            ),
            ListTile(
              tileColor: Colors.white,
              title: Text(AppLocaleKey.english.tr()),
              onTap: () => Navigator.pop(context, const Locale('en')),
            ),
            ListTile(
              tileColor: Colors.white,
              title: Text(AppLocaleKey.urdu.tr()),
              onTap: () => Navigator.pop(context, const Locale('ur')),
            ),
          ],
        ),
      ),
    );
    if (selected != null && mounted) context.setLocale(selected);
  }
}
