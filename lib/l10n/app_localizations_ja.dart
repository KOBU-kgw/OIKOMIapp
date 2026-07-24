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
  String get settingsSectionThresholdPack => 'カスタム閾値';

  @override
  String get settingsRestorePurchase => '購入を復元';

  @override
  String get settingsCustomThresholds => 'カスタム閾値';

  @override
  String get settingsCustomThresholdsLocked => 'タップして購入';

  @override
  String settingsThresholdPackPrice(String price) {
    return '$price · タップして解放';
  }

  @override
  String get purchaseScreenTitle => 'カスタム閾値パック';

  @override
  String get purchaseHeadline => '「戦争」が始まるラインを、あなた仕様に。';

  @override
  String get purchaseBody => '「まだ平和」から「戦争」まで、5段階のラインをあなた仕様に調整できるようになります。';

  @override
  String get purchaseOneTime => '一度の購入で永続利用できます';

  @override
  String get purchaseScopeNote =>
      '対象はカスタム閾値機能です。タスク管理・通知などの基本機能は無料のままご利用いただけます。';

  @override
  String purchaseButton(String price) {
    return '$price で購入';
  }

  @override
  String get purchaseUnavailable => 'ストアに接続できません';

  @override
  String get purchaseRetry => '再試行';

  @override
  String get purchaseLoadError => '商品情報を取得できませんでした。通信環境をご確認のうえ再試行してください。';

  @override
  String get purchaseSuccess => 'カスタム閾値が解放されました！';

  @override
  String get purchaseRestoreDone => '購入情報を確認しました';

  @override
  String get purchaseErrorGeneric => '購入処理でエラーが発生しました';

  @override
  String get thresholdEditorTitle => 'カスタム閾値';

  @override
  String get thresholdEditorPreviewTitle => 'カスタム閾値プレビュー';

  @override
  String get thresholdEditorIntro => 'あなたの「戦争」が始まるラインを決めよう';

  @override
  String get thresholdEditorUseCustom => 'カスタム閾値を使う';

  @override
  String get thresholdLabelPeaceful => 'まだ平和 → いつかやる';

  @override
  String get thresholdLabelSomeday => 'いつかやる → 現実見ろ';

  @override
  String get thresholdLabelReality => '現実見ろ → 逃げ場なし';

  @override
  String get thresholdLabelNoEscape => '逃げ場なし → 戦争';

  @override
  String get thresholdReset => 'デフォルトに戻す';

  @override
  String get thresholdSave => '保存';

  @override
  String get thresholdSaved => '閾値を保存しました';

  @override
  String get thresholdPreviewHint => 'サンプル課題のラベルがどう変わるか確認できます';

  @override
  String get thresholdPreviewLockedNote => '保存にはカスタム閾値パックの購入が必要です';

  @override
  String get thresholdSampleTaskNear => '明日締切のレポート';

  @override
  String get thresholdSampleTaskMid => '3日後の小テスト対策';

  @override
  String get thresholdSampleTaskFar => '来週の期末レポート';

  @override
  String get nudgeCardTitle => '「戦争」が始まるタイミング、人によって違うらしい。';

  @override
  String get nudgeCardSubtitle => 'タップしてラインを調整してみる';

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

  @override
  String whatsNewTitle(String version) {
    return 'アップデート情報 v$version';
  }

  @override
  String get whatsNewClose => 'OK';

  @override
  String get whatsNewItem1 => 'ヤバさ計算を強化 — 先に締め切られる他の課題の分も考慮するように';

  @override
  String get whatsNewItem2 => 'カスタム閾値パック登場 — 「戦争」が始まるラインを自分仕様に調整（設定から）';
}
