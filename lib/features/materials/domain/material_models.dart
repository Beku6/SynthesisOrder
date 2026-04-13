import 'package:flutter/foundation.dart';

@immutable
class LessonMaterial {
  const LessonMaterial({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.fileUrl,
    required this.lessonTitle,
    required this.createdAt,
  });

  final int id;
  final int lessonId;
  final String title;
  final String fileUrl;
  final String lessonTitle;
  final DateTime createdAt;
}

@immutable
class MaterialUploadDraft {
  const MaterialUploadDraft({
    required this.lessonId,
    required this.title,
    required this.fileName,
    required this.bytes,
  });

  final int lessonId;
  final String title;
  final String fileName;
  final Uint8List bytes;
}
