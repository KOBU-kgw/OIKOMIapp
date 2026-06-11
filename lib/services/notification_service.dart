import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';
import '../models/tgl_state.dart';
import 'l10n_helper.dart';
import 'tgl_calculator.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  // iOS上限64件のうち本アプリが使う最大件数
  static const int _maxNotifications = 60;
  static const String _channelId = 'oikomi_notifications';

  static Future<void> init() async {
    final l = deviceL10n();
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(
      iOS: darwinSettings,
      android: androidSettings,
    );
    await _plugin.initialize(initSettings);

    // Android 通知チャネルを作成
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        l.notifChannelName,
        importance: Importance.high,
      ),
    );
  }

  static Future<void> requestPermission() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  static Future<void> scheduleNotificationsForTask(Task task) async {
    await cancelNotificationsForTask(task.id);

    final pending = await _plugin.pendingNotificationRequests();
    int remaining = _maxNotifications - pending.length;
    if (remaining <= 0) return;

    // hopeless 通知: T > D（必要時間が残り時間を超える）
    final D = task.deadline.difference(DateTime.now()).inMinutes / 60.0;
    if (D > 0 && task.requiredHours > D && remaining > 0) {
      await _scheduleNotification(
        id: _notificationId(task.id, 5),
        task: task,
        state: TGLState.overdue,
        triggerTime: DateTime.now().add(const Duration(seconds: 2)),
        isHopeless: true,
      );
      remaining--;
    }

    final transitions = [
      TGLState.someday,
      TGLState.reality,
      TGLState.noEscape,
      TGLState.war,
    ];

    for (final (index, targetState) in transitions.indexed) {
      if (remaining <= 0) break;
      final triggerTime = _calculateTransitionTime(task, targetState);
      if (triggerTime == null || !triggerTime.isAfter(DateTime.now())) continue;

      await _scheduleNotification(
        id: _notificationId(task.id, index),
        task: task,
        state: targetState,
        triggerTime: triggerTime,
      );
      remaining--;
    }
  }

  static Future<void> cancelNotificationsForTask(String taskId) async {
    for (int i = 0; i < 6; i++) {
      await _plugin.cancel(_notificationId(taskId, i));
    }
  }

  static DateTime? _calculateTransitionTime(Task task, TGLState state) {
    final threshold = _thresholdFor(state);
    if (threshold == null) return null;

    final T = task.requiredHours;
    final M = task.avoidance.toDouble();
    final now = DateTime.now();
    final deadlineHours = task.deadline.difference(now).inMinutes / 60.0;
    if (deadlineHours <= 0) return null;

    double tglAtD(double D) {
      final slack = softplus(D - T, kSmoothness) + epsilon;
      return (T * M) / slack;
    }

    // TGL が threshold 未満なら既に遷移済みか範囲外
    if (tglAtD(deadlineHours) >= threshold) return null;
    if (tglAtD(0) < threshold) return null;

    double lo = 0.0, hi = deadlineHours;
    for (int i = 0; i < 40; i++) {
      final mid = (lo + hi) / 2;
      if (tglAtD(mid) >= threshold) {
        lo = mid;
      } else {
        hi = mid;
      }
    }

    final hoursFromNow = (lo + hi) / 2;
    return now.add(Duration(milliseconds: (hoursFromNow * 3600 * 1000).toInt()));
  }

  static double? _thresholdFor(TGLState state) {
    switch (state) {
      case TGLState.someday:  return TGLThresholds.peaceful;
      case TGLState.reality:  return TGLThresholds.someday;
      case TGLState.noEscape: return TGLThresholds.reality;
      case TGLState.war:      return TGLThresholds.noEscape;
      default:                return null;
    }
  }

  static Future<void> _scheduleNotification({
    required int id,
    required Task task,
    required TGLState state,
    required DateTime triggerTime,
    bool isHopeless = false,
  }) async {
    final l = deviceL10n();
    final message = _notificationMessage(l, state, isHopeless: isHopeless);
    await _plugin.zonedSchedule(
      id,
      task.title,
      message,
      tz.TZDateTime.from(triggerTime, tz.local),
      NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          _channelId,
          l.notifChannelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static String _notificationMessage(dynamic l, TGLState state, {bool isHopeless = false}) {
    if (isHopeless) return l.notifHopeless;
    switch (state) {
      case TGLState.someday:  return l.notifSomeday;
      case TGLState.reality:  return l.notifReality;
      case TGLState.noEscape: return l.notifNoEscape;
      case TGLState.war:      return l.notifWar;
      default:                return '';
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  static Future<void> rescheduleAllNotifications(List<Task> tasks) async {
    await _plugin.cancelAll();
    for (final task in tasks) {
      await scheduleNotificationsForTask(task);
    }
  }

  static int _notificationId(String taskId, int stateIndex) {
    return (taskId.hashCode.abs() % 1000000) * 10 + stateIndex;
  }
}
