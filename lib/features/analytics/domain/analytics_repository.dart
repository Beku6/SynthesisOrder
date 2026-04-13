import '../domain/analytics_models.dart';

abstract class AnalyticsRepository {
  Future<GroupStats> fetchGroupStats(int groupId);
  Future<List<PerformanceMetric>> fetchGlobalInsights();
}
