import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_reading_position_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service =
      QuranReadingPositionService();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts with no reading position', () async {
    final position =
        await service.loadPosition();

    expect(position, isNull);
  });

  test('saves and loads reading position', () async {
    await service.savePosition(
      surahNumber: 2,
      ayahNumber: 255,
      surahName: 'Al-Baqarah',
    );

    final position =
        await service.loadPosition();

    expect(position, isNotNull);
    expect(position!.surahNumber, 2);
    expect(position.ayahNumber, 255);
    expect(position.surahName, 'Al-Baqarah');
  });

  test('overwrites previous reading position', () async {
    await service.savePosition(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
    );

    await service.savePosition(
      surahNumber: 18,
      ayahNumber: 10,
      surahName: 'Al-Kahf',
    );

    final position =
        await service.loadPosition();

    expect(position, isNotNull);
    expect(position!.surahNumber, 18);
    expect(position.ayahNumber, 10);
    expect(position.surahName, 'Al-Kahf');
  });

  test('clears reading position', () async {
    await service.savePosition(
      surahNumber: 112,
      ayahNumber: 1,
      surahName: 'Al-Ikhlas',
    );

    await service.clearPosition();

    final position =
        await service.loadPosition();

    expect(position, isNull);
  });

  test('invalid stored data returns null', () async {
    SharedPreferences.setMockInitialValues({
      'quran_reading_position':
          'not-valid-json',
    });

    final position =
        await service.loadPosition();

    expect(position, isNull);
  });
}