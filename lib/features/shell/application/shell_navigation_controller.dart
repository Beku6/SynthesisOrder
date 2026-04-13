import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../users/domain/user_models.dart';
import '../../../shared/models/app_models.dart';

enum ShellOverlay {
  none,
  messages,
  chatRoom,
  attendance,
  search,
  alarm,
  profileSettings,
}

@immutable
class ShellNavigationState {
  const ShellNavigationState({
    this.currentTab = ShellTab.home,
    this.overlay = ShellOverlay.none,
    this.scheduleMode = ScheduleMode.day,
    this.studyMode = StudyMode.study,
    this.alertTargetId,
    this.chatRoomId,
    this.attendanceContext,
    this.hasResolvedLandingTab = false,
  });

  final ShellTab currentTab;
  final ShellOverlay overlay;
  final ScheduleMode scheduleMode;
  final StudyMode studyMode;
  final int? alertTargetId;
  final String? chatRoomId;
  final ({int lessonId, int groupId, String title})? attendanceContext;
  final bool hasResolvedLandingTab;

  ShellNavigationState copyWith({
    ShellTab? currentTab,
    ShellOverlay? overlay,
    ScheduleMode? scheduleMode,
    StudyMode? studyMode,
    int? alertTargetId,
    String? chatRoomId,
    ({int lessonId, int groupId, String title})? attendanceContext,
    bool? hasResolvedLandingTab,
    bool clearAlert = false,
    bool clearChat = false,
    bool clearAttendance = false,
  }) {
    return ShellNavigationState(
      currentTab: currentTab ?? this.currentTab,
      overlay: overlay ?? this.overlay,
      scheduleMode: scheduleMode ?? this.scheduleMode,
      studyMode: studyMode ?? this.studyMode,
      alertTargetId: clearAlert ? null : (alertTargetId ?? this.alertTargetId),
      chatRoomId: clearChat ? null : (chatRoomId ?? this.chatRoomId),
      attendanceContext: clearAttendance ? null : (attendanceContext ?? this.attendanceContext),
      hasResolvedLandingTab:
          hasResolvedLandingTab ?? this.hasResolvedLandingTab,
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

  void ensureLandingTabForUser(SynorUser user) {
    if (state.hasResolvedLandingTab) {
      return;
    }
    state = state.copyWith(
      currentTab: ShellTab.home,
      hasResolvedLandingTab: true,
    );
  }

  void setTab(ShellTab tab) {
    state = state.copyWith(
      currentTab: tab,
      overlay: ShellOverlay.none,
      hasResolvedLandingTab: true,
    );
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
    state = state.copyWith(clearAlert: true);
  }

  void openChatRoom(String roomId) {
    state = state.copyWith(
      overlay: ShellOverlay.chatRoom,
      chatRoomId: roomId,
    );
  }

  void closeChatRoom() {
    state = state.copyWith(
      overlay: ShellOverlay.messages,
      clearChat: true,
    );
  }

  void openAttendance(int lessonId, int groupId, String title) {
    state = state.copyWith(
      overlay: ShellOverlay.attendance,
      attendanceContext: (lessonId: lessonId, groupId: groupId, title: title),
    );
  }

  void closeAttendance() {
    state = state.copyWith(
      overlay: ShellOverlay.none,
      clearAttendance: true,
    );
  }

  void openSearch() {
    state = state.copyWith(overlay: ShellOverlay.search);
  }

  void closeSearch() {
    state = state.copyWith(overlay: ShellOverlay.none);
  }
}
