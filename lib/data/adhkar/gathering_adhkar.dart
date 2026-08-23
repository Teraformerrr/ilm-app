import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem> gatheringAdhkar = [
  DuaAdhkarItem(
    id: 'gathering_expiation',
    title: 'Expiation of a Gathering',
    categoryId: 'gathering',
    arabic:
        'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ، '
        'أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ، '
        'أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ',
    transliteration:
        'Subhanakallahumma wa bihamdika, '
        'ash-hadu an la ilaha illa Anta, '
        'astaghfiruka wa atubu ilayk.',
    englishTranslation:
        'Glory and praise be to You, O Allah. '
        'I testify that there is no deity worthy of worship except You. '
        'I seek Your forgiveness and repent to You.',
    urduTranslation:
        'اے اللہ! تو پاک ہے اور تمام تعریف تیرے لیے ہے۔ '
        'میں گواہی دیتا ہوں کہ تیرے سوا کوئی معبود برحق نہیں۔ '
        'میں تجھ سے بخشش مانگتا ہوں اور تیری طرف توبہ کرتا ہوں۔',
    sourceType: DuaSourceType.hadith,
    authenticity: DuaAuthenticity.hasan,
    reference:
        'Jami` at-Tirmidhi; Riyad as-Salihin 831',
    repeatCount: 1,
    notes:
        'Recite before leaving a gathering.',
    benefit:
        'The narration states that it expiates what occurred of improper or useless speech in that gathering.',
    benefitDirectlySourced: true,
    references: [
      DuaReference(
        source: 'Riyad as-Salihin',
        reference: '831',
        note: 'Narrated from At-Tirmidhi.',
      ),
    ],
    occasions: [
      DuaOccasion.gathering,
      DuaOccasion.forgiveness,
      DuaOccasion.social,
    ],
    tags: [
      'gathering',
      'meeting',
      'forgiveness',
      'kaffarah',
    ],
    isPropheticDua: true,
  ),
];