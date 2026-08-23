import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> socialDailyAdhkar = [
  DuaAdhkarItem(
    id: 'social_return_greeting',
    title: 'Returning a Greeting',
    categoryId: 'social_daily',
    arabic:
        'وَعَلَيْكُمُ السَّلَامُ '
        'وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
    transliteration:
        'Wa ‘alaykumus-salamu '
        'wa rahmatullahi wa barakatuh.',
    englishTranslation:
        'And upon you be peace, '
        'and the mercy of Allah and His blessings.',
    urduTranslation:
        'اور تم پر بھی سلامتی ہو، '
        'اور اللہ کی رحمت اور اس کی برکتیں ہوں۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 4:86',
    repeatCount: 1,
    notes:
        'Return a greeting with one equal to it or better.',
    quranLocation: QuranLocation(
      surahNumber: 4,
      startAyah: 86,
    ),
    occasions: [
      DuaOccasion.social,
    ],
    tags: [
      'salam',
      'greeting',
      'social',
    ],
  ),

  DuaAdhkarItem(
    id: 'social_mashallah_blessing',
    title: 'Ask Allah to Bless What You Admire',
    categoryId: 'social_daily',
    arabic:
        'اللَّهُمَّ بَارِكْ',
    transliteration:
        'Allahumma barik.',
    englishTranslation:
        'O Allah, bless it.',
    urduTranslation:
        'اے اللہ! اس میں برکت عطا فرما۔',
    sourceType: DuaSourceType.generalDua,
    authenticity: DuaAuthenticity.notApplicable,
    reference:
        'General permissible supplication',
    repeatCount: 1,
    notes:
        'A simple permissible dua asking Allah to place blessing in something you admire.',
    authenticityNote:
        'This entry is presented as a general permissible dua, not as a fixed Prophetic formula with a prescribed count.',
    occasions: [
      DuaOccasion.social,
      DuaOccasion.general,
    ],
    tags: [
      'blessing',
      'admiration',
      'social',
    ],
  ),
];