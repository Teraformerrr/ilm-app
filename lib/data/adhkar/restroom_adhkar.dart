import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> restroomAdhkar = [
  DuaAdhkarItem(
    id: 'restroom_entering_protection',
    title: 'Before Entering the Restroom',
    categoryId: 'restroom',
    arabic:
        'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ '
        'مِنَ الْخُبُثِ وَالْخَبَائِثِ',
    transliteration:
        'Allahumma inni a‘udhu bika '
        'minal-khubuthi wal-khaba’ith.',
    englishTranslation:
        'O Allah, I seek refuge in You from male and female devils.',
    urduTranslation:
        'اے اللہ! میں ناپاک شیاطین، مرد اور عورت، سے تیری پناہ مانگتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih al-Bukhari 142',
    repeatCount: 1,
    notes:
        'Recite before entering the restroom.',
    references: [
      DuaReference(
        source: 'Sahih al-Bukhari',
        reference: '142',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.restroom,
      DuaOccasion.protection,
    ],
    tags: [
      'restroom',
      'toilet',
      'bathroom',
      'protection',
    ],
    isProtection: true,
    isPropheticDua: true,
  ),

  DuaAdhkarItem(
    id: 'restroom_leaving_ghufranak',
    title: 'After Leaving the Restroom',
    categoryId: 'restroom',
    arabic:
        'غُفْرَانَكَ',
    transliteration:
        'Ghufranak.',
    englishTranslation:
        'I seek Your forgiveness.',
    urduTranslation:
        'میں تیری بخشش چاہتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Jami` at-Tirmidhi 7; Sunan Ibn Majah 300',
    repeatCount: 1,
    notes:
        'Recite after leaving the restroom.',
    authenticityNote:
        'At-Tirmidhi described the narration as Hasan Gharib. The displayed grading for Ibn Majah 300 is Sahih.',
    references: [
      DuaReference(
        source: 'Jami` at-Tirmidhi',
        reference: '7',
        grade: 'Hasan Gharib',
      ),
      DuaReference(
        source: 'Sunan Ibn Majah',
        reference: '300',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.restroom,
      DuaOccasion.forgiveness,
    ],
    tags: [
      'restroom',
      'toilet',
      'bathroom',
      'forgiveness',
    ],
    isPropheticDua: true,
  ),
];