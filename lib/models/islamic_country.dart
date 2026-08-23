class IslamicCountry {
  const IslamicCountry({
    required this.code,
    required this.name,
    required this.flagEmoji,
    this.supportsOfficialIslamicDates = false,
  });

  /// ISO 3166-1 alpha-2 country code.
  ///
  /// Examples:
  /// AE = United Arab Emirates
  /// SA = Saudi Arabia
  /// IN = India
  /// PK = Pakistan
  final String code;

  /// English display name.
  final String name;

  /// Country flag shown in the UI.
  final String flagEmoji;

  /// True when ILM has country-specific official
  /// Islamic-date information available.
  ///
  /// This does NOT change the Hijri calculation.
  /// It only tells the app whether official local
  /// announcements can be displayed.
  final bool supportsOfficialIslamicDates;

  String get displayName {
    return '$flagEmoji $name';
  }

  @override
  bool operator ==(
    Object other,
  ) {
    if (identical(
      this,
      other,
    )) {
      return true;
    }

    return other is IslamicCountry &&
        other.code == code;
  }

  @override
  int get hashCode {
    return code.hashCode;
  }

  @override
  String toString() {
    return 'IslamicCountry('
        'code: $code, '
        'name: $name'
        ')';
  }
}