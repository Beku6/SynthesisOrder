import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../lessons/application/lesson_controller.dart';
import '../../materials/application/materials_controller.dart';
import '../../materials/domain/material_models.dart';
import '../../users/application/current_user_controller.dart';
import '../../users/domain/user_models.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../application/studies_controller.dart';
import '../domain/studies_models.dart';

class StudiesScreen extends ConsumerWidget {
  const StudiesScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  static const _pageInset = SynorSpacing.xxl;

  final StudyMode mode;
  final ValueChanged<StudyMode> onModeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materialsAsync = ref.watch(materialsControllerProvider);
    final currentUserAsync = ref.watch(currentUserControllerProvider);
    final lessonsAsync = ref.watch(lessonControllerProvider);
    final lessonSummary = lessonsAsync.maybeWhen(
      data: (lessons) => context.l10n.studies_syncedLessons(lessons.length),
      orElse: () => context.l10n.studies_syncingLessons,
    );
    final materialSummary = materialsAsync.maybeWhen(
      data: (materials) =>
          context.l10n.studies_materialsAvailable(materials.length),
      orElse: () => context.l10n.studies_syncingMaterials,
    );
    final assignmentsAsync = ref.watch(assignmentsProvider);
    final examsAsync = ref.watch(examsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(_pageInset, 48, _pageInset, 132),
      children: [
        Row(
          children: [
            Text(
              context.l10n.studies_title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            SynorIconActionButton(
              icon: LucideIcons.search,
              onTap: () => _showStudyToast(
                context,
                context.l10n.studies_searchTitle,
                context.l10n.studies_searchSubtitle,
                LucideIcons.search,
                SynorColors.indigo500,
              ),
              buttonSize: 40,
              radius: 16,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '$lessonSummary • $materialSummary',
          style: TextStyle(color: synorSecondaryText(context)),
        ),
        const SizedBox(height: 24),
        SynorSegmentedControl<StudyMode>(
          values: StudyMode.values,
          selected: mode,
          compact: true,
          labelBuilder: context.l10n.studyModeLabel,
          onChanged: onModeChanged,
        ),
        const SizedBox(height: 24),
        AnimatedSwitcher(
          duration: SynorMotion.page,
          reverseDuration: SynorMotion.page,
          layoutBuilder: synorStackedLayoutBuilder(
            alignment: Alignment.topCenter,
          ),
          transitionBuilder: synorFadeSlideTransitionBuilder(
            begin: const Offset(0, 0.02),
          ),
          child: switch (mode) {
            StudyMode.study => _StudyModeContent(
              key: const ValueKey('study'),
              currentUserAsync: currentUserAsync,
              materialsAsync: materialsAsync,
              lessonsAsync: lessonsAsync,
              assignmentsAsync: assignmentsAsync,
            ),
            StudyMode.today => const _TodayModeContent(key: ValueKey('today')),
            StudyMode.exams => _ExamsModeContent(
              key: const ValueKey('exams'),
              examsAsync: examsAsync,
            ),
          },
        ),
      ],
    );
  }
}

class _StudyModeContent extends StatelessWidget {
  const _StudyModeContent({
    super.key,
    required this.currentUserAsync,
    required this.materialsAsync,
    required this.lessonsAsync,
    required this.assignmentsAsync,
  });

  final AsyncValue<SynorUser?> currentUserAsync;
  final AsyncValue<List<LessonMaterial>> materialsAsync;
  final AsyncValue<List<Lesson>> lessonsAsync;
  final AsyncValue<List<Assignment>> assignmentsAsync;

  @override
  Widget build(BuildContext context) {
    final lessons = lessonsAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <Lesson>[],
    );
    return Column(
      key: const ValueKey('study-mode-content'),
      children: [
        _MaterialsSection(
          currentUserAsync: currentUserAsync,
          materialsAsync: materialsAsync,
          lessonsAsync: lessonsAsync,
        ),
        const SizedBox(height: 28),
        _ContinueStudyingSection(lessons: lessons),
        const SizedBox(height: 28),
        _AssignmentsSection(assignmentsAsync: assignmentsAsync),
        const SizedBox(height: 28),
        _SubjectsSection(lessons: lessons),
      ],
    );
  }
}

class _TodayModeContent extends ConsumerWidget {
  const _TodayModeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(lessonControllerProvider);
    final lessons = lessonsAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <Lesson>[],
    );
    final today = DateTime.now();
    final todayLessons = lessons.where((l) {
      final s = l.startTime;
      if (s == null) return false;
      return s.year == today.year && s.month == today.month && s.day == today.day;
    }).toList();

