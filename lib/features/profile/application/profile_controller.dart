import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_models.dart';
import '../data/in_memory_profile_repository.dart';
import '../domain/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return InMemoryProfileRepository();
});

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, ProfileData>(
      ProfileController.new,
    );

class ProfileController extends AsyncNotifier<ProfileData> {
  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  @override
  Future<ProfileData> build() => _repository.fetchProfile();

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
}
