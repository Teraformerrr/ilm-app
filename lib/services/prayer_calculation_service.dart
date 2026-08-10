import 'package:adhan/adhan.dart';

import '../models/prayer_time.dart';

class PrayerCalculationService {
  const PrayerCalculationService();

  List<PrayerTime> calculatePrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) {
    final coordinates = Coordinates(latitude, longitude);

    final params = CalculationMethod.dubai.getParameters();

    final dateComponents = DateComponents(
      date.year,
      date.month,
      date.day,
    );

    final prayers = PrayerTimes(
      coordinates,
      dateComponents,
      params,
    );

    return [
  PrayerTime(
    type: PrayerType.fajr,
    time: prayers.fajr.toLocal(),
  ),
  PrayerTime(
    type: PrayerType.sunrise,
    time: prayers.sunrise.toLocal(),
  ),
  PrayerTime(
    type: PrayerType.dhuhr,
    time: prayers.dhuhr.toLocal(),
  ),
  PrayerTime(
    type: PrayerType.asr,
    time: prayers.asr.toLocal(),
  ),
  PrayerTime(
    type: PrayerType.maghrib,
    time: prayers.maghrib.toLocal(),
  ),
  PrayerTime(
    type: PrayerType.isha,
    time: prayers.isha.toLocal(),
  ),
];
  }

  PrayerTime calculateTomorrowFajr({
    required double latitude,
    required double longitude,
    required DateTime date,
  }) {
    final tomorrow = DateTime(
      date.year,
      date.month,
      date.day + 1,
    );

    final tomorrowPrayers = calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: tomorrow,
    );

    return tomorrowPrayers.firstWhere(
      (prayer) => prayer.type == PrayerType.fajr,
    );
  }
}