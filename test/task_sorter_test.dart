import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/models/task_sort_order.dart';
import 'package:my_app/services/task_sorter.dart';

Task _makeTask({
  required String id,
  required DateTime deadline,
  required DateTime createdAt,
  double requiredHours = 2,
  int avoidance = 5,
}) {
  return Task()
    ..id = id
    ..title = id
    ..deadline = deadline
    ..requiredHours = requiredHours
    ..avoidance = avoidance
    ..isCompleted = false
    ..createdAt = createdAt
    ..type = TaskType.report;
}

void main() {
  final now = DateTime(2026, 6, 12, 12, 0);

  group('partitionAndSortTasks', () {
    test('overdue tasks are partitioned and sorted by createdAt', () {
      final overdueNew = _makeTask(
        id: 'overdue-new',
        deadline: now.subtract(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
      );
      final overdueOld = _makeTask(
        id: 'overdue-old',
        deadline: now.subtract(const Duration(hours: 5)),
        createdAt: now.subtract(const Duration(days: 10)),
      );
      final active = _makeTask(
        id: 'active',
        deadline: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 5)),
      );

      final result = partitionAndSortTasks(
        [overdueNew, active, overdueOld],
        TaskSortOrder.tgl,
        now: now,
      );

      expect(result.overdue.map((t) => t.id), ['overdue-old', 'overdue-new']);
      expect(result.active.map((t) => t.id), ['active']);
    });

    test('tgl order: higher TGL (more urgent) comes first', () {
      final urgent = _makeTask(
        id: 'urgent',
        deadline: now.add(const Duration(hours: 4)),
        requiredHours: 3,
        avoidance: 8,
        createdAt: now.subtract(const Duration(days: 1)),
      );
      final relaxed = _makeTask(
        id: 'relaxed',
        deadline: now.add(const Duration(days: 14)),
        requiredHours: 1,
        avoidance: 2,
        createdAt: now.subtract(const Duration(days: 10)),
      );

      final result = partitionAndSortTasks(
        [relaxed, urgent],
        TaskSortOrder.tgl,
        now: now,
      );

      expect(result.active.map((t) => t.id), ['urgent', 'relaxed']);
    });

    test('near-equal TGL falls back to createdAt order', () {
      // 同一の締切・必要時間・回避度 → TGL完全一致 → createdAt 昇順
      final older = _makeTask(
        id: 'older',
        deadline: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 3)),
      );
      final newer = _makeTask(
        id: 'newer',
        deadline: now.add(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 1)),
      );

      final result = partitionAndSortTasks(
        [newer, older],
        TaskSortOrder.tgl,
        now: now,
      );

      expect(result.active.map((t) => t.id), ['older', 'newer']);
    });

    test('deadline order: earlier deadline comes first', () {
      final later = _makeTask(
        id: 'later',
        deadline: now.add(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 10)),
      );
      final sooner = _makeTask(
        id: 'sooner',
        deadline: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
      );

      final result = partitionAndSortTasks(
        [later, sooner],
        TaskSortOrder.deadline,
        now: now,
      );

      expect(result.active.map((t) => t.id), ['sooner', 'later']);
    });

    test('same deadline falls back to createdAt order', () {
      final deadline = now.add(const Duration(days: 2));
      final older = _makeTask(
        id: 'older',
        deadline: deadline,
        createdAt: now.subtract(const Duration(days: 5)),
      );
      final newer = _makeTask(
        id: 'newer',
        deadline: deadline,
        createdAt: now.subtract(const Duration(days: 1)),
      );

      final result = partitionAndSortTasks(
        [newer, older],
        TaskSortOrder.deadline,
        now: now,
      );

      expect(result.active.map((t) => t.id), ['older', 'newer']);
    });

    test('result is deterministic regardless of input order', () {
      // TGLが近接する多数のタスクでも、入力順に依らず同一の並びになること
      // （旧実装の許容差比較は非推移的で、入力順により結果が変わり得た）
      final tasks = List.generate(20, (i) {
        return _makeTask(
          id: 'task-$i',
          deadline: now.add(Duration(days: 2, minutes: i * 7)),
          createdAt: now.subtract(Duration(days: 20 - i)),
        );
      });

      final baseline = partitionAndSortTasks(tasks, TaskSortOrder.tgl, now: now)
          .active
          .map((t) => t.id)
          .toList();

      final reversed = partitionAndSortTasks(
        tasks.reversed.toList(),
        TaskSortOrder.tgl,
        now: now,
      ).active.map((t) => t.id).toList();

      final shuffled = [...tasks]..shuffle();
      final fromShuffled =
          partitionAndSortTasks(shuffled, TaskSortOrder.tgl, now: now)
              .active
              .map((t) => t.id)
              .toList();

      expect(reversed, baseline);
      expect(fromShuffled, baseline);
    });

    test('preceding load can reorder tasks vs v1.4 (slack補正)', () {
      // B: 締切は遠いが、先行タスク群に時間を食われて実質逼迫している
      final b = _makeTask(
        id: 'b',
        deadline: now.add(const Duration(hours: 60)),
        requiredHours: 4,
        avoidance: 8,
        createdAt: now.subtract(const Duration(days: 1)),
      );
      // C: Bより少し逼迫して見える（v1.4なら上に来る）が、先行負荷なし
      final c = _makeTask(
        id: 'c',
        deadline: now.add(const Duration(hours: 100)),
        requiredHours: 6,
        avoidance: 9,
        createdAt: now.subtract(const Duration(days: 2)),
      );
      // Bに先行する重いタスク群（締切60h未満）
      final blockers = List.generate(3, (i) {
        return _makeTask(
          id: 'blocker-$i',
          deadline: now.add(Duration(hours: 10 + i * 5)),
          requiredHours: 8,
          avoidance: 5,
          createdAt: now.subtract(const Duration(days: 3)),
        );
      });

      final result = partitionAndSortTasks(
        [c, b, ...blockers],
        TaskSortOrder.tgl,
        now: now,
      );
      final ids = result.active.map((t) => t.id).toList();
      // 先行負荷24hを差し引かれたBは、負荷8h相当のCより逼迫扱いになる
      expect(ids.indexOf('b'), lessThan(ids.indexOf('c')));
    });

    test('does not mutate the input list', () {
      final a = _makeTask(
        id: 'a',
        deadline: now.add(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 1)),
      );
      final b = _makeTask(
        id: 'b',
        deadline: now.add(const Duration(hours: 3)),
        requiredHours: 2.5,
        avoidance: 9,
        createdAt: now.subtract(const Duration(days: 2)),
      );
      final input = [a, b];

      partitionAndSortTasks(input, TaskSortOrder.tgl, now: now);

      expect(input.map((t) => t.id), ['a', 'b']);
    });
  });
}
