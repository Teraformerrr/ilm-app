import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> fastingAdhkar = [
  DuaAdhkarItem(
    id: 'fasting_break_fast',
    title: 'Upon Breaking the Fast',
    categoryId: 'fasting',
    arabic:
        'ذَهَبَ الظَّمَأُ، '
        'وَابْتَلَّتِ الْعُرُوقُ، '
        'وَثَبَتَ الْأَجْرُ '
        'إِنْ شَاءَ اللَّهُ',
    transliteration:
        'Dhahabaz-zama’u, '
        'wabtallatil-‘uruqu, '
        'wa thabatal-ajru '
        'in sha’ Allah.',
    englishTranslation:
        'The thirst has gone, the veins are moistened, '
        'and the reward is confirmed, if Allah wills.',
    urduTranslation:
        'پیاس ختم ہو گئی، رگیں تر ہو گئیں '
        'اور اگر اللہ نے چاہا تو اجر ثابت ہو گیا۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference: 'Sunan Abi Dawud 2357',
    repeatCount: 1,
    notes:
        'Recite when breaking the fast.',
    references: [
      DuaReference(
        source: 'Sunan Abi Dawud',
        reference: '2357',
        grade: 'Hasan',
      ),
    ],
    occasions: [
      DuaOccasion.fasting,
    ],
    tags: [
      'fasting',
      'iftar',
      'ramadan',
      'breaking fast',
    ],
    isPropheticDua: true,
  ),
];