/// Pure helpers of relative timestamps (rounder-logic): the notification feed
/// shows "قبل ٥ دقائق" style lines. No widgets, no locale strings — the unit and
/// its count come back raw so the caller resolves its own message.
library;

enum RelativeTimeUnit { now, minute, hour, day }

class RelativeTime {
  const RelativeTime(this.unit, [this.value = 0]);

  final RelativeTimeUnit unit;
  final int value;
}

/// Buckets [createdAt] against [now]: under a minute is "now", then minutes,
/// hours, and whole days. A timestamp in the future reads as "now".
RelativeTime relativeTime(DateTime createdAt, {DateTime? now}) {
  final Duration difference = (now ?? DateTime.now()).difference(createdAt);
  if (difference.isNegative || difference.inMinutes < 1) {
    return const RelativeTime(RelativeTimeUnit.now);
  }
  if (difference.inMinutes < 60) {
    return RelativeTime(RelativeTimeUnit.minute, difference.inMinutes);
  }
  if (difference.inHours < 24) {
    return RelativeTime(RelativeTimeUnit.hour, difference.inHours);
  }
  return RelativeTime(RelativeTimeUnit.day, difference.inDays);
}
