import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:synor/app/application/app_session_controller.dart';
import 'package:synor/app/assets/synor_assets.dart';
import 'package:synor/app/synor_app.dart';
import 'package:synor/core/persistence/shared_preferences_provider.dart';
import 'package:synor/features/auth/data/auth_providers.dart';
import 'package:synor/features/auth/domain/auth_models.dart';
import 'package:synor/features/auth/domain/auth_repository.dart';
import 'package:synor/features/lessons/application/lesson_controller.dart';
import 'package:synor/features/lessons/domain/lesson_repository.dart';
import 'package:synor/features/materials/application/materials_controller.dart';
import 'package:synor/features/materials/domain/material_models.dart';
import 'package:synor/features/materials/domain/material_repository.dart';
import 'package:synor/features/profile/application/profile_controller.dart';
import 'package:synor/features/profile/domain/profile_repository.dart';
import 'package:synor/features/users/application/current_user_controller.dart';
import 'package:synor/features/users/domain/user_models.dart';
import 'package:synor/features/users/domain/user_repository.dart';
import 'package:synor/shared/models/app_models.dart';

const synorViewportSize = Size(430, 932);
const synorCompactViewportSize = Size(430, 640);
const synorWidePhoneViewportSize = Size(480, 932);

const _testUser = SynorUser(
  id: 'test-user',
  email: 'student@synor.app',
  name: 'Test Student',
  role: UserRole.student,
  isSuper: false,
  groupId: 1,
  groupName: 'SE-31',
);

final _testLessons = <Lesson>[
  Lesson(
    id: 1,
    title: 'Web Programming and Python',
    location: 'Tole bi №86',
    teacher: 'Urazimbetov M.',
    teacherId: 'teacher-1',
    groupId: 1,
    groupName: 'SE-31',
    colorVariant: LessonColorVariant.rose,
    startTime: DateTime(2026, 4, 1, 15),
    endTime: DateTime(2026, 4, 1, 15, 50),
  ),
  Lesson(
    id: 2,
    title: 'Database Management Systems',
    location: 'Kazybek bi №30',
    teacher: 'Nurlan K.',
    teacherId: 'teacher-2',
    groupId: 1,
    groupName: 'SE-31',
    colorVariant: LessonColorVariant.indigo,
    startTime: DateTime(2026, 4, 2, 10),
    endTime: DateTime(2026, 4, 2, 11, 50),
  ),
  Lesson(
    id: 3,
    title: 'Algorithms',
    location: 'Main Building, Room 201',
    teacher: 'Prof. Ivanov',
    teacherId: 'teacher-3',
    groupId: 1,
    groupName: 'SE-31',
    colorVariant: LessonColorVariant.emerald,
    startTime: DateTime(2026, 4, 3, 13),
    endTime: DateTime(2026, 4, 3, 14, 50),
  ),
];

Future<ProviderContainer> pumpSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
  Map<String, Object> preferences = const {},
}) async {
  tester.view.physicalSize = surfaceSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  SharedPreferences.setMockInitialValues(preferences);
  final sharedPreferences = await SharedPreferences.getInstance();

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        authRepositoryProvider.overrideWithValue(_FakeAuthRepository()),
        userRepositoryProvider.overrideWithValue(_FakeUserRepository()),
        lessonRepositoryProvider.overrideWithValue(_FakeLessonRepository()),
        profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
        materialRepositoryProvider.overrideWithValue(_FakeMaterialRepository()),
      ],
      child: const SynorApp(),
    ),
  );
  await tester.pump();
  return synorContainer(tester);
}

class _FakeAuthRepository implements AuthRepository {
  @override
  String? get currentUserId => null;

  @override
  Stream<String?> authStateChanges() => const Stream<String?>.empty();

  @override
  Future<AuthSubmissionResult> completeSignUp(SignUpDraft draft) async {
    return AuthSubmissionResult(
      userId: _testUser.id,
      hasSession: true,
      email: draft.email,
    );
  }

  @override
  Future<void> sendRecoveryLink(String identity) async {}

  @override
  Future<AuthSubmissionResult> signIn(SignInDraft draft) async {
    return AuthSubmissionResult(
      userId: _testUser.id,
      hasSession: true,
      email: draft.email,
    );
  }

  @override
  Future<void> signInWithGoogle() async {}

  @override
  Future<void> signOut() async {}
}

class _FakeUserRepository implements UserRepository {
  @override
  Future<SynorUser?> fetchCurrentUser() async => _testUser;

  @override
  Future<SynorUser?> fetchUserById(String userId) async =>
      userId == _testUser.id ? _testUser : null;

  @override
  Future<List<GroupData>> fetchGroups() async {
    return const [GroupData(id: 1, name: 'SE-31')];
  }

  @override
  Future<List<SynorUser>> fetchUsersByGroup(int groupId) async {
    return groupId == 1 ? [_testUser] : [];
  }
}

class _FakeMaterialRepository implements MaterialRepository {
  final List<LessonMaterial> _items = [
    LessonMaterial(
      id: 1,
      lessonId: 1,
      title: 'Syllabus.pdf',
      fileUrl: 'https://example.com/syllabus.pdf',
      lessonTitle: 'Web Programming and Python',
      createdAt: DateTime(2026, 3, 25),
    ),
  ];

