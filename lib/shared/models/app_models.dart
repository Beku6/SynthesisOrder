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
    required this.location,
    required this.teacher,
    required this.colorVariant,
    this.time,
    this.countdown,
    this.startTime,
    this.endTime,
    this.teacherId,
    this.groupId,
    this.groupName,
    this.alertLabel,
  });

  final int id;
  final String title;
  final String location;
  final String teacher;
  final LessonColorVariant colorVariant;
  final String? time;
  final String? countdown;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? teacherId;
  final int? groupId;
  final String? groupName;
  final String? alertLabel;

  String get resolvedTime {
    if (time != null && time!.isNotEmpty) {
      return time!;
    }
    if (startTime != null && endTime != null) {
      return '${_formatClock(startTime!)}-${_formatClock(endTime!)}';
    }
    return '--:--';
  }

  String get resolvedCountdown {
    if (countdown != null && countdown!.isNotEmpty) {
      return countdown!;
    }
    
    final now = DateTime.now();
    
    if (startTime == null) {
      return '--:--:--';
    }

    // Determine target for countdown
    DateTime target;
    if (now.isBefore(startTime!)) {
      target = startTime!;
    } else if (endTime != null && now.isBefore(endTime!)) {
      target = endTime!;
    } else if (endTime != null && now.isAfter(endTime!)) {
      return '00:00:00';
    } else {
      target = startTime!;
    }

    final difference = target.difference(now);
    final prefix = difference.isNegative ? '-' : '';
    final totalSeconds = difference.inSeconds.abs();
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$prefix$hours:$minutes:$seconds';
  }

  bool get isOngoing => 
      startTime != null && 
      endTime != null && 
      DateTime.now().isAfter(startTime!) && 
      DateTime.now().isBefore(endTime!);

  bool get isFinished => 
      endTime != null && DateTime.now().isAfter(endTime!);

  bool get isStarted =>
      (startTime != null && DateTime.now().isAfter(startTime!)) || 
      resolvedCountdown == '00:00:00' || 
      resolvedCountdown.startsWith('-');

  bool get isNear =>
      !isStarted &&
      (resolvedCountdown.startsWith('00:') ||
          resolvedCountdown.startsWith('01:'));

  Lesson copyWith({
    String? time,
    String? countdown,
    DateTime? startTime,
    DateTime? endTime,
    String? teacherId,
    int? groupId,
    String? groupName,
    String? alertLabel,
    bool clearAlert = false,
  }) {
    return Lesson(
      id: id,
      title: title,
      time: time ?? this.time,
      location: location,
      teacher: teacher,
      countdown: countdown ?? this.countdown,
      colorVariant: colorVariant,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      teacherId: teacherId ?? this.teacherId,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      alertLabel: clearAlert ? null : (alertLabel ?? this.alertLabel),
    );
  }

  String _formatClock(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

enum StoryMediaType { image, video }

@immutable
class StoryMedia {
  const StoryMedia({
    required this.id,
    required this.url,
    required this.type,
    this.duration = const Duration(seconds: 5),
    this.caption,
  });

  final String id;
  final String url;
  final StoryMediaType type;
  final Duration duration;
  final String? caption;
}

@immutable
class StoryItem {
  const StoryItem({
    required this.userId,
    required this.name,
    required this.borderColor,
    this.avatarAsset,
    this.icon,
    this.isAddStory = false,
    this.stories = const [],
    this.hasUnviewed = true,
  });

  final String userId;
  final String name;
  final Color borderColor;
  final String? avatarAsset;
  final IconData? icon;
  final bool isAddStory;
  final List<StoryMedia> stories;
  final bool hasUnviewed;
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
    this.room,
    this.teacherName,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String date;
  final RequestStatus status;
  final RequestType type;
  final String? description;
  final String? room;
  final String? teacherName;
  final String? imageUrl;
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
    required this.roomId,
    required this.name,
    required this.preview,
    required this.timestamp,
    this.avatarAsset,
    this.fallbackIcon,
  });

  final String roomId;
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
    this.university,
    this.bio,
    this.program,
    this.yearLabel,
    required this.groupLabel,
    required this.coverAsset,
    required this.avatarAsset,
    this.customCoverBytes,
    this.gpa,
  });

  final String name;
  final String username;
  final String? university;
  final String? bio;
  final String? program;
  final String? yearLabel;
  final String groupLabel;
  final String coverAsset;
  final String avatarAsset;
  final Uint8List? customCoverBytes;
  final double? gpa;

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
      gpa: gpa,
    );
  }
}
