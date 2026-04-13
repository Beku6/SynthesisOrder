import 'package:supabase_flutter/supabase_flutter.dart';

import '../../users/domain/user_models.dart';
import '../domain/material_models.dart';
import '../domain/material_repository.dart';

class SupabaseMaterialRepository implements MaterialRepository {
  SupabaseMaterialRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<LessonMaterial>> fetchMaterialsForUser(SynorUser user) async {
    final rows = await _client
        .from('materials')
        .select(
          'id,lesson_id,title,file_url,created_at,lesson:lessons(subject,teacher_id,group_id)',
        )
        .order('created_at', ascending: false);

    return rows
        .where((row) => _canAccessRow(user, row))
        .map<LessonMaterial>(_mapMaterial)
        .toList();
  }

  @override
  Future<LessonMaterial> uploadMaterial({
    required SynorUser actor,
    required MaterialUploadDraft draft,
  }) async {
    if (!actor.canManageLessons) {
      throw StateError('Only teachers can upload materials.');
    }

    final lesson = await _client
        .from('lessons')
        .select('id,subject,teacher_id')
        .eq('id', draft.lessonId)
        .single();
    final teacherId = lesson['teacher_id'] as String;
    if (!actor.canManageTeacherId(teacherId)) {
      throw StateError('You can only upload materials for lessons you manage.');
    }

    final safeName = draft.fileName.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final storagePath =
        '${actor.id}/${DateTime.now().millisecondsSinceEpoch}_$safeName';
    await _client.storage
        .from('materials')
        .uploadBinary(
          storagePath,
          draft.bytes,
          fileOptions: const FileOptions(upsert: true),
        );
    final publicUrl = _client.storage
        .from('materials')
        .getPublicUrl(storagePath);

    final row = await _client
        .from('materials')
        .insert({
          'lesson_id': draft.lessonId,
          'title': draft.title.trim(),
          'file_url': publicUrl,
        })
        .select(
          'id,lesson_id,title,file_url,created_at,lesson:lessons(subject,teacher_id,group_id)',
        )
        .single();

    return _mapMaterial(row);
  }

  bool _canAccessRow(SynorUser user, Map<String, dynamic> row) {
    final lesson = row['lesson'];
    if (lesson is! Map<String, dynamic>) {
      return false;
    }

    if (user.isSuper) {
      return true;
    }

    if (user.isStudent) {
      return lesson['group_id'] == user.groupId;
    }

    return lesson['teacher_id'] == user.id;
  }

  LessonMaterial _mapMaterial(Map<String, dynamic> row) {
    final lesson = row['lesson'] as Map<String, dynamic>? ?? const {};
    return LessonMaterial(
      id: row['id'] as int,
      lessonId: row['lesson_id'] as int,
      title: row['title'] as String,
      fileUrl: row['file_url'] as String,
      lessonTitle: lesson['subject'] as String? ?? 'Material',
      createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
    );
  }
}
