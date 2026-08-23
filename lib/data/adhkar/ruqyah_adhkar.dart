import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> ruqyahAdhkar = [
  DuaAdhkarItem(
    id: 'ruqyah_al_fatihah',
    title: 'Surah Al-Fatihah',
    categoryId: 'ruqyah',
    arabic:
        'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ ۝ '
        'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ ۝ '
        'الرَّحْمَٰنِ الرَّحِيمِ ۝ '
        'مَالِكِ يَوْمِ الدِّينِ ۝ '
        'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ ۝ '
        'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ ۝ '
        'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ '
        'غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ '
        'وَلَا الضَّالِّينَ',
    transliteration:
        'Bismillahir-Rahmanir-Rahim. '
        'Alhamdu lillahi Rabbil-‘alamin. '
        'Ar-Rahmanir-Rahim. '
        'Maliki yawmid-din. '
        'Iyyaka na‘budu wa iyyaka nasta‘in. '
        'Ihdinas-siratal-mustaqim. '
        'Siratal-ladhina an‘amta ‘alayhim, '
        'ghayril-maghdubi ‘alayhim '
        'wa lad-dallin.',
    englishTranslation:
        'In the Name of Allah, the Most Compassionate, the Most Merciful. '
        'All praise belongs to Allah, Lord of all worlds, '
        'the Most Compassionate, the Most Merciful, '
        'Master of the Day of Judgment. '
        'You alone we worship and You alone we ask for help. '
        'Guide us to the straight path, '
        'the path of those You have blessed, '
        'not those who earned anger nor those who went astray.',
    urduTranslation:
        'اللہ کے نام سے جو نہایت مہربان، بہت رحم فرمانے والا ہے۔ '
        'تمام تعریف اللہ کے لیے ہے جو تمام جہانوں کا رب ہے۔ '
        'نہایت مہربان، بہت رحم فرمانے والا۔ '
        'روز جزا کا مالک۔ '
        'ہم تیری ہی عبادت کرتے ہیں اور تجھ ہی سے مدد چاہتے ہیں۔ '
        'ہمیں سیدھا راستہ دکھا، '
        'ان لوگوں کا راستہ جن پر تو نے انعام فرمایا، '
        'نہ ان کا جن پر غضب ہوا اور نہ گمراہوں کا۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 1:1-7; Sahih al-Bukhari 5736',
    repeatCount: 1,
    notes:
        'Al-Fatihah is established as a recitation used for Ruqyah.',
    method:
        'Recite Al-Fatihah over yourself or the person receiving Ruqyah. '
        'The authentic narration establishes Al-Fatihah itself as Ruqyah. '
        'Do not attach an invented fixed repetition count unless following a separate supported practice.',
    benefit:
        'The Prophet ﷺ approved the companion’s use of Surah Al-Fatihah as Ruqyah.',
    benefitDirectlySourced: true,
    quranLocation: QuranLocation(
      surahNumber: 1,
      startAyah: 1,
      endAyah: 7,
    ),
    references: [
      DuaReference(
        source: 'Qur’an',
        reference: '1:1-7',
      ),
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '5736',
        grade: 'Sahih',
        note:
            'The companion recited Al-Fatihah as Ruqyah and the Prophet ﷺ approved it.',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.illness,
    ],
    tags: [
      'ruqyah',
      'fatihah',
      'healing',
      'quran',
    ],
    isRuqyah: true,
    isHealing: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_bismillahi_arqik',
    title: 'Ruqyah of Jibril',
    categoryId: 'ruqyah',
    arabic:
        'بِسْمِ اللَّهِ أَرْقِيكَ، '
        'مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، '
        'مِنْ شَرِّ كُلِّ نَفْسٍ '
        'أَوْ عَيْنِ حَاسِدٍ، '
        'اللَّهُ يَشْفِيكَ، '
        'بِسْمِ اللَّهِ أَرْقِيكَ',
    transliteration:
        'Bismillahi arqika, '
        'min kulli shay’in yu’dhika, '
        'min sharri kulli nafsin '
        'aw ‘ayni hasidin, '
        'Allahu yashfika, '
        'bismillahi arqika.',
    englishTranslation:
        'In the Name of Allah, I perform Ruqyah for you '
        'from everything that harms you, '
        'from the evil of every soul or envious eye. '
        'May Allah heal you. '
        'In the Name of Allah, I perform Ruqyah for you.',
    urduTranslation:
        'اللہ کے نام سے میں تم پر دم کرتا ہوں '
        'ہر اس چیز سے جو تمہیں تکلیف دیتی ہے، '
        'ہر نفس کے شر اور حسد کرنے والی آنکھ کے شر سے۔ '
        'اللہ تمہیں شفا عطا فرمائے۔ '
        'اللہ کے نام سے میں تم پر دم کرتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 908',
    repeatCount: 1,
    notes:
        'A Prophetic Ruqyah supplication transmitted from Jibril.',
    method:
        'Recite this over the person seeking Ruqyah while asking Allah alone for healing.',
    benefit:
        'The narration records Jibril reciting this Ruqyah for the Prophet ﷺ when he was ill.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '908',
        grade: 'Sahih — sourced from Muslim',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.illness,
      DuaOccasion.protection,
    ],
    tags: [
      'ruqyah',
      'evil eye',
      'healing',
      'jibril',
      'envy',
    ],
    isRuqyah: true,
    isHealing: true,
    isProtection: true,
    isPropheticDua: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_children_protection',
    title: 'Protection for Children',
    categoryId: 'ruqyah',
    arabic:
        'أُعِيذُكُمَا بِكَلِمَاتِ اللَّهِ التَّامَّةِ، '
        'مِنْ كُلِّ شَيْطَانٍ وَهَامَّةٍ، '
        'وَمِنْ كُلِّ عَيْنٍ لَامَّةٍ',
    transliteration:
        'U‘idhukuma bikalimatillahit-tammati, '
        'min kulli shaytanin wa hammah, '
        'wa min kulli ‘aynin lammah.',
    englishTranslation:
        'I seek protection for you both in the perfect words of Allah '
        'from every devil, every harmful creature, '
        'and every harmful envious eye.',
    urduTranslation:
        'میں تم دونوں کو اللہ کے کامل کلمات کے ذریعے '
        'ہر شیطان، ہر نقصان دہ جاندار '
        'اور ہر نقصان پہنچانے والی نظر سے پناہ میں دیتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih al-Bukhari 3371; Hisn al-Muslim 146',
    repeatCount: 1,
    notes:
        'The Prophet ﷺ used this wording for Al-Hasan and Al-Husain.',
    method:
        'Recite this when seeking Allah’s protection for two children. '
        'For one child, the Arabic grammatical form changes, so the app should later provide singular and plural variants separately.',
    benefit:
        'The Prophet ﷺ used this supplication to seek protection for Al-Hasan and Al-Husain.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '3371',
        grade: 'Sahih',
      ),
      DuaReference(
        source: 'Hisn al-Muslim',
        reference: '146',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.children,
      DuaOccasion.protection,
    ],
    tags: [
      'children',
      'protection',
      'evil eye',
      'ruqyah',
      'hasan',
      'husain',
    ],
    isRuqyah: true,
    isProtection: true,
    isPropheticDua: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_evil_eye',
    title: 'Ruqyah for the Evil Eye',
    categoryId: 'ruqyah',
    arabic:
        'بِسْمِ اللَّهِ أَرْقِيكَ، '
        'مِنْ كُلِّ شَيْءٍ يُؤْذِيكَ، '
        'مِنْ شَرِّ كُلِّ نَفْسٍ '
        'أَوْ عَيْنِ حَاسِدٍ، '
        'اللَّهُ يَشْفِيكَ، '
        'بِسْمِ اللَّهِ أَرْقِيكَ',
    transliteration:
        'Bismillahi arqika, '
        'min kulli shay’in yu’dhika, '
        'min sharri kulli nafsin '
        'aw ‘ayni hasidin, '
        'Allahu yashfika, '
        'bismillahi arqika.',
    englishTranslation:
        'In the Name of Allah, I perform Ruqyah for you '
        'from everything harming you, '
        'from the evil of every soul or envious eye. '
        'May Allah heal you. '
        'In the Name of Allah, I perform Ruqyah for you.',
    urduTranslation:
        'اللہ کے نام سے میں تم پر دم کرتا ہوں '
        'ہر اس چیز سے جو تمہیں نقصان پہنچاتی ہے، '
        'ہر نفس کے شر اور حسد والی نظر کے شر سے۔ '
        'اللہ تمہیں شفا عطا فرمائے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 908',
    repeatCount: 1,
    notes:
        'Ruqyah for the evil eye is explicitly established in authentic hadith.',
    benefit:
        'Authentic narrations explicitly permit and recommend Ruqyah for the evil eye.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '2195a / 2197',
        grade: 'Sahih',
        note:
            'Establishes Ruqyah for the evil eye.',
      ),
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '908',
        grade: 'Sahih — sourced from Muslim',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.protection,
      DuaOccasion.illness,
    ],
    tags: [
      'evil eye',
      'ayn',
      'ruqyah',
      'envy',
      'hasad',
    ],
    isRuqyah: true,
    isProtection: true,
    isHealing: true,
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_rabban_nas',
    title: 'Remove the Harm and Grant Healing',
    categoryId: 'ruqyah',
    arabic:
        'اللَّهُمَّ رَبَّ النَّاسِ، '
        'أَذْهِبِ الْبَأْسَ، '
        'اشْفِ أَنْتَ الشَّافِي، '
        'لَا شِفَاءَ إِلَّا شِفَاؤُكَ، '
        'شِفَاءً لَا يُغَادِرُ سَقَمًا',
    transliteration:
        'Allahumma Rabban-nas, '
        'adhhibil-ba’s, '
        'ishfi Antash-Shafi, '
        'la shifa’a illa shifa’uk, '
        'shifa’an la yughadiru saqama.',
    englishTranslation:
        'O Allah, Lord of mankind, remove the suffering and heal. '
        'You are the Healer. '
        'There is no healing except Your healing, '
        'a healing that leaves no illness behind.',
    urduTranslation:
        'اے اللہ! لوگوں کے رب، تکلیف دور فرما اور شفا عطا فرما۔ '
        'تو ہی شفا دینے والا ہے۔ '
        'تیری شفا کے سوا کوئی شفا نہیں۔ '
        'ایسی شفا عطا فرما جو کوئی بیماری باقی نہ چھوڑے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 5743',
    repeatCount: 1,
    notes:
        'An authentic Prophetic supplication used when treating illness.',
    method:
        'The narration describes the Prophet ﷺ passing his right hand over the affected person while making this supplication.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '5743',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.illness,
    ],
    tags: [
      'ruqyah',
      'healing',
      'illness',
      'shifa',
    ],
    isRuqyah: true,
    isHealing: true,
    isPropheticDua: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_pain_bismillah',
    title: 'For Localized Pain — Bismillah',
    categoryId: 'ruqyah',
    arabic:
        'بِسْمِ اللَّهِ',
    transliteration:
        'Bismillah.',
    englishTranslation:
        'In the Name of Allah.',
    urduTranslation:
        'اللہ کے نام سے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 2202',
    repeatCount: 3,
    notes:
        'First part of the authentic method for pain.',
    method:
        'Place your hand on the painful area and say Bismillah three times. Then recite the next supplication seven times.',
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '2202',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.illness,
    ],
    tags: [
      'ruqyah',
      'pain',
      'body pain',
      'healing',
    ],
    isRuqyah: true,
    isHealing: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'ruqyah_pain_refuge',
    title: 'For Localized Pain — Seek Refuge',
    categoryId: 'ruqyah',
    arabic:
        'أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ '
        'مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ',
    transliteration:
        'A‘udhu billahi wa qudratihi '
        'min sharri ma ajidu wa uhadhiru.',
    englishTranslation:
        'I seek refuge in Allah and His power '
        'from the evil of what I feel and fear.',
    urduTranslation:
        'میں اللہ اور اس کی قدرت کی پناہ مانگتا ہوں '
        'اس تکلیف کے شر سے جو میں محسوس کرتا ہوں '
        'اور جس کا مجھے خوف ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 2202',
    repeatCount: 7,
    notes:
        'Say after Bismillah has been recited three times.',
    method:
        'Keep your hand on the painful area and recite this seven times.',
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '2202',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.ruqyah,
      DuaOccasion.illness,
      DuaOccasion.protection,
    ],
    tags: [
      'ruqyah',
      'pain',
      'healing',
      'protection',
    ],
    isRuqyah: true,
    isHealing: true,
    isProtection: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),
];