import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> protectionAdhkar = [
  DuaAdhkarItem(
    id: 'protection_allahs_perfect_words',
    title: 'Seek Refuge in Allah’s Perfect Words',
    categoryId: 'protection',
    arabic:
        'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ '
        'مِنْ شَرِّ مَا خَلَقَ',
    transliteration:
        'A‘udhu bikalimatillahit-tammati '
        'min sharri ma khalaq.',
    englishTranslation:
        'I seek refuge in the perfect words of Allah '
        'from the evil of what He has created.',
    urduTranslation:
        'میں اللہ کے کامل کلمات کی پناہ مانگتا ہوں '
        'اس کی مخلوق کے شر سے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 2708',
    repeatCount: 1,
    notes:
        'Among its established uses is when stopping at a place during a journey.',
    occasions: [
      DuaOccasion.protection,
      DuaOccasion.travel,
    ],
    tags: [
      'protection',
      'travel',
      'staying somewhere',
      'evil',
    ],
    isProtection: true,
    isPropheticDua: true,
    isSharedAcrossCollections: true,
  ),

  DuaAdhkarItem(
    id: 'protection_hasbunallah',
    title: 'Allah Is Sufficient',
    categoryId: 'protection',
    arabic:
        'حَسْبُنَا اللَّهُ '
        'وَنِعْمَ الْوَكِيلُ',
    transliteration:
        'Hasbunallahu wa ni‘mal-wakil.',
    englishTranslation:
        'Allah is sufficient for us '
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
      DuaOccasion.protection,
      DuaOccasion.distress,
    ],
    tags: [
      'protection',
      'fear',
      'tawakkul',
      'distress',
    ],
    isProtection: true,
    isSharedAcrossCollections: true,
  ),
];