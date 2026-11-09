/// Fallback reference shown on the contact success screen.
///
/// The support endpoint normally returns its own reference; this local value
/// is used only when the accepted response carries none. Keeping it here (not
/// inside the flow's build) makes the generation pure and testable.
String contactTicketReference(DateTime submittedAt) {
  final int suffix = (submittedAt.millisecondsSinceEpoch ~/ 1000) % 10000;
  return 'SUP-${suffix.toString().padLeft(4, '0')}';
}
