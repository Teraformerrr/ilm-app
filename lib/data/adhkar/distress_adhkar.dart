import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> distressAdhkar = [
  DuaAdhkarItem(
    id: 'distress_yunus',
    title: 'Dua of Prophet Yunus',
    categoryId: 'distress',
    arabic:
        'لَا إِلَهَ إِلَّا أَنْتَ '
        'سُبْحَانَكَ '
        'إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
    transliteration:
        'La ilaha illa Anta, '
        'subhanaka, '
        'inni kuntu minaz-zalimin.',
    englishTranslation:
        'There is no deity worthy of worship except You. '
        'Glory be to You. '
        'Indeed, I have been among the wrongdoers.',
    urduTranslation:
        'تیرے سوا کوئی معبود برحق نہیں۔ '
        'تو پاک ہے۔ '
        'بے شک میں ہی ظالموں میں سے تھا۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 21:87',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 21,
      startAyah: 87,
    ),
    notes:
        'The supplication of Prophet Yunus عليه السلام while in distress.',
    occasions: [
      DuaOccasion.distress,
      DuaOccasion.forgiveness,
    ],
    tags: [
      'distress',
      'difficulty',
      'Yunus',
      'repentance',
    ],
  ),

  DuaAdhkarItem(
    id: 'distress_hasbunallah',
    title: 'Allah Is Sufficient for Us',
    categoryId: 'distress',
    arabic:
        'حَسْبُنَا اللَّهُ '
        'وَنِعْمَ الْوَكِيلُ',
    transliteration:
        'Hasbunallahu wa ni‘mal-wakil.',
    englishTranslation:
        'Allah is sufficient for us, '
        'and He is the best Disposer of affairs.',
    urduTranslation:
        'ہمارے لیے اللہ کافی ہے '
        'اور وہ بہترین کارساز ہے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 3:173',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 3,
      startAyah: 173,
    ),
    occasions: [
      DuaOccasion.distress,
      DuaOccasion.protection,
    ],
    tags: [
      'distress',
      'fear',
      'tawakkul',
      'reliance',
      'protection',
    ],
    isProtection: true,
  ),
];