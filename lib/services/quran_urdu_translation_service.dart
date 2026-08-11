import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quran_translation.dart';

class QuranUrduTranslationService {
  const QuranUrduTranslationService();

  Future<List<QuranTranslation>>
      loadJunagarhiTranslations() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/quran_urdu_junagarhi.json',
    );

    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException(
        'Urdu Qur’an translation data must be a JSON list.',
      );
    }

    final translations = decoded.map<QuranTranslation>(
      (item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid Urdu Qur’an translation entry.',
          );
        }

        return QuranTranslation(
          surahNumber: item['surahNumber'] as int,
          ayahNumber: item['ayahNumber'] as int,
          text: item['translation'] as String,
        );
      },
    ).toList();

    if (translations.length != 6236) {
      throw FormatException(
        'Expected 6236 Urdu translations, '
        'found ${translations.length}.',
      );
    }

    return translations;
  }

  Future<List<QuranTranslation>>
      loadSurahTranslations(
    int surahNumber,
  ) async {
    if (surahNumber < 1 || surahNumber > 114) {
      throw ArgumentError.value(
        surahNumber,
        'surahNumber',
        'Surah number must be between 1 and 114.',
      );
    }

    final translations =
        await loadJunagarhiTranslations();

    return translations
        .where(
          (translation) =>
              translation.surahNumber == surahNumber,
        )
        .toList()
      ..sort(
        (a, b) => a.ayahNumber.compareTo(
          b.ayahNumber,
        ),
      );
  }
}