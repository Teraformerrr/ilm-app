import 'package:shared_preferences/shared_preferences.dart';

import '../models/quran_reader_preferences.dart';

class QuranReaderPreferencesService {
  const QuranReaderPreferencesService();

  static const String _showEnglishKey =
      'quran_reader_show_english';

  static const String _arabicFontSizeKey =
      'quran_reader_arabic_font_size';

  static const String _englishFontSizeKey =
      'quran_reader_english_font_size';

  Future<QuranReaderPreferences> loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();

    return QuranReaderPreferences(
      showEnglish:
          preferences.getBool(_showEnglishKey) ?? true,
      arabicFontSize:
          preferences.getDouble(_arabicFontSizeKey) ?? 26.0,
      englishFontSize:
          preferences.getDouble(_englishFontSizeKey) ?? 16.0,
    );
  }

  Future<void> saveShowEnglish(
    bool value,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(
      _showEnglishKey,
      value,
    );
  }

  Future<void> saveArabicFontSize(
    double value,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setDouble(
      _arabicFontSizeKey,
      value,
    );
  }

  Future<void> saveEnglishFontSize(
    double value,
  ) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setDouble(
      _englishFontSizeKey,
      value,
    );
  }
}