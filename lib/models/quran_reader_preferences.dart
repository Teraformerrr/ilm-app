class QuranReaderPreferences {
  const QuranReaderPreferences({
    this.showEnglish = true,
    this.showUrdu = false,
    this.arabicFontSize = 26.0,
    this.englishFontSize = 16.0,
    this.urduFontSize = 18.0,
  });

  final bool showEnglish;
  final bool showUrdu;

  final double arabicFontSize;
  final double englishFontSize;
  final double urduFontSize;

  QuranReaderPreferences copyWith({
    bool? showEnglish,
    bool? showUrdu,
    double? arabicFontSize,
    double? englishFontSize,
    double? urduFontSize,
  }) {
    return QuranReaderPreferences(
      showEnglish:
          showEnglish ?? this.showEnglish,
      showUrdu:
          showUrdu ?? this.showUrdu,
      arabicFontSize:
          arabicFontSize ?? this.arabicFontSize,
      englishFontSize:
          englishFontSize ?? this.englishFontSize,
      urduFontSize:
          urduFontSize ?? this.urduFontSize,
    );
  }
}