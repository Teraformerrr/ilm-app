class TafsirEntry {
  const TafsirEntry({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.sourceId,
    required this.sourceName,
    required this.languageCode,
  });

  final int surahNumber;
  final int ayahNumber;

  final String text;

  final String sourceId;
  final String sourceName;

  final String languageCode;

  String get reference {
    return '$surahNumber:$ayahNumber';
  }

  bool get isEnglish {
    return languageCode.toLowerCase() == 'en';
  }

  bool get isUrdu {
    return languageCode.toLowerCase() == 'ur';
  }

  factory TafsirEntry.fromJson(Map<String, dynamic> json) {
    final surahNumber = json['surahNumber'];

    final ayahNumber = json['ayahNumber'];

    final text = json['text'];

    final sourceId = json['sourceId'];

    final sourceName = json['sourceName'];

    final languageCode = json['languageCode'];

    if (surahNumber is! int ||
        ayahNumber is! int ||
        text is! String ||
        sourceId is! String ||
        sourceName is! String ||
        languageCode is! String) {
      throw const FormatException('Invalid Tafsir entry.');
    }

    if (surahNumber < 1 || surahNumber > 114) {
      throw FormatException('Invalid Tafsir Surah number: $surahNumber');
    }

    if (ayahNumber < 1) {
      throw FormatException('Invalid Tafsir Ayah number: $ayahNumber');
    }

    if (text.trim().isEmpty) {
      throw FormatException(
        'Tafsir entry $surahNumber:$ayahNumber contains empty text.',
      );
    }

    if (sourceName.trim().isEmpty) {
      throw FormatException(
        'Tafsir entry $surahNumber:$ayahNumber has no source name.',
      );
    }

    return TafsirEntry(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      text: text.trim(),
      sourceId: sourceId.trim(),
      sourceName: sourceName.trim(),
      languageCode: languageCode.trim(),
    );
  }
}
