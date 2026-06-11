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
