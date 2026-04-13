import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../features/lessons/application/lesson_controller.dart';
import '../../../features/lessons/domain/lesson_repository.dart';
import '../../../features/materials/application/materials_controller.dart';
import '../../../features/users/application/current_user_controller.dart';
import '../../../features/users/domain/user_models.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../analytics/application/analytics_controller.dart';
import '../../analytics/presentation/analytics_widgets.dart';
import '../../notifications/presentation/notification_widgets.dart';
import '../../studies/application/assignment_controller.dart';
import '../../studies/application/studies_controller.dart';
import '../../studies/domain/studies_models.dart';
import '../../users/domain/user_repository.dart';
import '../../messages/application/chat_room_controller.dart';
import '../../../app/router/app_route_controller.dart';

class TeacherDashboardScreen extends ConsumerStatefulWidget {
  const TeacherDashboardScreen({
    super.key,
    required this.user,
    required this.lessons,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onOpenMessages,
    required this.onOpenAlarm,
  });

  final SynorUser user;
  final List<Lesson> lessons;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenMessages;
  final VoidCallback onOpenAlarm;

  @override
  ConsumerState<TeacherDashboardScreen> createState() =>
      _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState
    extends ConsumerState<TeacherDashboardScreen> {
  Future<void> _openLessonComposer([Lesson? lesson]) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LessonComposerSheet(existingLesson: lesson),
    );
  }

  @override
  Widget build(BuildContext context) {
    final materialsAsync = ref.watch(materialsControllerProvider);
    final now = DateTime.now();
    final upcomingLessons = widget.lessons
        .where((lesson) => lesson.startTime?.isAfter(now) ?? false)
        .take(4)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 132),
      children: [
        Row(
          children: [
            const SynorBrandLogo(size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.teacher_dashboardTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.roleLabel(
                      widget.user.role,
                      isSuper: widget.user.isSuper,
                    ),
                    style: TextStyle(color: synorSecondaryText(context)),
                  ),
                ],
              ),
            ),
            SynorIconActionButton(
              icon: LucideIcons.message_square,
              onTap: widget.onOpenMessages,
              radius: 16,
            ),
            const SizedBox(width: 12),
            const SynorNotificationBell(),
            const SizedBox(width: 12),
            SynorIconActionButton(
              icon: LucideIcons.alarm_clock,
              onTap: widget.onOpenAlarm,
              radius: 16,
            ),
          ],
        ),
        const SizedBox(height: 24),
        SynorGlassPanel(
          radius: SynorRadii.cardLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.teacher_teachingSpace,
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SynorStatusChip(
                    label: widget.user.isSuper
                        ? context.l10n.teacher_superAccess
                        : context.l10n.teacher_teacher,
                    backgroundColor: synorIsDark(context)
                        ? SynorColors.indigo500.withValues(alpha: 0.12)
                        : SynorColors.indigo50,
                    foregroundColor: synorIsDark(context)
                        ? SynorColors.indigo300
                        : SynorColors.indigo600,
                    borderColor: synorIsDark(context)
                        ? SynorColors.indigo500.withValues(alpha: 0.24)
                        : SynorColors.indigo100,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DashboardMetricTile(
                      label: context.l10n.teacher_upcomingLessons,
                      value: '${upcomingLessons.length}',
                      icon: LucideIcons.calendar,
                      color: SynorColors.indigo500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DashboardMetricTile(
                      label: context.l10n.teacher_materials,
                      value: materialsAsync.maybeWhen(
                        data: (items) => '${items.length}',
                        orElse: () => '...',
                      ),
                      icon: LucideIcons.file_text,
                      color: SynorColors.emerald500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SynorPrimaryButton(
                label: context.l10n.teacher_createLesson,
                icon: LucideIcons.plus,
                onTap: _openLessonComposer,
                height: 52,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Row(
          children: [
            Text(
              context.l10n.teacher_managedSchedule,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            PressableScale(
              onTap: widget.onToggleTheme,
              child: Text(
                widget.isDarkMode
                    ? context.l10n.teacher_lightMode
                    : context.l10n.teacher_darkMode,
                style: TextStyle(
                  color: synorIsDark(context)
                      ? SynorColors.indigo300
                      : SynorColors.indigo600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...widget.lessons.map(
          (lesson) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _TeacherLessonTile(
              lesson: lesson,
              canEdit: true,
              onEdit: () {},
            ),
          ),
        ),
        const SizedBox(height: 28),
        _AssignmentCenterSection(lessons: widget.lessons),
        const SizedBox(height: 28),
        _AnalyticsInsightsSection(lessons: widget.lessons),
        const SizedBox(height: 28),
        const _StudentSearchSection(),
      ],
    );
  }
}

class _DashboardMetricTile extends StatelessWidget {
  const _DashboardMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: synorPrimaryText(context),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: synorSecondaryText(context), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TeacherLessonTile extends ConsumerWidget {
  const _TeacherLessonTile({
    required this.lesson,
    required this.onEdit,
    this.canEdit = false,
  });

  final Lesson lesson;
  final VoidCallback onEdit;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.lessonTitleLabel(lesson.title),
                  style: TextStyle(
                    color: synorPrimaryText(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${lesson.resolvedTime} • ${context.l10n.lessonLocationLabel(lesson.location)}',
                  style: TextStyle(color: synorSecondaryText(context)),
                ),
                if ((lesson.groupName ?? '').isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    lesson.groupName!,
                    style: TextStyle(
                      color: synorIsDark(context)
                          ? SynorColors.indigo300
                          : SynorColors.indigo600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (canEdit) ...[
            SynorIconActionButton(
              icon: LucideIcons.user_check,
              onTap: () {
                ref.read(appRouteControllerProvider).goToAttendance(
                  lesson.id,
                  lesson.groupId ?? 0,
                  context.l10n.lessonTitleLabel(lesson.title),
                );
              },
              radius: 16,
              backgroundColor: SynorColors.indigo500.withValues(alpha: 0.1),
              foregroundColor: SynorColors.indigo500,
              borderColor: Colors.transparent,
            ),
            const SizedBox(width: 8),
            SynorIconActionButton(
              icon: LucideIcons.pencil,
              onTap: onEdit,
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
}

class _LessonComposerSheet extends ConsumerStatefulWidget {
  const _LessonComposerSheet({this.existingLesson});

  final Lesson? existingLesson;

  @override
  ConsumerState<_LessonComposerSheet> createState() =>
      _LessonComposerSheetState();
}

class _LessonComposerSheetState extends ConsumerState<_LessonComposerSheet> {
  late final TextEditingController _subjectController;
  late final TextEditingController _roomController;

  int? _selectedGroupId;
  late DateTime _startTime;
  late DateTime _endTime;
  bool _isSubmitting = false;
  bool _didLocalizeInitialValues = false;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController(
      text: widget.existingLesson?.title ?? '',
    );
    _roomController = TextEditingController(
      text: widget.existingLesson?.location ?? '',
    );
    _selectedGroupId = widget.existingLesson?.groupId;
    _startTime = widget.existingLesson?.startTime ?? DateTime.now();
    _endTime =
        widget.existingLesson?.endTime ??
        DateTime.now().add(const Duration(hours: 1, minutes: 30));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didLocalizeInitialValues) {
      return;
    }
    final lesson = widget.existingLesson;
    if (lesson != null) {
      _subjectController.text = context.l10n.lessonTitleLabel(lesson.title);
      _roomController.text = context.l10n.lessonLocationLabel(lesson.location);
    }
    _didLocalizeInitialValues = true;
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final base = isStart ? _startTime : _endTime;
    final date = await showDatePicker(
      context: context,
      initialDate: base,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (!mounted || date == null) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(base),
    );
    if (!mounted || time == null) {
      return;
    }
    final result = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isStart) {
        _startTime = result;
        if (!_endTime.isAfter(result)) {
          _endTime = result.add(const Duration(hours: 1, minutes: 30));
        }
      } else {
        _endTime = result;
      }
    });
  }

  Future<void> _submit() async {
    if (_subjectController.text.trim().isEmpty ||
        _roomController.text.trim().isEmpty ||
        _selectedGroupId == null ||
        !_endTime.isAfter(_startTime)) {
      showSynorToast(
        context,
        message: context.l10n.teacher_incompleteLessonTitle,
        subtitle: context.l10n.teacher_incompleteLessonSubtitle,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });
    try {
      final mutation = LessonMutation(
        lessonId: widget.existingLesson?.id,
        subject: _subjectController.text.trim(),
        groupId: _selectedGroupId!,
        startTime: _startTime,
        endTime: _endTime,
        room: _roomController.text.trim(),
        teacherId: widget.existingLesson?.teacherId,
      );

      if (widget.existingLesson == null) {
        await ref
            .read(lessonControllerProvider.notifier)
            .createLesson(mutation);
      } else {
        await ref
            .read(lessonControllerProvider.notifier)
            .updateLesson(mutation);
      }

      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      showSynorToast(
        context,
        message: widget.existingLesson == null
            ? context.l10n.teacher_lessonCreated
            : context.l10n.teacher_lessonUpdated,
        subtitle: _subjectController.text.trim(),
        icon: LucideIcons.badge_check,
        accentColor: SynorColors.emerald500,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showSynorToast(
        context,
        message: context.l10n.teacher_lessonSaveFailed,
        subtitle: context.l10n.appErrorLabel('$error'),
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupsProvider);
    final groups = groupsAsync.maybeWhen(
      data: (value) => value,
      orElse: () => const <GroupData>[],
    );
    _selectedGroupId ??= groups.isEmpty ? null : groups.first.id;

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const SynorModalScrim(),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: synorIsDark(context)
                ? SynorColors.deepBlack
                : SynorColors.lightBackground,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  20,
                  24,
                  24 + MediaQuery.viewInsetsOf(context).bottom,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: SynorBottomSheetHandle()),
                      Text(
                        widget.existingLesson == null
                            ? context.l10n.teacher_createLessonTitle
                            : context.l10n.teacher_editLessonTitle,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 18),
                      SynorSearchField(
                        controller: _subjectController,
                        hintText: context.l10n.teacher_subjectHint,
                        prefixIcon: LucideIcons.book_open,
                      ),
                      const SizedBox(height: 12),
                      SynorSearchField(
                        controller: _roomController,
                        hintText: context.l10n.teacher_roomHint,
                        prefixIcon: LucideIcons.map_pin,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: synorIsDark(context)
                              ? SynorColors.white5
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: synorIsDark(context)
                                ? SynorColors.white10
                                : SynorColors.slate200,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _selectedGroupId,
                            isExpanded: true,
                            dropdownColor: synorIsDark(context)
                                ? SynorColors.deepBlack
                                : Colors.white,
                            hint: Text(context.l10n.teacher_selectGroup),
                            items: groups
                                .map(
                                  (group) => DropdownMenuItem<int>(
                                    value: group.id,
                                    child: Text(group.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedGroupId = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _DateTimeTile(
                              label: context.l10n.teacher_start,
                              value: _startTime,
                              onTap: () => _pickDateTime(isStart: true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _DateTimeTile(
                              label: context.l10n.teacher_end,
                              value: _endTime,
                              onTap: () => _pickDateTime(isStart: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SynorPrimaryButton(
                        label: _isSubmitting
                            ? context.l10n.teacher_saving
                            : context.l10n.teacher_saveLesson,
                        icon: LucideIcons.badge_check,
                        onTap: _isSubmitting ? () {} : _submit,
                        height: 52,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: synorIsDark(context) ? SynorColors.white5 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: synorIsDark(context)
                ? SynorColors.white10
                : SynorColors.slate200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: synorSecondaryText(context),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              context.l10n.teacher_subjectLine(
                synorNumericDate(context, value),
                synorClock(context, value),
              ),
              style: TextStyle(
                color: synorPrimaryText(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AssignmentCenterSection extends ConsumerWidget {
  const _AssignmentCenterSection({required this.lessons});

  final List<Lesson> lessons;

  void _openAssignmentComposer(BuildContext context, [Assignment? assignment]) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AssignmentComposerSheet(
        lessons: lessons,
        existingAssignment: assignment,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Assignment Center',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            SynorIconActionButton(
              icon: LucideIcons.plus,
              onTap: () => _openAssignmentComposer(context),
              buttonSize: 32,
              radius: 8,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 16),
        assignmentsAsync.when(
          data: (assignments) {
            final teacherAssignments = assignments.where((a) => lessons.any((l) => l.id == a.lessonId)).toList();
            if (teacherAssignments.isEmpty) {
              return SynorInlineStateCard(
                icon: LucideIcons.file_text,
                title: 'No assignments created',
                message: 'Tap the "+" icon to post a new assignment for your students.',
                accentColor: SynorColors.indigo500,
              );
            }
            return Column(
              children: teacherAssignments.map((assignment) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SynorGlassPanel(
                  radius: SynorRadii.card,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.title,
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Due: ${synorNumericDate(context, assignment.deadline)}',
                              style: TextStyle(
                                color: synorSecondaryText(context),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              assignment.lessonTitle,
                              style: TextStyle(
                                color: SynorColors.indigo500,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SynorIconActionButton(
                        icon: LucideIcons.trash_2,
                        onTap: () => ref.read(assignmentControllerProvider.notifier).deleteAssignment(assignment.id),
                        radius: 10,
                        size: 20,
                        foregroundColor: SynorColors.rose500,
                        backgroundColor: SynorColors.rose500.withValues(alpha: 0.1),
                        borderColor: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ],
    );
  }
}

class _AssignmentComposerSheet extends ConsumerStatefulWidget {
  const _AssignmentComposerSheet({required this.lessons, this.existingAssignment});

  final List<Lesson> lessons;
  final Assignment? existingAssignment;

  @override
  ConsumerState<_AssignmentComposerSheet> createState() => _AssignmentComposerSheetState();
}

class _AssignmentComposerSheetState extends ConsumerState<_AssignmentComposerSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _deadline;
  int? _selectedLessonId;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.existingAssignment?.title ?? '');
    _descriptionController = TextEditingController(text: widget.existingAssignment?.description ?? '');
    _deadline = widget.existingAssignment?.deadline ?? DateTime.now().add(const Duration(days: 7));
    _selectedLessonId = widget.existingAssignment?.lessonId ?? (widget.lessons.isNotEmpty ? widget.lessons.first.id : null);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty || _selectedLessonId == null) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(assignmentControllerProvider.notifier).createAssignment(
        lessonId: _selectedLessonId!,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: _deadline,
      );
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      decoration: BoxDecoration(
        color: synorIsDark(context) ? SynorColors.deepBlack : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: SynorBottomSheetHandle()),
          Text('Post Assignment', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          SynorSearchField(
            controller: _titleController,
            hintText: 'Assignment Title',
            prefixIcon: LucideIcons.file_text,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Description (optional)'),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: synorIsDark(context) ? SynorColors.white5 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: synorIsDark(context) ? SynorColors.white10 : SynorColors.slate200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _selectedLessonId,
                isExpanded: true,
                dropdownColor: synorIsDark(context) ? SynorColors.deepBlack : Colors.white,
                items: widget.lessons.map((l) => DropdownMenuItem(
                  value: l.id,
                  child: Text(l.title),
                )).toList(),
                onChanged: (v) => setState(() => _selectedLessonId = v),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SynorPrimaryButton(
            label: _isSubmitting ? 'Posting...' : 'Post Assignment',
            onTap: _submit,
          ),
        ],
      ),
    );
  }
}

class _StudentSearchSection extends ConsumerStatefulWidget {
  const _StudentSearchSection();

  @override
  ConsumerState<_StudentSearchSection> createState() => _StudentSearchSectionState();
}

class _StudentSearchSectionState extends ConsumerState<_StudentSearchSection> {
  final _searchController = TextEditingController();
  List<SynorUser> _results = [];
  bool _searching = false;

  Future<void> _search(String query) async {
    if (query.length < 2) {
      setState(() => _results = []);
      return;
    }
    setState(() => _searching = true);
    try {
      final repository = ref.read(userRepositoryProvider);
      final users = await repository.fetchUsersByGroup(1); 
      setState(() {
        _results = users.where((u) => u.name.toLowerCase().contains(query.toLowerCase())).toList();
      });
    } finally {
      setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text('Student Directory', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SynorSearchField(
          controller: _searchController,
          hintText: 'Search for students...',
          prefixIcon: LucideIcons.search,
          onChanged: _search,
        ),
        if (_results.isNotEmpty) ...[
          const SizedBox(height: 16),
          ..._results.map((student) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SynorGlassPanel(
              radius: SynorRadii.card,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(radius: 16, child: Text(student.name[0])),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text('GPA: ${student.gpa ?? "N/A"} • ${student.program ?? "Unknown"}', style: TextStyle(fontSize: 12, color: synorSecondaryText(context))),
                      ],
                    ),
                  ),
                  SynorIconActionButton(
                    icon: LucideIcons.message_square,
                    onTap: () async {
                      final roomId = await ref.read(chatRoomNotifierProvider.notifier).getOrCreateDirectRoom(student.id);
                      if (context.mounted) {
                        ref.read(appRouteControllerProvider).goToChatRoom(roomId);
                      }
                    },
                    radius: 10,
                    size: 20,
                    backgroundColor: SynorColors.indigo500.withValues(alpha: 0.1),
                    borderColor: Colors.transparent,
                    foregroundColor: SynorColors.indigo500,
                  ),
                ],
              ),
            ),
          )),
        ],
      ],
    );
  }
}

class _AnalyticsInsightsSection extends ConsumerWidget {
  const _AnalyticsInsightsSection({required this.lessons});

  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (lessons.isEmpty) return const SizedBox.shrink();
    
    // For this prototype, we'll pick the first group represented in lessons
    final groupId = lessons.first.groupId ?? 0;
    final statsAsync = ref.watch(groupStatsProvider(groupId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Insights',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        statsAsync.when(
          data: (stats) => Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SynorStatCard(
                      label: 'Avg. GPA',
                      value: stats.averageGpa.toStringAsFixed(2),
                      percent: stats.averageGpa / 4.0,
                      icon: LucideIcons.graduation_cap,
                      color: SynorColors.indigo500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SynorStatCard(
                      label: 'Attendance',
                      value: '${(stats.attendanceRate * 100).toInt()}%',
                      percent: stats.attendanceRate,
                      icon: LucideIcons.users,
                      color: SynorColors.emerald500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SynorGlassPanel(
                radius: SynorRadii.card,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Submission Progress',
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SynorProgressCard(
                      title: 'Weekly Assignments',
                      progress: stats.submissionRate,
                      color: SynorColors.indigo500,
                    ),
                    const SizedBox(height: 16),
                    SynorProgressCard(
                      title: 'Monthly Exams',
                      progress: 0.45, // Static for prototype
                      color: SynorColors.emerald500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error loading stats: $err')),
        ),
      ],
    );
  }
}

