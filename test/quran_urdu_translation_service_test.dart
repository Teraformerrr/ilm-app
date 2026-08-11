import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_urdu_translation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = QuranUrduTranslationService();

  test('loads all 6236 Urdu translations', () async {
    final translations =
        await service.loadJunagarhiTranslations();

    expect(
      translations.length,
      6236,
    );
  });

  test('Surah 1 contains 7 Urdu translations', () async {
    final translations =
        await service.loadSurahTranslations(1);

    expect(
      translations.length,
      7,
    );

    for (var index = 0;
        index < translations.length;
        index++) {
      expect(
        translations[index].ayahNumber,
        index + 1,
      );
    }
  });

  test('Surah 114 contains 6 Urdu translations', () async {
    final translations =
        await service.loadSurahTranslations(114);

    expect(
      translations.length,
      6,
    );

    for (var index = 0;
        index < translations.length;
        index++) {
      expect(
        translations[index].ayahNumber,
        index + 1,
      );
    }
  });

  test('every Urdu translation contains text', () async {
    final translations =
        await service.loadJunagarhiTranslations();

    for (final translation in translations) {
      expect(
        translation.text.trim(),
        isNotEmpty,
      );
    }
  });

  test('invalid Surah numbers are rejected', () async {
    expect(
      () => service.loadSurahTranslations(0),
      throwsArgumentError,
    );

    expect(
      () => service.loadSurahTranslations(115),
      throwsArgumentError,
    );
  });
}