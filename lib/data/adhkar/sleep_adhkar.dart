import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> sleepAdhkar = [
  DuaAdhkarItem(
    id: 'sleep_ayat_al_kursi',
    title: 'Ayat al-Kursi',
    categoryId: 'sleep',
    arabic:
        'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ '
        'لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ '
        'لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ '
        'مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ '
        'يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ '
        'وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ '
        'وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ '
        'وَلَا يَئُودُهُ حِفْظُهُمَا ۚ '
        'وَهُوَ الْعَلِيُّ الْعَظِيمُ',
    transliteration:
        'Allahu la ilaha illa Huwa, Al-Hayyul-Qayyum. '
        'La ta’khudhuhu sinatun wa la nawm. '
        'Lahu ma fis-samawati wa ma fil-ard. '
        'Man dhal-ladhi yashfa‘u ‘indahu illa bi-idhnih. '
        'Ya‘lamu ma bayna aydihim wa ma khalfahum, '
        'wa la yuhituna bi-shay’in min ‘ilmihi illa bima sha’. '
        'Wasi‘a Kursiyyuhus-samawati wal-ard, '
        'wa la ya’uduhu hifzuhuma, '
        'wa Huwal-‘Aliyyul-‘Azim.',
    englishTranslation:
        'Allah—there is no deity worthy of worship except Him, '
        'the Ever-Living, the Sustainer of all. '
        'Neither drowsiness nor sleep overtakes Him. '
        'To Him belongs whatever is in the heavens and whatever is on the earth. '
        'Who can intercede with Him except by His permission? '
        'He knows what is before them and what is behind them, '
        'and they encompass nothing of His knowledge except what He wills. '
        'His Kursi extends over the heavens and the earth, '
        'and preserving them does not tire Him. '
        'He is the Most High, the Magnificent.',
    urduTranslation:
        'اللہ کے سوا کوئی معبود برحق نہیں۔ وہ زندہ اور سب کو قائم رکھنے والا ہے۔ '
        'نہ اسے اونگھ آتی ہے اور نہ نیند۔ آسمانوں اور زمین میں جو کچھ ہے سب اسی کا ہے۔ '
        'کون ہے جو اس کی اجازت کے بغیر اس کے سامنے سفارش کر سکے؟ '
        'وہ جانتا ہے جو ان کے آگے ہے اور جو ان کے پیچھے ہے، '
        'اور وہ اس کے علم میں سے کسی چیز کا احاطہ نہیں کر سکتے مگر جتنا وہ چاہے۔ '
        'اس کی کرسی آسمانوں اور زمین پر محیط ہے، '
        'اور ان دونوں کی حفاظت اسے نہیں تھکاتی۔ '
        'وہی بلند اور عظمت والا ہے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference: 'Qur’an 2:255; Sahih al-Bukhari 2311',
    repeatCount: 1,
    notes:
        'Recite before going to sleep.',
    method:
        'Recite the complete Ayat al-Kursi when going to bed.',
    benefit:
        'The bedtime narration states that a guardian from Allah remains with the reciter and Shaytan does not approach until morning.',
    benefitDirectlySourced: true,
    quranLocation: QuranLocation(
      surahNumber: 2,
      startAyah: 255,
    ),
    references: [
      DuaReference(
        source: 'Qur’an',
        reference: '2:255',
      ),
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '2311',
        grade: 'Sahih',
        note:
            'Contains the bedtime instruction and the stated protection until morning.',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.protection,
    ],
    tags: [
      'sleep',
      'ayat al kursi',
      'protection',
      'shaytan',
    ],
    alternateTitles: [
      'Ayatul Kursi',
      'Throne Verse',
    ],
    isSleep: true,
    isProtection: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_three_quls',
    title: 'Al-Ikhlas, Al-Falaq & An-Nas',
    categoryId: 'sleep',
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ '
        'اللَّهُ الصَّمَدُ ۝ '
        'لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ '
        'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ\n\n'
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ '
        'مِنْ شَرِّ مَا خَلَقَ ۝ '
        'وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ '
        'وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ '
        'وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ\n\n'
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ '
        'مَلِكِ النَّاسِ ۝ '
        'إِلَهِ النَّاسِ ۝ '
        'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ '
        'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ '
        'مِنَ الْجِنَّةِ وَالنَّاسِ',
    transliteration:
        'Qul huwallahu ahad. Allahus-samad. '
        'Lam yalid wa lam yulad. '
        'Wa lam yakun lahu kufuwan ahad.\n\n'
        'Qul a‘udhu bi Rabbil-falaq. '
        'Min sharri ma khalaq. '
        'Wa min sharri ghasiqin idha waqab. '
        'Wa min sharrin-naffathati fil-‘uqad. '
        'Wa min sharri hasidin idha hasad.\n\n'
        'Qul a‘udhu bi Rabbin-nas. '
        'Malikin-nas. Ilahin-nas. '
        'Min sharril-waswasil-khannas. '
        'Alladhi yuwaswisu fi sudurin-nas. '
        'Minal-jinnati wan-nas.',
    englishTranslation:
        'Recite Surah Al-Ikhlas, Surah Al-Falaq and Surah An-Nas.',
    urduTranslation:
        'سورۃ الاخلاص، سورۃ الفلق اور سورۃ الناس پڑھیں۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 112-114; Sahih al-Bukhari 5017',
    repeatCount: 3,
    notes:
        'Perform the complete sequence three times before sleeping.',
    method:
        'Cup both hands together, blow lightly into them after reciting Al-Ikhlas, Al-Falaq and An-Nas, then wipe over as much of the body as possible, beginning with the head, face and front of the body. Repeat the complete sequence three times.',
    benefit:
        'This is the established bedtime practice reported from the Prophet ﷺ.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Qur’an',
        reference: '112-114',
      ),
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '5017',
        grade: 'Sahih',
        note:
            'Reports the blowing, wiping method and repetition three times.',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.protection,
    ],
    tags: [
      'sleep',
      'three quls',
      'muawwidhat',
      'protection',
    ],
    alternateTitles: [
      'Three Quls',
      'Muawwidhat',
    ],
    isSleep: true,
    isProtection: true,
    isSharedAcrossCollections: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_last_two_baqarah',
    title: 'Last Two Verses of Al-Baqarah',
    categoryId: 'sleep',
    arabic:
        'آمَنَ الرَّسُولُ بِمَا أُنْزِلَ إِلَيْهِ مِنْ رَبِّهِ وَالْمُؤْمِنُونَ ۚ '
        'كُلٌّ آمَنَ بِاللَّهِ وَمَلَائِكَتِهِ وَكُتُبِهِ وَرُسُلِهِ '
        'لَا نُفَرِّقُ بَيْنَ أَحَدٍ مِنْ رُسُلِهِ ۚ '
        'وَقَالُوا سَمِعْنَا وَأَطَعْنَا ۖ '
        'غُفْرَانَكَ رَبَّنَا وَإِلَيْكَ الْمَصِيرُ ۝ '
        'لَا يُكَلِّفُ اللَّهُ نَفْسًا إِلَّا وُسْعَهَا ۚ '
        'لَهَا مَا كَسَبَتْ وَعَلَيْهَا مَا اكْتَسَبَتْ ۗ '
        'رَبَّنَا لَا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا ۚ '
        'رَبَّنَا وَلَا تَحْمِلْ عَلَيْنَا إِصْرًا '
        'كَمَا حَمَلْتَهُ عَلَى الَّذِينَ مِنْ قَبْلِنَا ۚ '
        'رَبَّنَا وَلَا تُحَمِّلْنَا مَا لَا طَاقَةَ لَنَا بِهِ ۖ '
        'وَاعْفُ عَنَّا وَاغْفِرْ لَنَا وَارْحَمْنَا ۚ '
        'أَنْتَ مَوْلَانَا فَانْصُرْنَا عَلَى الْقَوْمِ الْكَافِرِينَ',
    transliteration:
        'Amanar-Rasulu bima unzila ilayhi mir-Rabbihi wal-mu’minun... '
        'La yukallifullahu nafsan illa wus‘aha...',
    englishTranslation:
        'The Messenger believes in what has been revealed to him from his Lord, '
        'and so do the believers... Allah does not burden a soul beyond its capacity... '
        'Our Lord, do not hold us accountable if we forget or make a mistake... '
        'Pardon us, forgive us and have mercy upon us.',
    urduTranslation:
        'رسول اس چیز پر ایمان لائے جو ان کی طرف ان کے رب کی جانب سے نازل کی گئی، '
        'اور مومن بھی... اللہ کسی جان کو اس کی طاقت سے زیادہ مکلف نہیں کرتا... '
        'اے ہمارے رب! اگر ہم بھول جائیں یا غلطی کریں تو ہمیں نہ پکڑنا... '
        'ہمیں معاف فرما، ہمیں بخش دے اور ہم پر رحم فرما۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 2:285-286; Sahih al-Bukhari 5009',
    repeatCount: 1,
    notes:
        'Recite at night.',
    benefit:
        'The Prophet ﷺ stated that whoever recites the final two verses of Al-Baqarah at night, they suffice for him.',
    benefitDirectlySourced: true,
    quranLocation: QuranLocation(
      surahNumber: 2,
      startAyah: 285,
      endAyah: 286,
    ),
    references: [
      DuaReference(
        source: 'Qur’an',
        reference: '2:285-286',
      ),
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '5009',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.general,
    ],
    tags: [
      'sleep',
      'night',
      'baqarah',
    ],
    isSleep: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_bismika_amutu_wa_ahya',
    title: 'With Your Name I Die and Live',
    categoryId: 'sleep',
    arabic:
        'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
    transliteration:
        'Bismika Allahumma amutu wa ahya.',
    englishTranslation:
        'In Your Name, O Allah, I die and I live.',
    urduTranslation:
        'اے اللہ! تیرے ہی نام کے ساتھ میں مرتا اور زندہ ہوتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6324',
    repeatCount: 1,
    notes:
        'Recite when going to bed.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6324',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
    ],
    tags: [
      'sleep',
      'bed',
    ],
    isSleep: true,
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_submission_dua',
    title: 'Final Supplication Before Sleep',
    categoryId: 'sleep',
    arabic:
        'اللَّهُمَّ أَسْلَمْتُ وَجْهِي إِلَيْكَ، '
        'وَفَوَّضْتُ أَمْرِي إِلَيْكَ، '
        'وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، '
        'رَغْبَةً وَرَهْبَةً إِلَيْكَ، '
        'لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، '
        'آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، '
        'وَبِنَبِيِّكَ الَّذِي أَرْسَلْتَ',
    transliteration:
        'Allahumma aslamtu wajhi ilayka, '
        'wa fawwadtu amri ilayka, '
        'wa alja’tu zahri ilayka, '
        'raghbatan wa rahbatan ilayka. '
        'La malja’a wa la manja minka illa ilayka. '
        'Amantu bikitabikal-ladhi anzalta, '
        'wa binabiyyikal-ladhi arsalta.',
    englishTranslation:
        'O Allah, I submit myself to You, entrust my affairs to You, '
        'and rely upon You, hoping in You and fearing You. '
        'There is no refuge and no escape from You except to You. '
        'I believe in Your Book which You revealed '
        'and in Your Prophet whom You sent.',
    urduTranslation:
        'اے اللہ! میں نے اپنا رخ تیرے سپرد کیا، '
        'اپنا معاملہ تیرے حوالے کیا، '
        'اور اپنی پشت تیرے سہارے لگا دی، '
        'تیری رغبت اور تیرے خوف کے ساتھ۔ '
        'تیرے سوا کوئی پناہ اور نجات کی جگہ نہیں۔ '
        'میں تیری نازل کردہ کتاب اور تیرے بھیجے ہوئے نبی پر ایمان لایا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6311',
    repeatCount: 1,
    notes:
        'Recite before sleep and make these among your final words.',
    method:
        'Perform wudu as for salah, lie on your right side, then recite this supplication.',
    benefit:
        'The narration states that if a person dies that night after saying these words, he dies upon the fitrah.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '6311',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
    ],
    tags: [
      'sleep',
      'right side',
      'wudu',
    ],
    isSleep: true,
    isPropheticDua: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_subhanallah_33',
    title: 'SubhanAllah Before Sleep',
    categoryId: 'sleep',
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
        'Sahih al-Bukhari — Tasbih of Fatimah',
    repeatCount: 33,
    notes:
        'Recite before sleeping as part of the Tasbih taught to Ali and Fatimah.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: 'Bedtime Tasbih narration',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.general,
    ],
    tags: [
      'tasbih fatimah',
      'sleep',
      'dhikr',
    ],
    isSleep: true,
    isGeneralDhikr: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_alhamdulillah_33',
    title: 'Alhamdulillah Before Sleep',
    categoryId: 'sleep',
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
        'Sahih al-Bukhari — Tasbih of Fatimah',
    repeatCount: 33,
    notes:
        'Recite before sleeping as part of the Tasbih taught to Ali and Fatimah.',
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.general,
    ],
    tags: [
      'tasbih fatimah',
      'sleep',
      'dhikr',
    ],
    isSleep: true,
    isGeneralDhikr: true,
  ),

  DuaAdhkarItem(
    id: 'sleep_allahu_akbar_34',
    title: 'Allahu Akbar Before Sleep',
    categoryId: 'sleep',
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
        'Sahih al-Bukhari — Tasbih of Fatimah',
    repeatCount: 34,
    notes:
        'Recite before sleeping as part of the Tasbih taught to Ali and Fatimah.',
    benefit:
        'The Prophet ﷺ told Ali and Fatimah that this remembrance was better for them than a servant.',
    benefitDirectlySourced: true,
    occasions: [
      DuaOccasion.beforeSleep,
      DuaOccasion.general,
    ],
    tags: [
      'tasbih fatimah',
      'sleep',
      'dhikr',
    ],
    isSleep: true,
    isGeneralDhikr: true,
  ),
];