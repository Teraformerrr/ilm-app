class QuranBookmark {
  const QuranBookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.createdAt,
  });

  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final DateTime createdAt;

  String get id => '$surahNumber:$ayahNumber';

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QuranBookmark.fromJson(
    Map<String, dynamic> json,
  ) {
    final surahNumber = json['surahNumber'];
    final ayahNumber = json['ayahNumber'];
    final surahName = json['surahName'];
    final createdAt = json['createdAt'];

    if (surahNumber is! int ||
        ayahNumber is! int ||
        surahName is! String ||
        createdAt is! String) {
      throw const FormatException(
        'Invalid Qur’an bookmark data.',
      );
    }

    if (surahNumber < 1 || surahNumber > 114) {
      throw const FormatException(
        'Invalid bookmark Surah number.',
      );
    }

    if (ayahNumber < 1) {
      throw const FormatException(
        'Invalid bookmark Ayah number.',
      );
    }

    final parsedCreatedAt =
        DateTime.tryParse(createdAt);

    if (parsedCreatedAt == null) {
      throw const FormatException(
        'Invalid bookmark creation date.',
      );
    }

    return QuranBookmark(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      createdAt: parsedCreatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is QuranBookmark &&
        other.surahNumber == surahNumber &&
        other.ayahNumber == ayahNumber;
  }

  @override
  int get hashCode =>
      Object.hash(
        surahNumber,
        ayahNumber,
      );
}