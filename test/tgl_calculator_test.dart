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
