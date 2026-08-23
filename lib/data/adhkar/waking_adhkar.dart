import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> wakingAdhkar = [
  DuaAdhkarItem(
    id: 'waking_alhamdulillah_ahyana',
    title: 'Upon Waking Up',
    categoryId: 'waking',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا '
        'بَعْدَ مَا أَمَاتَنَا '
        'وَإِلَيْهِ النُّشُورُ',
    transliteration:
        'Alhamdu lillahil-ladhi ahyana '
        'ba‘da ma amatana '
        'wa ilayhin-nushur.',
    englishTranslation:
        'All praise belongs to Allah Who gave us life '
        'after causing us to die, and to Him is the resurrection.',
    urduTranslation:
        'تمام تعریف اللہ کے لیے ہے جس نے ہمیں موت جیسی نیند کے بعد '
        'دوبارہ زندگی دی، اور اسی کی طرف دوبارہ اٹھنا ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6324',
    repeatCount: 1,
    notes:
        'Recite immediately after waking from sleep.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6324',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.afterWaking,
    ],
    tags: [
      'waking',
      'morning',
      'sleep',
    ],
    isWakeUp: true,
    isPropheticDua: true,
  ),
];