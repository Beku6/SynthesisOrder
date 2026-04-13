import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../features/users/domain/user_models.dart';
import '../shared/models/app_models.dart';
import 'app_localizations.dart';

extension SynorAppLocalizationsX on AppLocalizations {
  String scheduleModeLabel(ScheduleMode mode) {
    return switch (mode) {
      ScheduleMode.day => schedule_modeDay,
      ScheduleMode.week => schedule_modeWeek,
      ScheduleMode.month => schedule_modeMonth,
    };
  }

  String studyModeLabel(StudyMode mode) {
    return switch (mode) {
      StudyMode.today => studies_modeToday,
      StudyMode.study => studies_modeStudy,
      StudyMode.exams => studies_modeExams,
    };
  }

  String alarmModeLabel(AlarmMode mode) {
    return switch (mode) {
      AlarmMode.personal => alarm_modePersonal,
      AlarmMode.academic => alarm_modeAcademic,
    };
  }

  String homeFilterLabel(String filterId) {
    return switch (filterId) {
      'lessons' => home_filterLessons,
      'all' => home_filterAll,
      'missed' => home_filterMissed,
      'tomorrow' => home_filterTomorrow,
      _ => filterId,
    };
  }

  String roleLabel(UserRole role, {bool isSuper = false}) {
    return switch (role) {
      UserRole.student => auth_roleStudent,
      UserRole.teacher => isSuper ? teacher_superTeacher : auth_roleTeacher,
    };
  }

  String requestStatusLabel(RequestStatus status) {
    return switch (status) {
      RequestStatus.ready => request_statusReady,
      RequestStatus.pending => request_statusPending,
      RequestStatus.processing => request_statusProcessing,
      RequestStatus.open => request_statusOpen,
      RequestStatus.inProgress => request_statusInProgress,
    };
  }

  String serviceTitle(ServiceView view) {
    return switch (view) {
      ServiceView.documents => services_documents,
      ServiceView.payments => services_payments,
      ServiceView.housing => services_housing,
      ServiceView.support => services_support,
      ServiceView.allRequests => services_allRequests,
      ServiceView.main => services_title,
    };
  }

  String serviceSubtitle(ServiceView view) {
    return switch (view) {
      ServiceView.documents => services_documentsSubtitle,
      ServiceView.payments => services_paymentsSubtitle,
      ServiceView.housing => services_housingSubtitle,
      ServiceView.support => services_supportSubtitle,
      ServiceView.main || ServiceView.allRequests => '',
    };
  }

  String housingIssueTypeLabel(String issueType) {
    return switch (issueType) {
      'services.issue.plumbing' || 'Plumbing' => services_issueTypePlumbing,
      'services.issue.electrical' ||
      'Electrical' => services_issueTypeElectrical,
      'services.issue.furniture' || 'Furniture' => services_issueTypeFurniture,
      'services.issue.other' || 'Other' => services_issueTypeOther,
      _ => issueType,
    };
  }

  String alarmAcademicTypeLabel(String type) {
    return switch (type) {
      'alarm.type.wakeUp' || 'Wake up' => alarm_typeWakeUp,
      'alarm.type.examPrep' || 'Exam prep' => alarm_typeExamPrep,
      'alarm.type.assignment' || 'Assignment' => alarm_typeAssignment,
      'alarm.type.lecture' || 'Lecture' => alarm_typeLecture,
      _ => type,
    };
  }

  String quickAlertPresetLabel(String label) {
    return switch (label) {
      'quickAlert.preset.5Min' || '5 min before' => quickAlert_preset5Min,
      'quickAlert.preset.10Min' || '10 min before' => quickAlert_preset10Min,
      'quickAlert.preset.20Min' || '20 min before' => quickAlert_preset20Min,
      'quickAlert.preset.30Min' || '30 min before' => quickAlert_preset30Min,
      'quickAlert.preset.1Hour' || '1 hour before' => quickAlert_preset1Hour,
      'quickAlert.preset.leaveOnTime' ||
      'Leave on time' => quickAlert_presetLeaveOnTime,
      'quickAlert.preset.wakeUpBeforeClass' ||
      'Wake up before class' => quickAlert_presetWakeUpBeforeClass,
      'quickAlert.preset.custom45Min' ||
      '45 min before' => quickAlert_customPreset,
      _ => label,
    };
  }

  String campusLabel(String campusId) {
    return switch (campusId) {
      'campus.main' || 'Main Building' => auth_campusMainBuilding,
      'campus.south' || 'South Campus' => auth_campusSouthCampus,
      'campus.remote' || 'Remote Study' => auth_campusRemoteStudy,
      _ => campusId,
    };
  }

  String localeLabel(Locale locale) {
    return switch (locale.languageCode) {
      'ru' => common_languageRussian,
      'kk' => common_languageKazakh,
      _ => common_languageEnglish,
    };
  }

