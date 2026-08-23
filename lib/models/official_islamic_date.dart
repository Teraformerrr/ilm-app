enum OfficialIslamicDateStatus {
  announced,
  confirmed,
}

class OfficialIslamicDate {
  const OfficialIslamicDate({
    required this.countryCode,
    required this.eventId,
    required this.hijriYear,
    required this.gregorianDate,
    required this.status,
    required this.sourceName,
    this.sourceReference,
    this.note,
  });

  /// ISO 3166-1 alpha-2 country code.
  final String countryCode;

  /// Matches IslamicEvent.id.
  final String eventId;

  /// Hijri year this announcement belongs to.
  final int hijriYear;

  /// Officially announced Gregorian date.
  final DateTime gregorianDate;

  final OfficialIslamicDateStatus status;

  /// Example:
  /// UAE Government
  /// Saudi Supreme Court
  /// Government of Pakistan
  final String sourceName;

  /// Optional source URL or source identifier.
  final String? sourceReference;

  final String? note;

  bool get isConfirmed =>
      status ==
      OfficialIslamicDateStatus.confirmed;

  String get statusLabel {
    switch (status) {
      case OfficialIslamicDateStatus.announced:
        return 'Announced';

      case OfficialIslamicDateStatus.confirmed:
        return 'Confirmed';
    }
  }
}