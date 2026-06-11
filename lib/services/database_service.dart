import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';
import '../models/user_preference.dart';

class DatabaseService {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskSchema, UserPreferenceSchema],
      directory: dir.path,
    );
  }

  // ─── UserPreference ───────────────────────────────────────────

  static Future<UserPreference> getUserPreference() async {
    return await _isar.userPreferences.get(0) ?? UserPreference();
  }

  static Future<void> saveUserPreference(UserPreference pref) async {
    await _isar.writeTxn(() async {
      await _isar.userPreferences.put(pref);
    });
  }

  // ─── Task ─────────────────────────────────────────────────────

  static Future<List<Task>> getAllIncompleteTasks() {
    return _isar.tasks
        .filter()
        .isCompletedEqualTo(false)
        .deletedAtIsNull()
        .findAll();
  }

  static Future<Task?> getTaskByUuid(String uuid) {
    return _isar.tasks.filter().idEqualTo(uuid).findFirst();
  }

  static Future<void> saveTask(Task task) async {
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  static Future<void> markCompleted(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) return;
    task.isCompleted = true;
    task.completedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  static Future<void> undoComplete(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) return;
    task.isCompleted = false;
    task.completedAt = null;
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  static Future<void> softDeleteTask(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) return;
    task.deletedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  static Future<void> undoDeleteTask(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) return;
    task.deletedAt = null;
    await _isar.writeTxn(() async {
      await _isar.tasks.put(task);
    });
  }

  static Future<void> purgeStaleDeleted() async {
    final stale = await _isar.tasks.filter().deletedAtIsNotNull().findAll();
    if (stale.isEmpty) return;
    await _isar.writeTxn(() async {
      for (final t in stale) {
        await _isar.tasks.delete(t.isarId);
      }
    });
  }

  static Future<void> deleteTask(String uuid) async {
    final task = await getTaskByUuid(uuid);
    if (task == null) return;
    await _isar.writeTxn(() async {
      await _isar.tasks.delete(task.isarId);
    });
  }

  static Stream<List<Task>> watchIncompleteTasks() {
    return _isar.tasks
        .filter()
        .isCompletedEqualTo(false)
        .deletedAtIsNull()
        .watch(fireImmediately: true);
  }
}
