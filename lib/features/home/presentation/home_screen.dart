import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route_controller.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../l10n/app_localization_x.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../notifications/presentation/notification_widgets.dart';
import '../application/home_content_provider.dart';
import '../domain/home_content_repository.dart';
import 'story_creation_sheet.dart';
import 'story_viewer_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
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
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _pageInset = SynorSpacing.xxl;

  String _searchQuery = '';
  late String _activeFilter;

  @override
  void initState() {
    super.initState();
    // Default filter if uninitialized or async loading
    _activeFilter = 'lessons';
  }

  List<Lesson> _visibleLessons(String activeFilter) {
    Iterable<Lesson> items = widget.lessons;
    switch (activeFilter) {
      case 'missed':
        items = items.where((lesson) => lesson.isStarted);
        break;
      case 'tomorrow':
        final now = DateTime.now();
        final tomorrow = DateTime(now.year, now.month, now.day + 1);
        items = items.where((lesson) {
          final start = lesson.startTime;
          if (start == null) return false;
          return start.year == tomorrow.year &&
              start.month == tomorrow.month &&
              start.day == tomorrow.day;
        });
        break;
      case 'all':
      case 'lessons':
        break;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      items = items.where(
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
                .contains(query),
      );
    }
    return items.toList();
  }

  String _emptyMessage(String activeFilter) {
    if (_searchQuery.isNotEmpty) {
      return context.l10n.home_emptySearchMessage(_searchQuery);
    }
    if (activeFilter == 'missed') {
      return context.l10n.home_emptyMissedMessage;
    }
    if (activeFilter == 'tomorrow') {
      return context.l10n.home_emptyTomorrowMessage;
    }
    return context.l10n.home_emptyDefaultMessage;
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(appRouteControllerProvider);
    final homeContentAsync = ref.watch(homeContentProvider);
    final homeContent = homeContentAsync.valueOrNull ?? HomeContent(stories: [], filters: ['lessons', 'all', 'missed', 'tomorrow']);
    final filters = homeContent.filters;
    final activeFilter = filters.contains(_activeFilter)
        ? _activeFilter
        : (filters.isNotEmpty ? filters.first : 'lessons');
    final visibleLessons = _visibleLessons(activeFilter);
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
                const SynorNotificationBell(),
                const SizedBox(width: 12),
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
                    hintText: context.l10n.home_searchPlaceholder,
                    prefixIcon: LucideIcons.search,
                    readOnly: true,
                    onTap: router.goToSearch,
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
                  itemCount: homeContent.stories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final story = homeContent.stories[index];
                    return StoryCard(
                      story: story,
                      onTap: () {
                        if (story.isAddStory) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => const StoryCreationSheet(),
                          );
                        } else if (story.stories.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryViewerScreen(
                                bundles: homeContent.stories
                                    .where((s) => !s.isAddStory)
                                    .toList(),
                                initialBundleIndex: homeContent.stories
                                    .where((s) => !s.isAddStory)
                                    .toList()
                                    .indexOf(story),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
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
                  itemCount: filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final active = filter == activeFilter;
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
                          child: Text(context.l10n.homeFilterLabel(filter)),
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
                title: context.l10n.home_emptyTitle,
                message: _emptyMessage(activeFilter),
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
