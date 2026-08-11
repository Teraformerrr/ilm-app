import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _prayerChannelId =
      'ilm_prayer_notifications';

  static const String _adhanChannelId =
      'ilm_adhan_notifications_v1';

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    final localTimezone =
        await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(localTimezone.identifier),
    );

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    await initialize();

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return false;
    }

    final granted =
        await androidPlugin.requestNotificationsPermission();

    return granted ?? false;
  }

  Future<void> showTestNotification() async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      _prayerChannelId,
      'Prayer Notifications',
      channelDescription:
          'Notifications for Islamic prayer times',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(
      id: 1,
      title: 'ILM Prayer Reminder',
      body: 'Prayer notifications are working.',
      notificationDetails: notificationDetails,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await initialize();

    final scheduledDate = _toLocalScheduledDate(
      scheduledTime,
    );

    if (scheduledDate.isBefore(
      tz.TZDateTime.now(tz.local),
    )) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _prayerChannelId,
      'Prayer Notifications',
      channelDescription:
          'Notifications for Islamic prayer times',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleAdhanNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await initialize();

    final scheduledDate = _toLocalScheduledDate(
      scheduledTime,
    );

    if (scheduledDate.isBefore(
      tz.TZDateTime.now(tz.local),
    )) {
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      _adhanChannelId,
      'Adhan',
      channelDescription:
          'Plays the Adhan at Islamic prayer times',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        'adhan_default',
      ),
      audioAttributesUsage:
          AudioAttributesUsage.alarm,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduleOneMinuteAdhanTest() async {
    final scheduledTime = DateTime.now().add(
      const Duration(minutes: 1),
    );

    await scheduleAdhanNotification(
      id: 998,
      title: 'ILM Adhan Test',
      body: 'Testing the ILM Adhan notification.',
      scheduledTime: scheduledTime,
    );
  }

  Future<List<PendingNotificationRequest>>
      getPendingNotifications() async {
    await initialize();

    return _notifications.pendingNotificationRequests();
  }

  Future<void> cancelNotification(int id) async {
    await initialize();

    await _notifications.cancel(id: id);
  }

  tz.TZDateTime _toLocalScheduledDate(
    DateTime dateTime,
  ) {
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }

  Future<bool> requestExactAlarmPermission() async {
    await initialize();

    final androidPlugin =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return false;
    }

    final granted =
        await androidPlugin.requestExactAlarmsPermission();

    return granted ?? false;
  }
}