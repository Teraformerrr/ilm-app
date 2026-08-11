import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_translation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = QuranTranslationService();

  test('loads all 6236 Pickthall translations', () async {
    final translations =
        await service.loadPickthallTranslations();

    expect(
      translations.length,
      6236,
    );
  });

  test('Surah 1 contains 7 translations', () async {
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

  test('Surah 114 contains 6 translations', () async {
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

  test('every translation contains text', () async {
    final translations =
        await service.loadPickthallTranslations();

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