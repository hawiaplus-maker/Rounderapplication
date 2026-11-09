import 'package:rounder_application/core/locale/app_locale_key.dart';

/// Built-in ticket categories used only when `GET /resident/support/info` does
/// not return the backend's own category list. [code] is the value the tickets
/// endpoint receives; [labelKey] is the translated chip label.
enum SupportTicketCategory {
  order('order_issue', AppLocaleKey.contactCategoryOrder),
  payment('payment', AppLocaleKey.contactCategoryPayment),
  home('home', AppLocaleKey.contactCategoryHome),
  other('other', AppLocaleKey.contactCategoryOther);

  const SupportTicketCategory(this.code, this.labelKey);

  final String code;
  final String labelKey;
}
