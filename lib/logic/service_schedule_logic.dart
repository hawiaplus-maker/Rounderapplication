/// Pure scheduling math of the service journey (rounder-logic): combine the
/// chosen day and time — or the "fastest available" option — into the instant
/// the preview order stores, and decide whether it is still in the future.
/// No widgets, no locale, no side effects.
library;

/// Resolves the requested service instant.
///
/// [fastestAvailable] ignores the picker and schedules three hours from
/// [now]; otherwise the chosen [selectedDate] (today when null) at
/// [hour]:[minute]. [now] is injectable for deterministic tests.
DateTime resolveServiceSchedule({
  required DateTime? selectedDate,
  required int hour,
  required int minute,
  required bool fastestAvailable,
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();
  if (fastestAvailable) return reference.add(const Duration(hours: 3));
  final date = selectedDate ?? reference;
  return DateTime(date.year, date.month, date.day, hour, minute);
}

/// Whether [scheduledAt] is still after [now].
bool isServiceScheduleInFuture(DateTime scheduledAt, {DateTime? now}) =>
    scheduledAt.isAfter(now ?? DateTime.now());
