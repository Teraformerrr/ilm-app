import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_metadata_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = QuranMetadataService();

  test('loads all 114 Surahs in sequence', () async {
    final surahs = await service.loadSurahs();

    expect(surahs.length, 114);

    for (var index = 0; index < surahs.length; index++) {
      expect(
        surahs[index].number,
        index + 1,
      );
    }
  });

  test('contains 6236 numbered Ayahs', () async {
    final surahs = await service.loadSurahs();

    final totalAyahs = surahs.fold<int>(
      0,
      (total, surah) => total + surah.ayahCount,
    );

    expect(totalAyahs, 6236);
  });

  test('first and last Surah metadata are present', () async {
    final surahs = await service.loadSurahs();

    expect(surahs.first.number, 1);
    expect(surahs.first.arabicName.isNotEmpty, isTrue);
    expect(surahs.first.englishName.isNotEmpty, isTrue);

    expect(surahs.last.number, 114);
    expect(surahs.last.arabicName.isNotEmpty, isTrue);
    expect(surahs.last.englishName.isNotEmpty, isTrue);
  });

  test('every Surah has valid metadata', () async {
    final surahs = await service.loadSurahs();

    for (final surah in surahs) {
      expect(surah.number, inInclusiveRange(1, 114));
      expect(surah.ayahCount, greaterThan(0));
      expect(surah.arabicName.trim(), isNotEmpty);
      expect(surah.englishName.trim(), isNotEmpty);
      expect(surah.translatedName.trim(), isNotEmpty);
      expect(surah.revelationType.trim(), isNotEmpty);
    }
  });
}