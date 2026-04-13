import '../../users/domain/user_models.dart';
import '../../../shared/models/app_models.dart';

class LessonMutation {
  const LessonMutation({
    this.lessonId,
    required this.subject,
    required this.groupId,
    required this.startTime,
    required this.endTime,
    required this.room,
    this.teacherId,
  });

  final int? lessonId;
  final String subject;
  final int groupId;
  final DateTime startTime;
  final DateTime endTime;
  final String room;
  final String? teacherId;
}

abstract class LessonRepository {
  Future<List<Lesson>> fetchLessonsForUser(SynorUser user);

  Future<List<Lesson>> applyAlert({
    required int lessonId,
    required String alertLabel,
  });

  Future<List<Lesson>> removeAlert(int lessonId);

  Future<Lesson> createLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  });

  Future<Lesson> updateLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  });
}
