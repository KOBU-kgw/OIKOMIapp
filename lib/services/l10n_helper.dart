import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../l10n/app_localizations.dart';

/// BuildContext なしで現在のデバイス言語に対応した L10n を返す。
/// 通知サービスなど UI ツリー外からのテキスト取得に使用する。
AppLocalizations deviceL10n() {
  final locale = ui.PlatformDispatcher.instance.locale;
  final resolved = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  )
      ? Locale(locale.languageCode)
      : const Locale('en');
  return lookupAppLocalizations(resolved);
}
