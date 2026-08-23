import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> illnessHealingAdhkar = [
  DuaAdhkarItem(
    id: 'healing_pain_bismillah',
    title: 'For Pain in the Body',
    categoryId: 'illness_healing',
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillah.',
    englishTranslation: 'In the Name of Allah.',
    urduTranslation: 'اللہ کے نام سے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 2202',
    repeatCount: 3,
    notes:
        'Place your hand on the area of pain and say Bismillah three times. Then continue with the next supplication seven times.',
    method:
        'Place your hand on the part of the body where you feel pain. Say Bismillah three times.',
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '2202',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.illness,
    ],
    tags: [
      'pain',
      'illness',
      'healing',
      'body pain',
    ],
    isPropheticDua: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'healing_pain_refuge',
    title: 'Seek Refuge from the Pain',
    categoryId: 'illness_healing',
    arabic:
        'أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ '
        'مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ',
    transliteration:
        'A‘udhu billahi wa qudratihi '
        'min sharri ma ajidu wa uhadhiru.',
    englishTranslation:
        'I seek refuge in Allah and His power '
        'from the evil of what I feel and what I fear.',
    urduTranslation:
        'میں اللہ اور اس کی قدرت کی پناہ مانگتا ہوں '
        'اس تکلیف کے شر سے جو میں محسوس کرتا ہوں اور جس کا مجھے خوف ہے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 2202',
    repeatCount: 7,
    notes:
        'Recite seven times after saying Bismillah three times while placing your hand on the painful area.',
    method:
        'Keep your hand on the painful area. After saying Bismillah three times, recite this supplication seven times.',
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '2202',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.illness,
      DuaOccasion.protection,
    ],
    tags: [
      'pain',
      'healing',
      'illness',
      'protection',
    ],
    isProtection: true,
    isPropheticDua: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'healing_rabban_nas',
    title: 'Dua for Healing',
    categoryId: 'illness_healing',
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
        'O Allah, Lord of mankind, remove the suffering and grant healing. '
        'You are the Healer. There is no healing except Your healing, '
        'a healing that leaves no illness behind.',
    urduTranslation:
        'اے اللہ! لوگوں کے رب، تکلیف کو دور فرما اور شفا عطا فرما۔ '
        'تو ہی شفا دینے والا ہے۔ تیری شفا کے سوا کوئی شفا نہیں۔ '
        'ایسی شفا عطا فرما جو بیماری کو باقی نہ چھوڑے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari; Sahih Muslim',
    repeatCount: 1,
    notes:
        'A Prophetic supplication asking Allah for healing.',
    occasions: [
      DuaOccasion.illness,
    ],
    tags: [
      'healing',
      'sickness',
      'illness',
      'shifa',
    ],
    isPropheticDua: true,
  ),
];