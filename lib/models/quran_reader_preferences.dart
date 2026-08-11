class QuranReaderPreferences {
  const QuranReaderPreferences({
    this.showEnglish = true,
    this.arabicFontSize = 26.0,
    this.englishFontSize = 16.0,
  });

  final bool showEnglish;
  final double arabicFontSize;
  final double englishFontSize;

  QuranReaderPreferences copyWith({
    bool? showEnglish,
    double? arabicFontSize,
    double? englishFontSize,
  }) {
    return QuranReaderPreferences(
      showEnglish: showEnglish ?? this.showEnglish,
      arabicFontSize:
          arabicFontSize ?? this.arabicFontSize,
      englishFontSize:
          englishFontSize ?? this.englishFontSize,
    );
  }
}