import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/models/app_models.dart';
import '../../users/domain/user_models.dart';
import '../domain/lesson_repository.dart';

class SupabaseLessonRepository implements LessonRepository {
  SupabaseLessonRepository(this._client, this._preferences);

  final SupabaseClient _client;
  final SharedPreferences _preferences;

  static const _alertStorageKey = 'lessons.alert_labels';

  SynorUser? _lastScopeUser;

  @override
  Future<List<Lesson>> fetchLessonsForUser(SynorUser user) async {
    _lastScopeUser = user;
    final rows = await _fetchLessonRows(user);
    final alerts = _readAlerts();
    return rows.map((row) => _mapLesson(row, alerts)).toList();
  }

  @override
  Future<List<Lesson>> applyAlert({
    required int lessonId,
    required String alertLabel,
  }) async {
    final alerts = _readAlerts();
    alerts['$lessonId'] = alertLabel;
    await _saveAlerts(alerts);
    final currentUser = _lastScopeUser;
    if (currentUser == null) {
      return [];
    }
    return fetchLessonsForUser(currentUser);
  }

  @override
  Future<List<Lesson>> removeAlert(int lessonId) async {
    final alerts = _readAlerts();
    alerts.remove('$lessonId');
    await _saveAlerts(alerts);
    final currentUser = _lastScopeUser;
    if (currentUser == null) {
      return [];
    }
    return fetchLessonsForUser(currentUser);
  }

  @override
  Future<Lesson> createLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  }) async {
    _assertCanManage(actor);
    final row = await _client
        .from('lessons')
        .insert(_buildMutationPayload(actor: actor, mutation: mutation))
        .select(_lessonSelect)
        .single();
    return _mapLesson(row, _readAlerts());
  }

  @override
  Future<Lesson> updateLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  }) async {
    _assertCanManage(actor);
    final lessonId = mutation.lessonId;
    if (lessonId == null) {
      throw StateError('Lesson id is required for updates.');
    }

    final existing = await _client
        .from('lessons')
        .select('teacher_id')
        .eq('id', lessonId)
        .single();
    final ownerId = existing['teacher_id'] as String;
    if (!actor.canManageTeacherId(ownerId)) {
      throw StateError('You do not have permission to edit this lesson.');
    }

    final row = await _client
        .from('lessons')
        .update(_buildMutationPayload(actor: actor, mutation: mutation))
        .eq('id', lessonId)
        .select(_lessonSelect)
        .single();
    return _mapLesson(row, _readAlerts());
  }

  Future<List<dynamic>> _fetchLessonRows(SynorUser user) {
    final query = _client.from('lessons').select(_lessonSelect);
    if (user.isSuper) {
      return query.order('start_time');
    }
    if (user.isStudent) {
      final groupId = user.groupId;
      if (groupId == null) {
        return Future.value(const <dynamic>[]);
      }
      return query.eq('group_id', groupId).order('start_time');
    }
    return query.eq('teacher_id', user.id).order('start_time');
  }

  void _assertCanManage(SynorUser actor) {
    if (!actor.canManageLessons) {
      throw StateError('Only teachers can manage lessons.');
    }
  }

  Map<String, dynamic> _buildMutationPayload({
    required SynorUser actor,
    required LessonMutation mutation,
  }) {
    return {
      'subject': mutation.subject.trim(),
      'teacher_id': actor.isSuper ? (mutation.teacherId ?? actor.id) : actor.id,
      'group_id': mutation.groupId,
      'start_time': mutation.startTime.toUtc().toIso8601String(),
      'end_time': mutation.endTime.toUtc().toIso8601String(),
      'room': mutation.room.trim(),
    };
  }

  Lesson _mapLesson(Map<String, dynamic> row, Map<String, String> alerts) {
    final start = DateTime.parse(row['start_time'] as String).toLocal();
    final end = DateTime.parse(row['end_time'] as String).toLocal();
    final teacher = row['teacher'];
    final group = row['group'];
    final lessonId = row['id'] as int;
    return Lesson(
      id: lessonId,
      title: row['subject'] as String,
      location: row['room'] as String,
      teacher: teacher is Map<String, dynamic>
          ? (teacher['name'] as String? ?? 'Teacher')
          : 'Teacher',
      colorVariant: LessonColorVariant
          .values[lessonId % LessonColorVariant.values.length],
      startTime: start,
      endTime: end,
      teacherId: row['teacher_id'] as String,
      groupId: row['group_id'] as int?,
      groupName: group is Map<String, dynamic>
          ? group['name'] as String?
          : null,
      alertLabel: alerts['$lessonId'],
    );
  }

  Map<String, String> _readAlerts() {
    final raw = _preferences.getString(_alertStorageKey);
    if (raw == null || raw.isEmpty) {
      return <String, String>{};
    }
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, value as String));
  }

  Future<void> _saveAlerts(Map<String, String> alerts) {
    return _preferences.setString(_alertStorageKey, jsonEncode(alerts));
  }

  static const _lessonSelect =
      'id,subject,teacher_id,group_id,start_time,end_time,room,teacher:users!lessons_teacher_id_fkey(name),group:groups(name)';
}