  String lessonTitleLabel(String title) {
    return switch (title) {
      'lesson.physicsLab' || 'Physics Lab' => lesson_subjectPhysicsLab,
      'lesson.webProgrammingPython' ||
      'Web Programming and Python' => lesson_subjectWebProgrammingPython,
      'lesson.algorithmsMathematics' ||
      'Algoritm and Matemathics' => lesson_subjectAlgorithmsMathematics,
      'lesson.databaseManagementSystems' ||
      'Database Management Systems' => lesson_subjectDatabaseManagementSystems,
      _ => title,
    };
  }

  String lessonLocationLabel(String location) {
    return switch (location) {
      'location.mainBuildingRoom201' ||
      'Main Building, Room 201' => lesson_locationMainBuildingRoom201,
      'location.toleBi86' ||
      'Tole bi №86' ||
      'Tole bi в„–86' => lesson_locationToleBi86,
      'location.kazybekBi30' ||
      'Kazybek bi №30' ||
      'Kazybek bi в„–30' => lesson_locationKazybekBi30,
      'location.online' || 'Online' => common_online,
      _ => location,
    };
  }

  String lessonTeacherLabel(String teacher) {
    return switch (teacher) {
      'teacher.ivanov' || 'Prof. Ivanov' => lesson_teacherProfessorIvanov,
      _ => teacher,
    };
  }

  String messageNameLabel(String name) {
    return switch (name) {
      'message.sender.universityAdmin' ||
      'University Admin' => messages_senderUniversityAdmin,
      _ => name,
    };
  }

  String messagePreviewLabel(String preview) {
    return switch (preview) {
      'message.preview.projectMeeting' ||
      'Hey, are we still meeting for the project?' =>
        messages_previewProjectMeeting,
      'message.preview.thanksNotes' ||
      'Thanks for the notes!' => messages_previewThanksNotes,
      'message.preview.scheduleUpdated' ||
      'Your schedule has been updated.' => messages_previewScheduleUpdated,
      _ => preview,
    };
  }

  String messageTimestampLabel(String timestamp) {
    return switch (timestamp) {
      'message.time.yesterday' || 'Yesterday' => profile_yesterday,
      'message.time.monday' || 'Mon' => common_mondayShort,
      'message.time.1042' || '10:42 AM' => '10:42',
      _ => timestamp,
    };
  }

  String profileProgramLabel(String value) {
    return switch (value) {
      'profile.program.softwareEngineering' ||
      'Software Engineering' => profile_programSoftwareEngineering,
      'profile.program.studentSchedule' ||
      'Student Schedule' => profile_programStudentSchedule,
      'profile.program.teachingStaff' ||
      'Teaching Staff' => profile_programTeachingStaff,
      _ => value,
    };
  }

  String profileYearLabel(String value) {
    return switch (value) {
      'profile.year.second' || '2nd Year' => profile_yearSecond,
      'profile.year.student' || 'Student' => profile_yearStudent,
      'profile.year.teacher' || 'Teacher' => profile_yearTeacher,
      'profile.year.superTeacher' || 'Super Teacher' => teacher_superTeacher,
      _ => value,
    };
  }

  String profileBioLabel(String value) {
    return switch (value) {
      'profile.bio.default' ||
      'Passionate about Frontend, AI, and building things. Always up for a hackathon!' =>
        profile_defaultBio,
      'profile.bio.liveStudent' ||
      'Student flow connected to live schedules, reminders, and shared materials.' =>
        profile_liveStudentBio,
      'profile.bio.liveTeacher' ||
      'Teacher dashboard connected to your live classes and materials.' =>
        profile_liveTeacherBio,
      'profile.bio.liveSuperTeacher' ||
      'Super teacher with full schedule management access.' =>
        profile_liveSuperTeacherBio,
      _ => value,
    };
  }

  String profileGroupLabel(String value) {
    return switch (value) {
      'profile.group.notAssigned' ||
      'No group assigned' => profile_groupNotAssigned,
      _ => value,
    };
  }

  String coverTemplateTitleLabel(String value) {
    return switch (value) {
      'cover.campus' || 'Campus' => profile_coverTemplateCampus,
      'cover.library' || 'Library' => profile_coverTemplateLibrary,
      'cover.graduation' || 'Graduation' => profile_coverTemplateGraduation,
      'cover.architecture' ||
      'Architecture' => profile_coverTemplateArchitecture,
      'cover.abstractTech' ||
      'Abstract Tech' => profile_coverTemplateAbstractTech,
      'cover.science' || 'Science' => profile_coverTemplateScience,
      _ => value,
    };
  }

