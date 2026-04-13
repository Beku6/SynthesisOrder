import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/data/supabase_client_provider.dart';
import '../data/supabase_home_content_repository.dart';
import '../domain/home_content_repository.dart';

final homeContentRepositoryProvider = Provider<HomeContentRepository>((ref) {
  return SupabaseHomeContentRepository(ref.watch(supabaseClientProvider));
});

final homeContentProvider = FutureProvider<HomeContent>((ref) async {
  return ref.watch(homeContentRepositoryProvider).fetchContent();
});
