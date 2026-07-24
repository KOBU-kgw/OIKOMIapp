import '../models/task.dart';
import '../models/tgl_state.dart';
import 'tgl_calculator.dart';
import 'tgl_context.dart';
import 'threshold_provider.dart';

/// 予約すべき通知1件分の候補。
class NotificationCandidate {
  const NotificationCandidate({
    required this.task,
    required this.state,
    required this.triggerTime,
    required this.stateIndex,
    this.isHopeless = false,
  });

  final Task task;
  final TGLState state;
  final DateTime triggerTime;

  /// notificationId() に渡すインデックス（遷移: 0〜3、hopeless: 5）
  final int stateIndex;
  final bool isHopeless;
}

/// 全再スケジュール1回分の計画。プラグイン非依存（テスト可能）。
class NotificationPlan {
  const NotificationPlan({
    required this.scheduled,
    required this.hopelessToMark,
    required this.hopelessToClear,
  });

  /// 予約対象（トリガー時刻昇順・予算以内）
  final List<NotificationCandidate> scheduled;

  /// hopelessNotifiedAt を now に設定すべきタスク
  final List<Task> hopelessToMark;

  /// hopelessNotifiedAt をクリアすべきタスク
  final List<Task> hopelessToClear;
}

/// hopeless 即時通知の stateIndex（旧実装と同じ値・通知IDの互換維持）
const int kHopelessStateIndex = 5;

/// 通知予算（iOS上限64件のうち本アプリが使う最大件数。バッファ4件）
const int kNotificationBudget = 60;

const List<TGLState> kTransitionStates = [
  TGLState.someday,
  TGLState.reality,
  TGLState.noEscape,
  TGLState.war,
];

/// 遷移先状態に対応する閾値（1つ手前の状態の上限を跨いだ瞬間が遷移）。
/// [thresholds] 未指定時は ThresholdProvider.current。
double? thresholdForTransition(TGLState state, {TGLThresholdSet? thresholds}) {
  final t = thresholds ?? ThresholdProvider.current;
  switch (state) {
    case TGLState.someday:  return t.peaceful;
    case TGLState.reality:  return t.someday;
    case TGLState.noEscape: return t.reality;
    case TGLState.war:      return t.noEscape;
    default:                return null;
  }
}

/// 未完了タスク集合から通知計画を立てる。
///
/// - precedingLoad（v1.5 マルチタスクslack補正）を遷移時刻の逆算に反映
/// - 全候補をトリガー時刻昇順でソートし、近い未来を優先して [budget] 件まで採用
/// - hopeless（T > 残り時間）の即時通知は旧実装のセマンティクスを維持
///   （判定式に precedingLoad は含めない）
NotificationPlan planNotifications(
  List<Task> tasks,
  DateTime now, {
  int budget = kNotificationBudget,
}) {
  final ctx = TglContext.of(tasks);
  final candidates = <NotificationCandidate>[];
  final hopelessToMark = <Task>[];
  final hopelessToClear = <Task>[];

  for (final task in tasks) {
    // hopeless 通知: T > D（必要時間が残り時間を超える）。
    // 同じhopelessエピソード中の再発火は抑制し、状態が解消されたらリセットする。
    final D = task.deadline.difference(now).inMinutes / 60.0;
    final isHopelessNow = D > 0 && task.requiredHours > D;
    if (isHopelessNow) {
      if (task.hopelessNotifiedAt == null) {
        candidates.add(NotificationCandidate(
          task: task,
          state: TGLState.overdue,
          triggerTime: now.add(const Duration(seconds: 2)),
          stateIndex: kHopelessStateIndex,
          isHopeless: true,
        ));
        hopelessToMark.add(task);
      }
    } else if (task.hopelessNotifiedAt != null) {
      hopelessToClear.add(task);
    }

    final precedingLoad = ctx.loadFor(task);
    for (final (index, targetState) in kTransitionStates.indexed) {
      final threshold = thresholdForTransition(targetState);
      if (threshold == null) continue;
      final hours = calendarHoursUntilThreshold(task, threshold,
          now: now, precedingLoad: precedingLoad);
      if (hours == null) continue;
      final triggerTime =
          now.add(Duration(milliseconds: (hours * 3600 * 1000).toInt()));
      if (!triggerTime.isAfter(now)) continue;
      candidates.add(NotificationCandidate(
        task: task,
        state: targetState,
        triggerTime: triggerTime,
        stateIndex: index,
      ));
    }
  }

  candidates.sort((a, b) => a.triggerTime.compareTo(b.triggerTime));
  return NotificationPlan(
    scheduled: candidates.take(budget).toList(),
    hopelessToMark: hopelessToMark,
    hopelessToClear: hopelessToClear,
  );
}
