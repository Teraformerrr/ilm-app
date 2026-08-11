import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/quran_surah.dart';

class QuranMetadataService {
  const QuranMetadataService();

  Future<List<QuranSurah>> loadSurahs() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/quran_surahs.json',
    );

    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException(
        'Qur’an Surah metadata must be a JSON list.',
      );
    }

    final surahs = decoded.map<QuranSurah>(
      (item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid Surah metadata entry.',
          );
        }

        return QuranSurah(
          number: item['number'] as int,
          arabicName: item['arabicName'] as String,
          englishName: item['englishName'] as String,
          translatedName: item['translatedName'] as String,
          revelationType: item['revelationType'] as String,
          ayahCount: item['ayahCount'] as int,
        );
      },
    ).toList();

    if (surahs.length != 114) {
      throw FormatException(
        'Expected 114 Surahs, found ${surahs.length}.',
      );
    }

    final totalAyahs = surahs.fold<int>(
      0,
      (total, surah) => total + surah.ayahCount,
    );

    if (totalAyahs != 6236) {
      throw FormatException(
        'Expected 6236 numbered Ayahs, found $totalAyahs.',
      );
    }

    return surahs;
  }
}