import 'package:flutter/foundation.dart';

enum UserRole { student, teacher }

UserRole userRoleFromString(String value) {
  return switch (value.trim().toLowerCase()) {
    'teacher' => UserRole.teacher,
    _ => UserRole.student,
  };
}

@immutable
class GroupData {
  const GroupData({required this.id, required this.name});

  final int id;
  final String name;
}

@immutable
class SynorUser {
  const SynorUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isSuper,
    this.groupId,
    this.groupName,
    this.bio,
    this.gpa,
    this.program,
    this.university,
    this.courseYear,
  });

  final String id;
  final String email;
  final String name;
  final UserRole role;
  final bool isSuper;
  final int? groupId;
  final String? groupName;
  final String? bio;
  final double? gpa;
  final String? program;
  final String? university;
  final String? courseYear;

  bool get isStudent => role == UserRole.student;
  bool get isTeacher => role == UserRole.teacher;
  bool get canManageLessons => isTeacher || isSuper;
  bool canManageTeacherId(String teacherId) => isSuper || id == teacherId;

  String get roleLabel => switch (role) {
    UserRole.student => 'Student',
    UserRole.teacher => isSuper ? 'Super Teacher' : 'Teacher',
  };
}
