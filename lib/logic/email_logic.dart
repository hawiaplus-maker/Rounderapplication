/// Pure email-shape helper (rounder-logic): the single home of the address
/// pattern shared by the auth validators and the account profile check. The
/// localized message stays in the feature validators.
library;

final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

/// Whether [value] is a non-empty, address-shaped email of at most 254 chars.
bool isEmail(String value) {
  final email = value.trim();
  return email.isNotEmpty &&
      email.length <= 254 &&
      _emailPattern.hasMatch(email);
}
