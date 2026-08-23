import '../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> morningAdhkar = [
  DuaAdhkarItem(
    id: 'morning_sayyid_al_istighfar',
    title: 'Sayyid al-Istighfar',
    categoryId: 'morning',
    arabic:
        'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، '
        'خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ '
        'وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ '
        'مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، '
        'وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي، فَإِنَّهُ لَا '
        'يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
    transliteration:
        'Allahumma anta Rabbi la ilaha illa Anta, '
        'khalaqtani wa ana abduka, wa ana ala ahdika '
        'wa wa’dika mastata’tu. A’udhu bika min sharri '
        'ma sana’tu. Abu’u laka bini’matika alayya, '
        'wa abu’u bidhanbi, faghfir li, fa innahu la '
        'yaghfirudh-dhunuba illa Anta.',
    englishTranslation:
        'O Allah, You are my Lord. None has the right to be worshipped except You. '
        'You created me and I am Your servant. I remain faithful to Your covenant '
        'and promise as much as I am able. I seek refuge in You from the evil of '
        'what I have done. I acknowledge Your blessings upon me and I acknowledge '
        'my sins, so forgive me, for none forgives sins except You.',
    urduTranslation:
        'اے اللہ! تو ہی میرا رب ہے، تیرے سوا کوئی معبود نہیں۔ '
        'تو نے مجھے پیدا کیا اور میں تیرا بندہ ہوں۔ میں اپنی استطاعت '
        'کے مطابق تیرے عہد اور وعدے پر قائم ہوں۔ میں اپنے کیے ہوئے '
        'اعمال کے شر سے تیری پناہ مانگتا ہوں۔ میں اپنے اوپر تیری '
        'نعمتوں کا اقرار کرتا ہوں اور اپنے گناہوں کا بھی اعتراف کرتا ہوں، '
        'پس مجھے بخش دے، کیونکہ تیرے سوا کوئی گناہوں کو نہیں بخش سکتا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 6306',
    repeatCount: 1,
    notes:
        'Recite in the morning with sincerity and conviction.',
    benefit:
        'The Prophet ﷺ described this as the foremost supplication for seeking forgiveness.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_ikhlas',
    title: 'Surah Al-Ikhlas',
    categoryId: 'morning',
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
        'Qur’an 112:1-4; Jami` at-Tirmidhi 3575 for morning/evening repetition',
    repeatCount: 3,
    notes:
        'Recite three times in the morning.',
    benefit:
        'Recited together with Al-Falaq and An-Nas three times in the morning and evening.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_falaq',
    title: 'Surah Al-Falaq',
    categoryId: 'morning',
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
        'Say: I seek refuge in the Lord of daybreak, from the evil of what He created, '
        'from the evil of darkness when it settles, from the evil of those who blow on knots, '
        'and from the evil of an envier when he envies.',
    urduTranslation:
        'کہہ دیجئے: میں صبح کے رب کی پناہ مانگتا ہوں، ہر اس چیز کے شر سے '
        'جو اس نے پیدا کی، رات کی تاریکی کے شر سے جب وہ چھا جائے، '
        'گرہوں میں پھونکنے والوں کے شر سے، اور حسد کرنے والے کے شر سے جب وہ حسد کرے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 113:1-5; Jami` at-Tirmidhi 3575 for morning/evening repetition',
    repeatCount: 3,
    notes:
        'Recite three times in the morning.',
    benefit:
        'Part of the three protective surahs recited morning and evening.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_nas',
    title: 'Surah An-Nas',
    categoryId: 'morning',
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
        'Say: I seek refuge in the Lord of mankind, the King of mankind, '
        'the God of mankind, from the evil of the retreating whisperer, '
        'who whispers into the hearts of mankind, from among jinn and mankind.',
    urduTranslation:
        'کہہ دیجئے: میں لوگوں کے رب، لوگوں کے بادشاہ اور لوگوں کے معبود کی پناہ مانگتا ہوں، '
        'وسوسہ ڈال کر پیچھے ہٹ جانے والے کے شر سے، جو لوگوں کے دلوں میں وسوسے ڈالتا ہے، '
        'خواہ وہ جنات میں سے ہو یا انسانوں میں سے۔',
    sourceType: DuaSourceType.quran,
    authenticity: DuaAuthenticity.quran,
    reference:
        'Qur’an 114:1-6; Jami` at-Tirmidhi 3575 for morning/evening repetition',
    repeatCount: 3,
    notes:
        'Recite three times in the morning.',
    benefit:
        'Part of the three protective surahs recited morning and evening.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_bismillah_protection',
    title: 'Protection from Harm',
    categoryId: 'morning',
    arabic:
        'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ '
        'شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ '
        'وَهُوَ السَّمِيعُ الْعَلِيمُ',
    transliteration:
        'Bismillahil-ladhi la yadurru ma‘asmihi shay’un '
        'fil-ardi wa la fis-sama’i wa Huwas-Sami‘ul-‘Alim.',
    englishTranslation:
        'In the Name of Allah, with Whose Name nothing on earth or in heaven can cause harm, '
        'and He is the All-Hearing, the All-Knowing.',
    urduTranslation:
        'اللہ کے نام کے ساتھ، جس کے نام کے ساتھ زمین اور آسمان میں کوئی چیز نقصان نہیں پہنچا سکتی، '
        'اور وہی سب کچھ سننے والا، سب کچھ جاننے والا ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Jami` at-Tirmidhi 3388; Abu Dawud; Riyad as-Salihin 1457',
    repeatCount: 3,
    notes:
        'Recite three times in the morning.',
    benefit:
        'An established morning and evening supplication seeking protection from harm.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_raditu_billahi',
    title: 'Contentment with Allah, Islam and the Prophet ﷺ',
    categoryId: 'morning',
    arabic:
        'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، '
        'وَبِمُحَمَّدٍ ﷺ نَبِيًّا',
    transliteration:
        'Raditu billahi Rabban, wa bil-Islami dinan, '
        'wa bi Muhammadin ﷺ nabiyyan.',
    englishTranslation:
        'I am pleased with Allah as my Lord, with Islam as my religion, '
        'and with Muhammad ﷺ as my Prophet.',
    urduTranslation:
        'میں اللہ کو اپنا رب مان کر، اسلام کو اپنا دین مان کر، '
        'اور محمد ﷺ کو اپنا نبی مان کر راضی ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Hisn al-Muslim 87; related reports in At-Tirmidhi, Ahmad and Ibn Majah',
    repeatCount: 3,
    notes:
        'Recite three times in the morning.',
    benefit:
        'An established morning and evening declaration of contentment with Allah, Islam and Muhammad ﷺ.',
    isMorning: true,
  ),

  DuaAdhkarItem(
    id: 'morning_afiyah',
    title: 'Forgiveness and Well-Being',
    categoryId: 'morning',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ '
        'فِي الدُّنْيَا وَالْآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ '
        'الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ '
        'وَأَهْلِي وَمَالِي، اللَّهُمَّ اسْتُرْ عَوْرَاتِي '
        'وَآمِنْ رَوْعَاتِي، وَاحْفَظْنِي مِنْ بَيْنِ يَدَيَّ '
        'وَمِنْ خَلْفِي وَعَنْ يَمِينِي وَعَنْ شِمَالِي '
        'وَمِنْ فَوْقِي، وَأَعُوذُ بِعَظَمَتِكَ أَنْ أُغْتَالَ '
        'مِنْ تَحْتِي',
    transliteration:
        'Allahumma inni as’alukal-‘afwa wal-‘afiyata fid-dunya wal-akhirah. '
        'Allahumma inni as’alukal-‘afwa wal-‘afiyata fi dini wa dunyaya '
        'wa ahli wa mali. Allahummastur ‘awrati wa amin raw‘ati, '
        'wahfazni min bayni yadayya wa min khalfi wa ‘an yamini '
        'wa ‘an shimali wa min fawqi, wa a‘udhu bi ‘azamatika '
        'an ughtala min tahti.',
    englishTranslation:
        'O Allah, I ask You for forgiveness and well-being in this world and the Hereafter. '
        'O Allah, I ask You for forgiveness and well-being in my religion, my worldly affairs, '
        'my family and my wealth. O Allah, conceal my faults, calm my fears, and protect me '
        'from in front of me, behind me, on my right, on my left and above me. '
        'I seek refuge in Your greatness from being unexpectedly harmed from beneath me.',
    urduTranslation:
        'اے اللہ! میں تجھ سے دنیا اور آخرت میں معافی اور عافیت مانگتا ہوں۔ '
        'اے اللہ! میں اپنے دین، دنیا، اہل و عیال اور مال میں معافی اور عافیت مانگتا ہوں۔ '
        'اے اللہ! میری پردہ پوشی فرما، میرے خوف کو امن عطا فرما، اور مجھے آگے، پیچھے، '
        'دائیں، بائیں اور اوپر سے محفوظ فرما۔ میں تیری عظمت کی پناہ مانگتا ہوں کہ '
        'نیچے سے اچانک کسی آفت میں گرفتار کیا جاؤں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference: 'Sunan Ibn Majah 3871; Abu Dawud',
    repeatCount: 1,
    notes:
        'Among the supplications the Prophet ﷺ regularly recited morning and evening.',
    benefit:
        'A comprehensive supplication for forgiveness, well-being and protection.',
    isMorning: true,
  ),
  DuaAdhkarItem(
  id: 'morning_bika_asbahna',
  title: 'By Allah We Enter the Morning',
  categoryId: 'morning',
  arabic:
      'اللَّهُمَّ بِكَ أَصْبَحْنَا، '
      'وَبِكَ أَمْسَيْنَا، '
      'وَبِكَ نَحْيَا، '
      'وَبِكَ نَمُوتُ، '
      'وَإِلَيْكَ النُّشُورُ',
  transliteration:
      'Allahumma bika asbahna, '
      'wa bika amsayna, '
      'wa bika nahya, '
      'wa bika namutu, '
      'wa ilaykan-nushur.',
  englishTranslation:
      'O Allah, by You we enter the morning, '
      'by You we enter the evening, '
      'by You we live, by You we die, '
      'and to You is the resurrection.',
  urduTranslation:
      'اے اللہ! تیرے ہی ذریعے ہم نے صبح کی، '
      'تیرے ہی ذریعے ہم شام کرتے ہیں، '
      'تیرے ہی ذریعے ہم زندہ ہیں، '
      'تیرے ہی ذریعے ہم مرتے ہیں، '
      'اور تیری ہی طرف دوبارہ اٹھ کر جانا ہے۔',
  sourceType: DuaSourceType.hadith,
  authenticity: DuaAuthenticity.sahih,
  reference: 'Sunan Abi Dawud 5068',
  repeatCount: 1,
  notes:
      'Recite once upon entering the morning.',
  benefit:
      'A Prophetic morning remembrance acknowledging '
      'that life, death and resurrection are by Allah.',
  isMorning: true,
),
DuaAdhkarItem(
  id: 'morning_shaytan_protection',
  title: 'Protection from the Self and Shaytan',
  categoryId: 'morning',
  arabic:
      'اللَّهُمَّ عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، '
      'فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، '
      'رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، '
      'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، '
      'أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي، '
      'وَمِنْ شَرِّ الشَّيْطَانِ وَشِرْكِهِ',
  transliteration:
      'Allahumma alimal-ghaybi wash-shahadah, '
      'fatiras-samawati wal-ard, '
      'Rabba kulli shay-in wa malikahu, '
      'ash-hadu an la ilaha illa Anta, '
      'a udhu bika min sharri nafsi, '
      'wa min sharrish-shaytani wa shirkihi.',
  englishTranslation:
      'O Allah, Knower of the unseen and the seen, '
      'Originator of the heavens and the earth, '
      'Lord and Sovereign of everything, '
      'I bear witness that none has the right to be '
      'worshipped except You. I seek refuge in You '
      'from the evil of myself and from the evil '
      'of Shaytan and his shirk.',
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
      'The Prophet ﷺ taught Abu Bakr to say this '
      'in the morning, evening and when going to bed.',
  isMorning: true,
),
DuaAdhkarItem(
  id: 'morning_subhanallahi_bihamdihi_100',
  title: 'SubhanAllahi wa Bihamdihi',
  categoryId: 'morning',
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
      'Recite one hundred times in the morning.',
  benefit:
      'The Prophet ﷺ mentioned a special virtue '
      'for saying this one hundred times in the '
      'morning and evening.',
  isMorning: true,
),
];