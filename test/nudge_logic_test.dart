import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/nudge_logic.dart';

void main() {
  final firstLaunch = DateTime(2026, 6, 1);

  bool show({int daysAfter = 0, int shown = 0, bool unlocked = false}) {
    return shouldShowNudge(
      firstLaunchAt: firstLaunch,
      nudgeShownCount: shown,
      isUnlocked: unlocked,
      now: firstLaunch.add(Duration(days: daysAfter)),
    );
  }

  group('shouldShowNudge', () {
    test('not shown before 7 days', () {
      expect(show(daysAfter: 6), isFalse);
    });

    test('shown at 7 days (first time)', () {
      expect(show(daysAfter: 7), isTrue);
      expect(show(daysAfter: 10), isTrue);
    });

    test('after first showing, hidden until 21 days', () {
      expect(show(daysAfter: 10, shown: 1), isFalse);
      expect(show(daysAfter: 20, shown: 1), isFalse);
    });

    test('second showing at 21 days (7 + 14)', () {
      expect(show(daysAfter: 21, shown: 1), isTrue);
    });

    test('never shown a third time', () {
      expect(show(daysAfter: 100, shown: 2), isFalse);
      expect(show(daysAfter: 1000, shown: 5), isFalse);
    });

    test('suppressed for unlocked users', () {
      expect(show(daysAfter: 7, unlocked: true), isFalse);
      expect(show(daysAfter: 21, shown: 1, unlocked: true), isFalse);
    });

    test('null firstLaunchAt never shows', () {
      expect(
        shouldShowNudge(
          firstLaunchAt: null,
          nudgeShownCount: 0,
          isUnlocked: false,
          now: DateTime(2026, 6, 1),
        ),
        isFalse,
      );
    });
  });
}
