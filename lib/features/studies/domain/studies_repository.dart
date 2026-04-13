import 'package:synor/features/studies/domain/studies_models.dart';

abstract class StudiesRepository {
  Future<List<Assignment>> fetchAssignments();
  Future<List<Exam>> fetchExams();

  Future<void> createAssignment({
    required int lessonId,
    required String title,
    String? description,
    required DateTime deadline,
  });

  Future<void> deleteAssignment(int id);
}
