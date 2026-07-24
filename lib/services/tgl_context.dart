import '../models/task.dart';

/// マルチタスクslack補正（v1.5）のための precedingLoad 事前計算。
///
/// 先行タスク P(i) = 未完了 かつ 自分以外 かつ
///   (締切が早い、または 同時刻締切なら createdAt が早い) タスク。
/// precedingLoad(i) = P(i) の requiredHours 合計。
///
/// (deadline, createdAt) 昇順ソート＋累積和で O(N log N)。
/// 同時刻締切は createdAt の早い方のみが先行（相互参照しない）。
class TglContext {
  final Map<String, double> _loads;

  const TglContext._(this._loads);

  static const TglContext empty = TglContext._({});

  /// [incompleteTasks] は未完了・論理削除除外済みのリストを渡すこと
  /// （DatabaseService.getAllIncompleteTasks / watchIncompleteTasks の結果）。
  factory TglContext.of(List<Task> incompleteTasks) {
    final sorted = List<Task>.of(incompleteTasks)
      ..sort((a, b) {
        final cmp = a.deadline.compareTo(b.deadline);
        if (cmp != 0) return cmp;
        return a.createdAt.compareTo(b.createdAt);
      });

    final loads = <String, double>{};
    double runningLoad = 0.0;
    for (final task in sorted) {
      loads[task.id] = runningLoad;
      runningLoad += task.requiredHours;
    }
    return TglContext._(loads);
  }

  /// タスクの先行負荷（時間）。コンテキスト外のタスクは 0。
  double loadFor(Task task) => _loads[task.id] ?? 0.0;
}
