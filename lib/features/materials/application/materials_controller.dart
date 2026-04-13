import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/data/supabase_client_provider.dart';
import '../../users/application/current_user_controller.dart';
import '../../users/domain/user_models.dart';
import '../data/supabase_material_repository.dart';
import '../domain/material_models.dart';
import '../domain/material_repository.dart';

final materialRepositoryProvider = Provider<MaterialRepository>((ref) {
  return SupabaseMaterialRepository(ref.watch(supabaseClientProvider));
});

final materialsControllerProvider =
    AsyncNotifierProvider<MaterialsController, List<LessonMaterial>>(
      MaterialsController.new,
    );

class MaterialsController extends AsyncNotifier<List<LessonMaterial>> {
  MaterialRepository get _repository => ref.read(materialRepositoryProvider);

  @override
  Future<List<LessonMaterial>> build() async {
    final user = await ref.watch(currentUserControllerProvider.future);
    if (user == null) {
      return const [];
    }
    return _repository.fetchMaterialsForUser(user);
  }

  Future<void> reload() async {
    final user = await _requireCurrentUser();
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.fetchMaterialsForUser(user),
    );
  }

  Future<void> uploadMaterial(MaterialUploadDraft draft) async {
    final actor = await _requireCurrentUser();
    state = await AsyncValue.guard(() async {
      await _repository.uploadMaterial(actor: actor, draft: draft);
      return _repository.fetchMaterialsForUser(actor);
    });
  }

  Future<SynorUser> _requireCurrentUser() async {
    final user = await ref.read(currentUserControllerProvider.future);
    if (user == null) {
      throw StateError('An authenticated user is required.');
    }
    return user;
  }
}
