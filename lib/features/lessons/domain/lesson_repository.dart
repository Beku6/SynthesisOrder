import '../../../shared/models/app_models.dart';

abstract class LessonRepository {
  Future<List<Lesson>> fetchLessons();

  Future<List<Lesson>> applyAlert({
    required int lessonId,
    required String alertLabel,
  });

  Future<List<Lesson>> removeAlert(int lessonId);
}
