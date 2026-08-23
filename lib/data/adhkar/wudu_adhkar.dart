import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> wuduAdhkar = [
  DuaAdhkarItem(
    id: 'wudu_after_shahadah',
    title: 'After Completing Wudu',
    categoryId: 'wudu',
    arabic:
        'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا اللَّهُ '
        'وَحْدَهُ لَا شَرِيكَ لَهُ، '
        'وَأَشْهَدُ أَنَّ مُحَمَّدًا '
        'عَبْدُهُ وَرَسُولُهُ',
    transliteration:
        'Ash-hadu an la ilaha illallahu '
        'wahdahu la sharika lah, '
        'wa ash-hadu anna Muhammadan '
        '‘abduhu wa rasuluh.',
    englishTranslation:
        'I testify that there is no deity worthy of worship except Allah alone, '
        'without partner, and I testify that Muhammad is His servant and Messenger.',
    urduTranslation:
        'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود برحق نہیں، '
        'وہ اکیلا ہے، اس کا کوئی شریک نہیں، '
        'اور میں گواہی دیتا ہوں کہ محمد ﷺ اس کے بندے اور رسول ہیں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.sahih,
    reference: 'Sahih Muslim 234a',
    repeatCount: 1,
    notes:
        'Recite after completing wudu properly.',
    benefit:
        'The narration states that the eight gates of Paradise are opened for the person who performs wudu well and says this testimony.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Sahih Muslim',
        reference: '234a',
        grade: 'Sahih',
      ),
    ],
    occasions: [
      DuaOccasion.wudu,
    ],
    tags: [
      'wudu',
      'ablution',
      'shahadah',
      'purification',
    ],
    isPropheticDua: true,
  ),
];