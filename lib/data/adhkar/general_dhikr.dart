import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> generalDhikr = [
  DuaAdhkarItem(
    id: 'general_subhanallah_bihamdihi_100',
    title: 'SubhanAllahi wa Bihamdihi',
    categoryId: 'general_dhikr',
    arabic:
        'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration:
        'SubhanAllahi wa bihamdihi.',
    englishTranslation:
        'Glory and praise be to Allah.',
    urduTranslation:
        'اللہ پاک ہے اور تمام تعریف اسی کے لیے ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6405',
    repeatCount: 100,
    notes:
        'The hadith specifies one hundred times in a day.',
    benefit:
        'The narration states that sins are forgiven even if they are as numerous as the foam of the sea.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6405',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.general,
      DuaOccasion.forgiveness,
    ],
    tags: [
      'tasbih',
      'dhikr',
      '100',
      'forgiveness',
    ],
    isGeneralDhikr: true,
    isSharedAcrossCollections: true,
  ),

  DuaAdhkarItem(
    id: 'general_tahlil_100',
    title: 'La Ilaha Illallah — 100 Times',
    categoryId: 'general_dhikr',
    arabic:
        'لَا إِلَهَ إِلَّا اللَّهُ '
        'وَحْدَهُ لَا شَرِيكَ لَهُ، '
        'لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، '
        'وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
    transliteration:
        'La ilaha illallahu wahdahu la sharika lah, '
        'lahul-mulku wa lahul-hamd, '
        'wa Huwa ‘ala kulli shay’in Qadir.',
    englishTranslation:
        'There is no deity worthy of worship except Allah alone, '
        'without partner. '
        'To Him belongs the dominion and all praise, '
        'and He has power over all things.',
    urduTranslation:
        'اللہ کے سوا کوئی معبود برحق نہیں۔ '
        'وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ '
        'اسی کے لیے بادشاہی اور تمام تعریف ہے، '
        'اور وہ ہر چیز پر قادر ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6403',
    repeatCount: 100,
    notes:
        'The narration specifies one hundred times during the day.',
    benefit:
        'The narration mentions the reward of freeing ten slaves, '
        'one hundred good deeds, removal of one hundred sins, '
        'and protection from Shaytan for that day until evening.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6403',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.general,
      DuaOccasion.protection,
    ],
    tags: [
      'tahlil',
      'tawhid',
      '100',
      'dhikr',
      'protection',
    ],
    isGeneralDhikr: true,
    isProtection: true,
  ),

  DuaAdhkarItem(
    id: 'general_subhanallah',
    title: 'SubhanAllah',
    categoryId: 'general_dhikr',
    arabic:
        'سُبْحَانَ اللَّهِ',
    transliteration:
        'SubhanAllah.',
    englishTranslation:
        'Glory be to Allah.',
    urduTranslation:
        'اللہ پاک ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Established general remembrance in authentic Sunnah',
    notes:
        'No fixed count is assigned in this general entry.',
    occasions: [
      DuaOccasion.general,
    ],
    tags: [
      'tasbih',
      'dhikr',
      'subhanallah',
    ],
    isGeneralDhikr: true,
  ),

  DuaAdhkarItem(
    id: 'general_alhamdulillah',
    title: 'Alhamdulillah',
    categoryId: 'general_dhikr',
    arabic:
        'الْحَمْدُ لِلَّهِ',
    transliteration:
        'Alhamdulillah.',
    englishTranslation:
        'All praise belongs to Allah.',
    urduTranslation:
        'تمام تعریف اللہ کے لیے ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Established general remembrance in authentic Sunnah',
    notes:
        'No fixed count is assigned in this general entry.',
    occasions: [
      DuaOccasion.general,
    ],
    tags: [
      'praise',
      'dhikr',
      'alhamdulillah',
    ],
    isGeneralDhikr: true,
  ),

  DuaAdhkarItem(
    id: 'general_allahu_akbar',
    title: 'Allahu Akbar',
    categoryId: 'general_dhikr',
    arabic:
        'اللَّهُ أَكْبَرُ',
    transliteration:
        'Allahu Akbar.',
    englishTranslation:
        'Allah is the Greatest.',
    urduTranslation:
        'اللہ سب سے بڑا ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Established general remembrance in authentic Sunnah',
    notes:
        'No fixed count is assigned in this general entry.',
    occasions: [
      DuaOccasion.general,
    ],
    tags: [
      'takbir',
      'dhikr',
      'allahu akbar',
    ],
    isGeneralDhikr: true,
  ),
];