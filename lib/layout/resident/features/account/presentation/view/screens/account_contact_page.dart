import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_info_model.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_ticket_model.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/cubit/support_cubit.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/model/support_ticket_category.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/screens/account_sub_page.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_channels.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_form.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_contact_intro.dart';
import 'package:url_launcher/url_launcher.dart';

/// Contact page: the support channels fetched from `GET /resident/support/info`
/// and the ticket form submitted to `POST /resident/support/tickets`. The send
/// action hands the accepted ticket back to the account flow, which shows the
/// success page with the server reference.
class AccountContactPage extends StatefulWidget {
  const AccountContactPage({
    super.key,
    required this.onBack,
    required this.onSubmitted,
  });

  final VoidCallback onBack;
  final ValueChanged<SupportTicket> onSubmitted;

  @override
  State<AccountContactPage> createState() => _AccountContactPageState();
}

class _AccountContactPageState extends State<AccountContactPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final GlobalKey _formSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    context.read<SupportCubit>().ensureLoaded();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// The chat row has no separate chat channel yet, so it brings the message
  /// form into view instead of opening an empty channel.
  void _scrollToForm() {
    final BuildContext? formContext = _formSectionKey.currentContext;
    if (formContext == null) return;
    Scrollable.ensureVisible(
      formContext,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _launch(Uri uri) async {
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) _showLaunchError();
    } catch (_) {
      _showLaunchError();
    }
  }

  void _showLaunchError() {
    if (!mounted) return;
    _toast(AppLocaleKey.connectionError.tr());
  }

  /// Sends the ticket through the cubit and opens the success page with the
  /// reference the backend assigned. A rejected ticket keeps this page open
  /// with the server's message.
  Future<void> _submit(SupportCategory category, XFile? attachment) async {
    final SupportCubit cubit = context.read<SupportCubit>();
    final SupportTicket? ticket = await cubit.sendTicket(
      category: category.value,
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
      attachmentPath: attachment?.path,
      attachmentName: attachment?.name,
    );
    if (!mounted) return;
    if (ticket == null) {
      final SupportState state = cubit.state;
      final String error = state is SupportReady
          ? state.error
          : state is SupportFailure
          ? state.message
          : '';
      _toast(error.isEmpty ? AppLocaleKey.connectionError.tr() : error);
      return;
    }
    widget.onSubmitted(ticket);
  }

  void _toast(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupportCubit, SupportState>(
      builder: (context, state) {
        final SupportInfo info = state is SupportReady
            ? state.info
            : const SupportInfo();
        final bool sending = state is SupportReady && state.sending;
        final String phone = info.phone.isNotEmpty
            ? info.phone
            : AppLocaleKey.contactSupportPhone.tr();
        final String email = info.email.isNotEmpty
            ? info.email
            : AppLocaleKey.contactSupportEmail.tr();
        final String hours = info.workingHours.isNotEmpty
            ? info.workingHours
            : AppLocaleKey.contactChatHours.tr();
        final String dialablePhone = phone.replaceAll(RegExp(r'\s+'), '');
        final List<SupportCategory> categories = info.categories.isNotEmpty
            ? info.categories
            : SupportTicketCategory.values
                  .map(
                    (SupportTicketCategory category) => SupportCategory(
                      value: category.code,
                      label: category.labelKey.tr(),
                    ),
                  )
                  .toList();

        return AccountSubPage(
          titleKey: AppLocaleKey.contactUs,
          onBack: widget.onBack,
          children: [
            AccountContactIntro(
              titleKey: AppLocaleKey.contactUs,
              subtitleKey: AppLocaleKey.contactIntroBody,
            ),
            AccountContactChannels(
              phone: phone,
              email: email,
              hours: hours,
              onChat: _scrollToForm,
              onCall: () => _launch(Uri(scheme: 'tel', path: dialablePhone)),
              onEmail: () => _launch(Uri(scheme: 'mailto', path: email)),
            ),
            AccountContactForm(
              key: _formSectionKey,
              subjectController: _subjectController,
              messageController: _messageController,
              categories: categories,
              sending: sending,
              onSubmit: _submit,
            ),
          ],
        );
      },
    );
  }
}
