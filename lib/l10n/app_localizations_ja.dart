// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'OIKOMI';

  @override
  String get taskListTitle => '課題';

  @override
  String get taskListEmpty => '課題なし。平和。';

  @override
  String get addButton => '追加する';

  @override
  String get saveButton => '保存する';

  @override
  String get cancelButton => 'キャンセル';

  @override
  String get editTaskTitle => '課題を編集';

  @override
  String get addTaskTitle => '課題を追加';

  @override
  String get taskNameLabel => '課題名';

  @override
  String get taskNamePlaceholder => '例：統計学レポート、英語小テスト';

  @override
  String get taskNameRequired => '課題名を入力してください';

  @override
  String get taskTypeLabel => '課題タイプ';

  @override
  String get deadlineLabel => '締切';

  @override
  String get timeAndAvoidanceLabel => '所要時間 / やりたくなさ';

  @override
  String get requiredTimeLabel => '所要時間';

  @override
  String get avoidanceLevelLabel => 'やりたくなさ';

  @override
  String get saveTaskButton => '保存する';

  @override
  String get addTaskButton => '追加する';

  @override
  String get doneButton => '完了';

  @override
  String get swipeEdit => '編集';

  @override
  String get swipeComplete => '完了';

  @override
  String get swipeDelete => '削除';

  @override
  String get taskTypeMiniReport => 'ミニレポート';

  @override
  String get taskTypeReport => 'レポート';

  @override
  String get taskTypeQuizStudy => '小テスト勉強';

  @override
  String get taskTypePresentation => '発表準備';

  @override
  String get taskTypeFinalExam => '期末テスト';

  @override
  String get tglStatePeaceful => 'まだ平和';

  @override
  String get tglStateSomeday => 'そのうちやろ';

  @override
  String get tglStateReality => 'そろそろ現実';

  @override
  String get tglStateNoEscape => '逃げ場なし';

  @override
  String get tglStateWar => '戦争';

  @override
  String get tglStateOverdue => '期限超過';

  @override
  String get notifSomeday => '未来の自分が泣いてる';

  @override
  String get notifReality => 'そろそろ現実を見ようか';

  @override
  String get notifNoEscape => '逃げ場なくなりました';

  @override
  String get notifWar => '戦争です。以上。';

  @override
  String get notifHopeless => 'すでに詰んでます。ご武運を。';

  @override
  String get notifChannelName => 'タスク通知';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingPage1Heading => '締切までの時間がわかる';

  @override
  String get onboardingPage1Body => 'OIKOMIは\"心理的つらさ\"で課題を管理する、\n新しいタスク管理アプリ';

  @override
  String get onboardingPage2Heading => '入力はたった4つ';

  @override
  String get onboardingPage2Body =>
      '課題名・締切・所要時間・やりたくなさを\n入力するだけ。あとはOIKOMIが判断する';

  @override
  String get onboardingPage3Heading => '5段階で\"つらさ\"を表示';

  @override
  String get onboardingPage3Body =>
      'まだ平和 → そのうちやろ → そろそろ現実 →\n逃げ場なし → 戦争。\n状況が変わると通知でお知らせ';

  @override
  String get onboardingPage4Heading => 'さあ始めよう';

  @override
  String get onboardingPage4StartButton => '最初の課題を追加する';

  @override
  String get onboardingMockTaskName => '課題名';

  @override
  String get onboardingMockTaskValue => '統計学レポート';

  @override
  String get onboardingMockDeadline => '締切';

  @override
  String get onboardingMockDeadlineValue => '5/31 23:59';

  @override
  String get onboardingMockTime => '所要時間';

  @override
  String get onboardingMockTimeValue => '2時間';

  @override
  String get onboardingMockAvoidance => 'やりたくなさ';

  @override
  String get onboardingMockAvoidanceValue => '7';

  @override
  String timeUnitMinutes(int count) {
    return '$count分';
  }

  @override
  String timeUnitHours(int count) {
    return '$count時間';
  }

  @override
  String timeUnitHoursMinutes(int hours, int minutes) {
    return '$hours時間$minutes分';
  }

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionGeneral => '一般';

  @override
  String get settingsNotifications => '通知';

  @override
  String get settingsLanguage => '言語';

  @override
  String get settingsLanguageValue => 'システム設定に従う';

  @override
  String get settingsSectionInfo => '情報';

  @override
  String get settingsVersion => 'バージョン';

  @override
  String get settingsPrivacyPolicy => 'プライバシーポリシー';

  @override
  String get settingsTermsOfService => '利用規約';

  @override
  String get settingsSupport => 'サポート・お問い合わせ';

  @override
  String get settingsUrlError => 'URLを開けませんでした';

  @override
  String get settingsSectionPremium => 'Premium';

  @override
  String get settingsRestorePurchase => '購入を復元';

  @override
  String get settingsPremiumUpgrade => 'Premiumにアップグレード';

  @override
  String get settingsPremiumCustomThreshold => 'カスタム TGL閾値';

  @override
  String get settingsPremiumComingSoonTitle => '近日公開';

  @override
  String get settingsPremiumComingSoonBody => 'Premium機能は今後のアップデートで追加予定です。';

  @override
  String get taskDetailTitle => '課題詳細';

  @override
  String get deleteButton => '削除';

  @override
  String get completeButton => '完了にする';

  @override
  String get undoButton => '元に戻す';

  @override
  String get taskDeletedMessage => '課題を削除しました';

  @override
  String get taskCompletedMessage => '完了にしました';

  @override
  String get avoidance1 => '全然ない';

  @override
  String get avoidance2 => 'まだ余裕';

  @override
  String get avoidance3 => 'なくはない';

  @override
  String get avoidance4 => 'ちょっとどうかな';

  @override
  String get avoidance5 => 'まあいやだ';

  @override
  String get avoidance6 => '正直やりたくない';

  @override
  String get avoidance7 => 'かなりやりたくない';

  @override
  String get avoidance8 => 'せつにやりたくない';

  @override
  String get avoidance9 => 'マジでやりたくない';

  @override
  String get avoidance10 => '死んでもやりたくない';
}
