// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'OIKOMI';

  @override
  String get taskListTitle => 'Tasks';

  @override
  String get taskListEmpty => 'No tasks. All clear.';

  @override
  String get addButton => 'Add';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get editTaskTitle => 'Edit Task';

  @override
  String get addTaskTitle => 'Add Task';

  @override
  String get taskNameLabel => 'Task Name';

  @override
  String get taskNamePlaceholder => 'e.g. Statistics essay, English quiz';

  @override
  String get taskNameRequired => 'Please enter a task name';

  @override
  String get taskTypeLabel => 'Task Type';

  @override
  String get deadlineLabel => 'Deadline';

  @override
  String get timeAndAvoidanceLabel => 'Time required / Avoidance';

  @override
  String get requiredTimeLabel => 'Time required';

  @override
  String get avoidanceLevelLabel => 'Avoidance';

  @override
  String get saveTaskButton => 'Save';

  @override
  String get addTaskButton => 'Add';

  @override
  String get doneButton => 'Done';

  @override
  String get swipeEdit => 'Edit';

  @override
  String get swipeComplete => 'Done';

  @override
  String get swipeDelete => 'Delete';

  @override
  String get taskTypeMiniReport => 'Short Essay';

  @override
  String get taskTypeReport => 'Essay';

  @override
  String get taskTypeQuizStudy => 'Quiz Prep';

  @override
  String get taskTypePresentation => 'Presentation';

  @override
  String get taskTypeFinalExam => 'Final Exam';

  @override
  String get tglStatePeaceful => 'All Good';

  @override
  String get tglStateSomeday => 'Eventually...';

  @override
  String get tglStateReality => 'Getting Real';

  @override
  String get tglStateNoEscape => 'No Way Out';

  @override
  String get tglStateWar => 'WAR';

  @override
  String get tglStateOverdue => 'Overdue';

  @override
  String get notifSomeday => 'Future you is crying right now';

  @override
  String get notifReality => 'Time to face reality';

  @override
  String get notifNoEscape => 'There\'s no escape now';

  @override
  String get notifWar => 'It\'s war. That is all.';

  @override
  String get notifHopeless => 'Already hopeless. Good luck.';

  @override
  String get notifChannelName => 'Task Notifications';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingPage1Heading => 'Track deadline stress';

  @override
  String get onboardingPage1Body =>
      'OIKOMI manages tasks by \"psychological difficulty\" — a new kind of task manager';

  @override
  String get onboardingPage2Heading => 'Just 4 inputs';

  @override
  String get onboardingPage2Body =>
      'Name, deadline, time required, and avoidance level. OIKOMI figures out the rest.';

  @override
  String get onboardingPage3Heading => '5-level stress display';

  @override
  String get onboardingPage3Body =>
      'All Good → Eventually → Getting Real → No Way Out → WAR.\nYou get notified when the level changes.';

  @override
  String get onboardingPage4Heading => 'Let\'s go';

  @override
  String get onboardingPage4StartButton => 'Add your first task';

  @override
  String get onboardingMockTaskName => 'Task Name';

  @override
  String get onboardingMockTaskValue => 'Statistics essay';

  @override
  String get onboardingMockDeadline => 'Deadline';

  @override
  String get onboardingMockDeadlineValue => '5/31 23:59';

  @override
  String get onboardingMockTime => 'Time required';

  @override
  String get onboardingMockTimeValue => '2h';

  @override
  String get onboardingMockAvoidance => 'Avoidance';

  @override
  String get onboardingMockAvoidanceValue => '7';

  @override
  String timeUnitMinutes(int count) {
    return '$count min';
  }

  @override
  String timeUnitHours(int count) {
    return '${count}h';
  }

  @override
  String timeUnitHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionGeneral => 'General';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageValue => 'Follow system';

  @override
  String get settingsSectionInfo => 'Info';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsTermsOfService => 'Terms of Service';

  @override
  String get settingsSupport => 'Support';

  @override
  String get settingsUrlError => 'Could not open URL';

  @override
  String get settingsSectionThresholdPack => 'Custom Thresholds';

  @override
  String get settingsRestorePurchase => 'Restore Purchase';

  @override
  String get settingsCustomThresholds => 'Custom Thresholds';

  @override
  String get settingsCustomThresholdsLocked => 'Tap to purchase';

  @override
  String settingsThresholdPackPrice(String price) {
    return '$price · Tap to unlock';
  }

  @override
  String get purchaseScreenTitle => 'Custom Threshold Pack';

  @override
  String get purchaseHeadline => 'Decide when your \"War\" begins.';

  @override
  String get purchaseBody =>
      'Tune all five state boundaries — from \"Still Peaceful\" to \"War\" — to match how you actually work.';

  @override
  String get purchaseOneTime => 'One-time purchase, yours forever';

  @override
  String get purchaseScopeNote =>
      'This unlocks the custom threshold feature. Task management and notifications stay free.';

  @override
  String purchaseButton(String price) {
    return 'Buy for $price';
  }

  @override
  String get purchaseUnavailable => 'Store is unavailable';

  @override
  String get purchaseRetry => 'Retry';

  @override
  String get purchaseLoadError =>
      'Couldn\'t load product info. Check your connection and try again.';

  @override
  String get purchaseSuccess => 'Custom thresholds unlocked!';

  @override
  String get purchaseRestoreDone => 'Purchases checked';

  @override
  String get purchaseErrorGeneric => 'Something went wrong with the purchase';

  @override
  String get thresholdEditorTitle => 'Custom Thresholds';

  @override
  String get thresholdEditorPreviewTitle => 'Threshold Preview';

  @override
  String get thresholdEditorIntro => 'Decide when your \"War\" begins';

  @override
  String get thresholdEditorUseCustom => 'Use custom thresholds';

  @override
  String get thresholdLabelPeaceful => 'Still Peaceful → Someday';

  @override
  String get thresholdLabelSomeday => 'Someday → Get Real';

  @override
  String get thresholdLabelReality => 'Get Real → No Escape';

  @override
  String get thresholdLabelNoEscape => 'No Escape → War';

  @override
  String get thresholdReset => 'Reset to defaults';

  @override
  String get thresholdSave => 'Save';

  @override
  String get thresholdSaved => 'Thresholds saved';

  @override
  String get thresholdPreviewHint =>
      'See how the labels of sample tasks change';

  @override
  String get thresholdPreviewLockedNote =>
      'Purchase the Custom Threshold Pack to save';

  @override
  String get thresholdSampleTaskNear => 'Report due tomorrow';

  @override
  String get thresholdSampleTaskMid => 'Quiz prep in 3 days';

  @override
  String get thresholdSampleTaskFar => 'Final report next week';

  @override
  String get nudgeCardTitle =>
      'Turns out \"War\" starts at a different time for everyone.';

  @override
  String get nudgeCardSubtitle => 'Tap to tune your own thresholds';

  @override
  String get taskDetailTitle => 'Task Detail';

  @override
  String get deleteButton => 'Delete';

  @override
  String get completeButton => 'Complete';

  @override
  String get undoButton => 'Undo';

  @override
  String get taskDeletedMessage => 'Task deleted';

  @override
  String get taskCompletedMessage => 'Marked as complete';

  @override
  String get avoidance1 => 'No problem';

  @override
  String get avoidance2 => 'Pretty easy';

  @override
  String get avoidance3 => 'Can manage';

  @override
  String get avoidance4 => 'Kinda annoying';

  @override
  String get avoidance5 => 'Meh, fine';

  @override
  String get avoidance6 => 'Rather not';

  @override
  String get avoidance7 => 'Really don\'t wanna';

  @override
  String get avoidance8 => 'Please no';

  @override
  String get avoidance9 => 'Seriously, NO';

  @override
  String get avoidance10 => 'Over my dead body';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s New in v$version';
  }

  @override
  String get whatsNewClose => 'OK';

  @override
  String get whatsNewItem1 =>
      'Smarter urgency — now accounts for other tasks due before each one';

  @override
  String get whatsNewItem2 =>
      'Custom Threshold Pack — tune when your \"War\" begins (see Settings)';
}
