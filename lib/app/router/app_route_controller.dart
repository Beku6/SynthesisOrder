import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/auth_controller.dart';
import '../../features/services/application/services_controller.dart';
import '../../features/shell/application/shell_navigation_controller.dart';
import '../../l10n/l10n.dart';
import '../../shared/models/app_models.dart';
import '../application/app_session_controller.dart';
import 'synor_routes.dart';

@immutable
class SynorRouteState {
  const SynorRouteState({required this.path, required this.stage});

  final String path;
  final AuthStage stage;
}

final synorRouteStateProvider = Provider<SynorRouteState>((ref) {
  final session = ref.watch(appSessionControllerProvider);
  if (session.stage != AuthStage.main) {
    return SynorRouteState(
      path: switch (session.stage) {
        AuthStage.onboarding => SynorRoutes.onboarding,
        AuthStage.signIn => SynorRoutes.signIn,
        AuthStage.signUp => SynorRoutes.signUp,
        AuthStage.main => SynorRoutes.home,
      },
      stage: session.stage,
    );
  }

  final shell = ref.watch(shellNavigationControllerProvider);
  final services = ref
      .watch(servicesControllerProvider)
      .maybeWhen(data: (value) => value, orElse: () => null);
  final path = switch (shell.overlay) {
    ShellOverlay.messages => SynorRoutes.messages,
    ShellOverlay.chatRoom => SynorRoutes.messages, // Same base path, overlay handles specifics
    ShellOverlay.attendance => SynorRoutes.home, // Or appropriate fallback
    ShellOverlay.search => SynorRoutes.home,
    ShellOverlay.alarm => SynorRoutes.alarm,
    ShellOverlay.profileSettings => SynorRoutes.profileSettings,
    ShellOverlay.none =>
      shell.currentTab == ShellTab.services
          ? SynorRoutes.serviceViewPath(
              services?.activeView ?? ServiceView.main,
            )
          : SynorRoutes.tabPath(shell.currentTab),
  };

  return SynorRouteState(path: path, stage: session.stage);
});

final appRouteControllerProvider = Provider<AppRouteController>(
  AppRouteController.new,
);

class AppRouteController {
  AppRouteController(this.ref);

  final Ref ref;

  String get currentPath => ref.read(synorRouteStateProvider).path;

  Future<void> completeOnboarding() {
    ref.read(signInControllerProvider.notifier).reset();
    return ref.read(appSessionControllerProvider.notifier).completeOnboarding();
  }

  void openSignUp() {
    ref.read(signUpControllerProvider.notifier).reset();
    ref.read(appSessionControllerProvider.notifier).openSignUp();
  }

  void openSignIn() {
    ref.read(signInControllerProvider.notifier).reset();
    ref.read(appSessionControllerProvider.notifier).openSignIn();
  }

  Future<void> signOut() async {
    ref.read(signInControllerProvider.notifier).reset();
    ref.read(signUpControllerProvider.notifier).reset();
    ref.read(shellNavigationControllerProvider.notifier).reset();
    ref.read(servicesControllerProvider.notifier).resetToMain();
    await ref.read(appSessionControllerProvider.notifier).signOut();
  }

  void toggleTheme() {
    ref.read(appSessionControllerProvider.notifier).toggleTheme();
  }

  void setLocale(Locale locale) {
    if (!synorSupportedLocales.contains(locale)) {
      return;
    }
    ref.read(appSessionControllerProvider.notifier).setLocale(locale);
  }

  void goToTab(ShellTab tab) {
    ref.read(shellNavigationControllerProvider.notifier).setTab(tab);
    if (tab == ShellTab.services) {
      ref.read(servicesControllerProvider.notifier).resetToMain();
    }
  }

  void goToServiceView(ServiceView view) {
    ref
        .read(shellNavigationControllerProvider.notifier)
        .setTab(ShellTab.services);
    ref.read(servicesControllerProvider.notifier).setView(view);
  }

  void goToMessages() {
    ref.read(shellNavigationControllerProvider.notifier).openMessages();
  }

  void goToChatRoom(String roomId) {
    ref.read(shellNavigationControllerProvider.notifier).openChatRoom(roomId);
  }

  void closeChatRoom() {
    ref.read(shellNavigationControllerProvider.notifier).closeChatRoom();
  }

  void goToAttendance(int lessonId, int groupId, String title) {
    ref.read(shellNavigationControllerProvider.notifier).openAttendance(lessonId, groupId, title);
  }

  void closeAttendance() {
    ref.read(shellNavigationControllerProvider.notifier).closeAttendance();
  }

  void goToSearch() {
    ref.read(shellNavigationControllerProvider.notifier).openSearch();
  }

  void closeSearch() {
    ref.read(shellNavigationControllerProvider.notifier).closeSearch();
  }

  void goToAlarm() {
    ref.read(shellNavigationControllerProvider.notifier).openAlarm();
  }

  void goToProfileSettings() {
    ref.read(shellNavigationControllerProvider.notifier).openProfileSettings();
  }

  void closeOverlay() {
    ref.read(shellNavigationControllerProvider.notifier).closeOverlay();
  }
}
