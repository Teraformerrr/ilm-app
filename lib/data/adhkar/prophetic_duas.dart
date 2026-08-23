import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> propheticDuas = [
  DuaAdhkarItem(
    id: 'prophetic_guidance_piety_sufficiency',
    title: 'Guidance, Piety, Chastity and Sufficiency',
    categoryId: 'prophetic_duas',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ '
        'الْهُدَى وَالتُّقَى '
        'وَالْعَفَافَ وَالْغِنَى',
    transliteration:
        'Allahumma inni as’alukal-huda '
        'wat-tuqa wal-‘afafa wal-ghina.',
    englishTranslation:
        'O Allah, I ask You for guidance, '
        'piety, chastity and sufficiency.',
    urduTranslation:
        'اے اللہ! میں تجھ سے ہدایت، تقویٰ، پاکدامنی '
        'اور بے نیازی مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih Muslim; Riyad as-Salihin 1468',
    notes:
        'A supplication the Prophet ﷺ used to make.',
    references: [
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '1468',
        grade: 'Sahih — sourced from Muslim',
      ),
    ],
    occasions: [
      DuaOccasion.general,
      DuaOccasion.provision,
    ],
    tags: [
      'guidance',
      'piety',
      'chastity',
      'sufficiency',
      'contentment',
    ],
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'prophetic_anxiety_grief_debt',
    title: 'Protection from Anxiety, Grief and Debt',
    categoryId: 'prophetic_duas',
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ '
        'مِنَ الْهَمِّ وَالْحَزَنِ، '
        'وَالْعَجْزِ وَالْكَسَلِ، '
        'وَالْبُخْلِ وَالْجُبْنِ، '
        'وَضَلَعِ الدَّيْنِ '
        'وَغَلَبَةِ الرِّجَالِ',
    transliteration:
        'Allahumma inni a‘udhu bika '
        'minal-hammi wal-hazan, '
        'wal-‘ajzi wal-kasal, '
        'wal-bukhli wal-jubn, '
        'wa dala‘id-dayni '
        'wa ghalabatir-rijal.',
    englishTranslation:
        'O Allah, I seek refuge in You from anxiety and grief, '
        'from incapacity and laziness, '
        'from miserliness and cowardice, '
        'from the burden of debt '
        'and from being overpowered by others.',
    urduTranslation:
        'اے اللہ! میں تیری پناہ مانگتا ہوں '
        'فکر اور غم سے، '
        'بے بسی اور سستی سے، '
        'بخل اور بزدلی سے، '
        'قرض کے بوجھ سے '
        'اور لوگوں کے غلبے سے۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Sahih al-Bukhari; Hisn al-Muslim 121',
    notes:
        'A comprehensive supplication seeking refuge from anxiety, weakness and overwhelming debt.',
    references: [
      DuaReference(
        source: 'Hisn al-Muslim',
        reference: '121',
        note:
            'References the narration in Sahih al-Bukhari.',
      ),
    ],
    occasions: [
      DuaOccasion.distress,
      DuaOccasion.debt,
      DuaOccasion.protection,
    ],
    tags: [
      'anxiety',
      'grief',
      'debt',
      'laziness',
      'fear',
      'protection',
    ],
    isPropheticDua: true,
    isProtection: true,
    isSharedAcrossCollections: true,
  ),

  DuaAdhkarItem(
    id: 'prophetic_afiyah_general',
    title: 'Forgiveness and Well-Being',
    categoryId: 'prophetic_duas',
    arabic:
        'اللَّهُمَّ إِنِّي أَسْأَلُكَ '
        'الْعَفْوَ وَالْعَافِيَةَ '
        'فِي الدُّنْيَا وَالْآخِرَةِ',
    transliteration:
        'Allahumma inni as’alukal-‘afwa '
        'wal-‘afiyata fid-dunya wal-akhirah.',
    englishTranslation:
        'O Allah, I ask You for forgiveness and well-being '
        'in this world and the Hereafter.',
    urduTranslation:
        'اے اللہ! میں تجھ سے دنیا اور آخرت میں '
        'معافی اور عافیت مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference:
        'Established within the morning/evening supplication reported in Sunan Ibn Majah 3871',
    notes:
        'This wording forms the opening of the longer established morning and evening supplication.',
    occasions: [
      DuaOccasion.general,
      DuaOccasion.morning,
      DuaOccasion.evening,
      DuaOccasion.protection,
    ],
    tags: [
      'afiyah',
      'well-being',
      'forgiveness',
      'protection',
    ],
    isPropheticDua: true,
    isProtection: true,
    isSharedAcrossCollections: true,
  ),
];