import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../app/theme/synor_design_tokens.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.lessons,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onOpenAlarm,
    required this.onOpenMessages,
    required this.onAlertTap,
  });

  final List<Lesson> lessons;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenAlarm;
  final VoidCallback onOpenMessages;
  final ValueChanged<int> onAlertTap;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _pageInset = SynorSpacing.xxl;

  String _searchQuery = '';
  String _activeFilter = SynorMockData.homeFilters.first;

  List<Lesson> get _visibleLessons {
    Iterable<Lesson> items = widget.lessons;
    switch (_activeFilter) {
      case 'missed':
        items = items.where((lesson) => lesson.isStarted);
        break;
      case 'tomorrow':
        items = items.where((lesson) => {2, 3}.contains(lesson.id));
        break;
      case 'all':
      case 'lessons':
        break;
    }

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

  String get _emptyMessage {
    if (_searchQuery.isNotEmpty) {
      return 'No lessons match "$_searchQuery" in the current filter.';
    }
    if (_activeFilter == 'missed') {
      return 'No missed or in-progress lessons right now.';
    }
    if (_activeFilter == 'tomorrow') {
      return 'Tomorrow looks clear for now.';
    }
    return 'No lessons available in this view.';
  }

  @override
  Widget build(BuildContext context) {
    final visibleLessons = _visibleLessons;
    return Stack(
      children: [
        const Positioned.fill(child: SynorNoiseOverlay(opacity: 0.06)),
        ListView(
          padding: const EdgeInsets.fromLTRB(_pageInset, 48, _pageInset, 132),
          children: [
            Row(
              children: [
                const SynorBrandLogo(size: 36),
                const SizedBox(width: 12),
                Text(
                  'SYNOR',
                  style: TextStyle(
                    fontFamily: SynorTypography.logoFamily,
                    fontSize: 20,
                    letterSpacing: 3.2,
                    color: synorPrimaryText(context),
                  ),
                ),
                const Spacer(),
                PressableScale(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onToggleTheme();
                  },
                  child: AnimatedContainer(
                    duration: SynorMotion.theme,
                    curve: SynorMotion.themeCurve,
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: synorIsDark(context)
                          ? SynorColors.white5
                          : Colors.white,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: synorIsDark(context)
                            ? SynorColors.white10
                            : SynorColors.slate200,
                      ),
                      boxShadow: SynorShadows.soft,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: SynorMotion.medium,
                          opacity: widget.isDarkMode ? 0 : 1,
                          child: AnimatedRotation(
                            duration: SynorMotion.medium,
                            turns: widget.isDarkMode ? 0.25 : 0,
                            child: AnimatedScale(
                              duration: SynorMotion.medium,
                              scale: widget.isDarkMode ? 0.5 : 1,
                              child: const Icon(
                                LucideIcons.sun,
                                color: Color(0xFFF59E0B),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          duration: SynorMotion.medium,
                          opacity: widget.isDarkMode ? 1 : 0,
                          child: AnimatedRotation(
                            duration: SynorMotion.medium,
                            turns: widget.isDarkMode ? 0 : -0.25,
                            child: AnimatedScale(
                              duration: SynorMotion.medium,
                              scale: widget.isDarkMode ? 1 : 0.5,
                              child: const Icon(
                                LucideIcons.moon,
                                color: SynorColors.indigo500,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SynorSearchField(
                    hintText: 'Search...',
                    prefixIcon: LucideIcons.search,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SynorIconActionButton(
                  icon: LucideIcons.alarm_clock,
                  onTap: widget.onOpenAlarm,
                  radius: 16,
                ),
                const SizedBox(width: 12),
                SynorIconActionButton(
                  icon: LucideIcons.message_square,
                  onTap: widget.onOpenMessages,
                  radius: 16,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SynorHorizontalViewportBleed(
              height: StoryCard.dimension,
              horizontalInset: _pageInset,
              child: SizedBox(
                height: StoryCard.dimension,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: _pageInset),
                  scrollDirection: Axis.horizontal,
                  itemCount: SynorMockData.stories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) =>
                      StoryCard(story: SynorMockData.stories[index]),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SynorHorizontalViewportBleed(
              height: 44,
              horizontalInset: _pageInset,
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: _pageInset),
                  scrollDirection: Axis.horizontal,
                  itemCount: SynorMockData.homeFilters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final filter = SynorMockData.homeFilters[index];
                    final active = filter == _activeFilter;
                    return PressableScale(
                      onTap: () {
                        setState(() {
                          _activeFilter = filter;
                        });
                      },
                      child: AnimatedContainer(
                        duration: SynorMotion.theme,
                        curve: SynorMotion.themeCurve,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: active ? SynorGradients.activePill : null,
                          color: active
                              ? null
                              : (synorIsDark(context)
                                    ? SynorColors.white5
                                    : Colors.white),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: active
                                ? (synorIsDark(context)
                                      ? SynorColors.white20
                                      : SynorColors.slate700.withValues(
                                          alpha: 0.5,
                                        ))
                                : (synorIsDark(context)
                                      ? SynorColors.white5
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
                        child: AnimatedDefaultTextStyle(
                          duration: SynorMotion.theme,
                          curve: SynorMotion.themeCurve,
                          style: TextStyle(
                            color: active
                                ? Colors.white
                                : (synorIsDark(context)
                                      ? SynorColors.neutral400
                                      : SynorColors.slate600),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          child: Text(filter),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (visibleLessons.isEmpty)
              SynorInlineStateCard(
                icon: LucideIcons.search_x,
                title: 'Nothing to show',
                message: _emptyMessage,
                accentColor: SynorColors.indigo500,
              )
            else
              ...visibleLessons.map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: LessonCard(
                    lesson: lesson,
                    onAlertTap: () => widget.onAlertTap(lesson.id),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
