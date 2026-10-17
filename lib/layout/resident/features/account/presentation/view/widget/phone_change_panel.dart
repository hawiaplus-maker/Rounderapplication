import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounder_application/core/images/app_images.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/phone_change_cubit.dart';

/// Figma 636:1160 and 636:1205. Verification updates the edit draft only.
class PhoneChangePanel extends StatefulWidget {
  const PhoneChangePanel({super.key, required this.onVerified});
  final ValueChanged<String> onVerified;
  @override State<PhoneChangePanel> createState() => _PhoneChangePanelState();
}

class _PhoneChangePanelState extends State<PhoneChangePanel> {
  final _phone = TextEditingController();
  final _code = TextEditingController();
  @override void dispose() { _phone.dispose(); _code.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) => BlocProvider(
    create: (_) => PhoneChangeCubit(),
    child: BlocConsumer<PhoneChangeCubit, PhoneChangeState>(
      listener: (_, state) {
        if (state.step == PhoneChangeStep.verified) widget.onVerified(state.phone);
      },
      builder: (context, state) {
        final verifying = state.step != PhoneChangeStep.number;
        final cubit = context.read<PhoneChangeCubit>();
        return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text((verifying ? AppLocaleKey.verifyPhone : AppLocaleKey.changePhone).tr(),
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text((verifying ? AppLocaleKey.enterCodeForNumber : AppLocaleKey.newPhoneIntro).tr(),
            style: const TextStyle(color: Colors.white, fontSize: 15)),
          if (verifying) Text(state.phone, textDirection: TextDirection.ltr,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 24),
          if (!verifying) ...[
            Row(children: [
              SvgPicture.asset(AppImages.phoneShield, width: 40, height: 40),
              const SizedBox(width: 18),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(AppLocaleKey.currentPhoneUnchanged.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text(AppLocaleKey.phoneSaveHint.tr(), style: const TextStyle(color: Colors.white, fontSize: 12)),
              ])),
            ]),
            const SizedBox(height: 24),
          ],
          Container(padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: .93), borderRadius: BorderRadius.circular(24)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text((verifying ? AppLocaleKey.verificationCode : AppLocaleKey.enterNewPhone).tr(),
                style: const TextStyle(color: AppColors.petrol, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              TextField(
                key: ValueKey(verifying),
                controller: verifying ? _code : _phone,
                keyboardType: verifying ? TextInputType.number : TextInputType.phone,
                textDirection: TextDirection.ltr,
                textAlign: verifying ? TextAlign.center : TextAlign.start,
                maxLength: verifying ? 6 : 20,
                inputFormatters: verifying ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩۰-۹]'))] : null,
                autofillHints: verifying ? const [AutofillHints.oneTimeCode] : const [AutofillHints.telephoneNumber],
                decoration: InputDecoration(counterText: '', errorText: state.errorKey?.tr(),
                  hintText: verifying ? '— — — — — —' : '+966',
                  filled: true, fillColor: AppColors.mint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 14),
              Text(AppLocaleKey.previewVerification.tr(namedArgs: {'code': PhoneChangeCubit.previewCode}),
                style: const TextStyle(color: AppColors.petrol, fontSize: 12)),
              const SizedBox(height: 20),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.orange, foregroundColor: AppColors.petrol,
                  minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => verifying ? cubit.verify(_code.text) : cubit.send(_phone.text),
                child: Text((verifying ? AppLocaleKey.verifyPhone : AppLocaleKey.sendCode).tr())),
              if (verifying) ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: state.remaining == 0 ? () { _code.clear(); cubit.resend(); } : null,
                  child: Text(state.remaining == 0 ? AppLocaleKey.resendCode.tr()
                    : AppLocaleKey.resendAfter.tr(namedArgs: {'seconds': state.remaining.toString()}))),
              ],
            ])),
          const SizedBox(height: 20),
          if (verifying) FilledButton.tonal(onPressed: () { _code.clear(); cubit.editNumber(); },
            child: Text(AppLocaleKey.changePhone.tr())),
          const SizedBox(height: 10),
          Text(AppLocaleKey.phoneSaveHint.tr(), textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.petrol, fontSize: 13)),
        ]);
      },
    ),
  );
}
