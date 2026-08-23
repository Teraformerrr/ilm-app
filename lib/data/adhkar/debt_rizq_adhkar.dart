import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> debtRizqAdhkar = [
  DuaAdhkarItem(
    id: 'debt_halal_sufficiency',
    title: 'Dua for Debt and Halal Sufficiency',
    categoryId: 'debt_rizq',
    arabic:
        'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، '
        'وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',
    transliteration:
        'Allahummakfini bihalalika ‘an haramika, '
        'wa aghnini bifadlika ‘amman siwak.',
    englishTranslation:
        'O Allah, suffice me with what You have made lawful '
        'instead of what You have forbidden, '
        'and make me independent by Your bounty '
        'from everyone besides You.',
    urduTranslation:
        'اے اللہ! اپنے حلال کے ذریعے مجھے اپنے حرام سے کافی کر دے، '
        'اور اپنے فضل سے مجھے اپنے سوا سب سے بے نیاز کر دے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference: 'Jami` at-Tirmidhi 3563',
    repeatCount: 1,
    notes:
        'No fixed daily repetition count is established by this narration.',
    benefit:
        'This supplication was taught in the context of someone struggling with a debt obligation.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Jami` at-Tirmidhi',
        reference: '3563',
        grade: 'Hasan Gharib / Hasan',
      ),
    ],
    occasions: [
      DuaOccasion.debt,
      DuaOccasion.provision,
    ],
    tags: [
      'debt',
      'rizq',
      'halal income',
      'provision',
      'money',
      'financial difficulty',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'rizq_rabbana_good_worlds',
    title: 'Good in This World and the Hereafter',
    categoryId: 'debt_rizq',
    arabic:
        'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً '
        'وَفِي الْآخِرَةِ حَسَنَةً '
        'وَقِنَا عَذَابَ النَّارِ',
    transliteration:
        'Rabbana atina fid-dunya hasanatan '
        'wa fil-akhirati hasanatan '
        'wa qina ‘adhaban-nar.',
    englishTranslation:
        'Our Lord, give us good in this world '
        'and good in the Hereafter, '
        'and protect us from the punishment of the Fire.',
    urduTranslation:
        'اے ہمارے رب! ہمیں دنیا میں بھلائی عطا فرما، '
        'آخرت میں بھی بھلائی عطا فرما '
        'اور ہمیں آگ کے عذاب سے بچا۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 2:201',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 2,
      startAyah: 201,
    ),
    occasions: [
      DuaOccasion.provision,
      DuaOccasion.general,
    ],
    tags: [
      'rizq',
      'world',
      'akhirah',
      'goodness',
      'provision',
    ],
  ),
];