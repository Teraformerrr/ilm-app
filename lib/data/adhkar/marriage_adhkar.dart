import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> marriageAdhkar = [
  DuaAdhkarItem(
    id: 'marriage_congratulation',
    title: 'Dua for the Newly Married',
    categoryId: 'marriage',
    arabic:
        'بَارَكَ اللَّهُ لَكَ، '
        'وَبَارَكَ عَلَيْكَ، '
        'وَجَمَعَ بَيْنَكُمَا فِي خَيْرٍ',
    transliteration:
        'Barakallahu laka, '
        'wa baraka ‘alayka, '
        'wa jama‘a baynakuma fi khayr.',
    englishTranslation:
        'May Allah bless you, shower His blessings upon you, '
        'and bring you both together in goodness.',
    urduTranslation:
        'اللہ تمہیں برکت دے، تم پر اپنی برکت نازل فرمائے '
        'اور تم دونوں کو خیر کے ساتھ جمع رکھے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Jami` at-Tirmidhi 1091; Sunan Ibn Majah 1905',
    repeatCount: 1,
    notes:
        'Say when congratulating someone upon marriage.',
    references: [
      DuaReference(
        source: 'Jami` at-Tirmidhi',
        reference: '1091',
        grade: 'Hasan Sahih',
      ),
      DuaReference(
        source: 'Sunan Ibn Majah',
        reference: '1905',
      ),
    ],
    occasions: [
      DuaOccasion.marriage,
      DuaOccasion.social,
    ],
    tags: [
      'marriage',
      'newlywed',
      'wedding',
      'congratulations',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'marriage_family_qurrata_ayun',
    title: 'For a Blessed Family',
    categoryId: 'marriage',
    arabic:
        'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا '
        'وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ '
        'وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
    transliteration:
        'Rabbana hab lana min azwajina '
        'wa dhurriyyatina qurrata a‘yunin '
        'waj‘alna lil-muttaqina imama.',
    englishTranslation:
        'Our Lord, grant us from our spouses and offspring comfort to our eyes, '
        'and make us examples for the righteous.',
    urduTranslation:
        'اے ہمارے رب! ہمیں ہماری بیویوں اور اولاد سے آنکھوں کی ٹھنڈک عطا فرما '
        'اور ہمیں متقی لوگوں کے لیے نمونہ بنا۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 25:74',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 25,
      startAyah: 74,
    ),
    occasions: [
      DuaOccasion.marriage,
      DuaOccasion.family,
      DuaOccasion.children,
    ],
    tags: [
      'marriage',
      'family',
      'spouse',
      'children',
    ],
    isQuranicDua: true,
    isSharedAcrossCollections: true,
  ),
];