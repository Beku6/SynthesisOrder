import 'package:flutter/foundation.dart';

@immutable
class Assignment {
  const Assignment({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.title,
    this.description,
    required this.deadline,
    required this.createdAt,
  });

  final int id;
  final int lessonId;
  final String lessonTitle;
  final String title;
  final String? description;
  final DateTime deadline;
  final DateTime createdAt;
}

@immutable
class Exam {
  const Exam({
    required this.id,
    required this.lessonId,
    required this.lessonTitle,
    required this.title,
    required this.examDate,
    required this.location,
    required this.type,
    required this.createdAt,
  });

  final int id;
  final int lessonId;
  final String lessonTitle;
  final String title;
  final DateTime examDate;
  final String location;
  final String type;
  final DateTime createdAt;
}
