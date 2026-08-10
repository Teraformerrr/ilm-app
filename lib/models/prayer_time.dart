enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  tahajjud,
}

class PrayerTime {
  final PrayerType type;
  final DateTime time;

  const PrayerTime({
    required this.type,
    required this.time,
  });

  String get name {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
      case PrayerType.tahajjud:
        return 'Tahajjud';
    }
  }

  bool get isPrayer =>
      type != PrayerType.sunrise && type != PrayerType.tahajjud;
}