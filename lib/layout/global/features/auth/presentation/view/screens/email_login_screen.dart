import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/email_login_form.dart';

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
        appBar: AppBar(
          title: Text(
            creating
                ? AppLocaleKey.createAccount.tr()
                : AppLocaleKey.signIn.tr(),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: EmailLoginForm(
                  formKey: form,
                  name: name,
                  email: email,
                  phone: phone,
                  password: password,
                  confirm: confirm,
                  creating: creating,
                  onSubmit: submit,
                  onToggleMode: () => setState(() => creating = !creating),
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
