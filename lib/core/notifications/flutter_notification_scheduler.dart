import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

import '../../shared/models/app_models.dart';
import 'notification_scheduler.dart';

class FlutterNotificationScheduler implements NotificationScheduler {
  FlutterNotificationScheduler() {
    _plugin = FlutterLocalNotificationsPlugin();
  }

  late final FlutterLocalNotificationsPlugin _plugin;

  Future<void> initialize() async {
    // 1. Initialize timezones
    tz.initializeTimeZones();
    try {
      // Manual timezone setup for Kazakhstan (Asia/Almaty) 
      // as native flutter_timezone plugin is causing build failures.
      tz.setLocalLocation(tz.getLocation('Asia/Almaty'));
    } catch (e) {
      debugPrint('Could not set Asia/Almaty timezone, falling back to UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }

    // 2. Initialize notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // In 21.0.0, the settings parameter is named 'settings'
    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    // 3. Request permissions for Android 13+
    if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      // Request notification permission (Android 13+)
      await androidImplementation?.requestNotificationsPermission();
      // Request exact alarm permission (Android 12+)
      await androidImplementation?.requestExactAlarmsPermission();
    }

    // 4. Create Android notification channel for alarms
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'synor_alarms',
      'Synor Alarms',
      description: 'Alarm notifications for study and personal events',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  @override
  Future<void> scheduleAlarm(AlarmScheduleDraft draft) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      draft.hours,
      draft.minutes,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // In 21.0.0, uiLocalNotificationDateInterpretation is REMOVED
    await _plugin.zonedSchedule(
      id: draft.id.hashCode,
      title: draft.mode == AlarmMode.academic ? 'Academic Alert' : 'Personal Alarm',
      body: draft.label.isEmpty ? 'Time to wake up!' : draft.label,
      scheduledDate: scheduledDate,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'synor_alarms',
          'Synor Alarms',
          channelDescription: 'Alarm notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
    );
  }

  @override
  Future<void> cancelAlarm(String alarmId) async {
    // cancel uses named id in 21.0.0
    await _plugin.cancel(id: alarmId.hashCode);
  }

  @override
  Future<void> scheduleLessonAlert({
    required int lessonId,
    required String alertLabel,
  }) async {
    // Basic logic for lesson-specific alerts
  }

  @override
  Future<void> cancelLessonAlert(int lessonId) async {
    await _plugin.cancel(id: lessonId);
  }
}
