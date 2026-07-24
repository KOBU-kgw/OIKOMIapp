import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task.dart';
import 'package:my_app/models/tgl_state.dart';
import 'package:my_app/services/notification_planner.dart';
import 'package:my_app/services/threshold_provider.dart';

Task _makeTask({
  required String id,
  required DateTime deadline,
  required double requiredHours,
  DateTime? createdAt,
  int avoidance = 5,
  DateTime? hopelessNotifiedAt,
}) {
  return Task()
    ..id = id
    ..title = id
    ..deadline = deadline
    ..requiredHours = requiredHours
    ..avoidance = avoidance
    ..isCompleted = false
    ..createdAt = createdAt ?? DateTime(2026, 1, 1)
    ..type = TaskType.report
    ..hopelessNotifiedAt = hopelessNotifiedAt;
}

void main() {
  final now = DateTime(2026, 6, 1, 0, 0);

  group('planNotifications', () {
    // シナリオ6: タスク20件×遷移4件=80候補 → 予約は60件以下・近い順に採用
    test('caps at budget and keeps the earliest triggers', () {
      final tasks = [
        for (int i = 0; i < 20; i++)
          _makeTask(
            id: 't$i',
            // 全遷移が未来に残るよう十分先の締切をばらけさせる
            deadline: now.add(Duration(hours: 200 + i * 17)),
            requiredHours: 2,
            avoidance: 5,
          ),
      ];
      final plan = planNotifications(tasks, now);

      expect(plan.scheduled.length, lessThanOrEqualTo(kNotificationBudget));
      expect(plan.scheduled.length, kNotificationBudget); // 80候補あるので満杯

      // 採用分はトリガー時刻昇順
      for (int i = 1; i < plan.scheduled.length; i++) {
        expect(
          plan.scheduled[i].triggerTime.isBefore(
            plan.scheduled[i - 1].triggerTime,
          ),
          isFalse,
        );
      }

      // 「近い未来を優先」: 全候補を予算なしで並べた先頭60件と一致する
      final all = planNotifications(tasks, now, budget: 1 << 30).scheduled;
      expect(all.length, 80);
      final expected = all.take(kNotificationBudget).map((c) =>
          '${c.task.id}/${c.stateIndex}');
      final actual = plan.scheduled.map((c) => '${c.task.id}/${c.stateIndex}');
      expect(actual, expected);
    });

    test('preceding load shifts transition triggers earlier', () {
      final b = _makeTask(
          id: 'b', deadline: now.add(const Duration(hours: 200)), requiredHours: 3);
      final alone = planNotifications([b], now).scheduled;
      final a = _makeTask(
          id: 'a', deadline: now.add(const Duration(hours: 100)), requiredHours: 10);
      final withA = planNotifications([a, b], now)
          .scheduled
          .where((c) => c.task.id == 'b')
          .toList();

      // 同じ遷移same stateIndexで比較: 先行負荷があるとトリガーが前倒しになる
      for (final c in withA) {
        final ref = alone.firstWhere((x) => x.stateIndex == c.stateIndex);
        expect(c.triggerTime.isBefore(ref.triggerTime), isTrue,
            reason: 'stateIndex ${c.stateIndex} should fire earlier with load');
      }
    });

    test('hopeless task gets immediate candidate and mark, once', () {
      // T=10h > 残り5h → hopeless
      final task = _makeTask(
          id: 'h', deadline: now.add(const Duration(hours: 5)), requiredHours: 10);
      final plan = planNotifications([task], now);

      final hopeless =
          plan.scheduled.where((c) => c.isHopeless).toList();
      expect(hopeless, hasLength(1));
      expect(hopeless.single.stateIndex, kHopelessStateIndex);
      expect(hopeless.single.state, TGLState.overdue);
      expect(hopeless.single.triggerTime, now.add(const Duration(seconds: 2)));
      expect(plan.hopelessToMark.map((t) => t.id), ['h']);

      // 既に通知済みなら再発火しない
      final notified = _makeTask(
          id: 'h2',
          deadline: now.add(const Duration(hours: 5)),
          requiredHours: 10,
          hopelessNotifiedAt: now.subtract(const Duration(hours: 1)));
      final plan2 = planNotifications([notified], now);
      expect(plan2.scheduled.where((c) => c.isHopeless), isEmpty);
      expect(plan2.hopelessToMark, isEmpty);
    });

    test('resolved hopeless task is queued for clear', () {
      // T=1h < 残り100h → hopeless解消済みだが通知記録が残っている
      final task = _makeTask(
          id: 'r',
          deadline: now.add(const Duration(hours: 100)),
          requiredHours: 1,
          hopelessNotifiedAt: now.subtract(const Duration(days: 1)));
      final plan = planNotifications([task], now);
      expect(plan.hopelessToClear.map((t) => t.id), ['r']);
      expect(plan.hopelessToMark, isEmpty);
    });

    test('past-deadline task yields no transition candidates', () {
      final task = _makeTask(
          id: 'p',
          deadline: now.subtract(const Duration(hours: 1)),
          requiredHours: 2);
      final plan = planNotifications([task], now);
      expect(plan.scheduled, isEmpty);
    });

    // 回帰: カスタム閾値パック有効化（ThresholdProvider.current の変化）で
    // 既存タスクの通知トリガー時刻が変わることを保証する。
    // 購入/保存時の reload → requestResync が意味を持つための前提メカニズム。
    test('custom thresholds shift transition trigger times', () {
      addTearDown(ThresholdProvider.resetToDefaults);

      final task = _makeTask(
          id: 'c',
          deadline: now.add(const Duration(hours: 300)),
          requiredHours: 3);

      ThresholdProvider.resetToDefaults();
      final byIndexDefault = {
        for (final c in planNotifications([task], now).scheduled)
          c.stateIndex: c.triggerTime,
      };

      // デフォルト(0.4,1.5,6.0,20.0)より厳しめのセット → 遷移が前倒しになる
      ThresholdProvider.override(const TGLThresholdSet(
          peaceful: 0.2, someday: 0.8, reality: 3.0, noEscape: 10.0));
      final byIndexCustom = {
        for (final c in planNotifications([task], now).scheduled)
          c.stateIndex: c.triggerTime,
      };

      // 両方に現れる遷移が1つ以上あり、その全てで時刻が変化している
      final common = byIndexDefault.keys
          .where(byIndexCustom.containsKey)
          .toList();
      expect(common, isNotEmpty,
          reason: '比較できる共通の遷移が存在すること');
      for (final i in common) {
        expect(byIndexCustom[i], isNot(byIndexDefault[i]),
            reason: 'stateIndex $i のトリガー時刻が閾値変化で変わること');
      }
    });
  });
}
