class DailyWidgetContent {
  const DailyWidgetContent({
    required this.date,
    required this.ayahArabic,
    required this.ayahTranslation,
    required this.ayahReference,
    required this.surahNumber,
    required this.ayahNumber,
    required this.hadithText,
    required this.hadithReference,
  });

  final DateTime date;

  final String ayahArabic;

  final String ayahTranslation;

  final String ayahReference;

  final int surahNumber;

  final int ayahNumber;

  final String hadithText;

  final String hadithReference;

  String get dateKey {
    final year = date.year.toString().padLeft(4, '0');

    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'dateKey': dateKey,
      'ayahArabic': ayahArabic,
      'ayahTranslation': ayahTranslation,
      'ayahReference': ayahReference,
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'hadithText': hadithText,
      'hadithReference': hadithReference,
    };
  }

  factory DailyWidgetContent.fromJson(Map<String, dynamic> json) {
    return DailyWidgetContent(
      date: DateTime.parse(json['date'] as String),
      ayahArabic: json['ayahArabic'] as String,
      ayahTranslation: json['ayahTranslation'] as String,
      ayahReference: json['ayahReference'] as String,
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      hadithText: json['hadithText'] as String,
      hadithReference: json['hadithReference'] as String,
    );
  }
}
