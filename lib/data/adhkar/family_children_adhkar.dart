import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> familyChildrenAdhkar = [
  DuaAdhkarItem(
    id: 'children_protection_hasan_husain',
    title: 'Protection for Children',
    categoryId: 'family_children',
    arabic:
        'أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ '
        'مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ '
        'وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
    transliteration:
        'U‘idhukuma bikalimatillahit-tammati '
        'min kulli shaytanin wa hammah, '
        'wa min kulli ‘aynin lammah.',
    englishTranslation:
        'I seek protection for you both in the perfect words of Allah '
        'from every devil, every harmful creature, '
        'and every harmful envious eye.',
    urduTranslation:
        'میں تم دونوں کو اللہ کے کامل کلمات کے ذریعے '
        'ہر شیطان، ہر نقصان دہ جاندار '
        'اور ہر نقصان پہنچانے والی نظر سے پناہ دیتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 3371',
    repeatCount: 1,
    notes:
        'The Prophet ﷺ used this wording for Al-Hasan and Al-Husain.',
    method:
        'This Arabic wording is dual, because it was recited for two children. '
        'Later the app can provide grammatically correct singular and plural variants.',
    benefit:
        'The Prophet ﷺ used this supplication to seek Allah’s protection for Al-Hasan and Al-Husain.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '3371',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.children,
      DuaOccasion.family,
      DuaOccasion.protection,
      DuaOccasion.ruqyah,
    ],
    tags: [
      'children',
      'family',
      'protection',
      'evil eye',
      'shaytan',
    ],
    isProtection: true,
    isRuqyah: true,
    isPropheticDua: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'family_righteous_spouse_children',
    title: 'For Spouses and Children',
    categoryId: 'family_children',
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
      DuaOccasion.family,
      DuaOccasion.children,
      DuaOccasion.marriage,
    ],
    tags: [
      'family',
      'children',
      'spouse',
      'marriage',
      'righteousness',
    ],
    isQuranicDua: true,
    isSharedAcrossCollections: true,
  ),

  DuaAdhkarItem(
    id: 'family_righteous_offspring',
    title: 'For Righteous Offspring',
    categoryId: 'family_children',
    arabic:
        'رَبِّ هَبْ لِي مِنْ لَدُنْكَ '
        'ذُرِّيَّةً طَيِّبَةً '
        'إِنَّكَ سَمِيعُ الدُّعَاءِ',
    transliteration:
        'Rabbi hab li min ladunka '
        'dhurriyyatan tayyibatan, '
        'innaka Sami‘ud-du‘a.',
    englishTranslation:
        'My Lord, grant me from Yourself righteous offspring. '
        'Indeed, You are the Hearer of supplication.',
    urduTranslation:
        'اے میرے رب! مجھے اپنے پاس سے پاکیزہ اولاد عطا فرما۔ '
        'بے شک تو دعا سننے والا ہے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 3:38',
    repeatCount: 1,
    quranLocation: QuranLocation(
      surahNumber: 3,
      startAyah: 38,
    ),
    occasions: [
      DuaOccasion.children,
      DuaOccasion.family,
    ],
    tags: [
      'children',
      'offspring',
      'family',
      'pregnancy',
    ],
    isQuranicDua: true,
  ),
];