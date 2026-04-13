import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/user_models.dart';
import '../domain/user_repository.dart';

class SupabaseUserRepository implements UserRepository {
  SupabaseUserRepository({required SupabaseClient client}) : _client = client;

  final SupabaseClient _client;

  @override
  Future<SynorUser?> fetchCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      return null;
    }

    await _ensureUserRecord(authUser);
    return fetchUserById(authUser.id);
  }

  @override
  Future<SynorUser?> fetchUserById(String userId) async {
    final row = await _client
        .from('users')
        .select('*, group:groups(name)')
        .eq('id', userId)
        .maybeSingle();

    if (row == null) {
      final authUser = _client.auth.currentUser;
      if (authUser != null && authUser.id == userId) {
        final metadata = authUser.userMetadata ?? const <String, dynamic>{};
        return SynorUser(
          id: authUser.id,
          email: authUser.email ?? '',
          name: (metadata['name'] as String?)?.trim().isNotEmpty == true
              ? (metadata['name'] as String).trim()
              : authUser.email?.split('@').first ?? 'User',
          role: userRoleFromString(metadata['role'] as String? ?? 'student'),
          isSuper: false,
        );
      }
      return null;
    }

    return _mapUser(row);
  }

  @override
  Future<List<GroupData>> fetchGroups() async {
    final rows = await _client.from('groups').select('id,name').order('name');
    return rows
        .map<GroupData>(
          (row) => GroupData(id: row['id'] as int, name: row['name'] as String),
        )
        .toList();
  }

  Future<void> _ensureUserRecord(User authUser) async {
    final existing = await _client
        .from('users')
        .select('*')
        .eq('id', authUser.id)
        .maybeSingle();

    final metadata = authUser.userMetadata ?? const <String, dynamic>{};
    final email = authUser.email ?? existing?['email'] as String? ?? '';
    final name = (metadata['name'] as String?)?.trim().isNotEmpty == true
        ? (metadata['name'] as String).trim()
        : (existing?['name'] as String?)?.trim().isNotEmpty == true
        ? (existing?['name'] as String).trim()
        : email.split('@').first;
    final role = userRoleFromString(
      (metadata['role'] as String?) ??
          (existing?['role'] as String?) ??
          UserRole.student.name,
    );
    final existingGroupId = existing?['group_id'] as int?;
    final groupName = (metadata['group'] as String?)?.trim();
    
    // Always attempt to resolve group ID if it's currently missing in the user record
    final resolvedGroupId = existingGroupId ?? 
        (groupName != null ? await _lookupGroupIdByName(groupName) : null);

    final university = (metadata['university'] as String?)?.trim() ??
        (existing?['university'] as String?);
    final program = (metadata['faculty'] as String?)?.trim() ??
        (existing?['program'] as String?);
    final courseYear = (metadata['course_year'] as String?)?.trim() ??
        (existing?['course_year'] as String?);

    try {
      await _client
          .from('users')
          .upsert({
            'id': authUser.id,
            'email': email,
            'name': name,
            'role': role.name,
            'is_super': existing?['is_super'] ?? false,
            'group_id': role == UserRole.student ? resolvedGroupId : null,
            'university': university,
            'program': program,
            'course_year': courseYear,
          }, onConflict: 'id')
          .timeout(const Duration(seconds: 5));
    } catch (_) {
      // Ignore database errors, rely on fallback if needed
    }
  }

  Future<int?> _lookupGroupIdByName(String? groupName) async {
    if (groupName == null || groupName.isEmpty) {
      return null;
    }
    final row = await _client
        .from('groups')
        .select('id')
        .ilike('name', groupName)
        .maybeSingle()
        .timeout(const Duration(seconds: 5));
    return row?['id'] as int?;
  }

  SynorUser _mapUser(Map<String, dynamic> row) {
    final group = row['group'];
    return SynorUser(
      id: row['id'] as String? ?? '',
      email: row['email'] as String? ?? '',
      name: row['name'] as String? ?? 'User',
      role: userRoleFromString(row['role'] as String? ?? 'student'),
      isSuper: row['is_super'] as bool? ?? false,
      groupId: row['group_id'] as int?,
      groupName: group is Map<String, dynamic>
          ? group['name'] as String?
          : null,
      bio: row['bio'] as String?,
      gpa: (row['gpa'] as num?)?.toDouble(),
      program: row['program'] as String?,
      university: row['university'] as String?,
      courseYear: row['course_year'] as String?,
    );
  }

  @override
  Future<List<SynorUser>> fetchUsersByGroup(int groupId) async {
    final response = await _client
        .from('users')
        .select('*, group:groups(name)')
        .eq('group_id', groupId);

    return response.map(_mapUser).toList();
  }
}
