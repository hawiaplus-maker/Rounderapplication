import 'package:flutter_test/flutter_test.dart';
import 'package:rounder_application/logic/service_schedule_logic.dart';

void main() {
  final now = DateTime(2026, 10, 26, 10);

  test('chosen day and time resolve to one instant', () {
    expect(
      resolveServiceSchedule(
        selectedDate: DateTime(2026, 10, 27),
        hour: 9,
        minute: 30,
        fastestAvailable: false,
        now: now,
      ),
      DateTime(2026, 10, 27, 9, 30),
    );
    expect(
      resolveServiceSchedule(
        selectedDate: null,
        hour: 9,
        minute: 30,
        fastestAvailable: false,
        now: now,
      ),
      DateTime(2026, 10, 26, 9, 30),
    );
  });

  test('fastest available ignores the picker', () {
    expect(
      resolveServiceSchedule(
        selectedDate: DateTime(2026, 10, 27),
        hour: 9,
        minute: 30,
        fastestAvailable: true,
        now: now,
      ),
      now.add(const Duration(hours: 3)),
    );
  });

  test('past instants are not in the future', () {
    expect(
      isServiceScheduleInFuture(DateTime(2026, 10, 26, 10, 1), now: now),
      isTrue,
    );
    expect(
      isServiceScheduleInFuture(DateTime(2026, 10, 26, 9, 59), now: now),
      isFalse,
    );
  });
}
