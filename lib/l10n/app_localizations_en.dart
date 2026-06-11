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
  String get settingsSectionPremium => 'Premium';

  @override
  String get settingsRestorePurchase => 'Restore Purchase';

  @override
  String get settingsPremiumUpgrade => 'Upgrade to Premium';

  @override
  String get settingsPremiumCustomThreshold => 'Custom TGL Thresholds';

  @override
  String get settingsPremiumComingSoonTitle => 'Coming Soon';

  @override
  String get settingsPremiumComingSoonBody =>
      'Premium features will be added in a future update.';

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
}
