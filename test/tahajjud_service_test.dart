import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/tahajjud_service.dart';

void main() {
  const service = TahajjudService();

  test('calculates Islamic midnight and last third correctly', () {
    final maghrib = DateTime(2026, 8, 11, 19, 0);
    final nextFajr = DateTime(2026, 8, 12, 4, 30);

    final result = service.calculate(
      maghrib: maghrib,
      nextFajr: nextFajr,
    );

    expect(
      result.islamicMidnight,
      DateTime(2026, 8, 11, 23, 45),
    );

    expect(
      result.lastThirdStart,
      DateTime(2026, 8, 12, 1, 20),
    );

    expect(
      result.fajr,
      nextFajr,
    );
  });
}