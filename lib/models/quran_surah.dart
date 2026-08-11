class QuranSurah {
  const QuranSurah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.translatedName,
    required this.revelationType,
    required this.ayahCount,
  });

  final int number;
  final String arabicName;
  final String englishName;
  final String translatedName;
  final String revelationType;
  final int ayahCount;
}