enum DuaSourceType {
  quran,
  hadith,
  scholarly,
  generalDua,
  userRoutine,
}

enum DuaAuthenticity {
  quran,
  sahih,
  hasan,
  hasanSahih,
  accepted,
  weak,
  disputed,
  scholarlyGuidance,
  notApplicable,
}

enum DuaOccasion {
  morning,
  evening,
  beforeSleep,
  afterWaking,
  food,
  drink,
  home,
  mosque,
  restroom,
  wudu,
  salah,
  afterSalah,
  istikhara,
  fasting,
  travel,
  weather,
  illness,
  ruqyah,
  protection,
  distress,
  grief,
  debt,
  provision,
  forgiveness,
  family,
  children,
  marriage,
  sneezing,
  gathering,
  clothing,
  social,
  general,
}

class DuaReference {
  const DuaReference({
    required this.source,
    required this.reference,
    this.grade,
    this.note,
    this.url,
  });

  /// Example:
  ///
  /// Sahih al-Bukhari
  /// Sahih Muslim
  /// Jami' at-Tirmidhi
  /// Qur'an
  final String source;

  /// Example:
  ///
  /// 6306
  /// 2692
  /// 2:255
  final String reference;

  /// Optional grading attached specifically to this reference.
  ///
  /// Example:
  ///
  /// Sahih
  /// Hasan
  /// Hasan Sahih
  final String? grade;

  /// Additional clarification about this narration/reference.
  final String? note;

  /// Optional future source link.
  final String? url;

  String get displayText {
    if (reference.trim().isEmpty) {
      return source;
    }

    return '$source $reference';
  }
}

class QuranLocation {
  const QuranLocation({
    required this.surahNumber,
    required this.startAyah,
    this.endAyah,
  });

  final int surahNumber;

  final int startAyah;

  final int? endAyah;

  String get displayReference {
    if (endAyah == null ||
        endAyah == startAyah) {
      return 'Qur’an $surahNumber:$startAyah';
    }

    return 'Qur’an '
        '$surahNumber:$startAyah-$endAyah';
  }
}

class DuaAdhkarItem {
  const DuaAdhkarItem({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.arabic,
    required this.transliteration,
    required this.englishTranslation,
    required this.sourceType,
    required this.authenticity,
    required this.reference,

    this.urduTranslation,

    this.repeatCount,

    this.notes,

    this.benefit,

    this.audioAsset,

    this.method,

    this.authenticityNote,

    this.sourceTextNote,

    this.references =
        const <DuaReference>[],

    this.quranLocation,

    this.occasions =
        const <DuaOccasion>[],

    this.tags =
        const <String>[],

    this.alternateTitles =
        const <String>[],

    this.isRuqyah = false,

    this.isMorning = false,

    this.isEvening = false,

    this.isSleep = false,

    this.isWakeUp = false,

    this.isProtection = false,

    this.isHealing = false,

    this.isQuranicDua = false,

    this.isPropheticDua = false,

    this.isGeneralDhikr = false,

    this.isSharedAcrossCollections =
        false,

    this.benefitDirectlySourced =
        false,

    this.requiresMethodInstruction =
        false,
  });

  /// Unique stable identifier.
  ///
  /// Never change this after release if progress,
  /// favorites or routines depend on it.
  final String id;

  /// User-facing title.
  final String title;

  /// Main category identifier.
  ///
  /// Examples:
  ///
  /// morning
  /// evening
  /// sleep
  /// ruqyah
  /// protection
  final String categoryId;

  /// Original Arabic text.
  final String arabic;

  /// Roman transliteration.
  final String transliteration;

  /// English meaning.
  final String englishTranslation;

  /// Optional Urdu meaning.
  final String? urduTranslation;

  /// Qur'an, Hadith, scholarly guidance,
  /// general permissible dua or custom routine.
  final DuaSourceType sourceType;

  /// Overall authenticity classification.
  final DuaAuthenticity authenticity;

  /// Legacy/display reference.
  ///
  /// Existing data files already use this field,
  /// so we keep it for compatibility.
  ///
  /// Examples:
  ///
  /// Sahih al-Bukhari 6306
  /// Qur’an 2:255
  /// Sahih Muslim 2692
  final String reference;

  /// Structured references.
  ///
  /// An item may have multiple supporting sources.
  final List<DuaReference> references;

  /// Structured Qur'an location when applicable.
  final QuranLocation? quranLocation;

  /// Number of repetitions explicitly supported
  /// by the source.
  ///
  /// Null means ILM must NOT invent a count.
  final int? repeatCount;

  /// Usage notes.
  ///
  /// Example:
  ///
  /// "Recite in the morning and evening."
  final String? notes;

