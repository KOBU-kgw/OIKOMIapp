import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/task.dart';
import '../models/tgl_state.dart';
import 'database_service.dart';
import 'l10n_helper.dart';
import 'notification_id.dart';
import 'notification_planner.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

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

  // ─── 再スケジュール（v1.5: 候補収集＋予算60件・近い順優先） ───

  static Timer? _resyncDebounce;
  static bool _resyncing = false;
  static bool _resyncQueued = false;

  /// タスク操作後の再スケジュール要求（400ms debounce）。
  /// 連続操作（Undoスナックバー猶予中など）での連打を1回にまとめる。
  /// DB書き込みを完了させてから呼ぶこと。
  static void requestResync() {
    _resyncDebounce?.cancel();
    _resyncDebounce = Timer(const Duration(milliseconds: 400), () {
      resyncFromDatabase();
    });
  }

  /// DBの現在状態を正として全タスクの通知を再同期する統一エントリポイント。
  /// 通常は [requestResync] を使う。起動時など即時実行したい場合のみ直接呼ぶ。
  static Future<void> resyncFromDatabase() async {
    if (_resyncing) {
      _resyncQueued = true; // 実行中に来た要求は完了後にもう一度走らせる
      return;
    }
    _resyncing = true;
    try {
      do {
        _resyncQueued = false;
        await _resyncOnce();
      } while (_resyncQueued);
    } catch (e) {
      debugPrint('resyncFromDatabase failed: $e');
    } finally {
      _resyncing = false;
    }
  }

  static Future<void> _resyncOnce() async {
    if (!await _notificationsEnabled()) {
      await _plugin.cancelAll();
      return;
    }

    final tasks = await DatabaseService.getAllIncompleteTasks();
    final now = DateTime.now();
    final plan = planNotifications(tasks, now);

    // hopeless エピソードの記録（再発火抑制・解消リセット）
    for (final task in plan.hopelessToMark) {
      task.hopelessNotifiedAt = now;
      await DatabaseService.saveTask(task);
    }
    for (final task in plan.hopelessToClear) {
      task.hopelessNotifiedAt = null;
      await DatabaseService.saveTask(task);
    }

    final canExact = await _canScheduleExactNotifications();

    // 候補確定後にキャンセル→予約（通知が空になる時間を最小化）
    await _plugin.cancelAll();
    for (final c in plan.scheduled) {
      await _scheduleNotification(
        id: notificationId(c.task.id, c.stateIndex),
        task: c.task,
        state: c.state,
        triggerTime: c.triggerTime,
        useExactAlarm: canExact,
        isHopeless: c.isHopeless,
      );
    }
  }
}
