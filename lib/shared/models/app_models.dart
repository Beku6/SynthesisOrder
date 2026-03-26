import 'dart:typed_data';

import 'package:flutter/material.dart';

enum AuthStage { onboarding, signIn, signUp, main }

enum ShellTab { home, schedule, studies, services, profile }

enum ScheduleMode { day, week, month }

enum StudyMode { today, study, exams }

enum AlarmMode { personal, academic }

enum ServiceView { main, documents, payments, housing, support, allRequests }

enum LessonColorVariant { rose, emerald, indigo }

enum RequestStatus { ready, inProgress, pending, processing, open }

enum RequestType { document, housing, payment, support }

@immutable
class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.teacher,
    required this.countdown,
    required this.colorVariant,
    this.alertLabel,
  });

  final int id;
  final String title;
  final String time;
  final String location;
  final String teacher;
  final String countdown;
  final LessonColorVariant colorVariant;
  final String? alertLabel;

  bool get isStarted => countdown == '00:00:00' || countdown.startsWith('-');
  bool get isNear =>
      !isStarted &&
      (countdown.startsWith('00:') || countdown.startsWith('01:'));

  Lesson copyWith({
    String? countdown,
    String? alertLabel,
    bool clearAlert = false,
  }) {
    return Lesson(
      id: id,
      title: title,
      time: time,
      location: location,
      teacher: teacher,
      countdown: countdown ?? this.countdown,
      colorVariant: colorVariant,
      alertLabel: clearAlert ? null : (alertLabel ?? this.alertLabel),
    );
  }
}

@immutable
class StoryItem {
  const StoryItem({
    required this.name,
    required this.borderColor,
    this.avatarAsset,
    this.icon,
    this.isAddStory = false,
  });

  final String name;
  final Color borderColor;
  final String? avatarAsset;
  final IconData? icon;
  final bool isAddStory;
}

@immutable
class ServiceCategoryData {
  const ServiceCategoryData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final ServiceView id;
  final String title;
  final String subtitle;
  final Color color;
}

@immutable
class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.title,
    required this.date,
    required this.status,
    required this.type,
    required this.description,
  });

  final int id;
  final String title;
  final String date;
  final RequestStatus status;
  final RequestType type;
  final String description;
}

@immutable
class CoverTemplate {
  const CoverTemplate({required this.title, required this.assetPath});

  final String title;
  final String assetPath;
}

@immutable
class MessagePreview {
  const MessagePreview({
    required this.name,
    required this.preview,
    required this.timestamp,
    this.avatarAsset,
    this.fallbackIcon,
  });

  final String name;
  final String preview;
  final String timestamp;
  final String? avatarAsset;
  final IconData? fallbackIcon;
}

@immutable
class ProfileData {
  const ProfileData({
    required this.name,
    required this.username,
    required this.university,
    required this.bio,
    required this.program,
    required this.yearLabel,
    required this.groupLabel,
    required this.coverAsset,
    required this.avatarAsset,
    this.customCoverBytes,
  });

  final String name;
  final String username;
  final String university;
  final String bio;
  final String program;
  final String yearLabel;
  final String groupLabel;
  final String coverAsset;
  final String avatarAsset;
  final Uint8List? customCoverBytes;

  ProfileData copyWith({
    String? coverAsset,
    Uint8List? customCoverBytes,
    bool clearCustomCover = false,
  }) {
    return ProfileData(
      name: name,
      username: username,
      university: university,
      bio: bio,
      program: program,
      yearLabel: yearLabel,
      groupLabel: groupLabel,
      coverAsset: coverAsset ?? this.coverAsset,
      avatarAsset: avatarAsset,
      customCoverBytes: clearCustomCover
          ? null
          : (customCoverBytes ?? this.customCoverBytes),
    );
  }
}
