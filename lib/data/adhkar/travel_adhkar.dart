import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> travelAdhkar = [
  DuaAdhkarItem(
    id: 'travel_main_dua',
    title: 'Dua for Beginning a Journey',
    categoryId: 'travel',
    arabic:
        'اللَّهُ أَكْبَرُ، '
        'اللَّهُ أَكْبَرُ، '
        'اللَّهُ أَكْبَرُ\n\n'
        'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا '
        'وَمَا كُنَّا لَهُ مُقْرِنِينَ، '
        'وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ\n\n'
        'اللَّهُمَّ إِنَّا نَسْأَلُكَ '
        'فِي سَفَرِنَا هَذَا الْبِرَّ وَالتَّقْوَى، '
        'وَمِنَ الْعَمَلِ مَا تَرْضَى\n\n'
        'اللَّهُمَّ هَوِّنْ عَلَيْنَا '
        'سَفَرَنَا هَذَا، '
        'وَاطْوِ عَنَّا بُعْدَهُ\n\n'
        'اللَّهُمَّ أَنْتَ الصَّاحِبُ فِي السَّفَرِ، '
        'وَالْخَلِيفَةُ فِي الْأَهْلِ\n\n'
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ '
        'مِنْ وَعْثَاءِ السَّفَرِ، '
        'وَكَآبَةِ الْمَنْظَرِ، '
        'وَسُوءِ الْمُنْقَلَبِ '
        'فِي الْمَالِ وَالْأَهْلِ',
    transliteration:
        'Allahu Akbar, Allahu Akbar, Allahu Akbar.\n\n'
        'Subhanal-ladhi sakhkhara lana hadha '
        'wa ma kunna lahu muqrinin, '
        'wa inna ila Rabbina lamunqalibun.\n\n'
        'Allahumma inna nas’aluka fi safarina hadhal-birra wat-taqwa, '
        'wa minal-‘amali ma tarda.\n\n'
        'Allahumma hawwin ‘alayna safarana hadha '
        'watwi ‘anna bu‘dah.\n\n'
        'Allahumma Antas-Sahibu fis-safar, '
        'wal-Khalifatu fil-ahl.\n\n'
        'Allahumma inni a‘udhu bika min wa‘tha’is-safar, '
        'wa ka’abatil-manzar, '
        'wa su’il-munqalabi fil-mali wal-ahl.',
    englishTranslation:
        'Allah is the Greatest, Allah is the Greatest, Allah is the Greatest. '
        'Glory be to the One Who has subjected this for us, '
        'though we could not have controlled it ourselves, '
        'and surely to our Lord we will return. '
        'O Allah, we ask You during this journey for righteousness, '
        'piety and deeds that please You. '
        'O Allah, make this journey easy for us and shorten its distance. '
        'O Allah, You are the Companion on the journey '
        'and the Guardian over the family. '
        'O Allah, I seek refuge in You from the hardship of travel, '
        'a distressing sight, and an unpleasant return concerning wealth and family.',
    urduTranslation:
        'اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے، اللہ سب سے بڑا ہے۔ '
        'پاک ہے وہ ذات جس نے اس سواری کو ہمارے لیے تابع کر دیا، '
        'حالانکہ ہم خود اسے قابو میں نہیں لا سکتے تھے، '
        'اور یقیناً ہم اپنے رب ہی کی طرف لوٹنے والے ہیں۔ '
        'اے اللہ! ہم اس سفر میں تجھ سے نیکی، تقویٰ '
        'اور وہ اعمال مانگتے ہیں جن سے تو راضی ہو۔ '
        'اے اللہ! ہمارے اس سفر کو آسان کر دے '
        'اور اس کی دوری کو ہمارے لیے سمیٹ دے۔ '
        'اے اللہ! سفر میں تو ہی ساتھی ہے '
        'اور گھر والوں کا نگہبان ہے۔ '
        'اے اللہ! میں سفر کی مشقت، پریشان کن منظر '
        'اور مال و اہل میں بری واپسی سے تیری پناہ مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 972',
    repeatCount: 1,
    notes:
        'Recite when setting out on a journey.',
    method:
        'The narration begins with saying Allahu Akbar three times, followed by the complete travel supplication.',
    references: [
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '972',
        grade: 'Sahih — sourced from Muslim',
      ),
    ],
    occasions: [
      DuaOccasion.travel,
      DuaOccasion.protection,
    ],
    tags: [
      'travel',
      'journey',
      'car',
      'plane',
      'transport',
      'protection',
    ],
    isProtection: true,
    isPropheticDua: true,
    requiresMethodInstruction: true,
  ),

  DuaAdhkarItem(
    id: 'travel_returning',
    title: 'When Returning from a Journey',
    categoryId: 'travel',
    arabic:
        'آيِبُونَ، '
        'تَائِبُونَ، '
        'عَابِدُونَ، '
        'لِرَبِّنَا حَامِدُونَ',
    transliteration:
        'Ayibuna, ta’ibuna, '
        '‘abiduna, '
        'li-Rabbina hamidun.',
    englishTranslation:
        'We return, repenting, worshipping, '
        'and praising our Lord.',
    urduTranslation:
        'ہم واپس آنے والے، توبہ کرنے والے، '
        'عبادت کرنے والے اور اپنے رب کی تعریف کرنے والے ہیں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 987',
    repeatCount: 1,
    notes:
        'Recite while returning from a journey.',
    references: [
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '987',
        grade: 'Sahih — sourced from Muslim',
      ),
    ],
    occasions: [
      DuaOccasion.travel,
    ],
    tags: [
      'travel',
      'returning',
      'repentance',
      'homecoming',
    ],
    isPropheticDua: true,
  ),
];