  String serviceRequestTitleLabel(String value) {
    if (value.startsWith('request.maintenance:')) {
      final issueType = value.replaceFirst('request.maintenance:', '');
      return services_requestMaintenancePrefix(
        housingIssueTypeLabel(issueType),
      );
    }
    if (value.startsWith('Maintenance: ')) {
      final issueType = value.replaceFirst('Maintenance: ', '');
      return services_requestMaintenancePrefix(
        housingIssueTypeLabel(issueType),
      );
    }
    if (value.startsWith('request.support:')) {
      final subject = value.replaceFirst('request.support:', '');
      return services_requestSupportPrefix(subject);
    }
    if (value.startsWith('Support: ')) {
      final subject = value.replaceFirst('Support: ', '');
      return services_requestSupportPrefix(subject);
    }
    return switch (value) {
      'request.enrollmentCertificate' ||
      'Enrollment Certificate' => services_requestEnrollmentCertificate,
      'request.officialTranscript' ||
      'Official Transcript' => services_documentOfficialTranscript,
      'request.militaryDeferment' ||
      'Military Deferment' => services_documentMilitaryDeferment,
      'request.dormitoryRepair' ||
      'Dormitory Repair' => services_requestDormitoryRepair,
      'request.tuitionFeePayment' ||
      'Tuition Fee Payment' => services_requestTuitionFeePayment,
      _ => value,
    };
  }

  String serviceRequestDescriptionLabel(String value) {
    if (value.startsWith('request.dormitoryRoom412:')) {
      final description = value.replaceFirst('request.dormitoryRoom412:', '');
      return services_requestDormitoryRoom412(description);
    }
    if (value.startsWith('Dormitory #3, Room 412. ')) {
      final description = value.replaceFirst('Dormitory #3, Room 412. ', '');
      return services_requestDormitoryRoom412(description);
    }
    return switch (value) {
      'request.description.visaApplication' ||
      'Requested for visa application.' =>
        services_requestDescriptionVisaApplication,
      'request.description.leakingPipe' ||
      'Leaking pipe in bathroom.' => services_requestDescriptionLeakingPipe,
      'request.description.viaSynorServices' ||
      'Requested via Synor Services.' =>
        services_requestDescriptionViaSynorServices,
      'request.description.paymentSpring2026' ||
      'Payment of 450,000 ₸ for Spring Semester 2026.' =>
        services_requestDescriptionPaymentSpring2026,
      'Payment of 450,000 в‚ё for Spring Semester 2026.' =>
        services_requestDescriptionPaymentSpring2026,
      'Payment of 450,000 РІвЂљС‘ for Spring Semester 2026.' =>
        services_requestDescriptionPaymentSpring2026,
      _ => value,
    };
  }

  String serviceRequestDateLabel(String value) {
    return switch (value) {
      'date.oct12' || 'Oct 12' => services_dateOct12,
      'date.oct10' || 'Oct 10' => services_dateOct10,
      'date.justNow' || 'Just now' => common_justNow,
      _ => value,
    };
  }

  String appErrorLabel(String value) {
    final normalized = value.replaceFirst('Bad state: ', '').trim();
    return switch (normalized) {
      'An authenticated user is required.' => error_authenticatedUserRequired,
      'An authenticated user profile is required.' =>
        error_authenticatedProfileRequired,
      'Lesson id is required for updates.' => error_lessonIdRequired,
      'You do not have permission to edit this lesson.' =>
        error_lessonEditPermission,
      'Only teachers can manage lessons.' => error_onlyTeachersManageLessons,
      'Only teachers can upload materials.' =>
        error_onlyTeachersUploadMaterials,
      'You can only upload materials for lessons you manage.' =>
        error_onlyUploadManagedLessons,
      'Missing SUPABASE_URL and SUPABASE_ANON_KEY. Run with --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...' =>
        error_missingSupabaseConfig,
      _ => value,
    };
  }
}

String synorLocaleTag(BuildContext context) {
  final locale = Localizations.localeOf(context);
  return locale.countryCode == null || locale.countryCode!.isEmpty
      ? locale.languageCode
      : locale.toLanguageTag();
}

String synorWeekdayShort(BuildContext context, DateTime value) {
  return DateFormat('EEE', synorLocaleTag(context)).format(value);
}

String synorWeekdayLong(BuildContext context, DateTime value) {
  return DateFormat('EEEE', synorLocaleTag(context)).format(value);
}

String synorMonthShort(BuildContext context, DateTime value) {
  return DateFormat('MMM', synorLocaleTag(context)).format(value);
}

String synorMonthLong(BuildContext context, DateTime value) {
  return DateFormat('MMMM', synorLocaleTag(context)).format(value);
}

String synorNumericDate(BuildContext context, DateTime value) {
  return DateFormat('dd.MM.yyyy', synorLocaleTag(context)).format(value);
}

String synorClock(BuildContext context, DateTime value) {
  return DateFormat('HH:mm', synorLocaleTag(context)).format(value);
}
