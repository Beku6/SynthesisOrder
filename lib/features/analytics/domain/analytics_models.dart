import 'package:flutter/foundation.dart';

@immutable
class GroupStats {
  const GroupStats({
    required this.groupId,
    required this.groupName,
    required this.averageGpa,
    required this.attendanceRate,
    required this.submissionRate,
    required this.studentCount,
  });

  final int groupId;
  final String groupName;
  final double averageGpa;
  final double attendanceRate; // 0.0 to 1.0
  final double submissionRate; // 0.0 to 1.0
  final int studentCount;
}

@immutable
class PerformanceMetric {
  const PerformanceMetric({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.trend, // positive, negative, neutral
  });

  final String label;
  final double value;
  final double maxValue;
  final String trend;
}
