import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> sneezingAdhkar = [
  DuaAdhkarItem(
    id: 'sneezing_sneezer_praise',
    title: 'When You Sneeze',
    categoryId: 'sneezing',
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
    reference: 'Sahih al-Bukhari 6224',
    repeatCount: 1,
    notes:
        'Say after sneezing.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6224',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.sneezing,
    ],
    tags: [
      'sneeze',
      'sneezing',
      'alhamdulillah',
    ],
    isGeneralDhikr: true,
  ),

  DuaAdhkarItem(
    id: 'sneezing_response',
    title: 'Reply to Someone Who Sneezes',
    categoryId: 'sneezing',
    arabic:
        'يَرْحَمُكَ اللَّهُ',
    transliteration:
        'Yarhamukallah.',
    englishTranslation:
        'May Allah have mercy upon you.',
    urduTranslation:
        'اللہ تم پر رحم فرمائے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6224',
    repeatCount: 1,
    notes:
        'Say to the Muslim who sneezes and praises Allah.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6224',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.sneezing,
      DuaOccasion.social,
    ],
    tags: [
      'sneeze',
      'response',
      'mercy',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'sneezing_final_reply',
    title: 'Reply After YarhamukAllah',
    categoryId: 'sneezing',
    arabic:
        'يَهْدِيكُمُ اللَّهُ '
        'وَيُصْلِحُ بَالَكُمْ',
    transliteration:
        'Yahdikumullahu '
        'wa yuslihu balakum.',
    englishTranslation:
        'May Allah guide you and improve your condition.',
    urduTranslation:
        'اللہ تمہیں ہدایت دے '
        'اور تمہارے حالات درست فرمائے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6224',
    repeatCount: 1,
    notes:
        'The sneezer says this after another person says YarhamukAllah.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6224',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.sneezing,
      DuaOccasion.social,
    ],
    tags: [
      'sneeze',
      'guidance',
      'response',
    ],
    isPropheticDua: true,
  ),
];