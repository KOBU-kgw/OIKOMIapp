import 'dart:math' show exp, log;
import '../models/task.dart';
import '../models/tgl_state.dart';

const double epsilon = 0.01;
const double kSmoothness = 5.0;

double softplus(double x, double k) {
  final kx = k * x;
  if (kx > 30) return x;
  if (kx < -30) return exp(kx) / k;
  return log(1 + exp(kx)) / k;
}

double calculateTGL(Task task) {
  final now = DateTime.now();
  final D = task.deadline.difference(now).inMinutes / 60.0;
  final T = task.requiredHours;
  final M = task.avoidance.toDouble();
  final slack = softplus(D - T, kSmoothness) + epsilon;
  return (T * M) / slack;
}

TGLState taskToState(Task task) {
  final D = task.deadline.difference(DateTime.now()).inMinutes / 60.0;
  if (D < 0) return TGLState.overdue;
  final tgl = calculateTGL(task);
  if (tgl < TGLThresholds.peaceful) return TGLState.peaceful;
  if (tgl < TGLThresholds.someday)  return TGLState.someday;
  if (tgl < TGLThresholds.reality)  return TGLState.reality;
  if (tgl < TGLThresholds.noEscape) return TGLState.noEscape;
  return TGLState.war;
}
