import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> homeAdhkar = [
  DuaAdhkarItem(
    id: 'home_entering_bismillah',
    title: 'Entering the Home',
    categoryId: 'home',
    arabic:
        'بِسْمِ اللَّهِ وَلَجْنَا، '
        'وَبِسْمِ اللَّهِ خَرَجْنَا، '
        'وَعَلَى رَبِّنَا تَوَكَّلْنَا',
    transliteration:
        'Bismillahi walajna, '
        'wa bismillahi kharajna, '
        'wa ‘ala Rabbina tawakkalna.',
    englishTranslation:
        'In the Name of Allah we enter, '
        'in the Name of Allah we leave, '
        'and upon our Lord we rely.',
    urduTranslation:
        'اللہ کے نام سے ہم داخل ہوئے، '
        'اللہ کے نام سے ہم نکلے، '
        'اور اپنے رب ہی پر ہم نے بھروسہ کیا۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.accepted,
    reference:
        'Abu Dawud; Hisn al-Muslim',
    repeatCount:
        1,
    notes:
        'Recite when entering the home, then greet those present with salam.',
    method:
        'Mention Allah when entering and give salam to the people of the house.',
    authenticityNote:
        'This wording is included in Hisn al-Muslim with Abu Dawud as its reference. The general instruction to mention Allah on entering the house is established in Sahih Muslim.',
    references: [
      DuaReference(
        source:
            'Hisn al-Muslim',
        reference:
            'Entering the home',
      ),
      DuaReference(
        source:
            'Sahih Muslim',
        reference:
            '2018a',
        grade:
            'Sahih',
        note:
            'Establishes mentioning Allah when entering the home.',
      ),
    ],
    occasions: [
      DuaOccasion.home,
    ],
    tags: [
      'home',
      'entering home',
      'bismillah',
    ],
    requiresMethodInstruction:
        true,
  ),

  DuaAdhkarItem(
    id: 'home_leaving_tawakkul',
    title: 'Leaving the Home',
    categoryId: 'home',
    arabic:
        'بِسْمِ اللَّهِ، '
        'تَوَكَّلْتُ عَلَى اللَّهِ، '
        'وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration:
        'Bismillah, '
        'tawakkaltu ‘alallah, '
        'wa la hawla wa la quwwata illa billah.',
    englishTranslation:
        'In the Name of Allah. '
        'I place my trust in Allah. '
        'There is no power and no strength except through Allah.',
    urduTranslation:
        'اللہ کے نام سے۔ '
        'میں نے اللہ پر بھروسہ کیا۔ '
        'اللہ کے بغیر نہ کوئی طاقت ہے اور نہ قوت۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.hasan,
    reference:
        'Abu Dawud; At-Tirmidhi; Riyad as-Salihin 83',
    repeatCount:
        1,
    notes:
        'Recite when leaving the home.',
    benefit:
        'The narration states that the person is told: you are guided, defended and protected, and Shaytan withdraws from him.',
    benefitDirectlySourced:
        true,
    references: [
      DuaReference(
        source:
            'Riyad as-Salihin',
        reference:
            '83',
        grade:
            'Hasan',
        note:
            'Cites Abu Dawud, At-Tirmidhi and An-Nasa’i.',
      ),
    ],
    occasions: [
      DuaOccasion.home,
      DuaOccasion.protection,
    ],
    tags: [
      'home',
      'leaving home',
      'tawakkul',
      'protection',
    ],
    isProtection:
        true,
  ),

  DuaAdhkarItem(
    id: 'home_leaving_protection_dua',
    title: 'Protection When Leaving Home',
    categoryId: 'home',
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ '
        'أَنْ أَضِلَّ أَوْ أُضَلَّ، '
        'أَوْ أَزِلَّ أَوْ أُزَلَّ، '
        'أَوْ أَظْلِمَ أَوْ أُظْلَمَ، '
        'أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ',
    transliteration:
        'Allahumma inni a‘udhu bika '
        'an adilla aw udalla, '
        'aw azilla aw uzalla, '
        'aw azlima aw uzlama, '
        'aw ajhala aw yujhala ‘alayya.',
    englishTranslation:
        'O Allah, I seek refuge in You from going astray '
        'or being led astray, from slipping or being made to slip, '
        'from wronging others or being wronged, '
        'and from acting ignorantly or being treated ignorantly.',
    urduTranslation:
        'اے اللہ! میں تیری پناہ مانگتا ہوں کہ میں گمراہ ہو جاؤں '
        'یا مجھے گمراہ کیا جائے، میں پھسلوں یا مجھے پھسلایا جائے، '
        'میں ظلم کروں یا مجھ پر ظلم کیا جائے، '
        'میں جہالت کروں یا میرے ساتھ جہالت کا معاملہ کیا جائے۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.accepted,
    reference:
        'Abu Dawud; At-Tirmidhi; Riyad as-Salihin 82',
    repeatCount:
        1,
    notes:
        'Recite when leaving the house.',
    references: [
      DuaReference(
        source:
            'Riyad as-Salihin',
        reference:
            '82',
      ),
    ],
    occasions: [
      DuaOccasion.home,
      DuaOccasion.protection,
    ],
    tags: [
      'leaving home',
      'protection',
      'guidance',
    ],
    isProtection:
        true,
    isPropheticDua:
        true,
  ),
];