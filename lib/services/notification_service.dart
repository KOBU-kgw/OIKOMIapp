import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  /// 通知ON/OFF設定の SharedPreferences キー（設定画面と共有）
  static const String prefKeyNotificationsEnabled = 'notifications_enabled';

  static Future<bool> _notificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefKeyNotificationsEnabled) ?? true;
  }

  static Future<void> init() async {
    final l = deviceL10n();
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: darwinSettings,
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
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await ios?.requestPermissions(alert: true, badge: true, sound: true);
      return;
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return;
      await android.requestNotificationsPermission();
      final canExact = await android.canScheduleExactNotifications();
      debugPrint('canScheduleExactNotifications: $canExact');
    }
  }

  static Future<bool> _canScheduleExactNotifications() async {
    if (!Platform.isAndroid) return true;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.canScheduleExactNotifications() ?? false;
  }

  static Future<void> scheduleNotificationsForTask(Task task) async {
    await cancelNotificationsForTask(task.id);

    if (!await _notificationsEnabled()) return;

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

    final canExact = await _canScheduleExactNotifications();

    for (final (index, targetState) in transitions.indexed) {
      if (remaining <= 0) break;
      final triggerTime = _calculateTransitionTime(task, targetState);
      if (triggerTime == null || !triggerTime.isAfter(DateTime.now())) continue;

      await _scheduleNotification(
        id: _notificationId(task.id, index),
        task: task,
        state: targetState,
        triggerTime: triggerTime,
        useExactAlarm: canExact,
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
    final calendarHours = task.deadline.difference(now).inMinutes / 60.0;
    if (calendarHours <= 0) return null;

    final effectiveDeadline = calendarHours * kActiveRatio;

    double tglAtEffective(double effectiveD) {
      final slack = softplus(effectiveD - T, kSmoothness) + epsilon;
      return (T * M) / slack;
    }

    if (tglAtEffective(effectiveDeadline) >= threshold) return null;
    if (tglAtEffective(0) < threshold) return null;

    double lo = 0.0, hi = effectiveDeadline;
    for (int i = 0; i < 40; i++) {
      final mid = (lo + hi) / 2;
      if (tglAtEffective(mid) >= threshold) {
        lo = mid;
      } else {
        hi = mid;
      }
    }

    final effectiveHoursFromNow = (lo + hi) / 2;
    final calendarHoursFromNow = effectiveHoursFromNow / kActiveRatio;
    return now.add(Duration(milliseconds: (calendarHoursFromNow * 3600 * 1000).toInt()));
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
    bool useExactAlarm = true,
    bool isHopeless = false,
  }) async {
    final l = deviceL10n();
    final message = _notificationMessage(l, state, isHopeless: isHopeless);
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l.notifChannelName,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );
    final mode = useExactAlarm
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    try {
      await _plugin.zonedSchedule(
        id,
        task.title,
        message,
        tz.TZDateTime.from(triggerTime, tz.local),
        details,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      debugPrint('Schedule failed (id=$id, exact=$useExactAlarm): $e');
      if (useExactAlarm) {
        try {
          await _plugin.zonedSchedule(
            id,
            task.title,
            message,
            tz.TZDateTime.from(triggerTime, tz.local),
            details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
        } catch (e2) {
          debugPrint('Inexact also failed (id=$id): $e2');
        }
      }
    }
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
    // String.hashCode は実行間・プラットフォーム間で安定保証がないため、
    // FNV-1a 32bit で決定的にハッシュする
    var hash = 0x811C9DC5;
    for (final unit in taskId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return (hash % 1000000) * 10 + stateIndex;
  }
}
