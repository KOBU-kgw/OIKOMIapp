import '../models/task.dart';
import '../models/task_sort_order.dart';
import '../models/tgl_state.dart';
import 'tgl_calculator.dart';

/// TGL差がこの幅未満のタスクは同順位とみなし、作成日時順で並べる
const double kTglTieTolerance = 0.05;

/// タスクを期限切れ／進行中に分割し、それぞれソートして返す。
///
/// TGL・状態の評価は単一の基準時刻 [now] で行うため、ソート中に
/// 値がぶれない。TGL順の比較は kTglTieTolerance 幅で量子化した
/// 整数バケットで行う（近似値の許容比較は推移律を満たさないため）。
({List<Task> overdue, List<Task> active}) partitionAndSortTasks(
  List<Task> tasks,
  TaskSortOrder order, {
  DateTime? now,
}) {
  final reference = now ?? DateTime.now();

  final overdue = <Task>[];
  final entries = <({Task task, int tglBucket})>[];
  for (final task in tasks) {
    if (taskToState(task, now: reference) == TGLState.overdue) {
      overdue.add(task);
    } else {
      entries.add((
        task: task,
        tglBucket:
            (calculateTGL(task, now: reference) / kTglTieTolerance).round(),
      ));
    }
  }

  overdue.sort((a, b) => a.createdAt.compareTo(b.createdAt));

  entries.sort((a, b) {
    switch (order) {
      case TaskSortOrder.tgl:
        final cmp = b.tglBucket.compareTo(a.tglBucket);
        if (cmp != 0) return cmp;
      case TaskSortOrder.deadline:
        final cmp = a.task.deadline.compareTo(b.task.deadline);
        if (cmp != 0) return cmp;
    }
    return a.task.createdAt.compareTo(b.task.createdAt);
  });

  return (overdue: overdue, active: [for (final e in entries) e.task]);
}
