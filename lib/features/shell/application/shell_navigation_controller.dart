import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/app_models.dart';

enum ShellOverlay { none, messages, alarm, profileSettings }

@immutable
class ShellNavigationState {
  const ShellNavigationState({
    this.currentTab = ShellTab.home,
    this.scheduleMode = ScheduleMode.day,
    this.studyMode = StudyMode.study,
    this.overlay = ShellOverlay.none,
    this.alertTargetId,
  });

  final ShellTab currentTab;
  final ScheduleMode scheduleMode;
  final StudyMode studyMode;
  final ShellOverlay overlay;
  final int? alertTargetId;

  ShellNavigationState copyWith({
    ShellTab? currentTab,
    ScheduleMode? scheduleMode,
    StudyMode? studyMode,
    ShellOverlay? overlay,
    int? alertTargetId,
    bool clearAlertTarget = false,
  }) {
    return ShellNavigationState(
      currentTab: currentTab ?? this.currentTab,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      studyMode: studyMode ?? this.studyMode,
      overlay: overlay ?? this.overlay,
      alertTargetId: clearAlertTarget
          ? null
          : (alertTargetId ?? this.alertTargetId),
    );
  }
}

final shellNavigationControllerProvider =
    NotifierProvider<ShellNavigationController, ShellNavigationState>(
      ShellNavigationController.new,
    );

class ShellNavigationController extends Notifier<ShellNavigationState> {
  @override
  ShellNavigationState build() => const ShellNavigationState();

  void reset() {
    state = const ShellNavigationState();
  }

  void setTab(ShellTab tab) {
    state = state.copyWith(currentTab: tab, overlay: ShellOverlay.none);
  }

  void setScheduleMode(ScheduleMode mode) {
    state = state.copyWith(scheduleMode: mode);
  }

  void setStudyMode(StudyMode mode) {
    state = state.copyWith(studyMode: mode);
  }

  void openMessages() {
    state = state.copyWith(overlay: ShellOverlay.messages);
  }

  void openAlarm() {
    state = state.copyWith(overlay: ShellOverlay.alarm);
  }

  void openProfileSettings() {
    state = state.copyWith(
      currentTab: ShellTab.profile,
      overlay: ShellOverlay.profileSettings,
    );
  }

  void closeOverlay() {
    state = state.copyWith(overlay: ShellOverlay.none);
  }

  void openAlert(int lessonId) {
    state = state.copyWith(alertTargetId: lessonId);
  }

  void closeAlert() {
    state = state.copyWith(clearAlertTarget: true);
  }
}
