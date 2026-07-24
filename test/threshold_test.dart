import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/models/tgl_state.dart';
import 'package:my_app/models/user_preference.dart';
import 'package:my_app/services/tgl_calculator.dart';
import 'package:my_app/services/threshold_editor_logic.dart';
import 'package:my_app/services/threshold_provider.dart';

Task _makeTask({
  required DateTime deadline,
  required double requiredHours,
  required int avoidance,
}) {
  return Task()
    ..id = 'test'
    ..title = 'Test'
    ..deadline = deadline
    ..requiredHours = requiredHours
    ..avoidance = avoidance
    ..isCompleted = false
    ..createdAt = DateTime.now()
    ..type = TaskType.report;
}

void main() {
  group('clampThreshold', () {
    test('clamps to slider range', () {
      final values = [0.4, 1.5, 6.0, 20.0];
      expect(clampThreshold(0, -5.0, values), kThresholdRanges[0].min);
      expect(clampThreshold(3, 999.0, values), kThresholdRanges[3].max);
    });

    test('cannot cross the neighbor above (strict monotonic)', () {
      final values = [0.4, 1.5, 6.0, 20.0];
      // peaceful を someday(1.5) 以上へ上げようとする → 1.4 で止まる
      expect(clampThreshold(0, 1.9, values), closeTo(1.5 - kThresholdGap, 1e-9));
    });

    test('cannot cross the neighbor below', () {
      final values = [0.4, 1.5, 6.0, 20.0];
      // someday を peaceful(0.4) 以下へ下げようとする → 0.5 で止まる
      expect(clampThreshold(1, 0.1, values), closeTo(0.5, 1e-9)); // range min優先
      final tight = [1.0, 1.5, 6.0, 20.0];
      expect(clampThreshold(1, 0.5, tight), closeTo(1.0 + kThresholdGap, 1e-9));
    });

    test('any sequence of clamped edits preserves strict ordering', () {
      final values = [0.4, 1.5, 6.0, 20.0];
      final edits = [
        (0, 2.0), (1, 0.5), (2, 15.0), (3, 5.0), (1, 5.0), (2, 2.0),
      ];
      for (final (i, v) in edits) {
        values[i] = clampThreshold(i, v, values);
        for (int k = 0; k < 3; k++) {
          expect(values[k], lessThan(values[k + 1]),
              reason: 'ordering broken after edit ($i, $v): $values');
        }
      }
    });
  });

  group('ThresholdProvider.fromPreference', () {
    UserPreference pref(
        {required bool unlocked, required bool useCustom}) {
      return UserPreference()
        ..isThresholdsUnlocked = unlocked
        ..useCustomThresholds = useCustom
        ..customPeaceful = 1.0
        ..customSomeday = 2.0
        ..customReality = 8.0
        ..customNoEscape = 30.0;
    }

    test('custom applied only when unlocked AND enabled (4象限)', () {
      expect(ThresholdProvider.fromPreference(pref(unlocked: true, useCustom: true)).peaceful, 1.0);
      expect(ThresholdProvider.fromPreference(pref(unlocked: true, useCustom: false)).peaceful, TGLThresholds.peaceful);
      expect(ThresholdProvider.fromPreference(pref(unlocked: false, useCustom: true)).peaceful, TGLThresholds.peaceful);
      expect(ThresholdProvider.fromPreference(pref(unlocked: false, useCustom: false)).peaceful, TGLThresholds.peaceful);
    });

    test('NaN / null custom values fall back to defaults (isar移行対策)', () {
      final p = UserPreference()
        ..isThresholdsUnlocked = true
        ..useCustomThresholds = true
        ..customPeaceful = double.nan
        ..customSomeday = null;
      final set = ThresholdProvider.fromPreference(p);
      expect(set.peaceful, TGLThresholds.peaceful);
      expect(set.someday, TGLThresholds.someday);
    });
  });

  group('taskToState with custom thresholds', () {
    test('custom thresholds move state boundaries', () {
      final now = DateTime(2026, 1, 1);
      // TGL ≈ 3.08（デフォルトでは reality 帯）
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 24)),
        requiredHours: 5,
        avoidance: 8,
      );
      expect(taskToState(task, now: now), TGLState.reality);

      // reality の下限を 4.0 に引き上げると someday 帯に落ちる
      const relaxed = TGLThresholdSet(
          peaceful: 0.4, someday: 4.0, reality: 10.0, noEscape: 40.0);
      expect(taskToState(task, now: now, thresholds: relaxed),
          TGLState.someday);

      // 逆に閾値を厳しくすると war になる
      const strict = TGLThresholdSet(
          peaceful: 0.1, someday: 0.5, reality: 2.0, noEscape: 3.0);
      expect(taskToState(task, now: now, thresholds: strict), TGLState.war);
    });

    test('overdue unaffected by custom thresholds', () {
      final now = DateTime(2026, 1, 1);
      final task = _makeTask(
        deadline: now.subtract(const Duration(hours: 1)),
        requiredHours: 2,
        avoidance: 5,
      );
      const strict = TGLThresholdSet(
          peaceful: 0.1, someday: 0.5, reality: 2.0, noEscape: 3.0);
      expect(taskToState(task, now: now, thresholds: strict),
          TGLState.overdue);
    });
  });

  group('UserPreference accessors', () {
    test('nudgeShownCount defaults to 0 for null raw', () {
      expect(UserPreference().nudgeShownCount, 0);
      expect((UserPreference()..nudgeShownCountRaw = 2).nudgeShownCount, 2);
    });
  });
}
