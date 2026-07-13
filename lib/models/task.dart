import 'package:isar/isar.dart';

part 'task.g.dart';

enum TaskType {
  miniReport,
  report,
  quizStudy,
  presentation,
  finalExam,
}


@collection
class Task {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id; // UUID

  late String title;
  late DateTime deadline;
  late double requiredHours;

  @Enumerated(EnumType.name)
  late TaskType type;

  late int avoidance;
  late bool isCompleted;
  late DateTime createdAt;
  DateTime? deletedAt;
  DateTime? completedAt;

  /// hopeless状態の通知を送った日時。再発火の抑制に使う。
  DateTime? hopelessNotifiedAt;
}
