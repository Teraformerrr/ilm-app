class TahajjudWindow {
  const TahajjudWindow({
    required this.islamicMidnight,
    required this.lastThirdStart,
    required this.fajr,
  });

  final DateTime islamicMidnight;
  final DateTime lastThirdStart;
  final DateTime fajr;
}

class TahajjudService {
  const TahajjudService();

  TahajjudWindow calculate({
    required DateTime maghrib,
    required DateTime nextFajr,
  }) {
    final nightDuration = nextFajr.difference(maghrib);

    final islamicMidnight = maghrib.add(
      Duration(
        milliseconds: nightDuration.inMilliseconds ~/ 2,
      ),
    );

    final lastThirdStart = maghrib.add(
      Duration(
        milliseconds: (nightDuration.inMilliseconds * 2) ~/ 3,
      ),
    );

    return TahajjudWindow(
      islamicMidnight: islamicMidnight,
      lastThirdStart: lastThirdStart,
      fajr: nextFajr,
    );
  }
}