    return Column(
      key: const ValueKey('today-mode-content'),
      children: [
        _TodayPrioritySection(todayLessons: todayLessons),
        const SizedBox(height: 28),
        _TodayClassesSection(todayLessons: todayLessons),
      ],
    );
  }
}

class _ExamsModeContent extends StatelessWidget {
  const _ExamsModeContent({super.key, required this.examsAsync});

  final AsyncValue<List<Exam>> examsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('exams-mode-content'),
      children: [
        _ExamsSection(examsAsync: examsAsync), 
        const SizedBox(height: 28), 
        const _WeakTopicsSection()
      ],
    );
  }
}

class _MaterialsSection extends ConsumerWidget {
  const _MaterialsSection({
    required this.currentUserAsync,
    required this.materialsAsync,
    required this.lessonsAsync,
  });

  final AsyncValue<SynorUser?> currentUserAsync;
  final AsyncValue<List<LessonMaterial>> materialsAsync;
  final AsyncValue<List<Lesson>> lessonsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = currentUserAsync.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    final lessons = lessonsAsync.maybeWhen(
      data: (items) => items,
      orElse: () => const <Lesson>[],
    );
    final canUpload = currentUser?.canManageLessons ?? false;

    Future<void> openUploadSheet() async {
      if (lessons.isEmpty) {
        showSynorToast(
          context,
          message: context.l10n.studies_noLessonsAvailable,
          subtitle: context.l10n.studies_noLessonsAvailableSubtitle,
          icon: LucideIcons.circle_alert,
          accentColor: SynorColors.amber500,
        );
        return;
      }
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _MaterialUploadSheet(lessons: lessons),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.studies_materials,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            if (canUpload)
              PressableScale(
                onTap: openUploadSheet,
                child: Text(
                  context.l10n.studies_upload,
                  style: TextStyle(
                    color: synorIsDark(context)
                        ? SynorColors.indigo300
                        : SynorColors.indigo600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        materialsAsync.when(
          data: (materials) {
            if (materials.isEmpty) {
              return SynorInlineStateCard(
                icon: canUpload
                    ? LucideIcons.file_plus
                    : LucideIcons.file_search,
                title: canUpload
                    ? context.l10n.studies_noMaterialsTeacherTitle
                    : context.l10n.studies_noMaterialsStudentTitle,
                message: canUpload
                    ? context.l10n.studies_noMaterialsTeacherMessage
                    : context.l10n.studies_noMaterialsStudentMessage,
                accentColor: SynorColors.indigo500,
              );
            }

            final visibleItems = materials.take(3).toList();
            return Column(
              children: visibleItems
                  .map(
                    (material) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _MaterialTile(material: material),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const Column(
            children: [
              _MaterialSkeletonTile(),
              SizedBox(height: 12),
              _MaterialSkeletonTile(),
            ],
          ),
          error: (error, _) => SynorInlineStateCard(
            icon: LucideIcons.circle_alert,
            title: context.l10n.studies_materialsUnavailable,
            message: context.l10n.appErrorLabel('$error'),
            accentColor: SynorColors.rose500,
          ),
        ),
      ],
    );
  }
}

class _ContinueStudyingSection extends StatelessWidget {
  const _ContinueStudyingSection({required this.lessons});

  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    // Derive unique subjects, preserving first-seen order.
    final seen = <String>{};
    final unique = lessons
        .where((l) => seen.add(l.title))
        .take(3)
        .toList();

    final colors = [SynorColors.indigo500, SynorColors.rose500, SynorColors.emerald500];
    final icons = [LucideIcons.book_open, LucideIcons.file_text, LucideIcons.circle_play];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_continueStudying,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (unique.isEmpty)
          SynorInlineStateCard(
            icon: LucideIcons.book_marked,
            title: 'No subjects yet',
            message: 'Your schedule will appear here once lessons are added.',
            accentColor: SynorColors.indigo500,
          )
        else
          SynorHorizontalViewportBleed(
            height: 132,
            horizontalInset: StudiesScreen._pageInset,
            child: SizedBox(
              height: 132,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: StudiesScreen._pageInset,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: unique.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final lesson = unique[index];
                  final color = colors[index % colors.length];
                  final icon = icons[index % icons.length];
                  final nextLabel = lesson.startTime != null
                      ? context.l10n.teacher_subjectLine(
                          synorNumericDate(context, lesson.startTime!),
                          synorClock(context, lesson.startTime!),
                        )
                      : '';
                  return SizedBox(
                    width: 200,
                    child: PressableScale(
                      onTap: () {},
                      child: SynorGlassPanel(
                        radius: SynorRadii.card,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: color.withValues(
                                  alpha: synorIsDark(context) ? 0.12 : 0.1,
                                ),
                              ),
                              child: Icon(icon, color: color, size: 20),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              context.l10n.lessonTitleLabel(lesson.title),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              nextLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: synorSecondaryText(context),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}


class _AssignmentsSection extends StatelessWidget {
  const _AssignmentsSection({required this.assignmentsAsync});

  final AsyncValue<List<Assignment>> assignmentsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: context.l10n.studies_assignments),
        const SizedBox(height: 16),
        assignmentsAsync.when(
          data: (assignments) {
            if (assignments.isEmpty) {
              return SynorInlineStateCard(
                icon: LucideIcons.circle_check_big,
                title: 'No pending assignments',
                message: 'You have no assignments due at the moment.',
                accentColor: SynorColors.indigo500,
              );
            }
            return Column(
              children: assignments.map((assignment) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SynorGlassPanel(
                  radius: SynorRadii.card,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: synorIsDark(context)
                              ? SynorColors.indigo500.withValues(alpha: 0.12)
                              : SynorColors.indigo50,
                        ),
                        child: Icon(
                          LucideIcons.file_text,
                          color: synorIsDark(context)
                              ? SynorColors.indigo300
                              : SynorColors.indigo600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              assignment.title,
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.lessonTitleLabel(assignment.lessonTitle),
                              style: TextStyle(color: synorSecondaryText(context)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Due: ${synorNumericDate(context, assignment.deadline)}',
                              style: TextStyle(
                                color: SynorColors.rose500,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => SynorInlineStateCard(
            icon: LucideIcons.circle_alert,
            title: 'Error loading assignments',
            message: e.toString(),
            accentColor: SynorColors.rose500,
          ),
        ),
      ],
    );
  }
}


class _SubjectsSection extends StatelessWidget {
  const _SubjectsSection({required this.lessons});

  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    // Group lessons by title to derive unique subjects.
    final subjectMap = <String, List<Lesson>>{};
    for (final lesson in lessons) {
      subjectMap.putIfAbsent(lesson.title, () => []).add(lesson);
    }

    if (subjectMap.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.studies_subjects,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          SynorInlineStateCard(
            icon: LucideIcons.library_big,
            title: 'No subjects yet',
            message: 'Subjects appear here once lessons are scheduled.',
            accentColor: SynorColors.slate500,
          ),
        ],
      );
    }

    final colors = [SynorColors.indigo500, SynorColors.emerald500, SynorColors.rose500, SynorColors.amber500];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_subjects,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        ...subjectMap.entries.toList().asMap().entries.map((entry) {
          final index = entry.key;
          final title = entry.value.key;
          final group = entry.value.value;
          final teacher = group.first.teacher;
          final color = colors[index % colors.length];
          final nextLesson = group
              .where((l) => l.startTime != null)
              .toList()
            ..sort((a, b) => a.startTime!.compareTo(b.startTime!));
          final nextLabel = nextLesson.isNotEmpty && nextLesson.first.startTime != null
              ? context.l10n.teacher_subjectLine(
                  synorNumericDate(context, nextLesson.first.startTime!),
                  synorClock(context, nextLesson.first.startTime!),
                )
              : '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PressableScale(
              onTap: () {},
              child: SynorGlassPanel(
                radius: SynorRadii.cardLarge,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.lessonTitleLabel(title),
                                style: TextStyle(
                                  color: synorPrimaryText(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                teacher,
                                style: TextStyle(color: synorSecondaryText(context)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.withValues(alpha: synorIsDark(context) ? 0.12 : 0.1),
                            border: Border.all(color: color.withValues(alpha: synorIsDark(context) ? 0.25 : 0.16)),
                          ),
                          child: Center(
                            child: Icon(LucideIcons.book_open, color: color, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _MetaItem(
                          icon: LucideIcons.calendar,
                          label: '${group.length} lesson${group.length == 1 ? '' : 's'}',
                        ),
                      ],
                    ),
                    if (nextLabel.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Divider(
                        color: synorIsDark(context) ? SynorColors.white5 : SynorColors.slate100,
                        height: 1,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(LucideIcons.clock, size: 16, color: color),
                          const SizedBox(width: 8),
                          Text(
                            'Next: $nextLabel',
                            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}


class _TodayPrioritySection extends StatelessWidget {
  const _TodayPrioritySection({required this.todayLessons});

  final List<Lesson> todayLessons;

  @override
  Widget build(BuildContext context) {
    if (todayLessons.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.studies_priorityToday,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          SynorInlineStateCard(
            icon: LucideIcons.sun,
            title: 'No classes today',
            message: 'Enjoy your free day! Your next class will appear here.',
            accentColor: SynorColors.emerald500,
          ),
        ],
      );
    }

    final next = todayLessons.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_priorityToday,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SynorGlassPanel(
          radius: SynorRadii.card,
          backgroundColor: synorIsDark(context)
              ? SynorColors.indigo500.withValues(alpha: 0.12)
              : SynorColors.indigo50,
          borderColor: synorIsDark(context)
              ? SynorColors.indigo500.withValues(alpha: 0.2)
              : SynorColors.indigo100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.clock, color: SynorColors.indigo500, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.l10n.lessonTitleLabel(next.title),
                      style: const TextStyle(
                        color: SynorColors.indigo500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${context.l10n.lessonLocationLabel(next.location)} • '
                '${next.startTime != null ? synorClock(context, next.startTime!) : ''}',
                style: const TextStyle(color: SynorColors.indigo400, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayClassesSection extends StatelessWidget {
  const _TodayClassesSection({required this.todayLessons});

  final List<Lesson> todayLessons;

  @override
  Widget build(BuildContext context) {
    final colors = [SynorColors.rose500, SynorColors.emerald500, SynorColors.indigo500, SynorColors.amber500];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_todayClasses,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        if (todayLessons.isEmpty)
          SynorInlineStateCard(
            icon: LucideIcons.calendar_x,
            title: 'No classes today',
            message: 'Your schedule is clear for today.',
            accentColor: SynorColors.slate500,
          )
        else
          ...todayLessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final color = colors[index % colors.length];
            final timeLabel = lesson.startTime != null
                ? synorClock(context, lesson.startTime!)
                : '--:--';
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _TodayClassTile(
                time: timeLabel,
                title: context.l10n.lessonTitleLabel(lesson.title),
                subtitle: context.l10n.lessonLocationLabel(lesson.location),
                color: color,
              ),
            );
          }),
      ],
    );
  }
}

class _TodayClassTile extends StatelessWidget {
  const _TodayClassTile({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String time;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.xxl,
      padding: const EdgeInsets.all(16),
      backgroundColor: synorIsDark(context) ? SynorColors.white5 : Colors.white,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: synorIsDark(context) ? 0.12 : 0.1),
              border: Border.all(
                color: color.withValues(
                  alpha: synorIsDark(context) ? 0.25 : 0.16,
                ),
              ),
            ),
            child: Center(
              child: Text(
                time,
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: synorPrimaryText(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: synorSecondaryText(context),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// _ExamsSection implementation
class _ExamsSection extends StatelessWidget {
  const _ExamsSection({required this.examsAsync});

  final AsyncValue<List<Exam>> examsAsync;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_upcomingExams,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        examsAsync.when(
          data: (exams) {
            if (exams.isEmpty) {
              return _ComingSoonCard(
                icon: LucideIcons.graduation_cap,
                message: 'No upcoming exams.',
                accentColor: SynorColors.rose500,
              );
            }
            return Column(
              children: exams.map((exam) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SynorGlassPanel(
                  radius: SynorRadii.card,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: synorIsDark(context)
                              ? SynorColors.rose500.withValues(alpha: 0.12)
                              : SynorColors.rose50,
                        ),
                        child: Icon(
                          LucideIcons.graduation_cap,
                          color: synorIsDark(context)
                              ? SynorColors.rose300
                              : SynorColors.rose600,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exam.title,
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${context.l10n.lessonTitleLabel(exam.lessonTitle)} • ${exam.type.toUpperCase()}',
                              style: TextStyle(color: synorSecondaryText(context)),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${synorNumericDate(context, exam.examDate)} at ${synorClock(context, exam.examDate)} • ${exam.location}',
                              style: TextStyle(
                                color: synorSecondaryText(context),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => SynorInlineStateCard(
            icon: LucideIcons.circle_alert,
            title: 'Error loading exams',
            message: e.toString(),
            accentColor: SynorColors.rose500,
          ),
        ),
      ],
    );
  }
}

// _WeakTopicsSection — coming soon, no real backend data yet.
class _WeakTopicsSection extends StatelessWidget {
  const _WeakTopicsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.studies_aiWeakTopicsReview,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _ComingSoonCard(
          icon: LucideIcons.brain,
          message: 'AI-powered weak topic analysis is coming soon.',
          accentColor: SynorColors.indigo500,
        ),
      ],
    );
  }
}

/// Reusable honest placeholder card for unimplemented features.
class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.icon,
    required this.message,
    required this.accentColor,
  });

  final IconData icon;
  final String message;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SynorInlineStateCard(
      icon: icon,
      title: 'Coming Soon',
      message: message,
      accentColor: accentColor,
    );
  }
}


class _MaterialTile extends StatelessWidget {
  const _MaterialTile({required this.material});

  final LessonMaterial material;

  Future<void> _openMaterial(BuildContext context) async {
    final uri = Uri.tryParse(material.fileUrl);
    if (uri == null) {
      showSynorToast(
        context,
        message: context.l10n.studies_invalidMaterialLink,
        subtitle: material.title,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) {
      return;
    }
    if (!launched) {
      showSynorToast(
        context,
        message: context.l10n.studies_couldNotOpenMaterial,
        subtitle: material.title,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () => _openMaterial(context),
      child: SynorGlassPanel(
        radius: SynorRadii.card,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: synorIsDark(context)
                    ? SynorColors.indigo500.withValues(alpha: 0.12)
                    : SynorColors.indigo50,
              ),
              child: Icon(
                LucideIcons.file_text,
                color: synorIsDark(context)
                    ? SynorColors.indigo300
                    : SynorColors.indigo600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.title,
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.lessonTitleLabel(material.lessonTitle),
                    style: TextStyle(color: synorSecondaryText(context)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatMaterialTimestamp(material.createdAt),
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SynorIconActionButton(
              icon: LucideIcons.download,
              onTap: () => _openMaterial(context),
              buttonSize: 40,
              radius: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _MaterialSkeletonTile extends StatelessWidget {
  const _MaterialSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: synorIsDark(context)
                  ? SynorColors.white10
                  : SynorColors.slate100,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? SynorColors.white10
                        : SynorColors.slate100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 12,
                  width: 170,
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? SynorColors.white8
                        : SynorColors.slate100,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MaterialUploadSheet extends ConsumerStatefulWidget {
  const _MaterialUploadSheet({required this.lessons});

  final List<Lesson> lessons;

  @override
  ConsumerState<_MaterialUploadSheet> createState() =>
      _MaterialUploadSheetState();
}

class _MaterialUploadSheetState extends ConsumerState<_MaterialUploadSheet> {
  final TextEditingController _titleController = TextEditingController();

  int? _selectedLessonId;
  Uint8List? _fileBytes;
  String? _fileName;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedLessonId = widget.lessons.isEmpty ? null : widget.lessons.first.id;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (!mounted || result == null || result.files.isEmpty) {
      return;
    }
    final file = result.files.single;
    if (file.bytes == null || file.bytes!.isEmpty) {
      showSynorToast(
        context,
        message: context.l10n.studies_uploadFailed,
        subtitle: context.l10n.studies_uploadFailedSubtitle,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }
    setState(() {
      _fileBytes = file.bytes;
      _fileName = file.name;
      _titleController.text = _titleController.text.trim().isEmpty
          ? file.name
          : _titleController.text;
    });
  }

  Future<void> _submit() async {
    if (_selectedLessonId == null ||
        _fileBytes == null ||
        _fileName == null ||
        _titleController.text.trim().isEmpty) {
      showSynorToast(
        context,
        message: context.l10n.studies_materialIncomplete,
        subtitle: context.l10n.studies_materialIncompleteSubtitle,
        icon: LucideIcons.circle_alert,
        accentColor: SynorColors.rose500,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(materialsControllerProvider.notifier)
          .uploadMaterial(
            MaterialUploadDraft(
              lessonId: _selectedLessonId!,
              title: _titleController.text.trim(),
              fileName: _fileName!,
              bytes: _fileBytes!,
            ),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
      showSynorToast(
        context,
        message: context.l10n.studies_materialUploaded,
        subtitle: _titleController.text.trim(),
        icon: LucideIcons.badge_check,
        accentColor: SynorColors.emerald500,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      showSynorToast(
        context,
        message: context.l10n.studies_uploadFailed,
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
                        context.l10n.studies_uploadMaterial,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 18),
                      SynorSearchField(
                        controller: _titleController,
                        hintText: context.l10n.studies_materialTitle,
                        prefixIcon: LucideIcons.file_text,
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
                            value: _selectedLessonId,
                            isExpanded: true,
                            dropdownColor: synorIsDark(context)
                                ? SynorColors.deepBlack
                                : Colors.white,
                            hint: Text(context.l10n.studies_selectLesson),
                            items: widget.lessons
                                .map(
                                  (lesson) => DropdownMenuItem<int>(
                                    value: lesson.id,
                                    child: Text(
                                      context.l10n.lessonTitleLabel(
                                        lesson.title,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedLessonId = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      PressableScale(
                        onTap: _pickFile,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
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
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.upload,
                                color: synorIsDark(context)
                                    ? SynorColors.indigo300
                                    : SynorColors.indigo600,
                                size: 18,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _fileName ?? context.l10n.studies_chooseFile,
                                  style: TextStyle(
                                    color: _fileName == null
                                        ? synorSecondaryText(context)
                                        : synorPrimaryText(context),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SynorPrimaryButton(
                        label: _isSubmitting
                            ? context.l10n.studies_uploading
                            : context.l10n.studies_upload,
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

String _formatMaterialTimestamp(DateTime value) {
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final year = value.year;
  return '$day.$month.$year';
}

void _showStudyToast(
  BuildContext context,
  String title,
  String subtitle,
  IconData icon,
  Color accentColor,
) {
  showSynorToast(
    context,
    message: title,
    subtitle: subtitle,
    icon: icon,
    accentColor: accentColor,
  );
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: synorSecondaryText(context)),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(color: synorSecondaryText(context), fontSize: 12),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge);
  }
}
