class TafsirSavedItem {
  const TafsirSavedItem({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.savedAt,
  });

  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final DateTime savedAt;

  String get id => '$surahNumber:$ayahNumber';

  String get reference => '$surahName • $surahNumber:$ayahNumber';

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'ayahNumber': ayahNumber,
      'surahName': surahName,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory TafsirSavedItem.fromJson(Map<String, dynamic> json) {
    return TafsirSavedItem(
      surahNumber: json['surahNumber'] as int,
      ayahNumber: json['ayahNumber'] as int,
      surahName: json['surahName'] as String,
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
