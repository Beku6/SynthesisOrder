import 'dart:typed_data';

import '../../../shared/data/mock_data.dart';
import '../../../shared/data/mock_latency.dart';
import '../../../shared/models/app_models.dart';
import '../domain/profile_repository.dart';

class InMemoryProfileRepository implements ProfileRepository {
  ProfileData _profile = SynorMockData.profile;

  @override
  Future<ProfileData> fetchProfile() async =>
      SynorMockLatency.resolve(_profile, duration: SynorMockLatency.shell);

  @override
  Future<ProfileData> updateCoverAsset(String assetPath) async {
    _profile = _profile.copyWith(coverAsset: assetPath, clearCustomCover: true);
    return _profile;
  }

  @override
  Future<ProfileData> updateCustomCover(Uint8List bytes) async {
    _profile = _profile.copyWith(customCoverBytes: bytes);
    return _profile;
  }
}
