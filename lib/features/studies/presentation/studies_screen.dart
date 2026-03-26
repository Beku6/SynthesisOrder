import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class StudiesScreen extends StatelessWidget {
  const StudiesScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
  });

  static const _pageInset = SynorSpacing.xxl;

  final StudyMode mode;
  final ValueChanged<StudyMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(_pageInset, 48, _pageInset, 132),
      children: [
        Row(
          children: [
            Text('Study Hub', style: Theme.of(context).textTheme.headlineSmall),
            const Spacer(),
            SynorIconActionButton(
              icon: LucideIcons.search,
              onTap: () => _showStudyToast(
                context,
                'Study search',
                'Study-wide search will expand beyond this static export in the next phase.',
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
          '3 assignments this week • 2 unread materials',
          style: TextStyle(color: synorSecondaryText(context)),
        ),
        const SizedBox(height: 24),
        SynorSegmentedControl<StudyMode>(
          values: StudyMode.values,
          selected: mode,
          compact: true,
          labelBuilder: (value) => switch (value) {
            StudyMode.today => 'Today',
            StudyMode.study => 'Study',
            StudyMode.exams => 'Exams',
          },
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
            StudyMode.study => const _StudyModeContent(key: ValueKey('study')),
            StudyMode.today => const _TodayModeContent(key: ValueKey('today')),
            StudyMode.exams => const _ExamsModeContent(key: ValueKey('exams')),
          },
        ),
      ],
    );
  }
}

class _StudyModeContent extends StatelessWidget {
  const _StudyModeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('study-mode-content'),
      children: [
        _ContinueStudyingSection(),
        SizedBox(height: 28),
        _AssignmentsSection(),
        SizedBox(height: 28),
        _SubjectsSection(),
      ],
    );
  }
}

class _TodayModeContent extends StatelessWidget {
  const _TodayModeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('today-mode-content'),
      children: [
        _TodayPrioritySection(),
        SizedBox(height: 28),
        _TodayClassesSection(),
      ],
    );
  }
}

class _ExamsModeContent extends StatelessWidget {
  const _ExamsModeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      key: ValueKey('exams-mode-content'),
      children: [_ExamsSection(), SizedBox(height: 28), _WeakTopicsSection()],
    );
  }
}

class _ContinueStudyingSection extends StatelessWidget {
  const _ContinueStudyingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue studying',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        SynorHorizontalViewportBleed(
          height: 132,
          horizontalInset: StudiesScreen._pageInset,
          child: SizedBox(
            height: 132,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: StudiesScreen._pageInset,
              ),
              scrollDirection: Axis.horizontal,
              children: const [
                _MiniStudyCard(
                  icon: LucideIcons.book_open,
                  color: SynorColors.indigo500,
                  title: 'Advanced Math',
                  subtitle: '2 new notes • Review needed',
                ),
                SizedBox(width: 16),
                _MiniStudyCard(
                  icon: LucideIcons.file_text,
                  color: SynorColors.rose500,
                  title: 'Physics',
                  subtitle: '1 new file • Chapter 4',
                ),
                SizedBox(width: 16),
                _MiniStudyCard(
                  icon: LucideIcons.circle_play,
                  color: SynorColors.emerald500,
                  title: 'Programming',
                  subtitle: 'Lecture recording',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStudyCard extends StatelessWidget {
  const _MiniStudyCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: PressableScale(
        onTap: () => _showStudyToast(context, title, subtitle, icon, color),
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
        ),
      ),
    );
  }
}

