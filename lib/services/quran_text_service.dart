import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quran_ayah.dart';

class QuranTextService {
  const QuranTextService();

  Future<List<QuranAyah>> loadAllAyahs() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/quran_ayahs.json',
    );

    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException(
        'Qur’an Ayah data must be a JSON list.',
      );
    }

    final ayahs = decoded.map<QuranAyah>(
      (item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid Qur’an Ayah entry.',
          );
        }

        return QuranAyah(
          surahNumber: item['surahNumber'] as int,
          ayahNumber: item['ayahNumber'] as int,
          arabicText: item['arabicText'] as String,
        );
      },
    ).toList();

    if (ayahs.length != 6236) {
      throw FormatException(
        'Expected 6236 Ayahs, found ${ayahs.length}.',
      );
    }

    return ayahs;
  }

  Future<List<QuranAyah>> loadSurahAyahs(
    int surahNumber,
  ) async {
    if (surahNumber < 1 || surahNumber > 114) {
      throw ArgumentError.value(
        surahNumber,
        'surahNumber',
        'Surah number must be between 1 and 114.',
      );
    }

    final ayahs = await loadAllAyahs();

    return ayahs
        .where(
          (ayah) => ayah.surahNumber == surahNumber,
        )
        .toList()
      ..sort(
        (a, b) => a.ayahNumber.compareTo(
          b.ayahNumber,
        ),
      );
  }
}