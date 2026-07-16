import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/models/tgl_state.dart';
import 'package:my_app/services/tgl_calculator.dart';

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
  group('kActiveRatio', () {
    test('equals 0.75 (18h / 24h)', () {
      expect(kActiveHoursPerDay, 18.0);
      expect(kActiveRatio, 0.75);
    });
  });

  group('calculateTGL', () {
    test('returns higher TGL than raw calendar would (sleep correction)', () {
      final now = DateTime.now();
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 24)),
        requiredHours: 5,
        avoidance: 8,
      );
      final tgl = calculateTGL(task);
      // With kActiveRatio=0.75, effectiveHours=18, slack≈13, TGL≈40/13≈3.08
      // Without correction (raw 24h), slack≈19, TGL≈40/19≈2.11
      expect(tgl, greaterThan(2.11));
      expect(tgl, closeTo(3.08, 0.1));
    });

    test('72h deadline, T=5, M=8 → someday range', () {
      final now = DateTime.now();
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 72)),
        requiredHours: 5,
        avoidance: 8,
      );
      final tgl = calculateTGL(task);
      // effectiveHours=54, slack≈49, TGL≈40/49≈0.82
      expect(tgl, closeTo(0.82, 0.1));
      expect(tgl, lessThan(TGLThresholds.someday)); // < 1.5 → someday
    });

    test('24h deadline, T=5, M=8 → reality range', () {
      final now = DateTime.now();
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 24)),
        requiredHours: 5,
        avoidance: 8,
      );
      final tgl = calculateTGL(task);
      // effectiveHours=18, slack≈13, TGL≈40/13≈3.08
      expect(tgl, greaterThanOrEqualTo(TGLThresholds.someday));
      expect(tgl, lessThan(TGLThresholds.reality));
    });

    test('3h deadline, T=2, M=5 → war range', () {
      final now = DateTime.now();
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 3)),
        requiredHours: 2,
        avoidance: 5,
      );
      final tgl = calculateTGL(task);
      // effectiveHours=2.25, slack≈0.25, TGL=10/0.25=40
      expect(tgl, greaterThanOrEqualTo(TGLThresholds.noEscape));
    });
  });

  group('calendarHoursUntilThreshold', () {
    // 締切まで十分先の同一タスクに対し、しきい値ごとの到達時刻を比較する。
    // TGL は締切に近づくほど上がるので、しきい値が高い状態ほど遅く到達するはず。
    // 反転バグ（残り時間と経過時間の取り違え）が復活すると、この順序が崩れる。
    test('higher thresholds are reached later (monotonic ordering)', () {
      final now = DateTime(2026, 1, 1, 0, 0);
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 100)),
        requiredHours: 2,
        avoidance: 5,
      );
      final someday =
          calendarHoursUntilThreshold(task, TGLThresholds.peaceful, now: now);
      final reality =
          calendarHoursUntilThreshold(task, TGLThresholds.someday, now: now);
      final noEscape =
          calendarHoursUntilThreshold(task, TGLThresholds.reality, now: now);
      final war =
          calendarHoursUntilThreshold(task, TGLThresholds.noEscape, now: now);

      expect(someday, isNotNull);
      expect(reality, isNotNull);
      expect(noEscape, isNotNull);
      expect(war, isNotNull);

      // someday → reality → noEscape → war の順に単調増加（＝war が締切に最も近い）
      expect(someday!, lessThan(reality!));
      expect(reality, lessThan(noEscape!));
      expect(noEscape, lessThan(war!));
    });

    test('result is within (0, calendarHours)', () {
      final now = DateTime(2026, 1, 1, 0, 0);
      const calendarHours = 100.0;
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 100)),
        requiredHours: 2,
        avoidance: 5,
      );
      final war =
          calendarHoursUntilThreshold(task, TGLThresholds.noEscape, now: now)!;
      expect(war, greaterThan(0));
      expect(war, lessThan(calendarHours));
      // war は締切に近い側で到達する（前半ではなく後半）
      expect(war, greaterThan(calendarHours / 2));
    });

    test('returns null when threshold already reached', () {
      final now = DateTime(2026, 1, 1, 0, 0);
      // 締切間際・高逼迫度で、既に war しきい値を超えている
      final task = _makeTask(
        deadline: now.add(const Duration(hours: 2)),
        requiredHours: 2,
        avoidance: 5,
      );
      expect(
        calendarHoursUntilThreshold(task, TGLThresholds.noEscape, now: now),
        isNull,
      );
    });

    test('returns null when threshold never reached before deadline', () {
      final now = DateTime(2026, 1, 1, 0, 0);
      // 必要時間が極小・低回避度で、締切時点(残り0)でも noEscape へ到達しない
      final task = _makeTask(
        deadline: now.add(const Duration(days: 60)),
        requiredHours: 0.1,
        avoidance: 1,
      );
      expect(
        calendarHoursUntilThreshold(task, TGLThresholds.noEscape, now: now),
        isNull,
      );
    });

    test('returns null for past deadline', () {
      final now = DateTime(2026, 1, 1, 0, 0);
      final task = _makeTask(
        deadline: now.subtract(const Duration(hours: 1)),
        requiredHours: 2,
        avoidance: 5,
      );
      expect(
        calendarHoursUntilThreshold(task, TGLThresholds.someday, now: now),
        isNull,
      );
    });
  });

  group('taskToState', () {
    test('overdue task returns TGLState.overdue', () {
      final task = _makeTask(
        deadline: DateTime.now().subtract(const Duration(hours: 1)),
        requiredHours: 2,
        avoidance: 5,
      );
      expect(taskToState(task), TGLState.overdue);
    });

    test('far-future task returns peaceful or someday', () {
      final task = _makeTask(
        deadline: DateTime.now().add(const Duration(days: 30)),
        requiredHours: 1,
        avoidance: 1,
      );
      final state = taskToState(task);
      expect(state, anyOf(TGLState.peaceful, TGLState.someday));
    });
  });
}
