import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_text_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = QuranTextService();

  test('loads all 6236 numbered Ayahs', () async {
    final ayahs = await service.loadAllAyahs();

    expect(ayahs.length, 6236);
  });

  test('Surah 1 contains 7 Ayahs', () async {
    final ayahs = await service.loadSurahAyahs(1);

    expect(ayahs.length, 7);

    for (var index = 0; index < ayahs.length; index++) {
      expect(
        ayahs[index].ayahNumber,
        index + 1,
      );
    }
  });

  test('Surah 114 contains 6 Ayahs', () async {
    final ayahs = await service.loadSurahAyahs(114);

    expect(ayahs.length, 6);

    for (var index = 0; index < ayahs.length; index++) {
      expect(
        ayahs[index].ayahNumber,
        index + 1,
      );
    }
  });

  test('all Ayahs contain Arabic text', () async {
    final ayahs = await service.loadAllAyahs();

    for (final ayah in ayahs) {
      expect(
        ayah.arabicText.trim(),
        isNotEmpty,
      );
    }
  });

  test('invalid Surah numbers are rejected', () async {
    expect(
      () => service.loadSurahAyahs(0),
      throwsArgumentError,
    );

    expect(
      () => service.loadSurahAyahs(115),
      throwsArgumentError,
    );
  });
}