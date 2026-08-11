import '../models/prayer_reminder_mode.dart';
import '../models/prayer_time.dart';
import 'adhan_alarm_service.dart';
import 'notification_service.dart';
import 'prayer_calculation_service.dart';
import 'prayer_reminder_preferences.dart';

class PrayerNotificationService {
  const PrayerNotificationService();

  static const int daysToSchedule = 7;

  Future<void> scheduleUpcomingPrayers({
    required double latitude,
    required double longitude,
    DateTime? startDate,
  }) async {
    const calculationService = PrayerCalculationService();
    const reminderPreferences = PrayerReminderPreferences();

    final baseDate = startDate ?? DateTime.now();

    final reminderModes =
        await reminderPreferences.getAllPrayerModes();

    for (var dayOffset = 0;
        dayOffset < daysToSchedule;
        dayOffset++) {
      final date = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day + dayOffset,
      );

      final prayerTimes =
          calculationService.calculatePrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );

      for (final prayer in prayerTimes) {
        if (!prayer.isPrayer) {
          continue;
        }

        if (prayer.time.isBefore(DateTime.now())) {
          continue;
        }

        final mode =
            reminderModes[prayer.type] ??
                PrayerReminderMode.adhan;

        if (mode == PrayerReminderMode.off) {
          continue;
        }

        final alarmId = notificationId(
          date: date,
          type: prayer.type,
        );

        await NotificationService.instance.scheduleNotification(
          id: alarmId,
          title: '${prayer.name} Prayer',
          body: 'It is time for ${prayer.name} Salah.',
          scheduledTime: prayer.time,
        );

        if (mode == PrayerReminderMode.adhan) {
          await AdhanAlarmService.instance.scheduleAdhanAlarm(
            alarmId: alarmId,
            prayerTime: prayer.time,
            prayerName: prayer.name,
          );
        }
      }
    }
  }

  Future<void> cancelUpcomingAdhanAlarms({
    DateTime? startDate,
  }) async {
    final baseDate = startDate ?? DateTime.now();

    for (var dayOffset = 0;
        dayOffset < daysToSchedule;
        dayOffset++) {
      final date = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day + dayOffset,
      );

      for (final type in const [
        PrayerType.fajr,
        PrayerType.dhuhr,
        PrayerType.asr,
        PrayerType.maghrib,
        PrayerType.isha,
      ]) {
        final alarmId = notificationId(
          date: date,
          type: type,
        );

        await AdhanAlarmService.instance.cancelAdhanAlarm(
          alarmId: alarmId,
        );
      }
    }
  }

  int notificationId({
    required DateTime date,
    required PrayerType type,
  }) {
    final prayerCode = switch (type) {
      PrayerType.fajr => 1,
      PrayerType.dhuhr => 2,
      PrayerType.asr => 3,
      PrayerType.maghrib => 4,
      PrayerType.isha => 5,
      PrayerType.sunrise || PrayerType.tahajjud =>
        throw ArgumentError(
          '$type is not an obligatory daily prayer notification.',
        ),
    };

    return (date.year % 100) * 100000 +
        date.month * 1000 +
        date.day * 10 +
        prayerCode;
  }
}