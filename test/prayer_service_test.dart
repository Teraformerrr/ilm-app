import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/models/prayer_time.dart';
import 'package:ilm/services/prayer_service.dart';
void main() {
  const prayerService = PrayerService();

  final testDate = DateTime(2026, 8, 11);

  final prayerTimes = [
    PrayerTime(
      type: PrayerType.fajr,
      time: DateTime(2026, 8, 11, 4, 30),
    ),
    PrayerTime(
      type: PrayerType.sunrise,
      time: DateTime(2026, 8, 11, 5, 50),
    ),
    PrayerTime(
      type: PrayerType.dhuhr,
      time: DateTime(2026, 8, 11, 12, 30),
    ),
    PrayerTime(
      type: PrayerType.asr,
      time: DateTime(2026, 8, 11, 15, 50),
    ),
    PrayerTime(
      type: PrayerType.maghrib,
      time: DateTime(2026, 8, 11, 19, 0),
    ),
    PrayerTime(
      type: PrayerType.isha,
      time: DateTime(2026, 8, 11, 20, 20),
    ),
  ];

  test('returns Fajr before Fajr', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 3)),
    );

    expect(result?.type, PrayerType.fajr);
  });

  test('skips Sunrise and returns Dhuhr after Fajr', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 6)),
    );

    expect(result?.type, PrayerType.dhuhr);
  });

  test('returns Asr after Dhuhr', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 13)),
    );

    expect(result?.type, PrayerType.asr);
  });

  test('returns Maghrib after Asr', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 17)),
    );

    expect(result?.type, PrayerType.maghrib);
  });

  test('returns Isha after Maghrib', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 19, minutes: 30)),
    );

    expect(result?.type, PrayerType.isha);
  });

  test('returns null after Isha', () {
    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      now: testDate.add(const Duration(hours: 22)),
    );

    expect(result, isNull);
  });

  test('returns tomorrow Fajr after Isha when provided', () {
    final tomorrowFajr = PrayerTime(
      type: PrayerType.fajr,
      time: DateTime(2026, 8, 12, 4, 31),
    );

    final result = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      tomorrowFajr: tomorrowFajr,
      now: DateTime(2026, 8, 11, 22),
    );

    expect(result?.type, PrayerType.fajr);
    expect(result?.time, DateTime(2026, 8, 12, 4, 31));
  });
}