enum PrayerReminderMode {
  adhan,
  notification,
  off;

  String get label {
    switch (this) {
      case PrayerReminderMode.adhan:
        return 'Full Adhan';

      case PrayerReminderMode.notification:
        return 'Notification Only';

      case PrayerReminderMode.off:
        return 'Off';
    }
  }

  String get description {
    switch (this) {
      case PrayerReminderMode.adhan:
        return 'Play the full Adhan and show a prayer reminder.';

      case PrayerReminderMode.notification:
        return 'Show a prayer reminder without playing the Adhan.';

      case PrayerReminderMode.off:
        return 'Do not notify for this prayer.';
    }
  }
}