  @override
  Future<List<LessonMaterial>> fetchMaterialsForUser(SynorUser user) async {
    return _items;
  }

  @override
  Future<LessonMaterial> uploadMaterial({
    required SynorUser actor,
    required MaterialUploadDraft draft,
  }) async {
    return LessonMaterial(
      id: 2,
      lessonId: draft.lessonId,
      title: draft.title,
      fileUrl: 'https://example.com/${draft.fileName}',
      lessonTitle: 'Uploaded lesson',
      createdAt: DateTime.now(),
    );
  }
}

class _FakeLessonRepository implements LessonRepository {
  List<Lesson> _items = List<Lesson>.from(_testLessons);

  @override
  Future<List<Lesson>> applyAlert({
    required int lessonId,
    required String alertLabel,
  }) async {
    _items = _items
        .map(
          (lesson) => lesson.id == lessonId
              ? lesson.copyWith(alertLabel: alertLabel)
              : lesson,
        )
        .toList();
    return _items;
  }

  @override
  Future<Lesson> createLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  }) async {
    final lesson = Lesson(
      id: _items.length + 1,
      title: mutation.subject,
      location: mutation.room,
      teacher: actor.name,
      teacherId: mutation.teacherId ?? actor.id,
      groupId: mutation.groupId,
      groupName: 'SE-31',
      colorVariant: LessonColorVariant
          .values[_items.length % LessonColorVariant.values.length],
      startTime: mutation.startTime,
      endTime: mutation.endTime,
    );
    _items = [lesson, ..._items];
    return lesson;
  }

  @override
  Future<List<Lesson>> fetchLessonsForUser(SynorUser user) async {
    return _items.where((lesson) {
      if (user.isSuper) {
        return true;
      }
      if (user.isStudent) {
        return lesson.groupId == user.groupId;
      }
      return lesson.teacherId == user.id;
    }).toList();
  }

  @override
  Future<List<Lesson>> removeAlert(int lessonId) async {
    _items = _items
        .map(
          (lesson) => lesson.id == lessonId
              ? lesson.copyWith(clearAlert: true)
              : lesson,
        )
        .toList();
    return _items;
  }

  @override
  Future<Lesson> updateLesson({
    required SynorUser actor,
    required LessonMutation mutation,
  }) async {
    final lessonId = mutation.lessonId;
    if (lessonId == null) {
      throw StateError('Lesson id is required for updates.');
    }
    final existingIndex = _items.indexWhere((lesson) => lesson.id == lessonId);
    if (existingIndex == -1) {
      throw StateError('Lesson not found.');
    }
    final updated = _items[existingIndex].copyWith(
      startTime: mutation.startTime,
      endTime: mutation.endTime,
      teacherId: mutation.teacherId ?? actor.id,
      groupId: mutation.groupId,
      groupName: 'SE-31',
    );
    _items[existingIndex] = Lesson(
      id: updated.id,
      title: mutation.subject,
      location: mutation.room,
      teacher: actor.name,
      colorVariant: updated.colorVariant,
      startTime: updated.startTime,
      endTime: updated.endTime,
      teacherId: updated.teacherId,
      groupId: updated.groupId,
      groupName: updated.groupName,
      alertLabel: updated.alertLabel,
    );
    return _items[existingIndex];
  }
}

class _FakeProfileRepository implements ProfileRepository {
  ProfileData _profile = const ProfileData(
    name: 'Test Student',
    username: '@test_student',
    university: 'Abai University',
    bio: 'Focused on shipping polished student experiences.',
    program: 'Software Engineering',
    yearLabel: '2nd Year',
    groupLabel: 'SE-31',
    coverAsset: SynorAssets.campusCover,
    avatarAsset: SynorAssets.studentAvatar,
  );

  @override
  Future<ProfileData> fetchProfile() async => _profile;

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

  @override
  Future<ProfileData> updateBio(String bio) async {
    _profile = ProfileData(
      name: _profile.name,
      username: _profile.username,
      university: _profile.university,
      bio: bio,
      program: _profile.program,
      yearLabel: _profile.yearLabel,
      groupLabel: _profile.groupLabel,
      coverAsset: _profile.coverAsset,
      avatarAsset: _profile.avatarAsset,
      customCoverBytes: _profile.customCoverBytes,
    );
    return _profile;
  }
}

ProviderContainer synorContainer(WidgetTester tester) {
  return ProviderScope.containerOf(tester.element(find.byType(SynorApp)));
}

Future<ProviderContainer> pumpSignInSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
}) async {
  final container = await pumpSynorApp(
    tester,
    surfaceSize: surfaceSize,
    preferences: const {'app.onboarding_completed': true},
  );
  await settleSynorTransitions(tester, duration: const Duration(seconds: 2));
  return container;
}

Future<ProviderContainer> pumpSignedInSynorApp(
  WidgetTester tester, {
  Size surfaceSize = synorViewportSize,
}) async {
  final container = await pumpSignInSynorApp(tester, surfaceSize: surfaceSize);
  container.read(appSessionControllerProvider.notifier).signIn('test-user');
  await settleSynorTransitions(tester, duration: const Duration(seconds: 1));
  return container;
}

Future<void> settleSynorTransitions(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  await tester.pump();
  await tester.pump(duration);
}
