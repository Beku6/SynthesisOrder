import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/assets/synor_assets.dart';
import '../../users/domain/user_models.dart';
import '../../users/domain/user_repository.dart';
import '../../../shared/models/app_models.dart';
import '../domain/profile_repository.dart';

class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository({
    required UserRepository userRepository,
    required SharedPreferences preferences,
  }) : _userRepository = userRepository,
       _preferences = preferences;

  final UserRepository _userRepository;
  final SharedPreferences _preferences;

  @override
  Future<ProfileData> fetchProfile() async {
    final user = await _userRepository.fetchCurrentUser();
    if (user == null) {
      throw StateError('An authenticated user profile is required.');
    }

    return _buildProfile(user);
  }

  @override
  Future<ProfileData> updateCoverAsset(String assetPath) async {
    final user = await _requireUser();
    await _preferences.setString(_coverAssetKey(user.id), assetPath);
    await _preferences.remove(_customCoverKey(user.id));
    return _buildProfile(user, overrideCoverAsset: assetPath);
  }

  @override
  Future<ProfileData> updateCustomCover(Uint8List bytes) async {
    final user = await _requireUser();
    await _preferences.setString(_customCoverKey(user.id), base64Encode(bytes));
    return _buildProfile(user, overrideCustomCover: bytes);
  }

  @override
  Future<ProfileData> updateBio(String bio) async {
    final user = await _requireUser();
    final client = Supabase.instance.client;
    await client.from('users').update({'bio': bio}).eq('id', user.id);
    // Since `user` object from memory does not have the updated bio yet, we pass it as override or refetch. 
    // Wait, let's just refetch.
    return fetchProfile();
  }

  Future<SynorUser> _requireUser() async {
    final user = await _userRepository.fetchCurrentUser();
    if (user == null) {
      throw StateError('An authenticated user profile is required.');
    }
    return user;
  }

  ProfileData _buildProfile(
    SynorUser user, {
    String? overrideCoverAsset,
    Uint8List? overrideCustomCover,
  }) {
    final storedCoverAsset = _preferences.getString(_coverAssetKey(user.id));
    final storedCustomCover = _preferences.getString(_customCoverKey(user.id));
    final customCoverBytes =
        overrideCustomCover ??
        (storedCustomCover == null ? null : base64Decode(storedCustomCover));

    return ProfileData(
      name: user.name,
      username: '@${user.email.split('@').first}',
      university: user.university,
      bio: user.bio,
      program: user.program,
      gpa: user.gpa,
      yearLabel: user.courseYear,
      groupLabel: user.groupName ?? 'profile.group.notAssigned',
      coverAsset:
          overrideCoverAsset ??
          storedCoverAsset ??
          (user.isStudent
              ? SynorAssets.campusCover
              : SynorAssets.architectureCover),
      avatarAsset: user.isStudent
          ? SynorAssets.studentAvatar
          : SynorAssets.nuraliAvatar,
      customCoverBytes: customCoverBytes,
    );
  }

  String _coverAssetKey(String userId) => 'profile.cover_asset.$userId';
  String _customCoverKey(String userId) => 'profile.custom_cover.$userId';
}
