import 'package:shared_preferences/shared_preferences.dart';

import '../models/quran_reader_preferences.dart';

class QuranReaderPreferencesService {
  const QuranReaderPreferencesService();

  static const String _showEnglishKey =
      'quran_reader_show_english';

  static const String _showUrduKey =
      'quran_reader_show_urdu';

  static const String _arabicFontSizeKey =
      'quran_reader_arabic_font_size';

  static const String _englishFontSizeKey =
      'quran_reader_english_font_size';

  static const String _urduFontSizeKey =
      'quran_reader_urdu_font_size';

  Future<QuranReaderPreferences> loadPreferences() async {
    final preferences =
        await SharedPreferences.getInstance();

    return QuranReaderPreferences(
      showEnglish:
          preferences.getBool(_showEnglishKey) ?? true,
      showUrdu:
          preferences.getBool(_showUrduKey) ?? false,
      arabicFontSize:
          preferences.getDouble(_arabicFontSizeKey) ??
              26.0,
      englishFontSize:
          preferences.getDouble(_englishFontSizeKey) ??
              16.0,
      urduFontSize:
          preferences.getDouble(_urduFontSizeKey) ??
              18.0,
    );
  }

  Future<void> saveShowEnglish(
    bool value,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setBool(
      _showEnglishKey,
      value,
    );
  }

  Future<void> saveShowUrdu(
    bool value,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setBool(
      _showUrduKey,
      value,
    );
  }

  Future<void> saveArabicFontSize(
    double value,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setDouble(
      _arabicFontSizeKey,
      value,
    );
  }

  Future<void> saveEnglishFontSize(
    double value,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setDouble(
      _englishFontSizeKey,
      value,
    );
  }

  Future<void> saveUrduFontSize(
    double value,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.setDouble(
      _urduFontSizeKey,
      value,
    );
  }
}