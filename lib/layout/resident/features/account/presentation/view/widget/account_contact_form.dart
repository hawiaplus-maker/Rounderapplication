import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounder_application/core/locale/app_locale_key.dart';
import 'package:rounder_application/core/theme/app_text_styles.dart';
import 'package:rounder_application/core/theme/app_theme.dart';
import 'package:rounder_application/layout/global/features/auth/validation/auth_validators.dart';
import 'package:rounder_application/layout/resident/features/account/data/model/support_info_model.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_input.dart';
import 'package:rounder_application/layout/resident/features/account/presentation/view/widget/account_panel.dart';

/// Message form of the contact page: category chips, subject, description,
/// optional image and the send action. The page owns the controllers; this
/// widget owns the form rule, the category and the picked attachment.
class AccountContactForm extends StatefulWidget {
  const AccountContactForm({
    super.key,
    required this.subjectController,
    required this.messageController,
    required this.categories,
    required this.onSubmit,
    this.sending = false,
  });

  final TextEditingController subjectController;
  final TextEditingController messageController;

  /// The backend's ticket categories, or the localized built-in fallback.
  final List<SupportCategory> categories;

  /// Called only after the subject and the description pass validation, with
  /// the picked category and the optional attachment.
  final void Function(SupportCategory, XFile?) onSubmit;

  /// A ticket request is in flight; the send action stays disabled.
  final bool sending;

  @override
  State<AccountContactForm> createState() => _AccountContactFormState();
}

class _AccountContactFormState extends State<AccountContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  SupportCategory? _category;
  XFile? _attachment;

  SupportCategory? get _selectedCategory =>
      _category ?? (widget.categories.isEmpty ? null : widget.categories.first);

  @override
  void didUpdateWidget(AccountContactForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final SupportCategory? selected = _category;
    // The server categories replace the fallback once the info arrives; drop
    // a fallback selection that no longer exists in the new list.
    if (selected != null &&
        !widget.categories.any(
          (SupportCategory category) => category.value == selected.value,
        )) {
      _category = null;
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (!mounted || file == null) return;
      setState(() => _attachment = file);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocaleKey.imagePickFailed.tr())),
        );
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final SupportCategory? category = _selectedCategory;
    if (category == null) return;
    widget.onSubmit(category, _attachment);
  }

  @override
  Widget build(BuildContext context) {
    return AccountPanel(
      children: [
        Text(
          AppLocaleKey.contactFormTitle.tr(),
          textAlign: TextAlign.start,
          style: AppTextStyles.extraBold20.copyWith(color: AppColors.petrol),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final SupportCategory category in widget.categories)
              ChoiceChip(
                label: Text(
                  category.label,
                  style: AppTextStyles.labelAction.copyWith(
                    color: AppColors.petrol,
                  ),
                ),
                selected: _selectedCategory?.value == category.value,
                onSelected: (_) => setState(() => _category = category),
                showCheckmark: false,
                selectedColor: AppColors.mint,
                backgroundColor: AppColors.white,
                side: BorderSide(
                  color: _selectedCategory?.value == category.value
                      ? AppColors.teal
                      : AppColors.stroke,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                labelPadding: EdgeInsets.zero,
              ),
          ],
        ),
        const SizedBox(height: 16),
        Form(
          key: _formKey,
          child: Column(
            children: [
              AccountInput(
                labelKey: AppLocaleKey.contactSubject,
                controller: widget.subjectController,
                hintKey: AppLocaleKey.contactSubjectHint,
                validator: AuthValidators.requiredField,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              AccountInput(
                labelKey: AppLocaleKey.contactDescription,
                controller: widget.messageController,
                hintKey: AppLocaleKey.contactMessageHint,
                validator: AuthValidators.requiredField,
                keyboard: TextInputType.multiline,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _AttachmentRow(fileName: _attachment?.name, onTap: _pickAttachment),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: widget.sending ? null : _submit,
            icon: widget.sending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(AppLocaleKey.contactSend.tr()),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          AppLocaleKey.contactResponseNote.tr(),
          textAlign: TextAlign.center,
          style: AppTextStyles.captionRegular.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _AttachmentRow extends StatelessWidget {
  const _AttachmentRow({required this.fileName, required this.onTap});

  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mint.withValues(alpha: .35),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.add_rounded, size: 20, color: AppColors.teal),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName ?? AppLocaleKey.contactAttachment.tr(),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.captionSemiBold13.copyWith(
                        color: AppColors.petrol,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocaleKey.contactAttachmentHint.tr(),
                      textAlign: TextAlign.start,
                      style: AppTextStyles.captionRegular.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.attach_file_rounded,
                size: 18,
                color: AppColors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
