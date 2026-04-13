import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/shared_preferences_provider.dart';
import '../../../shared/models/app_models.dart';
import '../../users/application/current_user_controller.dart';
import '../data/supabase_profile_repository.dart';
import '../domain/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return SupabaseProfileRepository(
    userRepository: ref.watch(userRepositoryProvider),
    preferences: ref.watch(sharedPreferencesProvider),
  );
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, ProfileData>(
      ProfileController.new,
    );

class ProfileController extends AsyncNotifier<ProfileData> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<ProfileData> build() async {
    await ref.watch(currentUserControllerProvider.future);
    return _repository.fetchProfile();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_repository.fetchProfile);
  }

  Future<void> updateCoverAsset(String assetPath) async {
    state = await AsyncValue.guard(
      () => _repository.updateCoverAsset(assetPath),
    );
  }

  Future<void> updateCustomCover(Uint8List bytes) async {
    state = await AsyncValue.guard(() => _repository.updateCustomCover(bytes));
  }

  Future<void> updateBio(String bio) async {
    state = await AsyncValue.guard(() => _repository.updateBio(bio));
  }
}
