import '../data/home_hadiths.dart';
import '../models/daily_widget_content.dart';

class DailyWidgetContentService {
  const DailyWidgetContentService();

  static const List<_WidgetAyah> _widgetAyahs = [
    _WidgetAyah(
      surahNumber: 2,
      ayahNumber: 152,
      surahName: 'Al-Baqarah',
      arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ وَاشْكُرُوا لِي وَلَا تَكْفُرُونِ',
      translation:
          'Therefore remember Me; I will remember you. Give thanks to Me, and do not be ungrateful to Me.',
    ),

    _WidgetAyah(
      surahNumber: 2,
      ayahNumber: 186,
      surahName: 'Al-Baqarah',
      arabic: 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ',
      translation:
          'And when My servants question thee concerning Me, then surely I am nigh.',
    ),

    _WidgetAyah(
      surahNumber: 2,
      ayahNumber: 286,
      surahName: 'Al-Baqarah',
      arabic: 'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا',
      translation: 'Allah tasketh not a soul beyond its scope.',
    ),

    _WidgetAyah(
      surahNumber: 3,
      ayahNumber: 139,
      surahName: 'Aal-E-Imran',
      arabic:
          'وَلَا تَهِنُوا وَلَا تَحْزَنُوا وَأَنْتُمُ الْأَعْلَوْنَ إِنْ كُنْتُمْ مُؤْمِنِينَ',
      translation:
          'Faint not nor grieve, for ye will overcome them if ye are believers.',
    ),

    _WidgetAyah(
      surahNumber: 3,
      ayahNumber: 159,
      surahName: 'Aal-E-Imran',
      arabic: 'إِنَّ اللَّهَ يُحِبُّ الْمُتَوَكِّلِينَ',
      translation: 'Lo! Allah loveth those who put their trust in Him.',
    ),

    _WidgetAyah(
      surahNumber: 8,
      ayahNumber: 2,
      surahName: 'Al-Anfal',
      arabic:
          'إِنَّمَا الْمُؤْمِنُونَ الَّذِينَ إِذَا ذُكِرَ اللَّهُ وَجِلَتْ قُلُوبُهُمْ',
      translation:
          'They only are the true believers whose hearts feel fear when Allah is mentioned.',
    ),

    _WidgetAyah(
      surahNumber: 13,
      ayahNumber: 28,
      surahName: 'Ar-Ra\'d',
      arabic: 'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
      translation: 'Verily in the remembrance of Allah do hearts find rest.',
    ),

    _WidgetAyah(
      surahNumber: 14,
      ayahNumber: 7,
      surahName: 'Ibrahim',
      arabic: 'لَئِنْ شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
      translation: 'If ye give thanks, I will give you more.',
    ),

    _WidgetAyah(
      surahNumber: 20,
      ayahNumber: 46,
      surahName: 'Ta-Ha',
      arabic: 'لَا تَخَافَا إِنَّنِي مَعَكُمَا أَسْمَعُ وَأَرَى',
      translation: 'Fear not. Lo! I am with you twain, Hearing and Seeing.',
    ),

    _WidgetAyah(
      surahNumber: 29,
      ayahNumber: 69,
      surahName: 'Al-Ankabut',
      arabic: 'وَالَّذِينَ جَاهَدُوا فِينَا لَنَهْدِيَنَّهُمْ سُبُلَنَا',
      translation:
          'As for those who strive in Us, We surely guide them to Our paths.',
    ),

    _WidgetAyah(
      surahNumber: 39,
      ayahNumber: 53,
      surahName: 'Az-Zumar',
      arabic: 'لَا تَقْنَطُوا مِنْ رَحْمَةِ اللَّهِ',
      translation: 'Despair not of the mercy of Allah.',
    ),

    _WidgetAyah(
      surahNumber: 65,
      ayahNumber: 2,
      surahName: 'At-Talaq',
      arabic: 'وَمَنْ يَتَّقِ اللَّهَ يَجْعَلْ لَهُ مَخْرَجًا',
      translation:
          'Whosoever keepeth his duty to Allah, Allah will appoint a way out for him.',
    ),

    _WidgetAyah(
      surahNumber: 65,
      ayahNumber: 3,
      surahName: 'At-Talaq',
      arabic: 'وَمَنْ يَتَوَكَّلْ عَلَى اللَّهِ فَهُوَ حَسْبُهُ',
      translation: 'Whosoever putteth his trust in Allah, He will suffice him.',
    ),

    _WidgetAyah(
      surahNumber: 94,
      ayahNumber: 5,
      surahName: 'Ash-Sharh',
      arabic: 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translation: 'But lo! with hardship goeth ease.',
    ),

    _WidgetAyah(
      surahNumber: 94,
      ayahNumber: 6,
      surahName: 'Ash-Sharh',
      arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
      translation: 'Lo! with hardship goeth ease.',
    ),
  ];

  DailyWidgetContent getContentForDate(DateTime date) {
    if (_widgetAyahs.isEmpty) {
      throw StateError('Daily widget Ayah library is empty.');
    }

    if (homeHadiths.isEmpty) {
      throw StateError('Home Hadith library is empty.');
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);

    final dayIndex = normalizedDate.difference(DateTime(2026, 1, 1)).inDays;

    final ayahIndex = _safeModulo(dayIndex, _widgetAyahs.length);

    final hadithIndex = _safeModulo(dayIndex * 7 + 3, homeHadiths.length);

    final ayah = _widgetAyahs[ayahIndex];

    final hadith = homeHadiths[hadithIndex];

    return DailyWidgetContent(
      date: normalizedDate,
      ayahArabic: ayah.arabic,
      ayahTranslation: ayah.translation,
      ayahReference:
          '${ayah.surahName} '
          '${ayah.surahNumber}:${ayah.ayahNumber}',
      surahNumber: ayah.surahNumber,
      ayahNumber: ayah.ayahNumber,
      hadithText: hadith.text,
      hadithReference: hadith.source,
    );
  }

  DailyWidgetContent getTodayContent() {
    return getContentForDate(DateTime.now());
  }

  DailyWidgetContent getTomorrowContent() {
    final now = DateTime.now();

    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    return getContentForDate(tomorrow);
  }

  int _safeModulo(int value, int length) {
    return (value % length + length) % length;
  }
}

class _WidgetAyah {
  const _WidgetAyah({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.arabic,
    required this.translation,
  });

  final int surahNumber;

  final int ayahNumber;

  final String surahName;

  final String arabic;

  final String translation;
}
