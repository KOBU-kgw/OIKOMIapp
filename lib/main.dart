import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'l10n/app_localizations.dart';
import 'services/database_service.dart';
import 'services/notification_service.dart';
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

  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(TGLApp(showOnboarding: !onboardingCompleted));

  // Navigator ツリーが確立してから通知処理を実行する
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService.requestPermission();
    await _onAppLaunch();
  });
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
