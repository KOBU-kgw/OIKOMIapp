import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/services/tgl_calculator.dart';
import 'package:my_app/services/tgl_context.dart';

Task _makeTask({
  required String id,
  required DateTime deadline,
  required double requiredHours,
  DateTime? createdAt,
  int avoidance = 5,
}) {
  return Task()
    ..id = id
    ..title = id
    ..deadline = deadline
    ..requiredHours = requiredHours
    ..avoidance = avoidance
    ..isCompleted = false
    ..createdAt = createdAt ?? DateTime(2026, 1, 1)
    ..type = TaskType.report;
}

/// 仕様 P(i) の定義通りの O(N²) ブルートフォース参照実装
double _bruteForceLoad(Task i, List<Task> tasks) {
  double sum = 0;
  for (final j in tasks) {
    if (j.id == i.id) continue;
    final precedes = j.deadline.isBefore(i.deadline) ||
        (j.deadline == i.deadline && j.createdAt.isBefore(i.createdAt));
    if (precedes) sum += j.requiredHours;
  }
  return sum;
}

void main() {
  final base = DateTime(2026, 6, 1, 0, 0);

  group('TglContext', () {
    // シナリオ1: タスク1件のみ → precedingLoad=0（v1.4と同一TGL）
    test('single task has zero preceding load', () {
      final task = _makeTask(
          id: 'a', deadline: base.add(const Duration(hours: 24)), requiredHours: 5);
      final ctx = TglContext.of([task]);
      expect(ctx.loadFor(task), 0.0);
      expect(
        calculateTGL(task, now: base, precedingLoad: ctx.loadFor(task)),
        calculateTGL(task, now: base),
      );
    });

    // シナリオ2: 締切が近いAを追加 → 締切が遠いBのTGLが上がる
    test('adding earlier-deadline task raises later task TGL', () {
      final b = _makeTask(
          id: 'b', deadline: base.add(const Duration(hours: 72)), requiredHours: 5);
      final a = _makeTask(
          id: 'a', deadline: base.add(const Duration(hours: 24)), requiredHours: 3);

      final before = calculateTGL(b, now: base,
          precedingLoad: TglContext.of([b]).loadFor(b));
      final ctx = TglContext.of([a, b]);
      expect(ctx.loadFor(b), a.requiredHours); // B.slack が A.T ぶん減る
      expect(ctx.loadFor(a), 0.0);
      final after = calculateTGL(b, now: base, precedingLoad: ctx.loadFor(b));
      expect(after, greaterThan(before));
    });

    // シナリオ3(の計算部分): Aを完了(除外)するとBのTGLが下がる
    test('completing preceding task lowers TGL', () {
      final a = _makeTask(
          id: 'a', deadline: base.add(const Duration(hours: 24)), requiredHours: 3);
      final b = _makeTask(
          id: 'b', deadline: base.add(const Duration(hours: 72)), requiredHours: 5);
      final withA =
          calculateTGL(b, now: base, precedingLoad: TglContext.of([a, b]).loadFor(b));
      final withoutA =
          calculateTGL(b, now: base, precedingLoad: TglContext.of([b]).loadFor(b));
      expect(withoutA, lessThan(withA));
    });

    // シナリオ4: 同時刻締切2件 → createdAt順で片方向のみ先行（相互参照しない）
    test('equal deadlines: only earlier createdAt precedes (no mutual)', () {
      final deadline = base.add(const Duration(hours: 48));
      final first = _makeTask(
          id: 'first',
          deadline: deadline,
          requiredHours: 2,
          createdAt: DateTime(2026, 1, 1));
      final second = _makeTask(
          id: 'second',
          deadline: deadline,
          requiredHours: 4,
          createdAt: DateTime(2026, 1, 2));
      final ctx = TglContext.of([second, first]);
      expect(ctx.loadFor(first), 0.0);
      expect(ctx.loadFor(second), first.requiredHours);
    });

    // シナリオ5: 先行タスクがoverdueでも P(i) に含まれ、後続のslackを圧迫する
    test('overdue preceding task still contributes load', () {
      final overdue = _makeTask(
          id: 'overdue',
          deadline: base.subtract(const Duration(hours: 5)),
          requiredHours: 6);
      final b = _makeTask(
          id: 'b', deadline: base.add(const Duration(hours: 72)), requiredHours: 5);
      final ctx = TglContext.of([overdue, b]);
      expect(ctx.loadFor(b), overdue.requiredHours);
    });

    test('unknown task returns zero load', () {
      final a = _makeTask(
          id: 'a', deadline: base.add(const Duration(hours: 24)), requiredHours: 3);
      final other = _makeTask(
          id: 'other', deadline: base.add(const Duration(hours: 1)), requiredHours: 1);
      expect(TglContext.of([a]).loadFor(other), 0.0);
    });

    // シナリオ7: 累積和実装がブルートフォース参照実装と一致（O(N²)ループなし）
    test('prefix-sum matches O(N²) brute force on random-ish set', () {
      final tasks = <Task>[];
      for (int i = 0; i < 50; i++) {
        tasks.add(_makeTask(
          id: 't$i',
          // 同時刻締切のグループも意図的に作る（i ~/ 5 で10グループ）
          deadline: base.add(Duration(hours: 6 * (i ~/ 5))),
          requiredHours: 0.5 + (i % 7),
          createdAt: DateTime(2026, 1, 1).add(Duration(minutes: (i * 37) % 500)),
        ));
      }
      final ctx = TglContext.of(tasks);
      for (final t in tasks) {
        expect(ctx.loadFor(t), closeTo(_bruteForceLoad(t, tasks), 1e-9),
            reason: 'load mismatch for ${t.id}');
      }
    });
  });
}
