import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/data/mock_data.dart';
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

  int _selectedDayIndex = 1;
  int _monthIndex = 1;
  bool _isSearchVisible = false;
  String _searchQuery = '';

  static const _dayLessonMap = {
    0: [3],
    1: [4, 1, 2],
    2: [1, 2],
    3: <int>[],
    4: [4],
    5: <int>[],
  };

  static const _weekRows = [
    _WeekRowData(
      day: 'Mon',
      date: '12',
      cards: [
        _WeekScheduleCardData(
          title: 'Advanced Mathematics',
          time: '09:00 - 10:20',
          color: SynorColors.indigo500,
        ),
        _WeekScheduleCardData(
          title: 'Physics Lab',
          time: '11:00 - 12:50',
          color: SynorColors.emerald500,
        ),
      ],
    ),
    _WeekRowData(
      day: 'Tue',
      date: '13',
      active: true,
      cards: [
        _WeekScheduleCardData(
          title: 'Web Programming',
          time: '15:00 - 15:50',
          color: SynorColors.rose500,
        ),
      ],
    ),
    _WeekRowData(day: 'Wed', date: '14', cards: []),
  ];

  static const _monthViews = [
    _MonthViewData(
      title: 'September 2026',
      shortLabel: 'Sep',
      leadingDays: 1,
      totalDays: 30,
      eventDays: [3, 9, 16, 22],
      upcoming: [
        _MonthUpcomingEvent(
          day: '16',
          title: 'Algorithms Quiz',
          subtitle: 'Computer Science',
          color: SynorColors.indigo500,
        ),
      ],
    ),
    _MonthViewData(
      title: 'October 2026',
      shortLabel: 'Oct',
      leadingDays: 3,
      totalDays: 31,
      today: 13,
      eventDays: [2, 5, 12, 13, 18, 24, 28],
      upcoming: [
        _MonthUpcomingEvent(
          day: '18',
          title: 'Midterm Exam',
          subtitle: 'Advanced Mathematics',
          color: SynorColors.rose500,
        ),
        _MonthUpcomingEvent(
          day: '24',
          title: 'Project Deadline',
          subtitle: 'Web Programming',
          color: SynorColors.indigo500,
        ),
      ],
    ),
    _MonthViewData(
      title: 'November 2026',
      shortLabel: 'Nov',
      leadingDays: 6,
      totalDays: 30,
      eventDays: [4, 11, 19, 25],
      upcoming: [
        _MonthUpcomingEvent(
          day: '11',
          title: 'Research Review',
          subtitle: 'Database Systems',
          color: SynorColors.emerald500,
        ),
      ],
    ),
  ];

  List<Lesson> get _dayLessons {
    final ids = _dayLessonMap[_selectedDayIndex] ?? const <int>[];
    final lessonById = {for (final lesson in widget.lessons) lesson.id: lesson};
    Iterable<Lesson> items = ids
        .map((id) => lessonById[id])
        .whereType<Lesson>();
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      items = items.where(
        (lesson) =>
            lesson.title.toLowerCase().contains(query) ||
            lesson.location.toLowerCase().contains(query) ||
            lesson.teacher.toLowerCase().contains(query),
      );
    }
    return items.toList();
  }

  List<_WeekRowData> get _weekRowsVisible {
    if (_searchQuery.isEmpty) return _weekRows;
    final query = _searchQuery.toLowerCase();
    return _weekRows
        .map(
          (row) => row.copyWith(
            cards: row.cards
                .where(
                  (card) =>
                      card.title.toLowerCase().contains(query) ||
                      card.time.toLowerCase().contains(query),
                )
                .toList(),
          ),
        )
        .where((row) => row.cards.isNotEmpty)
        .toList();
  }

  List<_MonthUpcomingEvent> get _monthUpcomingVisible {
    final items = _monthViews[_monthIndex].upcoming;
    if (_searchQuery.isEmpty) return items;
    final query = _searchQuery.toLowerCase();
    return items
        .where(
          (item) =>
              item.title.toLowerCase().contains(query) ||
              item.subtitle.toLowerCase().contains(query),
        )
        .toList();
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

  @override
  Widget build(BuildContext context) {
    final currentMonth = _monthViews[_monthIndex];
    return ListView(
      padding: const EdgeInsets.fromLTRB(_pageInset, 48, _pageInset, 132),
      children: [
        Row(
          children: [
            Text('Schedule', style: Theme.of(context).textTheme.headlineSmall),
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
            hintText: 'Search lessons or events',
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
          labelBuilder: (value) => switch (value) {
            ScheduleMode.day => 'Day',
            ScheduleMode.week => 'Week',
            ScheduleMode.month => 'Month',
          },
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
          child: Builder(
            key: ValueKey(widget.mode),
            builder: (context) {
              if (widget.mode == ScheduleMode.day) {
                final lessons = _dayLessons;
                return Column(
                  children: [
                    SynorHorizontalViewportBleed(
                      height: 86,
                      horizontalInset: _pageInset,
                      child: SizedBox(
                        height: 86,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: _pageInset,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: SynorMockData.scheduleDays.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = SynorMockData.scheduleDays[index];
                            final active = index == _selectedDayIndex;
                            return PressableScale(
                              onTap: () {
                                setState(() {
                                  _selectedDayIndex = index;
                                });
                              },
                              child: Container(
                                width: 64,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  gradient: active
                                      ? SynorGradients.activePill
                                      : null,
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
                                              : SynorColors.slate700.withValues(
                                                  alpha: 0.5,
                                                ))
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
                                  children: [
                                    Text(
                                      item.$1,
                                      style: TextStyle(
                                        color: active
                                            ? SynorColors.indigo100
                                            : synorSecondaryText(context),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.$2,
                                      style: TextStyle(
                                        color: active
                                            ? Colors.white
                                            : synorPrimaryText(context),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
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
                    if (lessons.isEmpty)
                      const SynorInlineStateCard(
                        icon: LucideIcons.calendar_x_2,
                        title: 'No classes here',
                        message:
                            'This day is clear, or the current search does not match any lesson.',
                      )
                    else
                      Stack(
                        children: [
                          Positioned(
                            left: 19,
                            top: 0,
                            bottom: 0,
                            child: Container(
                              width: 1,
                              color: synorIsDark(context)
                                  ? SynorColors.white10
                                  : SynorColors.slate200,
                            ),
                          ),
                          Column(
                            children: lessons
                                .map(
                                  (lesson) => Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: TimelineLessonCard(
                                      lesson: lesson,
                                      onAlertTap: () =>
                                          widget.onAlertTap(lesson.id),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                  ],
                );
              }
              if (widget.mode == ScheduleMode.week) {
                final rows = _weekRowsVisible;
                if (rows.isEmpty) {
                  return const SynorInlineStateCard(
                    icon: LucideIcons.search_x,
                    title: 'No schedule matches',
                    message: 'Try another keyword or switch to Day mode.',
                  );
                }
                return SynorGlassPanel(
                  radius: SynorRadii.cardLarge,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'This Week',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      for (var index = 0; index < rows.length; index++) ...[
                        _WeekScheduleRow(
                          day: rows[index].day,
                          date: rows[index].date,
                          active: rows[index].active,
                          cards: rows[index].cards,
                        ),
                        if (index != rows.length - 1)
                          const SizedBox(height: 16),
                      ],
                    ],
                  ),
                );
              }
              final upcoming = _monthUpcomingVisible;
              return Column(
                children: [
                  _MonthCalendarCard(
                    month: currentMonth,
                    onPrevious: _monthIndex == 0
                        ? null
                        : () {
                            setState(() {
                              _monthIndex -= 1;
                            });
                          },
                    onNext: _monthIndex == _monthViews.length - 1
                        ? null
                        : () {
                            setState(() {
                              _monthIndex += 1;
                            });
                          },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Upcoming this month',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: synorPrimaryText(context),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (upcoming.isEmpty)
                    const SynorInlineStateCard(
                      icon: LucideIcons.search_x,
                      title: 'No matching events',
                      message: 'This month does not contain an upcoming match.',
                    )
                  else
                    ...upcoming.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _UpcomingMonthTile(
                          day: item.day,
                          monthLabel: currentMonth.shortLabel,
                          title: item.title,
                          subtitle: item.subtitle,
                          color: item.color,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WeekScheduleCardData {
  const _WeekScheduleCardData({
    required this.title,
    required this.time,
    required this.color,
  });

  final String title;
  final String time;
  final Color color;
}

class _WeekRowData {
  const _WeekRowData({
    required this.day,
    required this.date,
    required this.cards,
    this.active = false,
  });

  final String day;
  final String date;
  final List<_WeekScheduleCardData> cards;
  final bool active;

  _WeekRowData copyWith({List<_WeekScheduleCardData>? cards}) {
    return _WeekRowData(
      day: day,
      date: date,
      cards: cards ?? this.cards,
      active: active,
    );
  }
}

class _MonthUpcomingEvent {
  const _MonthUpcomingEvent({
    required this.day,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String day;
  final String title;
  final String subtitle;
  final Color color;
}

class _MonthViewData {
  const _MonthViewData({
    required this.title,
    required this.shortLabel,
    required this.leadingDays,
    required this.totalDays,
    required this.eventDays,
    required this.upcoming,
    this.today,
  });

  final String title;
  final String shortLabel;
  final int leadingDays;
  final int totalDays;
  final int? today;
  final List<int> eventDays;
  final List<_MonthUpcomingEvent> upcoming;
}

class _WeekScheduleRow extends StatelessWidget {
  const _WeekScheduleRow({
    required this.day,
    required this.date,
    required this.cards,
    this.active = false,
  });

  final String day;
  final String date;
  final List<_WeekScheduleCardData> cards;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  color: synorSecondaryText(context),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: TextStyle(
                  color: active
                      ? (synorIsDark(context)
                            ? SynorColors.indigo400
                            : SynorColors.indigo600)
                      : synorPrimaryText(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: cards.isEmpty
              ? Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: synorIsDark(context)
                        ? SynorColors.white5
                        : SynorColors.slate50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: synorIsDark(context)
                          ? SynorColors.white10
                          : SynorColors.slate200,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'No classes',
                      style: TextStyle(color: synorSecondaryText(context)),
                    ),
                  ),
                )
              : Column(
                  children: cards
                      .map(
                        (card) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: card.color.withValues(
                              alpha: synorIsDark(context) ? 0.12 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: card.color.withValues(
                                alpha: synorIsDark(context) ? 0.25 : 0.16,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.title,
                                style: TextStyle(
                                  color: synorIsDark(context)
                                      ? Colors.white
                                      : synorPrimaryText(context),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.time,
                                style: TextStyle(
                                  color: card.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class _MonthCalendarCard extends StatelessWidget {
  const _MonthCalendarCard({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final _MonthViewData month;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return SynorGlassPanel(
      radius: SynorRadii.cardLarge,
      child: Column(
        children: [
          Row(
            children: [
              Text(month.title, style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              SynorIconActionButton(
                icon: LucideIcons.chevron_left,
                onTap: onPrevious ?? () {},
                size: 20,
                buttonSize: 32,
                radius: 10,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                boxShadow: const [],
                foregroundColor: onPrevious == null
                    ? synorSecondaryText(context)
                    : null,
              ),
              const SizedBox(width: 8),
              SynorIconActionButton(
                icon: LucideIcons.chevron_right,
                onTap: onNext ?? () {},
                size: 20,
                buttonSize: 32,
                radius: 10,
                backgroundColor: Colors.transparent,
                borderColor: Colors.transparent,
                boxShadow: const [],
                foregroundColor: onNext == null
                    ? synorSecondaryText(context)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 14,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map(
                (day) => Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              ...List.generate(
                month.leadingDays,
                (_) => const SizedBox.shrink(),
              ),
              ...List.generate(month.totalDays, (index) {
                final day = index + 1;
                final hasEvent = month.eventDays.contains(day);
                final isToday = day == month.today;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isToday
                            ? SynorColors.indigo500
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        boxShadow: isToday
                            ? (synorIsDark(context)
                                  ? SynorShadows.indigoGlow
                                  : SynorShadows.lightIndigoGlow)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            color: isToday
                                ? Colors.white
                                : (synorIsDark(context)
                                      ? SynorColors.neutral300
                                      : SynorColors.slate700),
                            fontSize: 14,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (hasEvent && !isToday)
                      const Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 2,
                          backgroundColor: SynorColors.rose500,
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _UpcomingMonthTile extends StatelessWidget {
  const _UpcomingMonthTile({
    required this.day,
    required this.monthLabel,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String day;
  final String monthLabel;
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
              color: color.withValues(alpha: synorIsDark(context) ? 0.12 : 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(monthLabel, style: TextStyle(color: color, fontSize: 11)),
                Text(
                  day,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
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
                style: TextStyle(color: synorSecondaryText(context)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
