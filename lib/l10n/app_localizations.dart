import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('kk'),
    Locale('ru'),
  ];

  /// Localized text for 'app_name'.
  ///
  /// In en, this message translates to:
  /// **'Synor'**
  String get app_name;

  /// Localized text for 'branding_from'.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get branding_from;

  /// Localized text for 'common_skip'.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get common_skip;

  /// Localized text for 'common_continue'.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get common_continue;

  /// Localized text for 'common_getStarted'.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get common_getStarted;

  /// Localized text for 'common_or'.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get common_or;

  /// Localized text for 'common_close'.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get common_close;

  /// Localized text for 'common_upload'.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get common_upload;

  /// Localized text for 'common_viewAll'.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get common_viewAll;

  /// Localized text for 'common_tryAgain'.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get common_tryAgain;

  /// Localized text for 'common_success'.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get common_success;

  /// Localized text for 'common_languageEnglish'.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get common_languageEnglish;

  /// Localized text for 'common_languageRussian'.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get common_languageRussian;

  /// Localized text for 'common_languageKazakh'.
  ///
  /// In en, this message translates to:
  /// **'Қазақша'**
  String get common_languageKazakh;

  /// Localized text for 'auth_onboardingTitle1'.
  ///
  /// In en, this message translates to:
  /// **'Your academic life, finally organized.'**
  String get auth_onboardingTitle1;

  /// Localized text for 'auth_onboardingSubtitle1'.
  ///
  /// In en, this message translates to:
  /// **'Synor keeps your schedule, tasks, reminders, and study flow in one place.'**
  String get auth_onboardingSubtitle1;

  /// Localized text for 'auth_onboardingTitle2'.
  ///
  /// In en, this message translates to:
  /// **'Schedule, study, and routine — in one flow.'**
  String get auth_onboardingTitle2;

  /// Localized text for 'auth_onboardingSubtitle2'.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to succeed, seamlessly integrated.'**
  String get auth_onboardingSubtitle2;

  /// Localized text for 'auth_onboardingTitle3'.
  ///
  /// In en, this message translates to:
  /// **'Less chaos. More control.'**
  String get auth_onboardingTitle3;

  /// Localized text for 'auth_onboardingSubtitle3'.
  ///
  /// In en, this message translates to:
  /// **'Focus on what matters. We\'ll handle the rest.'**
  String get auth_onboardingSubtitle3;

  /// Localized text for 'auth_welcomeBack'.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get auth_welcomeBack;

  /// Localized text for 'auth_signInSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your schedule, study hub, and smart routine.'**
  String get auth_signInSubtitle;

  /// Localized text for 'auth_studentIdOrEmail'.
  ///
  /// In en, this message translates to:
  /// **'Student ID / Email'**
  String get auth_studentIdOrEmail;

  /// Localized text for 'auth_password'.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// Localized text for 'auth_forgotPassword'.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_forgotPassword;

  /// Localized text for 'auth_signingIn'.
  ///
  /// In en, this message translates to:
  /// **'Signing In...'**
  String get auth_signingIn;

  /// Localized text for 'auth_signIn'.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get auth_signIn;

  /// Localized text for 'auth_connecting'.
  ///
  /// In en, this message translates to:
  /// **'Connecting...'**
  String get auth_connecting;

  /// Localized text for 'auth_continueWithGoogle'.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get auth_continueWithGoogle;

  /// Localized text for 'auth_newHere'.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get auth_newHere;

  /// Localized text for 'auth_createAccount'.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get auth_createAccount;

  /// Localized text for 'auth_createAccountTitle'.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get auth_createAccountTitle;

  /// Localized text for 'auth_identitySubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start with your basic identity.'**
  String get auth_identitySubtitle;

  /// Localized text for 'auth_roleStudent'.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get auth_roleStudent;

  /// Localized text for 'auth_roleTeacher'.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get auth_roleTeacher;

  /// Localized text for 'auth_fullName'.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get auth_fullName;

  /// Localized text for 'auth_emailAddress'.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get auth_emailAddress;

  /// Localized text for 'auth_createPassword'.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get auth_createPassword;

  /// Localized text for 'auth_academicSetupTitle'.
  ///
  /// In en, this message translates to:
  /// **'Academic setup'**
  String get auth_academicSetupTitle;

  /// Localized text for 'auth_teachingSetupTitle'.
  ///
  /// In en, this message translates to:
  /// **'Teaching setup'**
  String get auth_teachingSetupTitle;

  /// Localized text for 'auth_academicSetupSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tell us where and what you study.'**
  String get auth_academicSetupSubtitle;

  /// Localized text for 'auth_teachingSetupSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tell us where you teach and which group you manage.'**
  String get auth_teachingSetupSubtitle;

  /// Localized text for 'auth_university'.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get auth_university;

  /// Localized text for 'auth_facultyDepartment'.
  ///
  /// In en, this message translates to:
  /// **'Faculty / Department'**
  String get auth_facultyDepartment;

  /// Localized text for 'auth_courseYear'.
  ///
  /// In en, this message translates to:
  /// **'Course Year'**
  String get auth_courseYear;

  /// Localized text for 'auth_group'.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get auth_group;

  /// Localized text for 'auth_primaryGroup'.
  ///
  /// In en, this message translates to:
  /// **'Primary Group'**
  String get auth_primaryGroup;

  /// Localized text for 'auth_personalizeTitle'.
  ///
  /// In en, this message translates to:
  /// **'Personalize your flow'**
  String get auth_personalizeTitle;

  /// Localized text for 'auth_personalizeSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'This helps Synor personalize your schedule, reminders, and study experience.'**
  String get auth_personalizeSubtitle;

  /// Localized text for 'auth_campusPreferences'.
  ///
  /// In en, this message translates to:
  /// **'Campus Preferences'**
  String get auth_campusPreferences;

  /// Localized text for 'auth_studyMode'.
  ///
  /// In en, this message translates to:
  /// **'Study Mode'**
  String get auth_studyMode;

  /// Localized text for 'auth_studyModeDeepFocus'.
  ///
  /// In en, this message translates to:
  /// **'Deep Focus'**
  String get auth_studyModeDeepFocus;

  /// Localized text for 'auth_studyModeFlexible'.
  ///
  /// In en, this message translates to:
  /// **'Flexible'**
  String get auth_studyModeFlexible;

  /// Localized text for 'auth_smartFeaturesTitle'.
  ///
  /// In en, this message translates to:
  /// **'Turn on smart features'**
  String get auth_smartFeaturesTitle;

  /// Localized text for 'auth_smartFeaturesSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Enable these to get the full Synor experience.'**
  String get auth_smartFeaturesSubtitle;

  /// Localized text for 'auth_smartNotifications'.
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get auth_smartNotifications;

  /// Localized text for 'auth_smartNotificationsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Get alerts for classes & tasks'**
  String get auth_smartNotificationsSubtitle;

  /// Localized text for 'auth_calendarSync'.
  ///
  /// In en, this message translates to:
  /// **'Calendar Sync'**
  String get auth_calendarSync;

  /// Localized text for 'auth_calendarSyncSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Connect your personal calendar'**
  String get auth_calendarSyncSubtitle;

  /// Localized text for 'auth_completing'.
  ///
  /// In en, this message translates to:
  /// **'Completing...'**
  String get auth_completing;

  /// Localized text for 'auth_completeSetup'.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get auth_completeSetup;

  /// Localized text for 'auth_validationEnterStudentEmailOrId'.
  ///
  /// In en, this message translates to:
  /// **'Enter your student email or ID.'**
  String get auth_validationEnterStudentEmailOrId;

  /// Localized text for 'auth_validationValidEmail'.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get auth_validationValidEmail;

  /// Localized text for 'auth_validationEnterPassword'.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get auth_validationEnterPassword;

  /// Localized text for 'auth_validationPasswordLength'.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get auth_validationPasswordLength;

  /// Localized text for 'auth_errorRestoreSession'.
  ///
  /// In en, this message translates to:
  /// **'Unable to restore your session. Please try again.'**
  String get auth_errorRestoreSession;

  /// Localized text for 'auth_errorSignInFailed'.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed. Please check your credentials.'**
  String get auth_errorSignInFailed;

  /// Localized text for 'auth_errorGoogleUnavailable'.
  ///
  /// In en, this message translates to:
  /// **'Google sign in is not available right now.'**
  String get auth_errorGoogleUnavailable;

  /// Localized text for 'auth_errorEnterEmailRecovery'.
  ///
  /// In en, this message translates to:
  /// **'Enter your email first to recover access.'**
  String get auth_errorEnterEmailRecovery;

  /// Localized text for 'auth_errorSignUpVerification'.
  ///
  /// In en, this message translates to:
  /// **'Account created. Check {email} to verify your email, then sign in.'**
  String auth_errorSignUpVerification(String email);

  /// Localized text for 'auth_errorSignUpSessionNotReady'.
  ///
  /// In en, this message translates to:
  /// **'Account created, but the session is not ready yet. Please sign in.'**
  String get auth_errorSignUpSessionNotReady;

  /// Localized text for 'auth_errorSignUpFailed'.
  ///
  /// In en, this message translates to:
  /// **'Could not complete sign up. Please try again.'**
  String get auth_errorSignUpFailed;

  /// Localized text for 'auth_signInFailedTitle'.
  ///
  /// In en, this message translates to:
  /// **'Sign in failed'**
  String get auth_signInFailedTitle;

  /// Localized text for 'auth_googleUnavailableTitle'.
  ///
  /// In en, this message translates to:
  /// **'Google sign in unavailable'**
  String get auth_googleUnavailableTitle;

  /// Localized text for 'auth_recoveryLinkSentTitle'.
  ///
  /// In en, this message translates to:
  /// **'Recovery link sent'**
  String get auth_recoveryLinkSentTitle;

  /// Localized text for 'auth_signUpCompleteTitle'.
  ///
  /// In en, this message translates to:
  /// **'Sign up complete'**
  String get auth_signUpCompleteTitle;

  /// Localized text for 'auth_signUpFailedTitle'.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed'**
  String get auth_signUpFailedTitle;

  /// Localized text for 'auth_campusMainBuilding'.
  ///
  /// In en, this message translates to:
  /// **'Main Building'**
  String get auth_campusMainBuilding;

  /// Localized text for 'auth_campusSouthCampus'.
  ///
  /// In en, this message translates to:
  /// **'South Campus'**
  String get auth_campusSouthCampus;

  /// Localized text for 'auth_campusRemoteStudy'.
  ///
  /// In en, this message translates to:
  /// **'Remote Study'**
  String get auth_campusRemoteStudy;

  /// Localized text for 'home_searchPlaceholder'.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get home_searchPlaceholder;

  /// Localized text for 'home_filterLessons'.
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get home_filterLessons;

  /// Localized text for 'home_filterAll'.
  ///
  /// In en, this message translates to:
  /// **'all'**
  String get home_filterAll;

  /// Localized text for 'home_filterMissed'.
  ///
  /// In en, this message translates to:
  /// **'missed'**
  String get home_filterMissed;

  /// Localized text for 'home_filterTomorrow'.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get home_filterTomorrow;

  /// Localized text for 'home_emptyTitle'.
  ///
  /// In en, this message translates to:
  /// **'Nothing to show'**
  String get home_emptyTitle;

  /// Localized text for 'home_emptySearchMessage'.
  ///
  /// In en, this message translates to:
  /// **'No lessons match \"{query}\" in the current filter.'**
  String home_emptySearchMessage(String query);

  /// Localized text for 'home_emptyMissedMessage'.
  ///
  /// In en, this message translates to:
  /// **'No missed or in-progress lessons right now.'**
  String get home_emptyMissedMessage;

  /// Localized text for 'home_emptyTomorrowMessage'.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow looks clear for now.'**
  String get home_emptyTomorrowMessage;

  /// Localized text for 'home_emptyDefaultMessage'.
  ///
  /// In en, this message translates to:
  /// **'No lessons available in this view.'**
  String get home_emptyDefaultMessage;

  /// Localized text for 'home_addStoryLabel'.
  ///
  /// In en, this message translates to:
  /// **'Your stories'**
  String get home_addStoryLabel;

  /// Localized text for 'home_lightMode'.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get home_lightMode;

  /// Localized text for 'home_darkMode'.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get home_darkMode;

  /// Localized text for 'lesson_actionAlert'.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get lesson_actionAlert;

  /// Localized text for 'lesson_actionNotes'.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get lesson_actionNotes;

  /// Localized text for 'lesson_actionMore'.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get lesson_actionMore;

  /// Localized text for 'lesson_inProgress'.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get lesson_inProgress;

  /// Localized text for 'lesson_notesUnavailableTitle'.
  ///
  /// In en, this message translates to:
  /// **'Lesson notes are not attached yet'**
  String get lesson_notesUnavailableTitle;

  /// Localized text for 'lesson_notesUnavailableSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Swipe for alerts, or open the Study Hub for materials.'**
  String get lesson_notesUnavailableSubtitle;

  /// Localized text for 'lesson_moreUnavailableTitle'.
  ///
  /// In en, this message translates to:
  /// **'More lesson actions land in the next phase'**
  String get lesson_moreUnavailableTitle;

  /// Localized text for 'lesson_moreUnavailableSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Current production polish is focused on alerts and scheduling.'**
  String get lesson_moreUnavailableSubtitle;

  /// Localized text for 'messages_title'.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages_title;

  /// Localized text for 'messages_loadingTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading messages'**
  String get messages_loadingTitle;

  /// Localized text for 'messages_loadingMessage'.
  ///
  /// In en, this message translates to:
  /// **'Preparing your recent conversations...'**
  String get messages_loadingMessage;

  /// Localized text for 'schedule_title'.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule_title;

  /// Localized text for 'schedule_searchPlaceholder'.
  ///
  /// In en, this message translates to:
  /// **'Search lessons or events'**
  String get schedule_searchPlaceholder;

  /// Localized text for 'schedule_modeDay'.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get schedule_modeDay;

  /// Localized text for 'schedule_modeWeek'.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get schedule_modeWeek;

  /// Localized text for 'schedule_modeMonth'.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get schedule_modeMonth;

  /// Localized text for 'schedule_noLessonsTitle'.
  ///
  /// In en, this message translates to:
  /// **'No lessons scheduled'**
  String get schedule_noLessonsTitle;

  /// Localized text for 'schedule_noLessonsMessage'.
  ///
  /// In en, this message translates to:
  /// **'This day is clear in your current schedule.'**
  String get schedule_noLessonsMessage;

  /// Localized text for 'schedule_noLessonsForDay'.
  ///
  /// In en, this message translates to:
  /// **'No lessons planned for this day.'**
  String get schedule_noLessonsForDay;

  /// Localized text for 'schedule_upcoming'.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get schedule_upcoming;

  /// Localized text for 'schedule_noMonthEvents'.
  ///
  /// In en, this message translates to:
  /// **'No events scheduled for this month.'**
  String get schedule_noMonthEvents;

  /// Localized text for 'schedule_weekLessonCount'.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{# lesson} other{# lessons}}'**
  String schedule_weekLessonCount(int count);

  /// Localized text for 'teacher_dashboardTitle'.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacher_dashboardTitle;

  /// Localized text for 'teacher_teachingSpace'.
  ///
  /// In en, this message translates to:
  /// **'Your teaching space'**
  String get teacher_teachingSpace;

  /// Localized text for 'teacher_superAccess'.
  ///
  /// In en, this message translates to:
  /// **'Super Access'**
  String get teacher_superAccess;

  /// Localized text for 'teacher_teacher'.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher_teacher;

  /// Localized text for 'teacher_upcomingLessons'.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Lessons'**
  String get teacher_upcomingLessons;

  /// Localized text for 'teacher_materials'.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get teacher_materials;

  /// Localized text for 'teacher_createLesson'.
  ///
  /// In en, this message translates to:
  /// **'Create Lesson'**
  String get teacher_createLesson;

  /// Localized text for 'teacher_managedSchedule'.
  ///
  /// In en, this message translates to:
  /// **'Managed schedule'**
  String get teacher_managedSchedule;

  /// Localized text for 'teacher_noLessonsTitle'.
  ///
  /// In en, this message translates to:
  /// **'No lessons yet'**
  String get teacher_noLessonsTitle;

  /// Localized text for 'teacher_noLessonsMessage'.
  ///
  /// In en, this message translates to:
  /// **'Create your first lesson to start filling the schedule.'**
  String get teacher_noLessonsMessage;

  /// Localized text for 'teacher_incompleteLessonTitle'.
  ///
  /// In en, this message translates to:
  /// **'Lesson details are incomplete'**
  String get teacher_incompleteLessonTitle;

  /// Localized text for 'teacher_incompleteLessonSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Set subject, room, group, and a valid time range.'**
  String get teacher_incompleteLessonSubtitle;

  /// Localized text for 'teacher_lessonCreated'.
  ///
  /// In en, this message translates to:
  /// **'Lesson created'**
  String get teacher_lessonCreated;

  /// Localized text for 'teacher_lessonUpdated'.
  ///
  /// In en, this message translates to:
  /// **'Lesson updated'**
  String get teacher_lessonUpdated;

  /// Localized text for 'teacher_lessonSaveFailed'.
  ///
  /// In en, this message translates to:
  /// **'Could not save lesson'**
  String get teacher_lessonSaveFailed;

  /// Localized text for 'teacher_createLessonTitle'.
  ///
  /// In en, this message translates to:
  /// **'Create Lesson'**
  String get teacher_createLessonTitle;

  /// Localized text for 'teacher_editLessonTitle'.
  ///
  /// In en, this message translates to:
  /// **'Edit Lesson'**
  String get teacher_editLessonTitle;

  /// Localized text for 'teacher_subjectHint'.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get teacher_subjectHint;

  /// Localized text for 'teacher_roomHint'.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get teacher_roomHint;

  /// Localized text for 'teacher_selectGroup'.
  ///
  /// In en, this message translates to:
  /// **'Select group'**
  String get teacher_selectGroup;

  /// Localized text for 'teacher_start'.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get teacher_start;

  /// Localized text for 'teacher_end'.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get teacher_end;

  /// Localized text for 'teacher_saving'.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get teacher_saving;

  /// Localized text for 'teacher_saveLesson'.
  ///
  /// In en, this message translates to:
  /// **'Save Lesson'**
  String get teacher_saveLesson;

  /// Localized text for 'services_title'.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services_title;

  /// Localized text for 'services_searchPlaceholder'.
  ///
  /// In en, this message translates to:
  /// **'Search services...'**
  String get services_searchPlaceholder;

  /// Localized text for 'services_noResults'.
  ///
  /// In en, this message translates to:
  /// **'No services found matching \"{query}\"'**
  String services_noResults(String query);

  /// Localized text for 'services_recentRequests'.
  ///
  /// In en, this message translates to:
  /// **'Recent Requests'**
  String get services_recentRequests;

  /// Localized text for 'services_availableToRequest'.
  ///
  /// In en, this message translates to:
  /// **'Available to request'**
  String get services_availableToRequest;

  /// Localized text for 'services_documents'.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get services_documents;

  /// Localized text for 'services_documentsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Certificates & references'**
  String get services_documentsSubtitle;

  /// Localized text for 'services_payments'.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get services_payments;

  /// Localized text for 'services_paymentsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tuition & dormitory'**
  String get services_paymentsSubtitle;

  /// Localized text for 'services_housing'.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get services_housing;

  /// Localized text for 'services_housingSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Dormitory requests'**
  String get services_housingSubtitle;

  /// Localized text for 'services_support'.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get services_support;

  /// Localized text for 'services_supportSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'IT & Academic help'**
  String get services_supportSubtitle;

  /// Localized text for 'services_documentEnrollmentCertificate'.
  ///
  /// In en, this message translates to:
  /// **'Enrollment Certificate'**
  String get services_documentEnrollmentCertificate;

  /// Localized text for 'services_documentEnrollmentCertificateSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Proof of student status'**
  String get services_documentEnrollmentCertificateSubtitle;

  /// Localized text for 'services_documentOfficialTranscript'.
  ///
  /// In en, this message translates to:
  /// **'Official Transcript'**
  String get services_documentOfficialTranscript;

  /// Localized text for 'services_documentOfficialTranscriptSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Academic record with grades'**
  String get services_documentOfficialTranscriptSubtitle;

  /// Localized text for 'services_documentMilitaryDeferment'.
  ///
  /// In en, this message translates to:
  /// **'Military Deferment'**
  String get services_documentMilitaryDeferment;

  /// Localized text for 'services_documentMilitaryDefermentSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'For military service exemption'**
  String get services_documentMilitaryDefermentSubtitle;

  /// Localized text for 'services_currentBalance'.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get services_currentBalance;

  /// Localized text for 'services_allFeesPaid'.
  ///
  /// In en, this message translates to:
  /// **'All fees paid'**
  String get services_allFeesPaid;

  /// Localized text for 'services_upcomingFees'.
  ///
  /// In en, this message translates to:
  /// **'Upcoming fees'**
  String get services_upcomingFees;

  /// Localized text for 'services_springSemester2026'.
  ///
  /// In en, this message translates to:
  /// **'Spring Semester 2026'**
  String get services_springSemester2026;

  /// Localized text for 'services_tuitionFee'.
  ///
  /// In en, this message translates to:
  /// **'Tuition Fee'**
  String get services_tuitionFee;

  /// Localized text for 'services_dueIn45Days'.
  ///
  /// In en, this message translates to:
  /// **'Due in 45 days (May 10, 2026)'**
  String get services_dueIn45Days;

  /// Localized text for 'services_payNow'.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get services_payNow;

  /// Localized text for 'services_dormitoryTitle'.
  ///
  /// In en, this message translates to:
  /// **'Dormitory #3'**
  String get services_dormitoryTitle;

  /// Localized text for 'services_dormitoryRoom'.
  ///
  /// In en, this message translates to:
  /// **'Room 412 • Floor 4'**
  String get services_dormitoryRoom;

  /// Localized text for 'services_maintenanceRequest'.
  ///
  /// In en, this message translates to:
  /// **'Maintenance request'**
  String get services_maintenanceRequest;

  /// Localized text for 'services_issueType'.
  ///
  /// In en, this message translates to:
  /// **'Issue Type'**
  String get services_issueType;

  /// Localized text for 'services_issueTypePlumbing'.
  ///
  /// In en, this message translates to:
  /// **'Plumbing'**
  String get services_issueTypePlumbing;

  /// Localized text for 'services_issueTypeElectrical'.
  ///
  /// In en, this message translates to:
  /// **'Electrical'**
  String get services_issueTypeElectrical;

  /// Localized text for 'services_issueTypeFurniture'.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get services_issueTypeFurniture;

  /// Localized text for 'services_issueTypeOther'.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get services_issueTypeOther;

  /// Localized text for 'services_description'.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get services_description;

  /// Localized text for 'services_describeIssue'.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue...'**
  String get services_describeIssue;

  /// Localized text for 'services_submitRequest'.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get services_submitRequest;

  /// Localized text for 'services_itHelpdesk'.
  ///
  /// In en, this message translates to:
  /// **'IT Helpdesk'**
  String get services_itHelpdesk;

  /// Localized text for 'services_itHelpdeskSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tech issues'**
  String get services_itHelpdeskSubtitle;

  /// Localized text for 'services_itHelpdeskRequest'.
  ///
  /// In en, this message translates to:
  /// **'IT Helpdesk Request'**
  String get services_itHelpdeskRequest;

  /// Localized text for 'services_academic'.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get services_academic;

  /// Localized text for 'services_academicSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Advisor contact'**
  String get services_academicSubtitle;

  /// Localized text for 'services_academicAdvisorContact'.
  ///
  /// In en, this message translates to:
  /// **'Academic Advisor Contact'**
  String get services_academicAdvisorContact;

  /// Localized text for 'services_newTicket'.
  ///
  /// In en, this message translates to:
  /// **'New ticket'**
  String get services_newTicket;

  /// Localized text for 'services_subject'.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get services_subject;

  /// Localized text for 'services_briefSummary'.
  ///
  /// In en, this message translates to:
  /// **'Brief summary...'**
  String get services_briefSummary;

  /// Localized text for 'services_message'.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get services_message;

  /// Localized text for 'services_howCanWeHelp'.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get services_howCanWeHelp;

  /// Localized text for 'services_sendMessage'.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get services_sendMessage;

  /// Localized text for 'services_allRequests'.
  ///
  /// In en, this message translates to:
  /// **'All Requests'**
  String get services_allRequests;

  /// Localized text for 'services_status'.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get services_status;

  /// Localized text for 'services_date'.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get services_date;

  /// Localized text for 'request_statusReady'.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get request_statusReady;

  /// Localized text for 'request_statusPending'.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get request_statusPending;

  /// Localized text for 'request_statusProcessing'.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get request_statusProcessing;

  /// Localized text for 'request_statusOpen'.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get request_statusOpen;

  /// Localized text for 'request_statusInProgress'.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get request_statusInProgress;

  /// Localized text for 'services_loadingTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading services'**
  String get services_loadingTitle;

  /// Localized text for 'services_loadingMessage'.
  ///
  /// In en, this message translates to:
  /// **'Preparing student services and recent requests...'**
  String get services_loadingMessage;

  /// Localized text for 'services_requestId'.
  ///
  /// In en, this message translates to:
  /// **'ID: REQ-{id}'**
  String services_requestId(String id);

  /// Localized text for 'services_successDocumentRequested'.
  ///
  /// In en, this message translates to:
  /// **'{title} requested successfully'**
  String services_successDocumentRequested(String title);

  /// Localized text for 'services_successPaymentInitiated'.
  ///
  /// In en, this message translates to:
  /// **'Payment initiated'**
  String get services_successPaymentInitiated;

  /// Localized text for 'services_successMaintenanceSubmitted'.
  ///
  /// In en, this message translates to:
  /// **'Maintenance request submitted'**
  String get services_successMaintenanceSubmitted;

  /// Localized text for 'services_successSupportCreated'.
  ///
  /// In en, this message translates to:
  /// **'Support ticket created'**
  String get services_successSupportCreated;

  /// Localized text for 'profile_settings'.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// Localized text for 'profile_preferences'.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profile_preferences;

  /// Localized text for 'profile_security'.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profile_security;

  /// Localized text for 'profile_privacySecurity'.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get profile_privacySecurity;

  /// Localized text for 'profile_darkMode'.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_darkMode;

  /// Localized text for 'profile_language'.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// Localized text for 'profile_notifications'.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_notifications;

  /// Localized text for 'profile_passwordSecurity'.
  ///
  /// In en, this message translates to:
  /// **'Password & Security'**
  String get profile_passwordSecurity;

  /// Localized text for 'profile_privacySettings'.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get profile_privacySettings;

  /// Localized text for 'profile_logOut'.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get profile_logOut;

  /// Localized text for 'profile_connected'.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get profile_connected;

  /// Localized text for 'profile_connect'.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get profile_connect;

  /// Localized text for 'profile_message'.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get profile_message;

  /// Localized text for 'profile_currentStatus'.
  ///
  /// In en, this message translates to:
  /// **'Current Status'**
  String get profile_currentStatus;

  /// Localized text for 'profile_update'.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get profile_update;

  /// Localized text for 'profile_statusInLecture'.
  ///
  /// In en, this message translates to:
  /// **'IN LECTURE'**
  String get profile_statusInLecture;

  /// Localized text for 'profile_statusLeft'.
  ///
  /// In en, this message translates to:
  /// **'LEFT'**
  String get profile_statusLeft;

  /// Localized text for 'profile_statusCoffeeBreak'.
  ///
  /// In en, this message translates to:
  /// **'Coffee break'**
  String get profile_statusCoffeeBreak;

  /// Localized text for 'profile_statusStudyGroup'.
  ///
  /// In en, this message translates to:
  /// **'Looking for study group'**
  String get profile_statusStudyGroup;

  /// Localized text for 'profile_statusSharingNotes'.
  ///
  /// In en, this message translates to:
  /// **'Sharing notes'**
  String get profile_statusSharingNotes;

  /// Localized text for 'profile_recentActivity'.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get profile_recentActivity;

  /// Localized text for 'profile_studentServices'.
  ///
  /// In en, this message translates to:
  /// **'Student Services'**
  String get profile_studentServices;

  /// Localized text for 'profile_servicesDocuments'.
  ///
  /// In en, this message translates to:
  /// **'Certificates & Documents'**
  String get profile_servicesDocuments;

  /// Localized text for 'profile_servicesDocumentsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Transcripts, study certificates'**
  String get profile_servicesDocumentsSubtitle;

  /// Localized text for 'profile_servicesFinance'.
  ///
  /// In en, this message translates to:
  /// **'Finance & Payments'**
  String get profile_servicesFinance;

  /// Localized text for 'profile_servicesFinanceSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tuition, dormitory fees'**
  String get profile_servicesFinanceSubtitle;

  /// Localized text for 'profile_servicesHousing'.
  ///
  /// In en, this message translates to:
  /// **'Housing & Dormitory'**
  String get profile_servicesHousing;

  /// Localized text for 'profile_servicesHousingSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Requests, rules, status'**
  String get profile_servicesHousingSubtitle;

  /// Localized text for 'profile_coverUploadFailed'.
  ///
  /// In en, this message translates to:
  /// **'Cover upload failed'**
  String get profile_coverUploadFailed;

  /// Localized text for 'profile_coverUploadFailedSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'The selected image could not be loaded.'**
  String get profile_coverUploadFailedSubtitle;

  /// Localized text for 'profile_coverTooLarge'.
  ///
  /// In en, this message translates to:
  /// **'Image is too large'**
  String get profile_coverTooLarge;

  /// Localized text for 'profile_coverTooLargeSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Choose a JPG, PNG, or GIF under 5MB.'**
  String get profile_coverTooLargeSubtitle;

  /// Localized text for 'profile_coverUpdated'.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get profile_coverUpdated;

  /// Localized text for 'profile_profileLinkCopied'.
  ///
  /// In en, this message translates to:
  /// **'Profile link copied'**
  String get profile_profileLinkCopied;

  /// Localized text for 'profile_profileCodeCopied'.
  ///
  /// In en, this message translates to:
  /// **'Profile code copied'**
  String get profile_profileCodeCopied;

  /// Localized text for 'profile_profileCodeCopiedSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Ready to paste into a campus kiosk or chat.'**
  String get profile_profileCodeCopiedSubtitle;

  /// Localized text for 'profile_connectionRequestSent'.
  ///
  /// In en, this message translates to:
  /// **'Connection request sent'**
  String get profile_connectionRequestSent;

  /// Localized text for 'profile_connectionRequestRemoved'.
  ///
  /// In en, this message translates to:
  /// **'Connection request removed'**
  String get profile_connectionRequestRemoved;

  /// Localized text for 'profile_statusUpdated'.
  ///
  /// In en, this message translates to:
  /// **'Status updated'**
  String get profile_statusUpdated;

  /// Localized text for 'profile_statusUpdatedSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Your active study signal stays visible on the profile card.'**
  String get profile_statusUpdatedSubtitle;

  /// Localized text for 'profile_viewAll'.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get profile_viewAll;

  /// Localized text for 'profile_statusSubject'.
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get profile_statusSubject;

  /// Localized text for 'profile_statusRoom'.
  ///
  /// In en, this message translates to:
  /// **'Room B-204'**
  String get profile_statusRoom;

  /// Localized text for 'profile_recentSharedNotesTitle'.
  ///
  /// In en, this message translates to:
  /// **'Shared Notes: Databases'**
  String get profile_recentSharedNotesTitle;

  /// Localized text for 'profile_recentSharedNotesSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Compiled all the SQL queries and normalization rules we covered.'**
  String get profile_recentSharedNotesSubtitle;

  /// Localized text for 'profile_recentJoinedGroupTitle'.
  ///
  /// In en, this message translates to:
  /// **'Joined Study Group'**
  String get profile_recentJoinedGroupTitle;

  /// Localized text for 'profile_recentJoinedGroupSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Advanced Algorithms Prep Group'**
  String get profile_recentJoinedGroupSubtitle;

  /// Localized text for 'profile_hoursAgo'.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String profile_hoursAgo(int count);

  /// Localized text for 'profile_yesterday'.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get profile_yesterday;

  /// Localized text for 'profile_editCover'.
  ///
  /// In en, this message translates to:
  /// **'Edit Cover'**
  String get profile_editCover;

  /// Localized text for 'profile_chooseFromTemplates'.
  ///
  /// In en, this message translates to:
  /// **'Choose from templates'**
  String get profile_chooseFromTemplates;

  /// Localized text for 'profile_uploadFromDevice'.
  ///
  /// In en, this message translates to:
  /// **'Upload from device'**
  String get profile_uploadFromDevice;

  /// Localized text for 'profile_usingUploadedCover'.
  ///
  /// In en, this message translates to:
  /// **'Using uploaded cover'**
  String get profile_usingUploadedCover;

  /// Localized text for 'profile_replaceUploadedCover'.
  ///
  /// In en, this message translates to:
  /// **'Tap to replace with another image'**
  String get profile_replaceUploadedCover;

  /// Localized text for 'profile_uploadRequirements'.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG or GIF (max. 5MB)'**
  String get profile_uploadRequirements;

  /// Localized text for 'profile_topStudent'.
  ///
  /// In en, this message translates to:
  /// **'Top 5% Student'**
  String get profile_topStudent;

  /// Localized text for 'profile_currentGpa'.
  ///
  /// In en, this message translates to:
  /// **'Current GPA'**
  String get profile_currentGpa;

  /// Localized text for 'profile_attendance'.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get profile_attendance;

  /// Localized text for 'profile_languageChanged'.
  ///
  /// In en, this message translates to:
  /// **'Language updated'**
  String get profile_languageChanged;

  /// Localized text for 'profile_languageChangedSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'{language}'**
  String profile_languageChangedSubtitle(String language);

  /// Localized text for 'teacher_superTeacher'.
  ///
  /// In en, this message translates to:
  /// **'Super Teacher'**
  String get teacher_superTeacher;

  /// Localized text for 'teacher_lightMode'.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get teacher_lightMode;

  /// Localized text for 'teacher_darkMode'.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get teacher_darkMode;

  /// Localized text for 'teacher_subjectLine'.
  ///
  /// In en, this message translates to:
  /// **'{date} • {time}'**
  String teacher_subjectLine(String date, String time);

  /// Localized text for 'alarm_title'.
  ///
  /// In en, this message translates to:
  /// **'Smart Alarm'**
  String get alarm_title;

  /// Localized text for 'alarm_subtitle'.
  ///
  /// In en, this message translates to:
  /// **'Never miss a class or deadline'**
  String get alarm_subtitle;

  /// Localized text for 'alarm_modePersonal'.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get alarm_modePersonal;

  /// Localized text for 'alarm_modeAcademic'.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get alarm_modeAcademic;

  /// Localized text for 'alarm_alertType'.
  ///
  /// In en, this message translates to:
  /// **'Alert Type'**
  String get alarm_alertType;

  /// Localized text for 'alarm_typeWakeUp'.
  ///
  /// In en, this message translates to:
  /// **'Wake up'**
  String get alarm_typeWakeUp;

  /// Localized text for 'alarm_typeExamPrep'.
  ///
  /// In en, this message translates to:
  /// **'Exam prep'**
  String get alarm_typeExamPrep;

  /// Localized text for 'alarm_typeAssignment'.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get alarm_typeAssignment;

  /// Localized text for 'alarm_typeLecture'.
  ///
  /// In en, this message translates to:
  /// **'Lecture'**
  String get alarm_typeLecture;

  /// Localized text for 'alarm_setAlarm'.
  ///
  /// In en, this message translates to:
  /// **'Set Alarm'**
  String get alarm_setAlarm;

  /// Localized text for 'alarm_setFor'.
  ///
  /// In en, this message translates to:
  /// **'Alarm set for {time}'**
  String alarm_setFor(String time);

  /// Localized text for 'alarm_activePersonal'.
  ///
  /// In en, this message translates to:
  /// **'Personal alarm is active.'**
  String get alarm_activePersonal;

  /// Localized text for 'alarm_activeAcademic'.
  ///
  /// In en, this message translates to:
  /// **'Academic alert type: {type}'**
  String alarm_activeAcademic(String type);

  /// Localized text for 'quickAlert_title'.
  ///
  /// In en, this message translates to:
  /// **'Quick Alert'**
  String get quickAlert_title;

  /// Localized text for 'quickAlert_suggestions'.
  ///
  /// In en, this message translates to:
  /// **'Smart Suggestions'**
  String get quickAlert_suggestions;

  /// Localized text for 'quickAlert_unavailable'.
  ///
  /// In en, this message translates to:
  /// **'Quick alerts are unavailable.'**
  String get quickAlert_unavailable;

  /// Localized text for 'quickAlert_customTime'.
  ///
  /// In en, this message translates to:
  /// **'Custom Time'**
  String get quickAlert_customTime;

  /// Localized text for 'quickAlert_remove'.
  ///
  /// In en, this message translates to:
  /// **'Remove Alert'**
  String get quickAlert_remove;

  /// Localized text for 'quickAlert_customPreset'.
  ///
  /// In en, this message translates to:
  /// **'45 min before'**
  String get quickAlert_customPreset;

  /// Localized text for 'quickAlert_preset5Min'.
  ///
  /// In en, this message translates to:
  /// **'5 min before'**
  String get quickAlert_preset5Min;

  /// Localized text for 'quickAlert_preset10Min'.
  ///
  /// In en, this message translates to:
  /// **'10 min before'**
  String get quickAlert_preset10Min;

  /// Localized text for 'quickAlert_preset20Min'.
  ///
  /// In en, this message translates to:
  /// **'20 min before'**
  String get quickAlert_preset20Min;

  /// Localized text for 'quickAlert_preset30Min'.
  ///
  /// In en, this message translates to:
  /// **'30 min before'**
  String get quickAlert_preset30Min;

  /// Localized text for 'quickAlert_preset1Hour'.
  ///
  /// In en, this message translates to:
  /// **'1 hour before'**
  String get quickAlert_preset1Hour;

  /// Localized text for 'quickAlert_presetLeaveOnTime'.
  ///
  /// In en, this message translates to:
  /// **'Leave on time'**
  String get quickAlert_presetLeaveOnTime;

  /// Localized text for 'quickAlert_presetWakeUpBeforeClass'.
  ///
  /// In en, this message translates to:
  /// **'Wake up before class'**
  String get quickAlert_presetWakeUpBeforeClass;

  /// Localized text for 'shell_loadingWorkspaceTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading workspace'**
  String get shell_loadingWorkspaceTitle;

  /// Localized text for 'shell_loadingWorkspaceMessage'.
  ///
  /// In en, this message translates to:
  /// **'Restoring your role and permissions...'**
  String get shell_loadingWorkspaceMessage;

  /// Localized text for 'shell_loadingScheduleTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading schedule'**
  String get shell_loadingScheduleTitle;

  /// Localized text for 'shell_loadingScheduleMessage'.
  ///
  /// In en, this message translates to:
  /// **'Preparing lessons and quick alerts...'**
  String get shell_loadingScheduleMessage;

  /// Localized text for 'shell_loadingProfileTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading profile'**
  String get shell_loadingProfileTitle;

  /// Localized text for 'shell_loadingProfileMessage'.
  ///
  /// In en, this message translates to:
  /// **'Preparing your student profile...'**
  String get shell_loadingProfileMessage;

  /// Localized text for 'studies_title'.
  ///
  /// In en, this message translates to:
  /// **'Study Hub'**
  String get studies_title;

  /// Localized text for 'studies_searchTitle'.
  ///
  /// In en, this message translates to:
  /// **'Study search'**
  String get studies_searchTitle;

  /// Localized text for 'studies_searchSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Study-wide search will expand beyond this static export in the next phase.'**
  String get studies_searchSubtitle;

  /// Localized text for 'studies_syncedLessons'.
  ///
  /// In en, this message translates to:
  /// **'{count} synced lessons'**
  String studies_syncedLessons(int count);

  /// Localized text for 'studies_materialsAvailable'.
  ///
  /// In en, this message translates to:
  /// **'{count} materials available'**
  String studies_materialsAvailable(int count);

  /// Localized text for 'studies_syncingLessons'.
  ///
  /// In en, this message translates to:
  /// **'Syncing lessons'**
  String get studies_syncingLessons;

  /// Localized text for 'studies_syncingMaterials'.
  ///
  /// In en, this message translates to:
  /// **'Syncing materials'**
  String get studies_syncingMaterials;

  /// Localized text for 'studies_modeToday'.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get studies_modeToday;

  /// Localized text for 'studies_modeStudy'.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studies_modeStudy;

  /// Localized text for 'studies_modeExams'.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get studies_modeExams;

  /// Localized text for 'studies_materials'.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get studies_materials;

  /// Localized text for 'studies_noLessonsAvailable'.
  ///
  /// In en, this message translates to:
  /// **'No lessons available'**
  String get studies_noLessonsAvailable;

  /// Localized text for 'studies_noLessonsAvailableSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Create a lesson before uploading materials.'**
  String get studies_noLessonsAvailableSubtitle;

  /// Localized text for 'studies_upload'.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get studies_upload;

  /// Localized text for 'studies_noMaterialsTeacherTitle'.
  ///
  /// In en, this message translates to:
  /// **'No materials uploaded yet'**
  String get studies_noMaterialsTeacherTitle;

  /// Localized text for 'studies_noMaterialsTeacherMessage'.
  ///
  /// In en, this message translates to:
  /// **'Upload the first lesson resource to populate Study Hub.'**
  String get studies_noMaterialsTeacherMessage;

  /// Localized text for 'studies_noMaterialsStudentTitle'.
  ///
  /// In en, this message translates to:
  /// **'No materials available yet'**
  String get studies_noMaterialsStudentTitle;

  /// Localized text for 'studies_noMaterialsStudentMessage'.
  ///
  /// In en, this message translates to:
  /// **'Materials shared by your teachers will appear here.'**
  String get studies_noMaterialsStudentMessage;

  /// Localized text for 'studies_materialsUnavailable'.
  ///
  /// In en, this message translates to:
  /// **'Materials are unavailable'**
  String get studies_materialsUnavailable;

  /// Localized text for 'studies_continueStudying'.
  ///
  /// In en, this message translates to:
  /// **'Continue studying'**
  String get studies_continueStudying;

  /// Localized text for 'studies_assignments'.
  ///
  /// In en, this message translates to:
  /// **'Assignments'**
  String get studies_assignments;

  /// Localized text for 'studies_seeAll'.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get studies_seeAll;

  /// Localized text for 'studies_overdue'.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get studies_overdue;

  /// Localized text for 'studies_inProgress'.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get studies_inProgress;

  /// Localized text for 'studies_dueInDays'.
  ///
  /// In en, this message translates to:
  /// **'Due in {count} days'**
  String studies_dueInDays(int count);

  /// Localized text for 'studies_subjects'.
  ///
  /// In en, this message translates to:
  /// **'Subjects'**
  String get studies_subjects;

  /// Localized text for 'studies_priorityToday'.
  ///
  /// In en, this message translates to:
  /// **'Priority for Today'**
  String get studies_priorityToday;

  /// Localized text for 'studies_continueWorking'.
  ///
  /// In en, this message translates to:
  /// **'Continue Working'**
  String get studies_continueWorking;

  /// Localized text for 'studies_todayClasses'.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Classes'**
  String get studies_todayClasses;

  /// Localized text for 'studies_upcomingExams'.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Exams'**
  String get studies_upcomingExams;

  /// Localized text for 'studies_midterm'.
  ///
  /// In en, this message translates to:
  /// **'Midterm'**
  String get studies_midterm;

  /// Localized text for 'studies_inDays'.
  ///
  /// In en, this message translates to:
  /// **'In {count} days'**
  String studies_inDays(int count);

  /// Localized text for 'studies_aiWeakTopicsReview'.
  ///
  /// In en, this message translates to:
  /// **'AI Weak Topics Review'**
  String get studies_aiWeakTopicsReview;

  /// Localized text for 'studies_invalidMaterialLink'.
  ///
  /// In en, this message translates to:
  /// **'Invalid material link'**
  String get studies_invalidMaterialLink;

  /// Localized text for 'studies_couldNotOpenMaterial'.
  ///
  /// In en, this message translates to:
  /// **'Could not open material'**
  String get studies_couldNotOpenMaterial;

  /// Localized text for 'studies_uploadFailed'.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get studies_uploadFailed;

  /// Localized text for 'studies_uploadFailedSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'The selected file could not be loaded.'**
  String get studies_uploadFailedSubtitle;

  /// Localized text for 'studies_materialIncomplete'.
  ///
  /// In en, this message translates to:
  /// **'Material details are incomplete'**
  String get studies_materialIncomplete;

  /// Localized text for 'studies_materialIncompleteSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Select a lesson, choose a file, and add a title.'**
  String get studies_materialIncompleteSubtitle;

  /// Localized text for 'studies_materialUploaded'.
  ///
  /// In en, this message translates to:
  /// **'Material uploaded'**
  String get studies_materialUploaded;

  /// Localized text for 'studies_uploadMaterial'.
  ///
  /// In en, this message translates to:
  /// **'Upload Material'**
  String get studies_uploadMaterial;

  /// Localized text for 'studies_materialTitle'.
  ///
  /// In en, this message translates to:
  /// **'Material title'**
  String get studies_materialTitle;

  /// Localized text for 'studies_selectLesson'.
  ///
  /// In en, this message translates to:
  /// **'Select lesson'**
  String get studies_selectLesson;

  /// Localized text for 'studies_chooseFile'.
  ///
  /// In en, this message translates to:
  /// **'Choose file'**
  String get studies_chooseFile;

  /// Localized text for 'studies_uploading'.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get studies_uploading;

  /// Localized text for 'studies_continueCardMathTitle'.
  ///
  /// In en, this message translates to:
  /// **'Advanced Math'**
  String get studies_continueCardMathTitle;

  /// Localized text for 'studies_continueCardMathSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'2 new notes • Review needed'**
  String get studies_continueCardMathSubtitle;

  /// Localized text for 'studies_continueCardPhysicsTitle'.
  ///
  /// In en, this message translates to:
  /// **'Physics'**
  String get studies_continueCardPhysicsTitle;

  /// Localized text for 'studies_continueCardPhysicsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'1 new file • Chapter 4'**
  String get studies_continueCardPhysicsSubtitle;

  /// Localized text for 'studies_continueCardProgrammingTitle'.
  ///
  /// In en, this message translates to:
  /// **'Programming'**
  String get studies_continueCardProgrammingTitle;

  /// Localized text for 'studies_continueCardProgrammingSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Lecture recording'**
  String get studies_continueCardProgrammingSubtitle;

  /// Localized text for 'studies_assignmentCalculusTitle'.
  ///
  /// In en, this message translates to:
  /// **'Calculus Assignment 3'**
  String get studies_assignmentCalculusTitle;

  /// Localized text for 'studies_assignmentCalculusSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mathematics'**
  String get studies_assignmentCalculusSubtitle;

  /// Localized text for 'studies_assignmentPythonTitle'.
  ///
  /// In en, this message translates to:
  /// **'Python Project'**
  String get studies_assignmentPythonTitle;

  /// Localized text for 'studies_assignmentPythonSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Web Programming'**
  String get studies_assignmentPythonSubtitle;

  /// Localized text for 'studies_subjectProgrammingFundamentals'.
  ///
  /// In en, this message translates to:
  /// **'Programming Fundamentals'**
  String get studies_subjectProgrammingFundamentals;

  /// Localized text for 'studies_subjectProfessorUrazimbetov'.
  ///
  /// In en, this message translates to:
  /// **'Prof. Urazimbetov M.'**
  String get studies_subjectProfessorUrazimbetov;

  /// Localized text for 'studies_subjectAiSummaryAvailable'.
  ///
  /// In en, this message translates to:
  /// **'AI summary available'**
  String get studies_subjectAiSummaryAvailable;

  /// Localized text for 'studies_subjectNextTomorrow0900'.
  ///
  /// In en, this message translates to:
  /// **'Next: Tomorrow 09:00'**
  String get studies_subjectNextTomorrow0900;

  /// Localized text for 'studies_subjectFiveMaterials'.
  ///
  /// In en, this message translates to:
  /// **'5 materials'**
  String get studies_subjectFiveMaterials;

  /// Localized text for 'studies_subjectTwoAssignments'.
  ///
  /// In en, this message translates to:
  /// **'2 assignments'**
  String get studies_subjectTwoAssignments;

  /// Localized text for 'studies_subjectDatabaseManagement'.
  ///
  /// In en, this message translates to:
  /// **'Database Management'**
  String get studies_subjectDatabaseManagement;

  /// Localized text for 'studies_subjectProfessorNurlan'.
  ///
  /// In en, this message translates to:
  /// **'Nurlan K.'**
  String get studies_subjectProfessorNurlan;

  /// Localized text for 'studies_subjectTwoWeakTopics'.
  ///
  /// In en, this message translates to:
  /// **'2 weak topics to review'**
  String get studies_subjectTwoWeakTopics;

  /// Localized text for 'studies_subjectNextToday1000'.
  ///
  /// In en, this message translates to:
  /// **'Next: Today 10:00'**
  String get studies_subjectNextToday1000;

  /// Localized text for 'studies_subjectThreeMaterials'.
  ///
  /// In en, this message translates to:
  /// **'3 materials'**
  String get studies_subjectThreeMaterials;

  /// Localized text for 'studies_subjectOneAssignment'.
  ///
  /// In en, this message translates to:
  /// **'1 assignment'**
  String get studies_subjectOneAssignment;

  /// Localized text for 'studies_priorityCalculusTitle'.
  ///
  /// In en, this message translates to:
  /// **'Calculus Assignment 3'**
  String get studies_priorityCalculusTitle;

  /// Localized text for 'studies_priorityCalculusSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Due tonight at 23:59. You have completed 60% of the tasks.'**
  String get studies_priorityCalculusSubtitle;

  /// Localized text for 'studies_priorityCalculusMeta'.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mathematics • Due tonight at 23:59'**
  String get studies_priorityCalculusMeta;

  /// Localized text for 'studies_todayClassWebProgrammingTitle'.
  ///
  /// In en, this message translates to:
  /// **'Web Programming'**
  String get studies_todayClassWebProgrammingTitle;

  /// Localized text for 'studies_todayClassWebProgrammingSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Tole bi №86 • Urazimbetov M.'**
  String get studies_todayClassWebProgrammingSubtitle;

  /// Localized text for 'studies_todayClassDatabaseManagementTitle'.
  ///
  /// In en, this message translates to:
  /// **'Database Management'**
  String get studies_todayClassDatabaseManagementTitle;

  /// Localized text for 'studies_todayClassDatabaseManagementSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Online • Nurlan K.'**
  String get studies_todayClassDatabaseManagementSubtitle;

  /// Localized text for 'studies_examAdvancedMathTitle'.
  ///
  /// In en, this message translates to:
  /// **'Advanced Mathematics'**
  String get studies_examAdvancedMathTitle;

  /// Localized text for 'studies_examCoverage'.
  ///
  /// In en, this message translates to:
  /// **'Covers Chapters 1-4. Bring calculator.'**
  String get studies_examCoverage;

  /// Localized text for 'studies_readyPercent'.
  ///
  /// In en, this message translates to:
  /// **'40% ready'**
  String get studies_readyPercent;

  /// Localized text for 'studies_weakTopicIntegralsTitle'.
  ///
  /// In en, this message translates to:
  /// **'Integrals'**
  String get studies_weakTopicIntegralsTitle;

  /// Localized text for 'studies_weakTopicIntegralsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Math • 3 mistakes'**
  String get studies_weakTopicIntegralsSubtitle;

  /// Localized text for 'studies_weakTopicSqlJoinsTitle'.
  ///
  /// In en, this message translates to:
  /// **'SQL Joins'**
  String get studies_weakTopicSqlJoinsTitle;

  /// Localized text for 'studies_weakTopicSqlJoinsSubtitle'.
  ///
  /// In en, this message translates to:
  /// **'Databases • 2 mistakes'**
  String get studies_weakTopicSqlJoinsSubtitle;

  /// Localized text for 'common_online'.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get common_online;

  /// Localized text for 'common_justNow'.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get common_justNow;

  /// Localized text for 'common_mondayShort'.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get common_mondayShort;

  /// Localized text for 'lesson_subjectPhysicsLab'.
  ///
  /// In en, this message translates to:
  /// **'Physics Lab'**
  String get lesson_subjectPhysicsLab;

  /// Localized text for 'lesson_subjectWebProgrammingPython'.
  ///
  /// In en, this message translates to:
  /// **'Web Programming and Python'**
  String get lesson_subjectWebProgrammingPython;

  /// Localized text for 'lesson_subjectAlgorithmsMathematics'.
  ///
  /// In en, this message translates to:
  /// **'Algorithms and Mathematics'**
  String get lesson_subjectAlgorithmsMathematics;

  /// Localized text for 'lesson_subjectDatabaseManagementSystems'.
  ///
  /// In en, this message translates to:
  /// **'Database Management Systems'**
  String get lesson_subjectDatabaseManagementSystems;

  /// Localized text for 'lesson_locationMainBuildingRoom201'.
  ///
  /// In en, this message translates to:
  /// **'Main Building, Room 201'**
  String get lesson_locationMainBuildingRoom201;

  /// Localized text for 'lesson_locationToleBi86'.
  ///
  /// In en, this message translates to:
  /// **'Tole bi №86'**
  String get lesson_locationToleBi86;

  /// Localized text for 'lesson_locationKazybekBi30'.
  ///
  /// In en, this message translates to:
  /// **'Kazybek bi №30'**
  String get lesson_locationKazybekBi30;

  /// Localized text for 'lesson_teacherProfessorIvanov'.
  ///
  /// In en, this message translates to:
  /// **'Prof. Ivanov'**
  String get lesson_teacherProfessorIvanov;

  /// Localized text for 'messages_senderUniversityAdmin'.
  ///
  /// In en, this message translates to:
  /// **'University Admin'**
  String get messages_senderUniversityAdmin;

  /// Localized text for 'messages_previewProjectMeeting'.
  ///
  /// In en, this message translates to:
  /// **'Hey, are we still meeting for the project?'**
  String get messages_previewProjectMeeting;

  /// Localized text for 'messages_previewThanksNotes'.
  ///
  /// In en, this message translates to:
  /// **'Thanks for the notes!'**
  String get messages_previewThanksNotes;

  /// Localized text for 'messages_previewScheduleUpdated'.
  ///
  /// In en, this message translates to:
  /// **'Your schedule has been updated.'**
  String get messages_previewScheduleUpdated;

  /// Localized text for 'profile_programSoftwareEngineering'.
  ///
  /// In en, this message translates to:
  /// **'Software Engineering'**
  String get profile_programSoftwareEngineering;

  /// Localized text for 'profile_programStudentSchedule'.
  ///
  /// In en, this message translates to:
  /// **'Student Schedule'**
  String get profile_programStudentSchedule;

  /// Localized text for 'profile_programTeachingStaff'.
  ///
  /// In en, this message translates to:
  /// **'Teaching Staff'**
  String get profile_programTeachingStaff;

  /// Localized text for 'profile_yearSecond'.
  ///
  /// In en, this message translates to:
  /// **'2nd Year'**
  String get profile_yearSecond;

  /// Localized text for 'profile_yearStudent'.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get profile_yearStudent;

  /// Localized text for 'profile_yearTeacher'.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get profile_yearTeacher;

  /// Localized text for 'profile_defaultBio'.
  ///
  /// In en, this message translates to:
  /// **'Passionate about Frontend, AI, and building things. Always up for a hackathon!'**
  String get profile_defaultBio;

  /// Localized text for 'profile_liveStudentBio'.
  ///
  /// In en, this message translates to:
  /// **'Student flow connected to live schedules, reminders, and shared materials.'**
  String get profile_liveStudentBio;

  /// Localized text for 'profile_liveTeacherBio'.
  ///
  /// In en, this message translates to:
  /// **'Teacher dashboard connected to your live classes and materials.'**
  String get profile_liveTeacherBio;

  /// Localized text for 'profile_liveSuperTeacherBio'.
  ///
  /// In en, this message translates to:
  /// **'Super teacher with full schedule management access.'**
  String get profile_liveSuperTeacherBio;

  /// Localized text for 'profile_groupNotAssigned'.
  ///
  /// In en, this message translates to:
  /// **'No group assigned'**
  String get profile_groupNotAssigned;

  /// Localized text for 'profile_coverTemplateCampus'.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get profile_coverTemplateCampus;

  /// Localized text for 'profile_coverTemplateLibrary'.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get profile_coverTemplateLibrary;

  /// Localized text for 'profile_coverTemplateGraduation'.
  ///
  /// In en, this message translates to:
  /// **'Graduation'**
  String get profile_coverTemplateGraduation;

  /// Localized text for 'profile_coverTemplateArchitecture'.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get profile_coverTemplateArchitecture;

  /// Localized text for 'profile_coverTemplateAbstractTech'.
  ///
  /// In en, this message translates to:
  /// **'Abstract Tech'**
  String get profile_coverTemplateAbstractTech;

  /// Localized text for 'profile_coverTemplateScience'.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get profile_coverTemplateScience;

  /// Localized text for 'services_requestMaintenancePrefix'.
  ///
  /// In en, this message translates to:
  /// **'Maintenance: {issueType}'**
  String services_requestMaintenancePrefix(String issueType);

  /// Localized text for 'services_requestSupportPrefix'.
  ///
  /// In en, this message translates to:
  /// **'Support: {subject}'**
  String services_requestSupportPrefix(String subject);

  /// Localized text for 'services_requestEnrollmentCertificate'.
  ///
  /// In en, this message translates to:
  /// **'Enrollment Certificate'**
  String get services_requestEnrollmentCertificate;

  /// Localized text for 'services_requestDormitoryRepair'.
  ///
  /// In en, this message translates to:
  /// **'Dormitory Repair'**
  String get services_requestDormitoryRepair;

  /// Localized text for 'services_requestTuitionFeePayment'.
  ///
  /// In en, this message translates to:
  /// **'Tuition Fee Payment'**
  String get services_requestTuitionFeePayment;

  /// Localized text for 'services_requestDescriptionVisaApplication'.
  ///
  /// In en, this message translates to:
  /// **'Requested for visa application.'**
  String get services_requestDescriptionVisaApplication;

  /// Localized text for 'services_requestDescriptionLeakingPipe'.
  ///
  /// In en, this message translates to:
  /// **'Leaking pipe in bathroom.'**
  String get services_requestDescriptionLeakingPipe;

  /// Localized text for 'services_requestDescriptionViaSynorServices'.
  ///
  /// In en, this message translates to:
  /// **'Requested via Synor Services.'**
  String get services_requestDescriptionViaSynorServices;

  /// Localized text for 'services_requestDescriptionPaymentSpring2026'.
  ///
  /// In en, this message translates to:
  /// **'Payment of 450,000 ₸ for Spring Semester 2026.'**
  String get services_requestDescriptionPaymentSpring2026;

  /// Localized text for 'services_requestDormitoryRoom412'.
  ///
  /// In en, this message translates to:
  /// **'Dormitory #3, Room 412. {description}'**
  String services_requestDormitoryRoom412(String description);

  /// Localized text for 'services_dateOct12'.
  ///
  /// In en, this message translates to:
  /// **'Oct 12'**
  String get services_dateOct12;

  /// Localized text for 'services_dateOct10'.
  ///
  /// In en, this message translates to:
  /// **'Oct 10'**
  String get services_dateOct10;

  /// Localized text for 'services_zeroBalanceAmount'.
  ///
  /// In en, this message translates to:
  /// **'0 ₸'**
  String get services_zeroBalanceAmount;

  /// Localized text for 'services_tuitionAmount'.
  ///
  /// In en, this message translates to:
  /// **'450,000 ₸'**
  String get services_tuitionAmount;

  /// Localized text for 'error_authenticatedUserRequired'.
  ///
  /// In en, this message translates to:
  /// **'An authenticated user is required.'**
  String get error_authenticatedUserRequired;

  /// Localized text for 'error_authenticatedProfileRequired'.
  ///
  /// In en, this message translates to:
  /// **'An authenticated user profile is required.'**
  String get error_authenticatedProfileRequired;

  /// Localized text for 'error_lessonIdRequired'.
  ///
  /// In en, this message translates to:
  /// **'Lesson ID is required for updates.'**
  String get error_lessonIdRequired;

  /// Localized text for 'error_lessonEditPermission'.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to edit this lesson.'**
  String get error_lessonEditPermission;

  /// Localized text for 'error_onlyTeachersManageLessons'.
  ///
  /// In en, this message translates to:
  /// **'Only teachers can manage lessons.'**
  String get error_onlyTeachersManageLessons;

  /// Localized text for 'error_onlyTeachersUploadMaterials'.
  ///
  /// In en, this message translates to:
  /// **'Only teachers can upload materials.'**
  String get error_onlyTeachersUploadMaterials;

  /// Localized text for 'error_onlyUploadManagedLessons'.
  ///
  /// In en, this message translates to:
  /// **'You can only upload materials for lessons you manage.'**
  String get error_onlyUploadManagedLessons;

  /// Localized text for 'error_missingSupabaseConfig'.
  ///
  /// In en, this message translates to:
  /// **'Missing Supabase configuration. Run the app with SUPABASE_URL and SUPABASE_ANON_KEY.'**
  String get error_missingSupabaseConfig;

  /// Localized text for 'async_loadingTitle'.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get async_loadingTitle;

  /// Localized text for 'async_loadingMessage'.
  ///
  /// In en, this message translates to:
  /// **'Preparing your data...'**
  String get async_loadingMessage;

  /// Localized text for 'async_errorTitle'.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get async_errorTitle;

  /// No description provided for @notifications_title.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications_title;

  /// No description provided for @notifications_markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notifications_markAllAsRead;

  /// No description provided for @notifications_empty.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get notifications_empty;

  /// No description provided for @alarm_repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get alarm_repeat;

  /// No description provided for @alarm_snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get alarm_snooze;

  /// No description provided for @alarm_label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get alarm_label;

  /// No description provided for @alarm_everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get alarm_everyDay;

  /// No description provided for @alarm_once.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get alarm_once;

  /// No description provided for @alarm_weekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get alarm_weekdays;

  /// No description provided for @alarm_weekends.
  ///
  /// In en, this message translates to:
  /// **'Weekends'**
  String get alarm_weekends;

  /// No description provided for @alarm_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete Alarm'**
  String get alarm_delete;

  /// No description provided for @alarm_save.
  ///
  /// In en, this message translates to:
  /// **'Save Alarm'**
  String get alarm_save;

  /// No description provided for @alarm_add.
  ///
  /// In en, this message translates to:
  /// **'Add Alarm'**
  String get alarm_add;

  /// No description provided for @alarm_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Alarm'**
  String get alarm_edit;
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
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
