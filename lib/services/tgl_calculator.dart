import 'dart:math' show exp, log;
import '../models/task.dart';
import '../models/tgl_state.dart';

const double epsilon = 0.01;
const double kSmoothness = 5.0;

/// 1日の想定稼働時間（大学生想定: 睡眠6時間除く18時間）
const double kActiveHoursPerDay = 18.0;

/// カレンダー時間 → 実効稼働時間の換算係数
const double kActiveRatio = kActiveHoursPerDay / 24.0; // 0.75

double softplus(double x, double k) {
  final kx = k * x;
  if (kx > 30) return x;
  if (kx < -30) return exp(kx) / k;
  return log(1 + exp(kx)) / k;
}

double calculateTGL(Task task, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final calendarHours = task.deadline.difference(reference).inMinutes / 60.0;
  final effectiveHours = calendarHours * kActiveRatio;
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final slack = softplus(effectiveHours - T, kSmoothness) + epsilon;
  return (T * M) / slack;
}

TGLState taskToState(Task task, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final D = task.deadline.difference(reference).inMinutes / 60.0;
  if (D < 0) return TGLState.overdue;
  final tgl = calculateTGL(task, now: reference);
  if (tgl < TGLThresholds.peaceful) return TGLState.peaceful;
  if (tgl < TGLThresholds.someday)  return TGLState.someday;
  if (tgl < TGLThresholds.reality)  return TGLState.reality;
  if (tgl < TGLThresholds.noEscape) return TGLState.noEscape;
  return TGLState.war;
}

/// タスクのTGLが [threshold] に到達するまでの、今からの経過カレンダー時間（時間単位）。
/// 既に到達済み、または締切までに到達しない場合は null。
///
/// TGL は締切に近づくほど（残り時間が減るほど）増加するため、二分探索は
/// 「遷移が起きる瞬間に残っている実効時間」を求める。発火までの経過時間は
/// その残り時間ではなく「実効締切 − 残り」で算出する必要がある。
double? calendarHoursUntilThreshold(Task task, double threshold,
    {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final calendarHours = task.deadline.difference(reference).inMinutes / 60.0;
  if (calendarHours <= 0) return null;
  final effectiveDeadline = calendarHours * kActiveRatio;

  double tglAt(double effectiveD) =>
      (T * M) / (softplus(effectiveD - T, kSmoothness) + epsilon);

  if (tglAt(effectiveDeadline) >= threshold) return null; // 既に到達済み
  if (tglAt(0) < threshold) return null;                  // 締切までに到達しない

  double lo = 0.0, hi = effectiveDeadline;
  for (int i = 0; i < 40; i++) {
    final mid = (lo + hi) / 2;
    if (tglAt(mid) >= threshold) {
      lo = mid;
    } else {
      hi = mid;
    }
  }
  final remainingEffectiveAtCrossing = (lo + hi) / 2;
  // 交点は「遷移時点で残っている実効時間」。経過時間 = 実効締切 − 残り。
  final elapsedEffective = effectiveDeadline - remainingEffectiveAtCrossing;
  return elapsedEffective / kActiveRatio;
}
