import 'package:shared_preferences/shared_preferences.dart';

import '../models/prayer_reminder_mode.dart';
import '../models/prayer_time.dart';

class PrayerReminderPreferences {
  const PrayerReminderPreferences();

  static const String _prefix = 'prayer_reminder_mode_';

  Future<PrayerReminderMode> getMode(
    PrayerType prayerType,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    final savedValue = preferences.getString(
      _keyForPrayer(prayerType),
    );

    return PrayerReminderMode.values.firstWhere(
      (mode) => mode.name == savedValue,
      orElse: () => PrayerReminderMode.adhan,
    );
  }

  Future<void> setMode({
    required PrayerType prayerType,
    required PrayerReminderMode mode,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(
      _keyForPrayer(prayerType),
      mode.name,
    );
  }

  Future<Map<PrayerType, PrayerReminderMode>>
      getAllPrayerModes() async {
    final result = <PrayerType, PrayerReminderMode>{};

    for (final prayerType in _obligatoryPrayers) {
      result[prayerType] = await getMode(prayerType);
    }

    return result;
  }

  String _keyForPrayer(PrayerType prayerType) {
    return '$_prefix${prayerType.name}';
  }

  static const List<PrayerType> _obligatoryPrayers = [
    PrayerType.fajr,
    PrayerType.dhuhr,
    PrayerType.asr,
    PrayerType.maghrib,
    PrayerType.isha,
  ];
}