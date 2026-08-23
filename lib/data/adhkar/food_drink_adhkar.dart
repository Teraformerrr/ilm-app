import '../../models/dua_adhkar_item.dart';

const List<DuaAdhkarItem>
    foodDrinkAdhkar = [
  DuaAdhkarItem(
    id: 'food_bismillah_before_eating',
    title: 'Before Eating',
    categoryId: 'food',
    arabic:
        'بِسْمِ اللَّهِ',
    transliteration:
        'Bismillah.',
    englishTranslation:
        'In the Name of Allah.',
    urduTranslation:
        'اللہ کے نام سے۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.sahih,
    reference:
        'Sahih al-Bukhari and Muslim; Riyad as-Salihin 727',
    repeatCount:
        1,
    notes:
        'Say before beginning to eat.',
    method:
        'Mention Allah’s Name, eat with the right hand and eat from what is nearest to you.',
    references: [
      DuaReference(
        source:
            'Riyad as-Salihin',
        reference:
            '727',
        grade:
            'Sahih — underlying Bukhari/Muslim narration',
      ),
    ],
    occasions: [
      DuaOccasion.food,
    ],
    tags: [
      'food',
      'eating',
      'bismillah',
    ],
    requiresMethodInstruction:
        true,
  ),

  DuaAdhkarItem(
    id: 'food_bismillah_if_forgot',
    title:
        'If You Forgot Bismillah',
    categoryId:
        'food',
    arabic:
        'بِسْمِ اللَّهِ أَوَّلَهُ وَآخِرَهُ',
    transliteration:
        'Bismillahi awwalahu wa akhirahu.',
    englishTranslation:
        'In the Name of Allah at its beginning and its end.',
    urduTranslation:
        'اللہ کے نام سے، اس کے شروع میں بھی اور آخر میں بھی۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.hasan,
    reference:
        'Sunan Ibn Majah 3264; Abu Dawud; At-Tirmidhi',
    repeatCount:
        1,
    notes:
        'Say this if you forgot to mention Allah’s Name before beginning the meal.',
    references: [
      DuaReference(
        source:
            'Sunan Ibn Majah',
        reference:
            '3264',
        note:
            'Reports the instruction for one who forgot to say Bismillah initially.',
      ),
    ],
    occasions: [
      DuaOccasion.food,
    ],
    tags: [
      'food',
      'forgot bismillah',
    ],
  ),

  DuaAdhkarItem(
    id: 'food_after_eating_praise',
    title:
        'After Eating',
    categoryId:
        'food',
    arabic:
        'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا '
        'وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي '
        'وَلَا قُوَّةٍ',
    transliteration:
        'Alhamdu lillahil-ladhi at‘amani hadha '
        'wa razaqanihi min ghayri hawlin minni '
        'wa la quwwah.',
    englishTranslation:
        'All praise belongs to Allah Who fed me this '
        'and provided it for me without any power '
        'or strength from myself.',
    urduTranslation:
        'تمام تعریف اللہ کے لیے ہے جس نے مجھے یہ کھانا کھلایا '
        'اور بغیر میری کسی طاقت اور قوت کے مجھے یہ رزق عطا فرمایا۔',
    sourceType:
        DuaSourceType.hadith,
    authenticity:
        DuaAuthenticity.hasan,
    reference:
        'Sunan Ibn Majah 3285',
    repeatCount:
        1,
    notes:
        'Recite after finishing food.',
    benefit:
        'The narration mentions forgiveness of previous sins for the one who says this after eating.',
    benefitDirectlySourced:
        true,
    references: [
      DuaReference(
        source:
            'Sunan Ibn Majah',
        reference:
            '3285',
        grade:
            'Hasan',
      ),
    ],
    occasions: [
      DuaOccasion.food,
      DuaOccasion.provision,
    ],
    tags: [
      'food',
      'after eating',
      'gratitude',
      'rizq',
    ],
  ),
];