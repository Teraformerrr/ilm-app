import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/models/prayer_time.dart';

void main() {
  group('Prayer rakah data', () {
    PrayerTime prayer(PrayerType type) {
      return PrayerTime(
        type: type,
        time: DateTime(2026, 8, 11),
      );
    }

    test('Fard rakah counts are correct', () {
      expect(prayer(PrayerType.fajr).fardRakah, 2);
      expect(prayer(PrayerType.dhuhr).fardRakah, 4);
      expect(prayer(PrayerType.asr).fardRakah, 4);
      expect(prayer(PrayerType.maghrib).fardRakah, 3);
      expect(prayer(PrayerType.isha).fardRakah, 4);
    });

    test('Sunrise and Tahajjud have no Fard rakah', () {
      expect(prayer(PrayerType.sunrise).fardRakah, isNull);
      expect(prayer(PrayerType.tahajjud).fardRakah, isNull);
    });

    test('Fajr breakdown is correct', () {
      final breakdown = prayer(PrayerType.fajr).rakahBreakdown;

      expect(breakdown.length, 2);
      expect(breakdown[0].rakah, 2);
      expect(breakdown[0].label, 'Sunnah Mu’akkadah');
      expect(breakdown[1].rakah, 2);
      expect(breakdown[1].label, 'Fard');
    });

    test('Dhuhr breakdown is correct', () {
      final breakdown = prayer(PrayerType.dhuhr).rakahBreakdown;

      expect(breakdown.length, 3);
      expect(breakdown[0].rakah, 4);
      expect(breakdown[1].rakah, 4);
      expect(breakdown[1].label, 'Fard');
      expect(breakdown[2].rakah, 2);
    });

    test('Isha breakdown includes Witr', () {
      final breakdown = prayer(PrayerType.isha).rakahBreakdown;

      expect(
        breakdown.any(
          (part) => part.label == 'Witr' && part.rakah == 3,
        ),
        isTrue,
      );
    });
  });
}