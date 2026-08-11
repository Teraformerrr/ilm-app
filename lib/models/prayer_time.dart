enum PrayerType {
  fajr,
  sunrise,
  dhuhr,
  asr,
  maghrib,
  isha,
  tahajjud,
}

class PrayerRakahPart {
  final String label;
  final int rakah;

  const PrayerRakahPart({
    required this.label,
    required this.rakah,
  });
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

  int? get fardRakah {
    switch (type) {
      case PrayerType.fajr:
        return 2;
      case PrayerType.dhuhr:
        return 4;
      case PrayerType.asr:
        return 4;
      case PrayerType.maghrib:
        return 3;
      case PrayerType.isha:
        return 4;
      case PrayerType.sunrise:
      case PrayerType.tahajjud:
        return null;
    }
  }

  List<PrayerRakahPart> get rakahBreakdown {
    switch (type) {
      case PrayerType.fajr:
        return const [
          PrayerRakahPart(
            label: 'Sunnah Mu’akkadah',
            rakah: 2,
          ),
          PrayerRakahPart(
            label: 'Fard',
            rakah: 2,
          ),
        ];

      case PrayerType.dhuhr:
        return const [
          PrayerRakahPart(
            label: 'Sunnah Mu’akkadah',
            rakah: 4,
          ),
          PrayerRakahPart(
            label: 'Fard',
            rakah: 4,
          ),
          PrayerRakahPart(
            label: 'Sunnah Mu’akkadah',
            rakah: 2,
          ),
        ];

      case PrayerType.asr:
        return const [
          PrayerRakahPart(
            label: 'Fard',
            rakah: 4,
          ),
        ];

      case PrayerType.maghrib:
        return const [
          PrayerRakahPart(
            label: 'Fard',
            rakah: 3,
          ),
          PrayerRakahPart(
            label: 'Sunnah Mu’akkadah',
            rakah: 2,
          ),
        ];

      case PrayerType.isha:
        return const [
          PrayerRakahPart(
            label: 'Fard',
            rakah: 4,
          ),
          PrayerRakahPart(
            label: 'Sunnah Mu’akkadah',
            rakah: 2,
          ),
          PrayerRakahPart(
            label: 'Witr',
            rakah: 3,
          ),
        ];

      case PrayerType.sunrise:
      case PrayerType.tahajjud:
        return const [];
    }
  }

  bool get isPrayer =>
      type != PrayerType.sunrise && type != PrayerType.tahajjud;
}