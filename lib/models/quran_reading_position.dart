class QuranReadingPosition {
  const QuranReadingPosition({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.updatedAt,
  });

  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory QuranReadingPosition.fromJson(
    Map<String, dynamic> json,
  ) {
    final surahNumber = json['surahNumber'];
    final ayahNumber = json['ayahNumber'];
    final surahName = json['surahName'];
    final updatedAt = json['updatedAt'];

    if (surahNumber is! int ||
        ayahNumber is! int ||
        surahName is! String ||
        updatedAt is! String) {
      throw const FormatException(
        'Invalid Qur’an reading position data.',
      );
    }

    if (surahNumber < 1 || surahNumber > 114) {
      throw const FormatException(
        'Invalid reading position Surah number.',
      );
    }

    if (ayahNumber < 1) {
      throw const FormatException(
        'Invalid reading position Ayah number.',
      );
    }

    final parsedUpdatedAt =
        DateTime.tryParse(updatedAt);

    if (parsedUpdatedAt == null) {
      throw const FormatException(
        'Invalid reading position date.',
      );
    }

    return QuranReadingPosition(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      updatedAt: parsedUpdatedAt,
    );
  }
}