import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/studies_models.dart';
import '../domain/studies_repository.dart';

class SupabaseStudiesRepository implements StudiesRepository {
  const SupabaseStudiesRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Assignment>> fetchAssignments() async {
    final rows = await _client
        .from('assignments')
        .select('id, lesson_id, title, description, deadline, created_at, lesson:lessons(subject)')
        .order('deadline', ascending: true);

    return rows.map((row) {
      final lesson = row['lesson'] as Map<String, dynamic>?;
      return Assignment(
        id: row['id'] as int,
        lessonId: row['lesson_id'] as int,
        lessonTitle: lesson?['subject'] as String? ?? 'Unknown Lesson',
        title: row['title'] as String,
        description: row['description'] as String?,
        deadline: DateTime.parse(row['deadline'] as String).toLocal(),
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      );
    }).toList();
  }

  @override
  Future<List<Exam>> fetchExams() async {
    final rows = await _client
        .from('exams')
        .select('id, lesson_id, title, exam_date, location, type, created_at, lesson:lessons(subject)')
        .order('exam_date', ascending: true);

    return rows.map((row) {
      final lesson = row['lesson'] as Map<String, dynamic>?;
      return Exam(
        id: row['id'] as int,
        lessonId: row['lesson_id'] as int,
        lessonTitle: lesson?['subject'] as String? ?? 'Unknown Lesson',
        title: row['title'] as String,
        examDate: DateTime.parse(row['exam_date'] as String).toLocal(),
        location: row['location'] as String,
        type: row['type'] as String,
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      );
    }).toList();
  }

  @override
  Future<void> createAssignment({
    required int lessonId,
    required String title,
    String? description,
    required DateTime deadline,
  }) async {
    await _client.from('assignments').insert({
      'lesson_id': lessonId,
      'title': title,
      'description': description,
      'deadline': deadline.toUtc().toIso8601String(),
    });
  }

  @override
  Future<void> deleteAssignment(int id) async {
    await _client.from('assignments').delete().eq('id', id);
  }
}
