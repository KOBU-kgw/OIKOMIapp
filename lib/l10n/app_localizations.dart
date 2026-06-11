import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'OIKOMI'**
  String get appTitle;

  /// No description provided for @taskListTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get taskListTitle;

  /// No description provided for @taskListEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks. All clear.'**
  String get taskListEmpty;

  /// No description provided for @addButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addButton;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @editTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTaskTitle;

  /// No description provided for @addTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTaskTitle;

  /// No description provided for @taskNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get taskNameLabel;

  /// No description provided for @taskNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Statistics essay, English quiz'**
  String get taskNamePlaceholder;

  /// No description provided for @taskNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a task name'**
  String get taskNameRequired;

  /// No description provided for @taskTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Task Type'**
  String get taskTypeLabel;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineLabel;

  /// No description provided for @timeAndAvoidanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Time required / Avoidance'**
  String get timeAndAvoidanceLabel;

  /// No description provided for @requiredTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time required'**
  String get requiredTimeLabel;

  /// No description provided for @avoidanceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Avoidance'**
  String get avoidanceLevelLabel;

  /// No description provided for @saveTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTaskButton;

  /// No description provided for @addTaskButton.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addTaskButton;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @swipeEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get swipeEdit;

  /// No description provided for @swipeComplete.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get swipeComplete;

  /// No description provided for @swipeDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swipeDelete;

  /// No description provided for @taskTypeMiniReport.
  ///
  /// In en, this message translates to:
  /// **'Short Essay'**
  String get taskTypeMiniReport;

  /// No description provided for @taskTypeReport.
  ///
  /// In en, this message translates to:
  /// **'Essay'**
  String get taskTypeReport;

  /// No description provided for @taskTypeQuizStudy.
  ///
  /// In en, this message translates to:
  /// **'Quiz Prep'**
  String get taskTypeQuizStudy;

  /// No description provided for @taskTypePresentation.
  ///
  /// In en, this message translates to:
  /// **'Presentation'**
  String get taskTypePresentation;

  /// No description provided for @taskTypeFinalExam.
  ///
  /// In en, this message translates to:
  /// **'Final Exam'**
  String get taskTypeFinalExam;

  /// No description provided for @tglStatePeaceful.
  ///
  /// In en, this message translates to:
  /// **'All Good'**
  String get tglStatePeaceful;

  /// No description provided for @tglStateSomeday.
  ///
  /// In en, this message translates to:
  /// **'Eventually...'**
  String get tglStateSomeday;

  /// No description provided for @tglStateReality.
  ///
  /// In en, this message translates to:
  /// **'Getting Real'**
  String get tglStateReality;

  /// No description provided for @tglStateNoEscape.
  ///
  /// In en, this message translates to:
  /// **'No Way Out'**
  String get tglStateNoEscape;

  /// No description provided for @tglStateWar.
  ///
  /// In en, this message translates to:
  /// **'WAR'**
  String get tglStateWar;

  /// No description provided for @tglStateOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get tglStateOverdue;

  /// No description provided for @notifSomeday.
  ///
  /// In en, this message translates to:
  /// **'Future you is crying right now'**
  String get notifSomeday;

  /// No description provided for @notifReality.
  ///
  /// In en, this message translates to:
  /// **'Time to face reality'**
  String get notifReality;

  /// No description provided for @notifNoEscape.
  ///
  /// In en, this message translates to:
  /// **'There\'s no escape now'**
  String get notifNoEscape;

  /// No description provided for @notifWar.
  ///
  /// In en, this message translates to:
  /// **'It\'s war. That is all.'**
  String get notifWar;

  /// No description provided for @notifHopeless.
  ///
  /// In en, this message translates to:
  /// **'Already hopeless. Good luck.'**
  String get notifHopeless;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Task Notifications'**
  String get notifChannelName;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingPage1Heading.
  ///
  /// In en, this message translates to:
  /// **'Track deadline stress'**
  String get onboardingPage1Heading;

  /// No description provided for @onboardingPage1Body.
  ///
  /// In en, this message translates to:
  /// **'OIKOMI manages tasks by \"psychological difficulty\" — a new kind of task manager'**
  String get onboardingPage1Body;

  /// No description provided for @onboardingPage2Heading.
  ///
  /// In en, this message translates to:
  /// **'Just 4 inputs'**
  String get onboardingPage2Heading;

  /// No description provided for @onboardingPage2Body.
  ///
  /// In en, this message translates to:
  /// **'Name, deadline, time required, and avoidance level. OIKOMI figures out the rest.'**
  String get onboardingPage2Body;

  /// No description provided for @onboardingPage3Heading.
  ///
  /// In en, this message translates to:
  /// **'5-level stress display'**
  String get onboardingPage3Heading;

  /// No description provided for @onboardingPage3Body.
  ///
  /// In en, this message translates to:
  /// **'All Good → Eventually → Getting Real → No Way Out → WAR.\nYou get notified when the level changes.'**
  String get onboardingPage3Body;

  /// No description provided for @onboardingPage4Heading.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go'**
  String get onboardingPage4Heading;

  /// No description provided for @onboardingPage4StartButton.
  ///
  /// In en, this message translates to:
  /// **'Add your first task'**
  String get onboardingPage4StartButton;

  /// No description provided for @onboardingMockTaskName.
  ///
  /// In en, this message translates to:
  /// **'Task Name'**
  String get onboardingMockTaskName;

  /// No description provided for @onboardingMockTaskValue.
  ///
  /// In en, this message translates to:
  /// **'Statistics essay'**
  String get onboardingMockTaskValue;

  /// No description provided for @onboardingMockDeadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get onboardingMockDeadline;

  /// No description provided for @onboardingMockDeadlineValue.
  ///
  /// In en, this message translates to:
  /// **'5/31 23:59'**
  String get onboardingMockDeadlineValue;

  /// No description provided for @onboardingMockTime.
  ///
  /// In en, this message translates to:
  /// **'Time required'**
  String get onboardingMockTime;

  /// No description provided for @onboardingMockTimeValue.
  ///
  /// In en, this message translates to:
  /// **'2h'**
  String get onboardingMockTimeValue;

  /// No description provided for @onboardingMockAvoidance.
  ///
  /// In en, this message translates to:
  /// **'Avoidance'**
  String get onboardingMockAvoidance;

  /// No description provided for @onboardingMockAvoidanceValue.
  ///
  /// In en, this message translates to:
  /// **'7'**
  String get onboardingMockAvoidanceValue;

  /// No description provided for @timeUnitMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String timeUnitMinutes(int count);

  /// No description provided for @timeUnitHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String timeUnitHours(int count);

  /// No description provided for @timeUnitHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}min'**
  String timeUnitHoursMinutes(int hours, int minutes);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageValue.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get settingsLanguageValue;

  /// No description provided for @settingsSectionInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get settingsSectionInfo;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsTermsOfService;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsSupport;

  /// No description provided for @settingsUrlError.
  ///
  /// In en, this message translates to:
  /// **'Could not open URL'**
  String get settingsUrlError;

  /// No description provided for @settingsSectionPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get settingsSectionPremium;

  /// No description provided for @settingsRestorePurchase.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get settingsRestorePurchase;

  /// No description provided for @settingsPremiumUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get settingsPremiumUpgrade;

  /// No description provided for @settingsPremiumCustomThreshold.
  ///
  /// In en, this message translates to:
  /// **'Custom TGL Thresholds'**
  String get settingsPremiumCustomThreshold;

  /// No description provided for @settingsPremiumComingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get settingsPremiumComingSoonTitle;

  /// No description provided for @settingsPremiumComingSoonBody.
  ///
  /// In en, this message translates to:
  /// **'Premium features will be added in a future update.'**
  String get settingsPremiumComingSoonBody;

  /// No description provided for @taskDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Task Detail'**
  String get taskDetailTitle;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @completeButton.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeButton;

  /// No description provided for @undoButton.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoButton;

  /// No description provided for @taskDeletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeletedMessage;

  /// No description provided for @taskCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Marked as complete'**
  String get taskCompletedMessage;

  /// No description provided for @avoidance1.
  ///
  /// In en, this message translates to:
  /// **'No problem'**
  String get avoidance1;

  /// No description provided for @avoidance2.
  ///
  /// In en, this message translates to:
  /// **'Pretty easy'**
  String get avoidance2;

  /// No description provided for @avoidance3.
  ///
  /// In en, this message translates to:
  /// **'Can manage'**
  String get avoidance3;

  /// No description provided for @avoidance4.
  ///
  /// In en, this message translates to:
  /// **'Kinda annoying'**
  String get avoidance4;

  /// No description provided for @avoidance5.
  ///
  /// In en, this message translates to:
  /// **'Meh, fine'**
  String get avoidance5;

  /// No description provided for @avoidance6.
  ///
  /// In en, this message translates to:
  /// **'Rather not'**
  String get avoidance6;

  /// No description provided for @avoidance7.
  ///
  /// In en, this message translates to:
  /// **'Really don\'t wanna'**
  String get avoidance7;

  /// No description provided for @avoidance8.
  ///
  /// In en, this message translates to:
  /// **'Please no'**
  String get avoidance8;

  /// No description provided for @avoidance9.
  ///
  /// In en, this message translates to:
  /// **'Seriously, NO'**
  String get avoidance9;

  /// No description provided for @avoidance10.
  ///
  /// In en, this message translates to:
  /// **'Over my dead body'**
  String get avoidance10;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
