import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/application/app_session_controller.dart';
import '../../../app/data/supabase_client_provider.dart';
import '../data/supabase_user_repository.dart';
import '../domain/user_models.dart';
import '../domain/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return SupabaseUserRepository(client: ref.watch(supabaseClientProvider));
});

final groupsProvider = FutureProvider<List<GroupData>>((ref) {
  return ref.watch(userRepositoryProvider).fetchGroups();
});

final currentUserControllerProvider =
    AsyncNotifierProvider<CurrentUserController, SynorUser?>(
      CurrentUserController.new,
    );

class CurrentUserController extends AsyncNotifier<SynorUser?> {
  UserRepository get _repository => ref.read(userRepositoryProvider);

  @override
  Future<SynorUser?> build() async {
    final session = ref.watch(appSessionControllerProvider);
    if (!session.isAuthenticated) {
      return null;
    }
    return _repository.fetchCurrentUser();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.fetchCurrentUser);
  }
}
