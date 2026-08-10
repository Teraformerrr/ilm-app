import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/models/prayer_time.dart';
import 'package:ilm/services/prayer_calculation_service.dart';

void main() {
  const service = PrayerCalculationService();

  test('calculates all six daily prayer-related times', () {
    final prayers = service.calculatePrayerTimes(
      latitude: 25.2048,
      longitude: 55.2708,
      date: DateTime(2026, 8, 11),
    );

    expect(prayers.length, 6);

    expect(prayers[0].type, PrayerType.fajr);
    expect(prayers[1].type, PrayerType.sunrise);
    expect(prayers[2].type, PrayerType.dhuhr);
    expect(prayers[3].type, PrayerType.asr);
    expect(prayers[4].type, PrayerType.maghrib);
    expect(prayers[5].type, PrayerType.isha);
  });

  test('calculated prayer times are in chronological order', () {
    final prayers = service.calculatePrayerTimes(
      latitude: 25.2048,
      longitude: 55.2708,
      date: DateTime(2026, 8, 11),
    );

    for (var i = 0; i < prayers.length - 1; i++) {
      expect(
        prayers[i].time.isBefore(prayers[i + 1].time),
        isTrue,
      );
    }
  });
}