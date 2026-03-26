import '../../../shared/data/mock_data.dart';
import '../../../shared/data/mock_latency.dart';
import '../../../shared/models/app_models.dart';
import '../domain/lesson_repository.dart';

class InMemoryLessonRepository implements LessonRepository {
  List<Lesson> _lessons = SynorMockData.lessons();

  @override
  Future<List<Lesson>> applyAlert({
    required int lessonId,
    required String alertLabel,
  }) async {
    _lessons = _lessons
        .map(
          (lesson) => lesson.id == lessonId
              ? lesson.copyWith(alertLabel: alertLabel)
              : lesson,
        )
        .toList();
    return _lessons;
  }

  @override
  Future<List<Lesson>> fetchLessons() async =>
      SynorMockLatency.resolve(_lessons, duration: SynorMockLatency.shell);

  @override
  Future<List<Lesson>> removeAlert(int lessonId) async {
    _lessons = _lessons
        .map(
          (lesson) => lesson.id == lessonId
              ? lesson.copyWith(clearAlert: true)
              : lesson,
        )
        .toList();
    return _lessons;
  }
}
