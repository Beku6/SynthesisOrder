import 'dart:typed_data';

import '../../../shared/models/app_models.dart';

abstract class ProfileRepository {
  Future<ProfileData> fetchProfile();

  Future<ProfileData> updateCoverAsset(String assetPath);

  Future<ProfileData> updateCustomCover(Uint8List bytes);
}