  /// Exact method when the Sunnah includes more
  /// than simply reading the words.
  ///
  /// Example for bedtime Mu'awwidhat:
  ///
  /// "Bring the palms together, blow lightly,
  /// recite the three surahs and wipe the body."
  final String? method;

  /// Benefit or virtue.
  ///
  /// This should remain conservative.
  final String? benefit;

  /// True only when the specific benefit written
  /// in [benefit] is directly established by
  /// Qur'an or the cited narration.
  final bool benefitDirectlySourced;

  /// Optional detail about grading differences.
  ///
  /// Example:
  ///
  /// "Graded Hasan Sahih by at-Tirmidhi."
  ///
  /// "Scholars differed regarding this narration."
  final String? authenticityNote;

  /// Optional textual/source clarification.
  ///
  /// Useful when authentic narrations contain
  /// multiple wording variants.
  final String? sourceTextNote;

  /// Future local/remote audio identifier.
  final String? audioAsset;

  /// Situations in which this dua/dhikr applies.
  ///
  /// One item may belong to several occasions.
  final List<DuaOccasion> occasions;

  /// Search/filter tags.
  ///
  /// Examples:
  ///
  /// protection
  /// forgiveness
  /// sleep
  /// evil-eye
  /// debt
  final List<String> tags;

  /// Alternate searchable titles.
  final List<String> alternateTitles;

  /// Specialized flags used by the app.
  final bool isRuqyah;

  final bool isMorning;

  final bool isEvening;

  final bool isSleep;

  final bool isWakeUp;

  final bool isProtection;

  final bool isHealing;

  final bool isQuranicDua;

  final bool isPropheticDua;

  final bool isGeneralDhikr;

  /// True when the exact same item can legitimately
  /// appear in multiple collections.
  ///
  /// Example:
  ///
  /// morning + evening
  /// morning + evening + sleep
  final bool isSharedAcrossCollections;

  /// True when the Sunnah includes a specific
  /// physical/action method that should be shown
  /// prominently in the reader.
  final bool requiresMethodInstruction;

  bool get hasFixedRepeatCount {
    return repeatCount != null &&
        repeatCount! > 0;
  }

  bool get hasUrduTranslation {
    return urduTranslation != null &&
        urduTranslation!
            .trim()
            .isNotEmpty;
  }

  bool get hasAudio {
    return audioAsset != null &&
        audioAsset!
            .trim()
            .isNotEmpty;
  }

  bool get hasMethod {
    return method != null &&
        method!
            .trim()
            .isNotEmpty;
  }

  bool get hasBenefit {
    return benefit != null &&
        benefit!
            .trim()
            .isNotEmpty;
  }

  bool get hasAuthenticityNote {
    return authenticityNote != null &&
        authenticityNote!
            .trim()
            .isNotEmpty;
  }

  bool get hasSourceTextNote {
    return sourceTextNote != null &&
        sourceTextNote!
            .trim()
            .isNotEmpty;
  }

  bool get hasStructuredReferences {
    return references.isNotEmpty;
  }

  bool get isQuran {
    return sourceType ==
            DuaSourceType.quran ||
        authenticity ==
            DuaAuthenticity.quran;
  }

  bool get isHadith {
    return sourceType ==
        DuaSourceType.hadith;
  }

  bool get isWeakOrDisputed {
    return authenticity ==
            DuaAuthenticity.weak ||
        authenticity ==
            DuaAuthenticity.disputed;
  }

  String get authenticityLabel {
    switch (authenticity) {
      case DuaAuthenticity.quran:
        return 'Qur’an';

      case DuaAuthenticity.sahih:
        return 'Sahih';

      case DuaAuthenticity.hasan:
        return 'Hasan';

      case DuaAuthenticity.hasanSahih:
        return 'Hasan Sahih';

      case DuaAuthenticity.accepted:
        return 'Accepted';

      case DuaAuthenticity.weak:
        return 'Weak';

      case DuaAuthenticity.disputed:
        return 'Disputed';

      case DuaAuthenticity.scholarlyGuidance:
        return 'Scholarly Guidance';

      case DuaAuthenticity.notApplicable:
        return 'Not Applicable';
    }
  }

  String get sourceTypeLabel {
    switch (sourceType) {
      case DuaSourceType.quran:
        return 'Qur’an';

      case DuaSourceType.hadith:
        return 'Hadith';

      case DuaSourceType.scholarly:
        return 'Scholarly Guidance';

      case DuaSourceType.generalDua:
        return 'General Dua';

      case DuaSourceType.userRoutine:
        return 'Personal Routine';
    }
  }

  List<String> get searchableTerms {
    return <String>[
      id,
      title,
      categoryId,
      ...alternateTitles,
      ...tags,
      englishTranslation,
      transliteration,
      reference,
    ];
  }
}