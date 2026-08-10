import '../models/prayer_time.dart';

class PrayerService {
  const PrayerService();

  PrayerTime? getNextPrayer({
    required List<PrayerTime> prayerTimes,
    PrayerTime? tomorrowFajr,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    final obligatoryPrayers = prayerTimes
        .where((prayer) => prayer.isPrayer)
        .toList()
      ..sort((a, b) => a.time.compareTo(b.time));

    for (final prayer in obligatoryPrayers) {
      if (prayer.time.isAfter(currentTime)) {
        return prayer;
      }
    }

    if (tomorrowFajr != null &&
        tomorrowFajr.type == PrayerType.fajr &&
        tomorrowFajr.time.isAfter(currentTime)) {
      return tomorrowFajr;
    }

    return null;
  }
}