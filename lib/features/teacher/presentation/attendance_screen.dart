import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../core/async/synor_async_state_view.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/attendance_controller.dart';
import '../domain/attendance_models.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({
    super.key,
    required this.lessonId,
    required this.groupId,
    required this.lessonTitle,
    required this.onBack,
  });

  final int lessonId;
  final int groupId;
  final String lessonTitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(lessonAttendanceProvider((lessonId: lessonId, groupId: groupId)));

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 24, 16),
          decoration: BoxDecoration(
            color: synorIsDark(context) ? SynorColors.appBlack : Colors.white,
            border: Border(
              bottom: BorderSide(
                color: synorIsDark(context) ? SynorColors.white10 : SynorColors.slate200,
              ),
            ),
          ),
          child: Row(
            children: [
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: onBack,
                buttonSize: 40,
                radius: 12,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance',
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      lessonTitle,
                      style: TextStyle(
                        color: synorSecondaryText(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: SynorAsyncStateView(
            value: attendanceAsync,
            data: (students) {
              if (students.isEmpty) {
                return const Center(child: Text('No students in this group.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return _AttendanceTile(
                    student: student,
                    lessonId: lessonId,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AttendanceTile extends ConsumerWidget {
  const _AttendanceTile({required this.student, required this.lessonId});

  final StudentAttendance student;
  final int lessonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = switch (student.status) {
      AttendanceStatus.present => SynorColors.emerald500,
      AttendanceStatus.absent => SynorColors.rose500,
      AttendanceStatus.late => SynorColors.amber500,
      null => synorSecondaryText(context),
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(student.studentId),
        confirmDismiss: (direction) async {
          final newStatus = direction == DismissDirection.startToEnd 
              ? AttendanceStatus.present 
              : AttendanceStatus.absent;
          
          HapticFeedback.mediumImpact();
          await ref.read(attendanceNotifierProvider.notifier).markAttendance(
            lessonId, 
            student.studentId, 
            newStatus
          );
          
          // Refresh list
          ref.invalidate(lessonAttendanceProvider);
          return false; // Don't actually remove from list
        },
        background: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: SynorColors.emerald500.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(LucideIcons.circle_check, color: SynorColors.emerald500),
        ),
        secondaryBackground: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: SynorColors.rose500.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(LucideIcons.circle_slash, color: SynorColors.rose500),
        ),
        child: SynorGlassPanel(
          radius: SynorRadii.card,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: statusColor.withValues(alpha: 0.1),
                child: Text(
                  student.studentName[0],
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  student.studentName,
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (student.status != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    student.status!.name.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
