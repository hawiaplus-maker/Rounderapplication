import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rounder_application/core/services/services_locator.dart';
import 'package:rounder_application/layout/global/features/auth/data/model/validate_mobile_model.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/cubit/phone_auth_cubit.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/screens/otp_flow_screen.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/auth_gradient_backdrop.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/login_brand.dart';
import 'package:rounder_application/layout/global/features/auth/presentation/view/widget/register_form_card.dart';

/// Register step of the phone journey (validate-mobile said
/// `is_registered: false`): the validated number travels read-only while the
/// name/email and matched password pair go to `EndPoints.registerPhone` with
/// the model's local `data.mobile`. Success continues to the send-otp screen
/// of the same journey.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.validated});
  final ValidateMobileModel validated;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final form = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void _continueToOtp() {
    final validated = widget.validated;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => sl<PhoneAuthCubit>(),
          child: OtpFlowScreen(
            phone: validated.formattedMobile,
            validated: validated,
          ),
        ),
      ),
    );
  }

  void _onRegister() {
    if (!form.currentState!.validate()) return;
    context.read<PhoneAuthCubit>().registerPhone(
      name: name.text.trim(),
      email: email.text.trim(),
      phone: widget.validated.mobile,
      password: password.text,
      passwordConfirmation: confirm.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneRegistered) _continueToOtp();
      },
      child: BlocBuilder<PhoneAuthCubit, PhoneAuthState>(
        builder: (context, state) => Scaffold(
          body: AuthGradientBackdrop(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        12,
                        24,
                        12,
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const LoginBrand(),
                          const SizedBox(height: 12),
                          Form(
                            key: form,
                            child: RegisterFormCard(
                              nameController: name,
                              emailController: email,
                              passwordController: password,
                              confirmController: confirm,
                              formattedMobile: widget.validated.formattedMobile,
                              inProgress: state is PhoneAuthInProgress,
                              errorText: state is PhoneAuthFailure
                                  ? state.message
                                  : null,
                              onContinue: _onRegister,
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
        ),
      ),
    );
  }
}
