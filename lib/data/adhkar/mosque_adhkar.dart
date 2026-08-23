import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> mosqueAdhkar = [
  DuaAdhkarItem(
    id: 'mosque_entering_mercy',
    title: 'Entering the Mosque',
    categoryId: 'mosque',
    arabic:
        'اللَّهُمَّ افْتَحْ لِي '
        'أَبْوَابَ رَحْمَتِكَ',
    transliteration:
        'Allahumma-ftah li abwaba rahmatik.',
    englishTranslation:
        'O Allah, open for me the gates of Your mercy.',
    urduTranslation:
        'اے اللہ! میرے لیے اپنی رحمت کے دروازے کھول دے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sunan an-Nasa’i 729',
    repeatCount: 1,
    notes:
        'Recite when entering the mosque.',
    references: [
      DuaReference(
        source: 'Sunan an-Nasa’i',
        reference: '729',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.mosque,
    ],
    tags: [
      'mosque',
      'masjid',
      'entering mosque',
      'mercy',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'mosque_leaving_bounty',
    title: 'Leaving the Mosque',
    categoryId: 'mosque',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ '
        'مِنْ فَضْلِكَ',
    transliteration:
        'Allahumma inni as’aluka min fadlik.',
    englishTranslation:
        'O Allah, I ask You from Your bounty.',
    urduTranslation:
        'اے اللہ! میں تجھ سے تیرے فضل کا سوال کرتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sunan an-Nasa’i 729',
    repeatCount: 1,
    notes:
        'Recite when leaving the mosque.',
    references: [
      DuaReference(
        source: 'Sunan an-Nasa’i',
        reference: '729',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.mosque,
      DuaOccasion.provision,
    ],
    tags: [
      'mosque',
      'masjid',
      'leaving mosque',
      'bounty',
    ],
    isPropheticDua: true,
  ),
];