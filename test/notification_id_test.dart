import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/services/notification_id.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('notificationId stays within 32bit signed positive range', () {
    const uuid = Uuid();
    for (int i = 0; i < 10000; i++) {
      final taskId = uuid.v4();
      for (int stateIndex = 0; stateIndex < 6; stateIndex++) {
        final id = notificationId(taskId, stateIndex);
        expect(id, greaterThanOrEqualTo(0));
        expect(id, lessThanOrEqualTo(2147483647));
      }
    }
  });

  test('notificationId has negligible collision rate across 10k tasks', () {
    const uuid = Uuid();
    final ids = <int>{};
    int collisions = 0;
    const taskCount = 10000;

    for (int i = 0; i < taskCount; i++) {
      final taskId = uuid.v4();
      for (int stateIndex = 0; stateIndex < 6; stateIndex++) {
        final id = notificationId(taskId, stateIndex);
        if (!ids.add(id)) collisions++;
      }
    }

    // 28bit空間（約2.68億バケット）に対し 60,000 件生成する程度では
    // 誕生日のパラドックスを踏まえても衝突はごく僅かに留まるはず
    expect(collisions, lessThan(5));
  });

  test('notificationId is deterministic for the same input', () {
    const taskId = 'fixed-task-id-for-determinism-check';
    for (int stateIndex = 0; stateIndex < 6; stateIndex++) {
      final first = notificationId(taskId, stateIndex);
      final second = notificationId(taskId, stateIndex);
      expect(first, equals(second));
    }
  });

  test('notificationId differs across stateIndex for the same task', () {
    const taskId = 'same-task-different-state';
    final ids = [for (int i = 0; i < 6; i++) notificationId(taskId, i)];
    expect(ids.toSet().length, equals(6));
  });
}