class _AssignmentsSection extends StatelessWidget {
  const _AssignmentsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _SectionHeader(title: 'Assignments', actionLabel: 'See all'),
        SizedBox(height: 16),
        _AssignmentCard(
          pillLabel: 'Overdue',
          pillColor: SynorColors.rose500,
          meta: 'Yesterday',
          metaIcon: LucideIcons.circle_alert,
          metaColor: SynorColors.rose500,
          title: 'Calculus Assignment 3',
          subtitle: 'Advanced Mathematics',
        ),
        SizedBox(height: 12),
        _AssignmentCard(
          pillLabel: 'In Progress',
          pillColor: SynorColors.indigo500,
          meta: 'Due in 2 days',
          metaColor: SynorColors.slate500,
          title: 'Python Project',
          subtitle: 'Web Programming',
        ),
      ],
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  const _AssignmentCard({
    required this.pillLabel,
    required this.pillColor,
    required this.meta,
    required this.title,
    required this.subtitle,
    this.metaIcon,
    this.metaColor,
  });

  final String pillLabel;
  final Color pillColor;
  final String meta;
  final String title;
  final String subtitle;
  final IconData? metaIcon;
  final Color? metaColor;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.card,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SynorStatusChip(
                      label: pillLabel,
                      backgroundColor: pillColor.withValues(
                        alpha: synorIsDark(context) ? 0.12 : 0.1,
                      ),
                      foregroundColor: pillColor,
                      borderColor: pillColor.withValues(
                        alpha: synorIsDark(context) ? 0.25 : 0.16,
                      ),
                      compact: true,
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        if (metaIcon != null) ...[
                          Icon(
                            metaIcon,
                            size: 14,
                            color: metaColor ?? pillColor,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          meta,
                          style: TextStyle(
                            color: metaColor ?? pillColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
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
          ),
          const SizedBox(width: 16),
          SynorIconActionButton(
            icon: LucideIcons.chevron_right,
            onTap: () => _showStudyToast(
              context,
              title,
              subtitle,
              LucideIcons.file_text,
              pillColor,
            ),
            size: 20,
            buttonSize: 40,
            radius: 12,
            backgroundColor: synorIsDark(context)
                ? SynorColors.white5
                : SynorColors.slate50,
            borderColor: synorIsDark(context)
                ? SynorColors.white5
                : SynorColors.slate200,
            foregroundColor: synorIsDark(context)
                ? SynorColors.neutral300
                : SynorColors.slate600,
          ),
        ],
      ),
    );
  }
}

