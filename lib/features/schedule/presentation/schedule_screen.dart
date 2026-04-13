import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.lessons,
    required this.onAlertTap,
  });

  final ScheduleMode mode;
  final ValueChanged<ScheduleMode> onModeChanged;
  final List<Lesson> lessons;
  final ValueChanged<int> onAlertTap;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  static const _pageInset = SynorSpacing.xxl;

  late DateTime _selectedDate;
  bool _isSearchVisible = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _selectedDate = _initialSelectedDate();
  }

  DateTime get _selectedMonth =>
      DateTime(_selectedDate.year, _selectedDate.month);

  DateTime get _weekStart => _startOfWeek(_selectedDate);

  List<DateTime> get _weekDays =>
      List.generate(7, (index) => _weekStart.add(Duration(days: index)));

  List<Lesson> _lessonsForDay(DateTime date) {
    final items = widget.lessons.where((lesson) {
      final start = lesson.startTime;
      if (start == null) {
        return false;
      }
      return start.year == date.year &&
          start.month == date.month &&
          start.day == date.day;
    });
    return _applySearch(items).toList()..sort((a, b) {
      final left = a.startTime ?? DateTime(2000);
      final right = b.startTime ?? DateTime(2000);
      return left.compareTo(right);
    });
  }

  Iterable<Lesson> _applySearch(Iterable<Lesson> items) {
    if (_searchQuery.isEmpty) {
      return items;
    }
    final query = _searchQuery.toLowerCase();
    return items.where(
      (lesson) =>
          context.l10n
              .lessonTitleLabel(lesson.title)
              .toLowerCase()
              .contains(query) ||
          context.l10n
              .lessonLocationLabel(lesson.location)
              .toLowerCase()
              .contains(query) ||
          context.l10n
              .lessonTeacherLabel(lesson.teacher)
              .toLowerCase()
              .contains(query) ||
          (lesson.groupName ?? '').toLowerCase().contains(query),
    );
  }

  List<Lesson> get _monthLessons {
    return _applySearch(
      widget.lessons.where((lesson) {
        final start = lesson.startTime;
        return start != null &&
            start.year == _selectedMonth.year &&
            start.month == _selectedMonth.month;
      }),
    ).toList()..sort((a, b) {
      final left = a.startTime ?? DateTime(2000);
      final right = b.startTime ?? DateTime(2000);
      return left.compareTo(right);
    });
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearchVisible && _searchQuery.isNotEmpty) {
        _searchQuery = '';
      } else {
        _isSearchVisible = !_isSearchVisible;
      }
    });
  }

  void _shiftWeek(int delta) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 7 * delta));
    });
  }

  void _shiftMonth(int delta) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + delta,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(_pageInset, 48, _pageInset, 132),
      children: [
        Row(
          children: [
            Text(
              context.l10n.schedule_title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            SynorIconActionButton(
              icon: _isSearchVisible ? LucideIcons.x : LucideIcons.search,
              onTap: _toggleSearch,
              buttonSize: 40,
              radius: 16,
            ),
          ],
        ),
        if (_isSearchVisible || _searchQuery.isNotEmpty) ...[
          const SizedBox(height: 16),
          SynorSearchField(
            hintText: context.l10n.schedule_searchPlaceholder,
            prefixIcon: LucideIcons.search,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
          ),
        ],
        const SizedBox(height: 24),
        SynorSegmentedControl<ScheduleMode>(
          values: ScheduleMode.values,
          selected: widget.mode,
          compact: true,
          labelBuilder: context.l10n.scheduleModeLabel,
          onChanged: widget.onModeChanged,
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
          child: switch (widget.mode) {
            ScheduleMode.day => _DayScheduleView(
              key: const ValueKey('schedule-day'),
              selectedDate: _selectedDate,
              weekDays: _weekDays,
              lessonsForDay: _lessonsForDay(_selectedDate),
              onSelectDate: (value) {
                setState(() {
                  _selectedDate = value;
                });
              },
              onAlertTap: widget.onAlertTap,
            ),
            ScheduleMode.week => _WeekScheduleView(
              key: const ValueKey('schedule-week'),
              weekStart: _weekStart,
              weekDays: _weekDays,
              lessonsForDay: _lessonsForDay,
              onShiftWeek: _shiftWeek,
              onAlertTap: widget.onAlertTap,
            ),
            ScheduleMode.month => _MonthScheduleView(
              key: const ValueKey('schedule-month'),
              month: _selectedMonth,
              lessons: _monthLessons,
              onShiftMonth: _shiftMonth,
              onSelectDate: (value) {
                setState(() {
                  _selectedDate = value;
                });
              },
              onAlertTap: widget.onAlertTap,
            ),
          },
        ),
      ],
    );
  }

  DateTime _initialSelectedDate() {
    final datedLesson =
        widget.lessons
            .where((lesson) => lesson.startTime != null)
            .map((lesson) => lesson.startTime!)
            .toList()
          ..sort();
    if (datedLesson.isNotEmpty) {
      return DateTime(
        datedLesson.first.year,
        datedLesson.first.month,
        datedLesson.first.day,
      );
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _startOfWeek(DateTime value) {
    final normalized = DateTime(value.year, value.month, value.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }
}

class _DayScheduleView extends StatelessWidget {
  const _DayScheduleView({
    super.key,
    required this.selectedDate,
    required this.weekDays,
    required this.lessonsForDay,
    required this.onSelectDate,
    required this.onAlertTap,
  });

  final DateTime selectedDate;
  final List<DateTime> weekDays;
  final List<Lesson> lessonsForDay;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<int> onAlertTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SynorHorizontalViewportBleed(
          height: 86,
          horizontalInset: 24,
          child: SizedBox(
            height: 86,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              itemCount: weekDays.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final day = weekDays[index];
                final active = _isSameDay(day, selectedDate);
                return PressableScale(
                  onTap: () => onSelectDate(day),
                  child: Container(
                    width: 64,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: active ? SynorGradients.activePill : null,
                      color: active
                          ? null
                          : (synorIsDark(context)
                                ? SynorColors.white5
                                : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: active
                            ? (synorIsDark(context)
                                  ? SynorColors.white20
                                  : SynorColors.slate700.withValues(alpha: 0.5))
                            : (synorIsDark(context)
                                  ? SynorColors.white10
                                  : SynorColors.slate200),
                      ),
                      boxShadow: active
                          ? [
                              if (synorIsDark(context))
                                const BoxShadow(
                                  color: Color(0x1AFFFFFF),
                                  blurRadius: 15,
                                )
                              else
                                ...SynorShadows.lightPill,
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          synorWeekdayShort(context, day),
                          style: TextStyle(
                            color: active
                                ? Colors.white
                                : synorSecondaryText(context),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${day.day}'.padLeft(2, '0'),
                          style: TextStyle(
                            color: active
                                ? Colors.white
                                : synorPrimaryText(context),
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (lessonsForDay.isEmpty)
          SynorInlineStateCard(
            icon: LucideIcons.calendar_x,
            title: context.l10n.schedule_noLessonsTitle,
            message: context.l10n.schedule_noLessonsMessage,
            accentColor: SynorColors.indigo500,
          )
        else
          ...lessonsForDay.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TimelineLessonCard(
                lesson: lesson,
                onAlertTap: () => onAlertTap(lesson.id),
              ),
            ),
          ),
      ],
    );
  }
}

class _WeekScheduleView extends StatelessWidget {
  const _WeekScheduleView({
    super.key,
    required this.weekStart,
    required this.weekDays,
    required this.lessonsForDay,
    required this.onShiftWeek,
    required this.onAlertTap,
  });

  final DateTime weekStart;
  final List<DateTime> weekDays;
  final List<Lesson> Function(DateTime day) lessonsForDay;
  final ValueChanged<int> onShiftWeek;
  final ValueChanged<int> onAlertTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CalendarHeader(
          title:
              '${synorMonthShort(context, weekStart)} ${weekStart.day} – ${synorMonthShort(context, weekDays.last)} ${weekDays.last.day}',
          onPrevious: () => onShiftWeek(-1),
          onNext: () => onShiftWeek(1),
        ),
        const SizedBox(height: 20),
        ...weekDays.map((day) {
          final lessons = lessonsForDay(day);
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${synorWeekdayLong(context, day)}, ${day.day} ${synorMonthShort(context, day)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      context.l10n.schedule_weekLessonCount(lessons.length),
                      style: TextStyle(color: synorSecondaryText(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (lessons.isEmpty)
                  SynorGlassPanel(
                    radius: SynorRadii.card,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      context.l10n.schedule_noLessonsForDay,
                      style: TextStyle(color: synorSecondaryText(context)),
                    ),
                  )
                else
                  ...lessons.map(
                    (lesson) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TimelineLessonCard(
                        lesson: lesson,
                        onAlertTap: () => onAlertTap(lesson.id),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _MonthScheduleView extends StatelessWidget {
  const _MonthScheduleView({
    super.key,
    required this.month,
    required this.lessons,
    required this.onShiftMonth,
    required this.onSelectDate,
    required this.onAlertTap,
  });

  final DateTime month;
  final List<Lesson> lessons;
  final ValueChanged<int> onShiftMonth;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<int> onAlertTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingDays = DateTime(month.year, month.month, 1).weekday - 1;
    final lessonDays = lessons
        .where((lesson) => lesson.startTime != null)
        .map((lesson) => lesson.startTime!.day)
        .toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CalendarHeader(
          title: '${synorMonthLong(context, month)} ${month.year}',
          onPrevious: () => onShiftMonth(-1),
          onNext: () => onShiftMonth(1),
        ),
        const SizedBox(height: 20),
        Row(
          children: List.generate(
            7,
            (index) => Expanded(
              child: Center(
                child: Text(
                  synorWeekdayShort(context, DateTime(2024, 1, index + 1)),
                  style: TextStyle(
                    color: synorSecondaryText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leadingDays + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            if (index < leadingDays) {
              return const SizedBox.shrink();
            }
            final day = index - leadingDays + 1;
            final hasEvent = lessonDays.contains(day);
            final date = DateTime(month.year, month.month, day);
            return PressableScale(
              onTap: () => onSelectDate(date),
              child: Container(
                decoration: BoxDecoration(
                  color: synorIsDark(context)
                      ? SynorColors.white5
                      : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: hasEvent
                        ? (synorIsDark(context)
                              ? SynorColors.indigo500.withValues(alpha: 0.24)
                              : SynorColors.indigo200)
                        : (synorIsDark(context)
                              ? SynorColors.white10
                              : SynorColors.slate200),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        color: synorPrimaryText(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedOpacity(
                      duration: SynorMotion.fast,
                      opacity: hasEvent ? 1 : 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: SynorColors.indigo500,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          context.l10n.schedule_upcoming,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 14),
        if (lessons.isEmpty)
          SynorGlassPanel(
            radius: SynorRadii.card,
            padding: const EdgeInsets.all(16),
            child: Text(
              context.l10n.schedule_noMonthEvents,
              style: TextStyle(color: synorSecondaryText(context)),
            ),
          )
        else
          ...lessons
              .take(4)
              .map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: TimelineLessonCard(
                    lesson: lesson,
                    onAlertTap: () => onAlertTap(lesson.id),
                  ),
                ),
              ),
      ],
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.title,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        SynorIconActionButton(
          icon: LucideIcons.chevron_left,
          onTap: onPrevious,
          buttonSize: 38,
          radius: 14,
          size: 20,
        ),
        const SizedBox(width: 8),
        SynorIconActionButton(
          icon: LucideIcons.chevron_right,
          onTap: onNext,
          buttonSize: 38,
          radius: 14,
          size: 20,
        ),
      ],
    );
  }
}

bool _isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
