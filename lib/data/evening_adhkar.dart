import '../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> eveningAdhkar = [
  DuaAdhkarItem(
    id: 'evening_ikhlas',
    title: 'Surah Al-Ikhlas',
    categoryId: 'evening',
    arabic:
        'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ '
        'اللَّهُ الصَّمَدُ ۝ '
        'لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ '
        'وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ',
    transliteration:
        'Qul huwallahu ahad. Allahus-samad. '
        'Lam yalid wa lam yulad. '
        'Wa lam yakun lahu kufuwan ahad.',
    englishTranslation:
        'Say: He is Allah, the One. Allah, the Eternal Refuge. '
        'He neither begets nor is born, and there is none comparable to Him.',
    urduTranslation:
        'کہہ دیجئے: وہ اللہ ایک ہے۔ اللہ بے نیاز ہے۔ '
        'نہ اس کی کوئی اولاد ہے اور نہ وہ کسی کی اولاد ہے۔ '
        'اور کوئی اس کے برابر نہیں۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 112:1-4; Jami` at-Tirmidhi 3575',
    repeatCount: 3,
    notes:
        'Recite three times in the evening.',
    benefit:
        'Recited with Al-Falaq and An-Nas as part of the established morning and evening remembrance.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_falaq',
    title: 'Surah Al-Falaq',
    categoryId: 'evening',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ '
        'مِنْ شَرِّ مَا خَلَقَ ۝ '
        'وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ '
        'وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ '
        'وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
    transliteration:
        'Qul a’udhu bi rabbil-falaq. '
        'Min sharri ma khalaq. '
        'Wa min sharri ghasiqin idha waqab. '
        'Wa min sharrin-naffathati fil-uqad. '
        'Wa min sharri hasidin idha hasad.',
    englishTranslation:
        'Say: I seek refuge in the Lord of daybreak, '
        'from the evil of what He created, '
        'from the evil of darkness when it settles, '
        'from the evil of those who blow on knots, '
        'and from the evil of an envier when he envies.',
    urduTranslation:
        'کہہ دیجئے: میں صبح کے رب کی پناہ مانگتا ہوں، '
        'ہر اس چیز کے شر سے جو اس نے پیدا کی، '
        'رات کی تاریکی کے شر سے جب وہ چھا جائے، '
        'گرہوں میں پھونکنے والوں کے شر سے، '
        'اور حسد کرنے والے کے شر سے جب وہ حسد کرے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 113:1-5; Jami` at-Tirmidhi 3575',
    repeatCount: 3,
    notes:
        'Recite three times in the evening.',
    benefit:
        'Part of the three protective surahs recited in the morning and evening.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_nas',
    title: 'Surah An-Nas',
    categoryId: 'evening',
    arabic:
        'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ '
        'مَلِكِ النَّاسِ ۝ '
        'إِلَهِ النَّاسِ ۝ '
        'مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ '
        'الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ '
        'مِنَ الْجِنَّةِ وَالنَّاسِ',
    transliteration:
        'Qul a’udhu bi rabbin-nas. '
        'Malikin-nas. Ilahin-nas. '
        'Min sharril-waswasil-khannas. '
        'Alladhi yuwaswisu fi sudurin-nas. '
        'Minal-jinnati wan-nas.',
    englishTranslation:
        'Say: I seek refuge in the Lord of mankind, '
        'the King of mankind, the God of mankind, '
        'from the evil of the retreating whisperer, '
        'who whispers into the hearts of mankind, '
        'from among jinn and mankind.',
    urduTranslation:
        'کہہ دیجئے: میں لوگوں کے رب، لوگوں کے بادشاہ '
        'اور لوگوں کے معبود کی پناہ مانگتا ہوں، '
        'وسوسہ ڈال کر پیچھے ہٹ جانے والے کے شر سے، '
        'جو لوگوں کے دلوں میں وسوسے ڈالتا ہے، '
        'خواہ وہ جنات میں سے ہو یا انسانوں میں سے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 114:1-6; Jami` at-Tirmidhi 3575',
    repeatCount: 3,
    notes:
        'Recite three times in the evening.',
    benefit:
        'Part of the three protective surahs recited in the morning and evening.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_bika_amsayna',
    title: 'By Allah We Enter the Evening',
    categoryId: 'evening',
    arabic:
        'اللَّهُمَّ بِكَ أَمْسَيْنَا، '
        'وَبِكَ أَصْبَحْنَا، '
        'وَبِكَ نَحْيَا، '
        'وَبِكَ نَمُوتُ، '
        'وَإِلَيْكَ النُّشُورُ',
    transliteration:
        'Allahumma bika amsayna, '
        'wa bika asbahna, '
        'wa bika nahya, '
        'wa bika namutu, '
        'wa ilaykan-nushur.',
    englishTranslation:
        'O Allah, by You we enter the evening, '
        'by You we enter the morning, '
        'by You we live, by You we die, '
        'and to You is the resurrection.',
    urduTranslation:
        'اے اللہ! تیرے ہی ذریعے ہم نے شام کی، '
        'تیرے ہی ذریعے ہم صبح کرتے ہیں، '
        'تیرے ہی ذریعے ہم زندہ ہیں، '
        'تیرے ہی ذریعے ہم مرتے ہیں، '
        'اور تیری ہی طرف دوبارہ اٹھنا ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Jami` at-Tirmidhi 3391; Sunan Ibn Majah 3868',
    repeatCount: 1,
    notes:
        'Recite once upon entering the evening.',
    benefit:
        'An established evening remembrance acknowledging that life, death and resurrection are by Allah.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_bismillah_protection',
    title: 'Protection from Harm',
    categoryId: 'evening',
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ '
        'شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ '
        'وَهُوَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Bismillahil-ladhi la yadurru ma‘asmihi shay’un '
        'fil-ardi wa la fis-sama’i '
        'wa Huwas-Sami‘ul-‘Alim.',
    englishTranslation:
        'In the Name of Allah, with Whose Name nothing '
        'on earth or in heaven can cause harm, '
        'and He is the All-Hearing, the All-Knowing.',
    urduTranslation:
        'اللہ کے نام کے ساتھ، جس کے نام کے ساتھ '
        'زمین اور آسمان میں کوئی چیز نقصان نہیں پہنچا سکتی، '
        'اور وہی سب کچھ سننے والا، سب کچھ جاننے والا ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference: 'Jami` at-Tirmidhi 3388',
    repeatCount: 3,
    notes:
        'Recite three times in the evening.',
    benefit:
        'The narration prescribes this three times in the morning and evening.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_raditu_billahi',
    title: 'Contentment with Allah, Islam and the Prophet ﷺ',
    categoryId: 'evening',
    arabic:
        'رَضِيتُ بِاللَّهِ رَبًّا، '
        'وَبِالْإِسْلَامِ دِينًا، '
        'وَبِمُحَمَّدٍ ﷺ نَبِيًّا',
    transliteration:
        'Raditu billahi Rabban, '
        'wa bil-Islami dinan, '
        'wa bi Muhammadin ﷺ nabiyyan.',
    englishTranslation:
        'I am pleased with Allah as my Lord, '
        'with Islam as my religion, '
        'and with Muhammad ﷺ as my Prophet.',
    urduTranslation:
        'میں اللہ کو اپنا رب مان کر، '
        'اسلام کو اپنا دین مان کر، '
        'اور محمد ﷺ کو اپنا نبی مان کر راضی ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Sunan Ibn Majah 3870; Hisn al-Muslim 87',
    repeatCount: 3,
    notes:
        'Recite three times in the evening.',
    benefit:
        'An established morning and evening declaration of contentment with Allah, Islam and Muhammad ﷺ.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_shaytan_protection',
    title: 'Protection from the Self and Shaytan',
    categoryId: 'evening',
    arabic:
        'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، '
        'فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، '
        'رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، '
        'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، '
        'أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، '
        'وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ',
    transliteration:
        'Allahumma ‘alimal-ghaybi wash-shahadah, '
        'fatiras-samawati wal-ard, '
        'Rabba kulli shay’in wa malikahu, '
        'ash-hadu an la ilaha illa Anta, '
        'a‘udhu bika min sharri nafsi, '
        'wa min sharrish-shaytani wa shirkihi.',
    englishTranslation:
        'O Allah, Knower of the unseen and the seen, '
        'Originator of the heavens and the earth, '
        'Lord and Sovereign of everything, '
        'I bear witness that none has the right to be worshipped except You. '
        'I seek refuge in You from the evil of myself '
        'and from the evil of Shaytan and his shirk.',
    urduTranslation:
        'اے اللہ! پوشیدہ اور ظاہر کو جاننے والے، '
        'آسمانوں اور زمین کو پیدا کرنے والے، '
        'ہر چیز کے رب اور مالک! '
        'میں گواہی دیتا ہوں کہ تیرے سوا کوئی معبود نہیں۔ '
        'میں اپنے نفس کے شر اور شیطان کے شر '
        'اور اس کے شرک سے تیری پناہ مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Jami` at-Tirmidhi 3392',
    repeatCount: 1,
    notes:
        'Recite in the morning, evening and before sleep.',
    benefit:
        'The Prophet ﷺ instructed Abu Bakr to say this in the morning, evening and before sleeping.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_afiyah',
    title: 'Forgiveness and Well-Being',
    categoryId: 'evening',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ '
        'فِي الدُّنْيَا وَالْآخِرَةِ، '
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ '
        'فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي، '
        'اللَّهُمَّ اسْتُرْ عَوْرَاتِي وَآمِنْ رَوْعَاتِي، '
        'وَاحْفَظْنِي مِنْ بَيْنِ يَدَيَّ وَمِنْ خَلْفِي '
        'وَعَنْ يَمِينِي وَعَنْ شِمَالِي وَمِنْ فَوْقِي، '
        'وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ مِنْ تَحْتِي',
    transliteration:
        'Allahumma inni as’alukal-‘afwa wal-‘afiyata '
        'fid-dunya wal-akhirah. '
        'Allahumma inni as’alukal-‘afwa wal-‘afiyata '
        'fi dini wa dunyaya wa ahli wa mali. '
        'Allahummastur ‘awrati wa amin raw‘ati, '
        'wahfazni min bayni yadayya wa min khalfi '
        'wa ‘an yamini wa ‘an shimali wa min fawqi, '
        'wa a‘udhu bi ‘azamatika an ughtala min tahti.',
    englishTranslation:
        'O Allah, I ask You for forgiveness and well-being '
        'in this world and the Hereafter. '
        'O Allah, I ask You for forgiveness and well-being '
        'in my religion, my worldly affairs, my family and my wealth. '
        'O Allah, conceal my faults, calm my fears, '
        'and protect me from in front of me, behind me, '
        'on my right, on my left and above me. '
        'I seek refuge in Your greatness from being unexpectedly harmed from beneath me.',
    urduTranslation:
        'اے اللہ! میں تجھ سے دنیا اور آخرت میں معافی اور عافیت مانگتا ہوں۔ '
        'اے اللہ! میں اپنے دین، دنیا، اہل و عیال اور مال میں معافی اور عافیت مانگتا ہوں۔ '
        'اے اللہ! میری پردہ پوشی فرما، میرے خوف کو امن عطا فرما، '
        'اور مجھے آگے، پیچھے، دائیں، بائیں اور اوپر سے محفوظ فرما۔ '
        'میں تیری عظمت کی پناہ مانگتا ہوں کہ نیچے سے اچانک کسی آفت میں گرفتار کیا جاؤں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sunan Ibn Majah 3871',
    repeatCount: 1,
    notes:
        'Among the supplications recited morning and evening.',
    benefit:
        'A comprehensive supplication for forgiveness, well-being and protection.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_subhanallahi_bihamdihi_100',
    title: 'SubhanAllahi wa Bihamdihi',
    categoryId: 'evening',
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
    reference: 'Sahih Muslim 2692',
    repeatCount: 100,
    notes:
        'Recite one hundred times in the evening.',
    benefit:
        'The narration specifically prescribes this remembrance one hundred times in the morning and evening.',
    isEvening: true,
  ),

  DuaAdhkarItem(
    id: 'evening_amsayna_mulku_lillah',
    title: 'The Kingdom Belongs to Allah',
    categoryId: 'evening',
    arabic:
        'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، '
        'وَالْحَمْدُ لِلَّهِ، '
        'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، '
        'لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، '
        'وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، '
        'رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذِهِ اللَّيْلَةِ '
        'وَخَيْرَ مَا بَعْدَهَا، '
        'وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذِهِ اللَّيْلَةِ '
        'وَشَرِّ مَا بَعْدَهَا، '
        'رَبِّ أَعُوذُ بِكَ مِنَ الْكَسَلِ وَسُوءِ الْكِبَرِ، '
        'رَبِّ أَعُوذُ بِكَ مِنْ عَذَابٍ فِي النَّارِ '
        'وَعَذَابٍ فِي الْقَبْرِ',
    transliteration:
        'Amsayna wa amsal-mulku lillah, '
        'wal-hamdu lillah. '
        'La ilaha illallahu wahdahu la sharika lah, '
        'lahul-mulku wa lahul-hamd, '
        'wa Huwa ‘ala kulli shay’in Qadir. '
        'Rabbi as’aluka khayra ma fi hadhihil-laylah '
        'wa khayra ma ba‘daha, '
        'wa a‘udhu bika min sharri ma fi hadhihil-laylah '
        'wa sharri ma ba‘daha. '
        'Rabbi a‘udhu bika minal-kasali wa su’il-kibar. '
        'Rabbi a‘udhu bika min ‘adhabin fin-nari '
        'wa ‘adhabin fil-qabr.',
    englishTranslation:
        'We have entered the evening and the kingdom belongs to Allah. '
        'All praise belongs to Allah. '
        'None has the right to be worshipped except Allah alone, without partner. '
        'To Him belongs the kingdom and to Him belongs all praise, '
        'and He has power over all things. '
        'My Lord, I ask You for the good of this night and the good that follows it, '
        'and I seek refuge in You from the evil of this night and the evil that follows it. '
        'My Lord, I seek refuge in You from laziness and the evils of old age. '
        'My Lord, I seek refuge in You from punishment in the Fire and punishment in the grave.',
    urduTranslation:
        'ہم نے شام کی اور ساری بادشاہی اللہ ہی کی ہے، '
        'اور تمام تعریف اللہ کے لیے ہے۔ '
        'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں۔ '
        'اسی کے لیے بادشاہی ہے اور اسی کے لیے تمام تعریف ہے، '
        'اور وہ ہر چیز پر قادر ہے۔ '
        'اے میرے رب! میں تجھ سے اس رات کی بھلائی '
        'اور اس کے بعد آنے والی بھلائی مانگتا ہوں، '
        'اور اس رات کے شر اور اس کے بعد کے شر سے تیری پناہ مانگتا ہوں۔ '
        'اے میرے رب! میں سستی اور بڑھاپے کی برائی سے تیری پناہ مانگتا ہوں۔ '
        'اے میرے رب! میں آگ کے عذاب اور قبر کے عذاب سے تیری پناہ مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 1455',
    repeatCount: 1,
    notes:
        'Recite once in the evening.',
    benefit:
        'A comprehensive evening remembrance containing praise, tawhid and supplication for the night ahead.',
    isEvening: true,
  ),
];