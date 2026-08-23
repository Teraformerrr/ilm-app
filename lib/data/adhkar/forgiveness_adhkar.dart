import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> forgivenessAdhkar = [
  DuaAdhkarItem(
    id: 'forgiveness_sayyid_al_istighfar',
    title: 'Sayyid al-Istighfar',
    categoryId: 'forgiveness',
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، '
        'خَلَقْتَنِي وَأَنَا عَبْدُكَ، '
        'وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ '
        'مَا اسْتَطَعْتُ، '
        'أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، '
        'أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، '
        'وَأَبُوءُ لَكَ بِذَنْبِي، '
        'فَاغْفِرْ لِي، '
        'فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Allahumma Anta Rabbi la ilaha illa Anta, '
        'khalaqtani wa ana ‘abduka, '
        'wa ana ‘ala ‘ahdika wa wa‘dika mastata‘tu. '
        'A‘udhu bika min sharri ma sana‘tu. '
        'Abu’u laka bini‘matika ‘alayya, '
        'wa abu’u laka bidhanbi, '
        'faghfir li, '
        'fa innahu la yaghfirudh-dhunuba illa Anta.',
    englishTranslation:
        'O Allah, You are my Lord. There is no deity worthy of worship except You. '
        'You created me and I am Your servant. '
        'I remain faithful to Your covenant and promise as much as I am able. '
        'I seek refuge in You from the evil of what I have done. '
        'I acknowledge Your blessings upon me '
        'and I acknowledge my sin. '
        'So forgive me, for no one forgives sins except You.',
    urduTranslation:
        'اے اللہ! تو میرا رب ہے، تیرے سوا کوئی معبود برحق نہیں۔ '
        'تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں۔ '
        'جہاں تک مجھ سے ہو سکتا ہے میں تیرے عہد اور وعدے پر قائم ہوں۔ '
        'میں اپنے کیے ہوئے اعمال کے شر سے تیری پناہ مانگتا ہوں۔ '
        'میں اپنے اوپر تیری نعمتوں کا اقرار کرتا ہوں '
        'اور اپنے گناہ کا بھی اقرار کرتا ہوں۔ '
        'پس مجھے بخش دے، کیونکہ تیرے سوا کوئی گناہوں کو نہیں بخش سکتا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6306',
    repeatCount: 1,
    notes:
        'Recite with conviction during the day or night.',
    benefit:
        'The narration gives a specific virtue for one who says it with firm faith during the day or night and then dies before the corresponding evening or morning.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6306',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.forgiveness,
      DuaOccasion.morning,
      DuaOccasion.evening,
    ],
    tags: [
      'forgiveness',
      'istighfar',
      'repentance',
      'morning',
      'evening',
    ],
    alternateTitles: [
      'Master Supplication for Forgiveness',
      'Best Istighfar',
    ],
    isMorning: true,
    isEvening: true,
    isPropheticDua: true,
    isSharedAcrossCollections: true,
  ),

  DuaAdhkarItem(
    id: 'forgiveness_adam',
    title: 'Dua of Adam and Hawwa',
    categoryId: 'forgiveness',
    arabic:
        'رَبَّنَا ظَلَمْنَا أَنْفُسَنَا '
        'وَإِنْ لَمْ تَغْفِرْ لَنَا '
        'وَتَرْحَمْنَا '
        'لَنَكُونَنَّ مِنَ الْخَاسِرِينَ',
    transliteration:
        'Rabbana zalamna anfusana '
        'wa illam taghfir lana '
        'wa tarhamna '
        'lanakunanna minal-khasirin.',
    englishTranslation:
        'Our Lord, we have wronged ourselves. '
        'If You do not forgive us and have mercy upon us, '
        'we will certainly be among the losers.',
    urduTranslation:
        'اے ہمارے رب! ہم نے اپنی جانوں پر ظلم کیا۔ '
        'اگر تو ہمیں نہ بخشے اور ہم پر رحم نہ فرمائے '
        'تو یقیناً ہم نقصان اٹھانے والوں میں سے ہو جائیں گے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 7:23',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 7,
      startAyah: 23,
    ),
    occasions: [
      DuaOccasion.forgiveness,
    ],
    tags: [
      'forgiveness',
      'repentance',
      'Adam',
      'Quran dua',
    ],
  ),
];