class _SubjectsSection extends StatelessWidget {
  const _SubjectsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Subjects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16),
        _SubjectCard(
          title: 'Programming Fundamentals',
          professor: 'Prof. Urazimbetov M.',
          grade: 'A',
          gradeColor: SynorColors.indigo500,
          footer: 'AI summary available',
          footerIcon: LucideIcons.sparkles,
          footerColor: SynorColors.emerald500,
          nextLabel: 'Next: Tomorrow 09:00',
          materialsCount: '5 materials',
          assignmentsCount: '2 assignments',
        ),
        SizedBox(height: 12),
        _SubjectCard(
          title: 'Database Management',
          professor: 'Nurlan K.',
          grade: 'A-',
          gradeColor: SynorColors.emerald500,
          footer: '2 weak topics to review',
          footerIcon: LucideIcons.brain,
          footerColor: SynorColors.slate500,
          nextLabel: 'Next: Today 10:00',
          materialsCount: '3 materials',
          assignmentsCount: '1 assignment',
        ),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({
    required this.title,
    required this.professor,
    required this.grade,
    required this.gradeColor,
    required this.footer,
    required this.footerIcon,
    required this.footerColor,
    required this.nextLabel,
    required this.materialsCount,
    required this.assignmentsCount,
  });

  final String title;
  final String professor;
  final String grade;
  final Color gradeColor;
  final String footer;
  final IconData footerIcon;
  final Color footerColor;
  final String nextLabel;
  final String materialsCount;
  final String assignmentsCount;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () => _showStudyToast(
        context,
        title,
        '$professor • $materialsCount • $assignmentsCount',
        LucideIcons.book_open,
        gradeColor,
      ),
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
                        title,
                        style: TextStyle(
                          color: synorPrimaryText(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        professor,
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
                    color: gradeColor.withValues(
                      alpha: synorIsDark(context) ? 0.12 : 0.1,
                    ),
                    border: Border.all(
                      color: gradeColor.withValues(
                        alpha: synorIsDark(context) ? 0.25 : 0.16,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      grade,
                      style: TextStyle(
                        color: gradeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _MetaItem(icon: LucideIcons.file_text, label: materialsCount),
                const SizedBox(width: 16),
                _MetaItem(
                  icon: LucideIcons.circle_check_big,
                  label: assignmentsCount,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(
              color: synorIsDark(context)
                  ? SynorColors.white5
                  : SynorColors.slate100,
              height: 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(footerIcon, size: 16, color: footerColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    footer,
                    style: TextStyle(
                      color: footerColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  nextLabel,
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayPrioritySection extends StatelessWidget {
  const _TodayPrioritySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority for Today',
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
                children: const [
                  Icon(
                    LucideIcons.circle_alert,
                    color: SynorColors.indigo500,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Calculus Assignment 3',
                    style: TextStyle(
                      color: SynorColors.indigo500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Due tonight at 23:59. You have completed 60% of the tasks.',
                style: TextStyle(color: SynorColors.indigo400, fontSize: 14),
              ),
              const SizedBox(height: 16),
              PressableScale(
                onTap: () => _showStudyToast(
                  context,
                  'Calculus Assignment 3',
                  'Advanced Mathematics • Due tonight at 23:59',
                  LucideIcons.circle_alert,
                  SynorColors.indigo500,
                ),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SynorColors.indigo600,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue Working',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayClassesSection extends StatelessWidget {
  const _TodayClassesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Today\'s Classes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16),
        _TodayClassTile(
          time: '15:00',
          title: 'Web Programming',
          subtitle: 'Tole bi №86 • Urazimbetov M.',
          color: SynorColors.rose500,
        ),
        SizedBox(height: 12),
        _TodayClassTile(
          time: '17:00',
          title: 'Database Management',
          subtitle: 'Online • Nurlan K.',
          color: SynorColors.emerald500,
        ),
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

class _ExamsSection extends StatelessWidget {
  const _ExamsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Upcoming Exams', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        SynorGlassPanel(
          radius: SynorRadii.card,
          borderColor: synorIsDark(context)
              ? SynorColors.rose500.withValues(alpha: 0.3)
              : SynorColors.rose200,
          child: Stack(
            children: [
              Positioned(
                right: -16,
                top: -16,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: SynorColors.rose500.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(999),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SynorStatusChip(
                        label: 'Midterm',
                        backgroundColor: synorIsDark(context)
                            ? SynorColors.rose500.withValues(alpha: 0.2)
                            : SynorColors.rose100,
                        foregroundColor: synorIsDark(context)
                            ? SynorColors.rose300
                            : SynorColors.rose700,
                        compact: true,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'In 3 days',
                        style: TextStyle(
                          color: synorSecondaryText(context),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Advanced Mathematics',
                    style: TextStyle(
                      color: synorPrimaryText(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Covers Chapters 1-4. Bring calculator.',
                    style: TextStyle(color: synorSecondaryText(context)),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: 0.4,
                            minHeight: 8,
                            backgroundColor: synorIsDark(context)
                                ? SynorColors.white10
                                : SynorColors.slate100,
                            valueColor: const AlwaysStoppedAnimation(
                              SynorColors.rose500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '40% ready',
                        style: TextStyle(
                          color: synorSecondaryText(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeakTopicsSection extends StatelessWidget {
  const _WeakTopicsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Weak Topics Review',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: _WeakTopicTile(
                title: 'Integrals',
                subtitle: 'Math • 3 mistakes',
                color: SynorColors.indigo500,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _WeakTopicTile(
                title: 'SQL Joins',
                subtitle: 'Databases • 2 mistakes',
                color: SynorColors.emerald500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WeakTopicTile extends StatelessWidget {
  const _WeakTopicTile({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: () =>
          _showStudyToast(context, title, subtitle, LucideIcons.brain, color),
      child: SynorGlassPanel(
        radius: SynorRadii.xxl,
        padding: const EdgeInsets.all(16),
        backgroundColor: synorIsDark(context)
            ? SynorColors.white5
            : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(LucideIcons.brain, color: color, size: 24),
            const SizedBox(height: 12),
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
      ),
    );
  }
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
  const _SectionHeader({required this.title, this.actionLabel});

  final String title;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        if (actionLabel != null)
          Text(
            actionLabel!,
            style: TextStyle(
              color: synorIsDark(context)
                  ? SynorColors.indigo400
                  : SynorColors.indigo600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
}
