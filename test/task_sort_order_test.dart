import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/task_sort_order.dart';

void main() {
  group('TaskSortOrder', () {
    test('has tgl and deadline values', () {
      expect(TaskSortOrder.values, hasLength(2));
      expect(TaskSortOrder.values, contains(TaskSortOrder.tgl));
      expect(TaskSortOrder.values, contains(TaskSortOrder.deadline));
    });
  });
}
