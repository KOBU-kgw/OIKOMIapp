import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'l10n/app_localizations.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
import 'services/purchase_service.dart';
import 'services/threshold_provider.dart';
import 'screens/task_list_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tzdata.initializeTimeZones();
  // 端末のタイムゾーンを tz.local に設定する（未設定だと UTC のままになる）。
  try {
    final localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));
  } catch (e) {
    debugPrint('setLocalLocation failed, using UTC: $e');
  }
  await DatabaseService.init();
  await NotificationService.init();
  await _seedFirstLaunchAt();
  await ThresholdProvider.reload();
  // first frame 前に初期化する（iOS起動時に配送される保留トランザクション対策）
  await PurchaseService().initialize();

  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(TGLApp(showOnboarding: !onboardingCompleted));

  // Navigator ツリーが確立してから通知処理を実行する
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService.requestPermission();
    await _onAppLaunch();
  });
}

/// 転換導線（FEAT-03）用の初回起動日時。未設定なら今を記録する。
/// v1.4以前からの更新ユーザーも更新時点から起算する（ナッジは新機能の告知のため）。
Future<void> _seedFirstLaunchAt() async {
  final pref = await DatabaseService.getUserPreference();
  if (pref.firstLaunchAt == null) {
    pref.firstLaunchAt = DateTime.now();
    await DatabaseService.saveUserPreference(pref);
  }
}

Future<void> _onAppLaunch() async {
  await DatabaseService.purgeStaleDeleted();
  // 全キャンセル後に再登録する（削除済みタスクや旧ID体系の通知が残らないように）
  await NotificationService.resyncFromDatabase();
}

class TGLApp extends StatelessWidget {
  const TGLApp({super.key, required this.showOnboarding});
  final bool showOnboarding;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OIKOMI',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: showOnboarding ? const OnboardingScreen() : const TaskListScreen(),
    );
  }
}
