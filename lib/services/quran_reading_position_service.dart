import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quran_reading_position.dart';

class QuranReadingPositionService {
  const QuranReadingPositionService();

  static const String _readingPositionKey =
      'quran_reading_position';

  Future<QuranReadingPosition?> loadPosition() async {
    final preferences =
        await SharedPreferences.getInstance();

    final rawPosition =
        preferences.getString(
      _readingPositionKey,
    );

    if (rawPosition == null ||
        rawPosition.isEmpty) {
      return null;
    }

    try {
      final decoded =
          jsonDecode(rawPosition);

      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      return QuranReadingPosition.fromJson(
        decoded,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> savePosition({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    final position =
        QuranReadingPosition(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      updatedAt: DateTime.now(),
    );

    await preferences.setString(
      _readingPositionKey,
      jsonEncode(
        position.toJson(),
      ),
    );
  }

  Future<void> clearPosition() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _readingPositionKey,
    );
  }
}