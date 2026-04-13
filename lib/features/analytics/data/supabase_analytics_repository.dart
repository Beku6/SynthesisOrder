import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/analytics_models.dart';
import '../domain/analytics_repository.dart';

class SupabaseAnalyticsRepository implements AnalyticsRepository {
  const SupabaseAnalyticsRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<GroupStats> fetchGroupStats(int groupId) async {
    // 1. Fetch group metadata and students
    final groupResponse = await _client
        .from('groups')
        .select('name, users(gpa)')
        .eq('id', groupId)
        .single();

    final students = groupResponse['users'] as List;
    final groupName = groupResponse['name'] as String;
    
    // Calculate Average GPA
    double avgGpa = 0;
    if (students.isNotEmpty) {
      final totalGpa = students.fold<double>(0, (sum, item) => sum + (item['gpa'] ?? 0));
      avgGpa = totalGpa / students.length;
    }

    // 2. Fetch Attendance rate for this group
    final attendanceResponse = await _client
        .from('lesson_attendance')
        .select('status')
        .eq('status', 'present');
    
    // For MVP, we'll mock the total possible based on group size * lessons
    // In production, this would join with the count of lessons passed for that group.
    final attendanceRate = students.isEmpty ? 0.0 : 0.85; // Mocking slightly for stabilization demo

    // 3. Fetch Submission rate
    final submissionRate = students.isEmpty ? 0.0 : 0.72; // Mocking for now

    return GroupStats(
      groupId: groupId,
      groupName: groupName,
      averageGpa: avgGpa,
      attendanceRate: attendanceRate,
      submissionRate: submissionRate,
      studentCount: students.length,
    );
  }

  @override
  Future<List<PerformanceMetric>> fetchGlobalInsights() async {
    // In next phase, this would be complex joins. 
    // For stabilization, we'll return high-level snapshots.
    return [
      const PerformanceMetric(label: 'Avg. Retention', value: 94.2, maxValue: 100, trend: 'positive'),
      const PerformanceMetric(label: 'Active Engagement', value: 78.5, maxValue: 100, trend: 'neutral'),
      const PerformanceMetric(label: 'Exam Progress', value: 12.0, maxValue: 15, trend: 'positive'),
    ];
  }
}
