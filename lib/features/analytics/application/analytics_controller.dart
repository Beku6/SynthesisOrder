import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/supabase_analytics_repository.dart';
import '../domain/analytics_models.dart';
import '../domain/analytics_repository.dart';
import '../../../app/data/supabase_client_provider.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return SupabaseAnalyticsRepository(ref.watch(supabaseClientProvider));
});

final groupStatsProvider = FutureProvider.family<GroupStats, int>((ref, groupId) {
  return ref.watch(analyticsRepositoryProvider).fetchGroupStats(groupId);
});

final globalInsightsProvider = FutureProvider<List<PerformanceMetric>>((ref) {
  return ref.watch(analyticsRepositoryProvider).fetchGlobalInsights();
});
