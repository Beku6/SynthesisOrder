import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router/app_route_controller.dart';
import '../../../app/theme/synor_design_tokens.dart';
import '../../../core/async/synor_async_state_view.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/widgets/synor_widgets.dart';
import '../../alarm/presentation/alarm_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../lessons/application/lesson_controller.dart';
import '../../messages/presentation/messages_screen.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../reminders/application/reminder_controller.dart';
import '../../reminders/domain/reminders_repository.dart';
import '../../schedule/presentation/schedule_screen.dart';
import '../../services/presentation/services_screen.dart';
import '../../studies/presentation/studies_screen.dart';
import '../application/shell_navigation_controller.dart';

class SynorAppShell extends ConsumerWidget {
  const SynorAppShell({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onSignOut,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(shellNavigationControllerProvider);
    final navigationController = ref.read(
      shellNavigationControllerProvider.notifier,
    );
    final router = ref.read(appRouteControllerProvider);
    final lessonsAsync = ref.watch(lessonControllerProvider);
    final profileAsync = ref.watch(profileControllerProvider);
    final quickAlertsAsync = ref.watch(quickAlertPresetsProvider);
    final hideBottomNav = navigation.overlay != ShellOverlay.none;
    final shellOverlay = _buildShellOverlay(
      key: ValueKey(navigation.overlay),
      context: context,
      navigation: navigation,
      router: router,
    );

    return Stack(
      children: [
        const Positioned.fill(child: SynorNoiseOverlay(opacity: 0.05)),
        SynorAsyncStateView<List<Lesson>>(
          value: lessonsAsync,
          loadingTitle: 'Loading schedule',
          loadingMessage: 'Preparing lessons and quick alerts...',
          loadingBuilder: (_) => const SynorShellLoadingSkeleton(),
          onRetry: () => ref.read(lessonControllerProvider.notifier).reload(),
          data: (lessons) => SynorAsyncStateView<ProfileData>(
            value: profileAsync,
            loadingTitle: 'Loading profile',
            loadingMessage: 'Preparing your student profile...',
            loadingBuilder: (_) => const SynorShellLoadingSkeleton(),
            onRetry: () =>
                ref.read(profileControllerProvider.notifier).reload(),
            data: (profile) => Stack(
              children: [
                AnimatedSwitcher(
                  duration: SynorMotion.page,
                  reverseDuration: SynorMotion.page,
                  layoutBuilder: synorStackedLayoutBuilder(
                    fit: StackFit.expand,
                  ),
                  transitionBuilder: synorFadeSlideTransitionBuilder(
                    begin: const Offset(0, 0.018),
                  ),
                  child: _buildTabScreen(
                    key: ValueKey(navigation.currentTab),
                    context: context,
                    navigation: navigation,
                    lessons: lessons,
                    profile: profile,
                    ref: ref,
                    router: router,
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: shellOverlay == null,
                    child: AnimatedSwitcher(
                      duration: SynorMotion.overlay,
                      reverseDuration: SynorMotion.overlay,
                      layoutBuilder: synorStackedLayoutBuilder(
                        fit: StackFit.expand,
                      ),
                      transitionBuilder: synorFadeSlideTransitionBuilder(
                        begin: const Offset(0.028, 0),
                      ),
                      child:
                          shellOverlay ??
                          const SizedBox.shrink(
                            key: ValueKey('shell-overlay-none'),
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: hideBottomNav,
            child: AnimatedSwitcher(
              duration: SynorMotion.overlay,
              reverseDuration: SynorMotion.overlay,
              layoutBuilder: synorStackedLayoutBuilder(
                alignment: Alignment.bottomCenter,
              ),
              transitionBuilder: synorFadeSlideTransitionBuilder(
                begin: const Offset(0, 0.05),
              ),
              child: hideBottomNav
                  ? const SizedBox.shrink(key: ValueKey('bottom-nav-hidden'))
                  : SynorBottomNavBar(
                      key: const ValueKey('bottom-nav-visible'),
                      currentTab: navigation.currentTab,
                      onChanged: router.goToTab,
                    ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            ignoring:
                navigation.alertTargetId == null || !lessonsAsync.hasValue,
            child: AnimatedSwitcher(
              duration: SynorMotion.overlay,
              reverseDuration: SynorMotion.overlay,
              layoutBuilder: synorStackedLayoutBuilder(
                alignment: Alignment.bottomCenter,
                fit: StackFit.expand,
              ),
              transitionBuilder: synorFadeSlideTransitionBuilder(
                begin: const Offset(0, 0.045),
              ),
              child: navigation.alertTargetId != null && lessonsAsync.hasValue
                  ? KeyedSubtree(
                      key: ValueKey('quick-alert-${navigation.alertTargetId}'),
                      child: _QuickAlertSheet(
                        lesson: lessonsAsync.requireValue.firstWhere(
                          (lesson) => lesson.id == navigation.alertTargetId,
                        ),
                        presetsAsync: quickAlertsAsync,
                        onClose: navigationController.closeAlert,
                        onApply: (label) async {
                          final targetId = navigation.alertTargetId;
                          if (targetId == null) return;
                          await ref
                              .read(lessonControllerProvider.notifier)
                              .applyAlert(targetId, label);
                          navigationController.closeAlert();
                        },
                        onRemove: () async {
                          final targetId = navigation.alertTargetId;
                          if (targetId == null) return;
                          await ref
                              .read(lessonControllerProvider.notifier)
                              .removeAlert(targetId);
                          navigationController.closeAlert();
                        },
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('quick-alert-hidden')),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabScreen({
    required Key key,
    required BuildContext context,
    required WidgetRef ref,
    required ShellNavigationState navigation,
    required AppRouteController router,
    required List<Lesson> lessons,
    required ProfileData profile,
  }) {
    return switch (navigation.currentTab) {
      ShellTab.home => HomeScreen(
        key: key,
        lessons: lessons,
        isDarkMode: isDarkMode,
        onToggleTheme: onToggleTheme,
        onOpenAlarm: router.goToAlarm,
        onOpenMessages: router.goToMessages,
        onAlertTap: ref
            .read(shellNavigationControllerProvider.notifier)
            .openAlert,
      ),
      ShellTab.schedule => ScheduleScreen(
        key: key,
        mode: navigation.scheduleMode,
        onModeChanged: ref
            .read(shellNavigationControllerProvider.notifier)
            .setScheduleMode,
        lessons: lessons,
        onAlertTap: ref
            .read(shellNavigationControllerProvider.notifier)
            .openAlert,
      ),
      ShellTab.studies => StudiesScreen(
        key: key,
        mode: navigation.studyMode,
        onModeChanged: ref
            .read(shellNavigationControllerProvider.notifier)
            .setStudyMode,
      ),
      ShellTab.services => const ServicesScreen(key: ValueKey('services')),
      ShellTab.profile => ProfileScreen(
        key: key,
        profile: profile,
        isDarkMode: isDarkMode,
        onToggleTheme: onToggleTheme,
        onUpdateCover: (assetPath) {
          ref
              .read(profileControllerProvider.notifier)
              .updateCoverAsset(assetPath);
        },
        onUploadCover: (imageBytes) {
          ref
              .read(profileControllerProvider.notifier)
              .updateCustomCover(imageBytes);
        },
        onOpenMessages: router.goToMessages,
        showSettings: navigation.overlay == ShellOverlay.profileSettings,
        onOpenSettings: router.goToProfileSettings,
        onCloseSettings: router.closeOverlay,
        onSignOut: onSignOut,
      ),
    };
  }

  Widget? _buildShellOverlay({
    required Key key,
    required BuildContext context,
    required ShellNavigationState navigation,
    required AppRouteController router,
  }) {
    return switch (navigation.overlay) {
      ShellOverlay.messages => Material(
        key: key,
        color: synorIsDark(context)
            ? SynorColors.appBlack
            : SynorColors.lightBackground,
        child: MessagesScreen(onBack: router.closeOverlay),
      ),
      ShellOverlay.alarm => Material(
        key: key,
        color: synorIsDark(context)
            ? SynorColors.appBlack
            : SynorColors.lightBackground,
        child: AlarmScreen(onBack: router.closeOverlay),
      ),
      _ => null,
    };
  }
}

class _QuickAlertSheet extends StatelessWidget {
  const _QuickAlertSheet({
    required this.lesson,
    required this.presetsAsync,
    required this.onClose,
    required this.onApply,
    required this.onRemove,
  });

  final Lesson lesson;
  final AsyncValue<List<AlertPreset>> presetsAsync;
  final VoidCallback onClose;
  final ValueChanged<String> onApply;
  final VoidCallback onRemove;

  IconData _iconForPreset(AlertPreset preset) {
    if (preset.kind == AlertPresetKind.commute) {
      return LucideIcons.map_pin;
    }
    if (preset.kind == AlertPresetKind.wakeUp) {
      return LucideIcons.sun;
    }
    return LucideIcons.alarm_clock;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: onClose, child: const SynorModalScrim()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: synorIsDark(context)
                  ? SynorColors.surfaceBlack
                  : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(32),
              ),
              border: Border(
                top: BorderSide(
                  color: synorIsDark(context)
                      ? SynorColors.white10
                      : SynorColors.slate200,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                children: [
                  const SynorBottomSheetHandle(),
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: synorIsDark(context)
                              ? SynorColors.indigo500.withValues(alpha: 0.12)
                              : SynorColors.indigo50,
                        ),
                        child: Icon(
                          LucideIcons.bell,
                          color: synorIsDark(context)
                              ? SynorColors.indigo400
                              : SynorColors.indigo600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quick Alert',
                              style: TextStyle(
                                color: synorPrimaryText(context),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lesson.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: synorSecondaryText(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'SMART SUGGESTIONS',
                    style: TextStyle(
                      color: synorSecondaryText(context),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...presetsAsync.when(
                    data: (presets) => presets
                        .map(
                          (preset) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: PressableScale(
                              onTap: () => onApply(preset.label),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: synorIsDark(context)
                                      ? SynorColors.white5
                                      : SynorColors.slate50,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _iconForPreset(preset),
                                      color: synorSecondaryText(context),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        preset.label,
                                        style: TextStyle(
                                          color: synorPrimaryText(context),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.chevron_right,
                                      size: 18,
                                      color: synorSecondaryText(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    loading: () => [const SynorQuickAlertLoadingSkeleton()],
                    error: (error, stackTrace) => [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: synorIsDark(context)
                              ? SynorColors.white5
                              : SynorColors.slate50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          'Quick alerts are unavailable.',
                          style: TextStyle(
                            color: synorSecondaryText(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PressableScale(
                    onTap: () => onApply('45 min before'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: synorIsDark(context)
                              ? SynorColors.white10
                              : SynorColors.slate200,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Custom Time',
                          style: TextStyle(
                            color: synorSecondaryText(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (lesson.alertLabel != null) ...[
                    const SizedBox(height: 12),
                    PressableScale(
                      onTap: onRemove,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: synorIsDark(context)
                              ? SynorColors.rose500.withValues(alpha: 0.12)
                              : SynorColors.rose50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            'Remove Alert',
                            style: TextStyle(
                              color: synorIsDark(context)
                                  ? SynorColors.rose400
                                  : SynorColors.rose600,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
