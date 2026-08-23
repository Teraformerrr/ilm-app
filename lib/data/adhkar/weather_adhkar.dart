import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> weatherAdhkar = [
  DuaAdhkarItem(
    id: 'weather_rain_beneficial',
    title: 'When It Rains',
    categoryId: 'weather',
    arabic:
        'اللَّهُمَّ صَيِّبًا نَافِعًا',
    transliteration:
        'Allahumma sayyiban nafi‘an.',
    englishTranslation:
        'O Allah, make it beneficial rain.',
    urduTranslation:
        'اے اللہ! اسے فائدہ مند بارش بنا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 1032',
    repeatCount: 1,
    notes:
        'Recite when rain begins or when seeing rainfall.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '1032',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.weather,
    ],
    tags: [
      'rain',
      'weather',
      'beneficial rain',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'weather_strong_wind',
    title: 'During Strong Wind',
    categoryId: 'weather',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا، '
        'وَخَيْرَ مَا فِيهَا، '
        'وَخَيْرَ مَا أُرْسِلَتْ بِهِ، '
        'وَأَعُوذُ بِكَ مِنْ شَرِّهَا، '
        'وَشَرِّ مَا فِيهَا، '
        'وَشَرِّ مَا أُرْسِلَتْ بِهِ',
    transliteration:
        'Allahumma inni as’aluka khayraha, '
        'wa khayra ma fiha, '
        'wa khayra ma ursilat bihi, '
        'wa a‘udhu bika min sharriha, '
        'wa sharri ma fiha, '
        'wa sharri ma ursilat bihi.',
    englishTranslation:
        'O Allah, I ask You for the good of this wind, '
        'the good within it and the good for which it was sent. '
        'I seek refuge in You from its evil, '
        'the evil within it and the evil for which it was sent.',
    urduTranslation:
        'اے اللہ! میں تجھ سے اس ہوا کی بھلائی، '
        'اس کے اندر موجود بھلائی '
        'اور اس مقصد کی بھلائی مانگتا ہوں جس کے لیے اسے بھیجا گیا۔ '
        'اور میں اس کے شر، اس کے اندر موجود شر '
        'اور اس مقصد کے شر سے تیری پناہ مانگتا ہوں '
        'جس کے لیے اسے بھیجا گیا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 899b',
    repeatCount: 1,
    notes:
        'Recite when the wind becomes strong or stormy.',
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '899b',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.weather,
      DuaOccasion.protection,
    ],
    tags: [
      'wind',
      'storm',
      'weather',
      'protection',
    ],
    isProtection: true,
    isPropheticDua: true,
  ),
];