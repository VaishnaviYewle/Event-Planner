// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._private();
  static final NotificationService instance = NotificationService._private();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Android init (use your app launcher icon)
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS / macOS init (request default permissions)
    final darwinInit = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
      macOS: darwinInit,
    );

    await _notificationsPlugin.initialize(initSettings);
  }

  /// Schedule a one-off notification at [scheduledTime].
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final tzScheduled = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'event_channel',
          'Event Notifications',
          channelDescription: 'Notifications for upcoming events',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      // NOTE: `uiLocalNotificationDateInterpretation` removed in newer versions,
      // so do NOT include it. For Android exact scheduling (may need permission):
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // No `matchDateTimeComponents` here because this is a one-off notification.
    );
  }

  /// Cancel a scheduled notification by id (optional helper)
  Future<void> cancel(int id) => _notificationsPlugin.cancel(id);

  /// Cancel all scheduled notifications (optional)
  Future<void> cancelAll() => _notificationsPlugin.cancelAll();
}
