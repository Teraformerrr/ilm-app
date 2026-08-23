import '../models/islamic_event.dart';
import '../models/official_islamic_date.dart';

class ResolvedIslamicEventDate {
  const ResolvedIslamicEventDate({
    required this.calculatedEvent,
    required this.officialDate,
    required this.daysRemaining,
  });

  final UpcomingIslamicEvent calculatedEvent;

  final OfficialIslamicDate?
      officialDate;

  final int daysRemaining;

  IslamicEvent get event =>
      calculatedEvent.event;

  int get hijriYear =>
      calculatedEvent.hijriYear;

  bool get hasOfficialDate =>
      officialDate != null;

  bool get isOfficiallyConfirmed =>
      officialDate?.isConfirmed ??
      false;

  DateTime get gregorianDate =>
      officialDate?.gregorianDate ??
      calculatedEvent.gregorianDate;

  bool get isToday =>
      daysRemaining == 0;
}

class OfficialIslamicDatesService {
  const OfficialIslamicDatesService();

  /*
   * IMPORTANT:
   *
   * Only VERIFIED country announcements belong here.
   *
   * Do not add projected dates from generic calendar
   * websites as official overrides.
   *
   * In a later step this static list can be replaced
   * or supplemented by signed online data downloaded
   * from ILM's backend.
   */
  static const List<OfficialIslamicDate>
      officialDates = [
    /*
     * Example format only — do NOT uncomment unless
     * the date has been verified from an official
     * authority.
     *
     * OfficialIslamicDate(
     *   countryCode: 'AE',
     *   eventId: 'eid_al_fitr',
     *   hijriYear: 1448,
     *   gregorianDate: DateTime(2027, 3, 10),
     *   status: OfficialIslamicDateStatus.confirmed,
     *   sourceName: 'UAE Government',
     * ),
     */
  ];

  OfficialIslamicDate? findOfficialDate({
    required String countryCode,
    required String eventId,
    required int hijriYear,
  }) {
    final normalizedCountry =
        countryCode
            .trim()
            .toUpperCase();

    for (final date
        in officialDates) {
      if (date.countryCode ==
              normalizedCountry &&
          date.eventId ==
              eventId &&
          date.hijriYear ==
              hijriYear) {
        return date;
      }
    }

    return null;
  }

  ResolvedIslamicEventDate resolve({
    required String countryCode,
    required UpcomingIslamicEvent
        calculatedEvent,
    DateTime? from,
  }) {
    final official =
        findOfficialDate(
      countryCode:
          countryCode,
      eventId:
          calculatedEvent.event.id,
      hijriYear:
          calculatedEvent.hijriYear,
    );

    final effectiveDate =
        official?.gregorianDate ??
        calculatedEvent
            .gregorianDate;

    final today =
        _dateOnly(
      from ?? DateTime.now(),
    );

    final target =
        _dateOnly(
      effectiveDate,
    );

    return ResolvedIslamicEventDate(
      calculatedEvent:
          calculatedEvent,
      officialDate:
          official,
      daysRemaining:
          target
              .difference(
                today,
              )
              .inDays,
    );
  }

  List<ResolvedIslamicEventDate>
      resolveUpcomingEvents({
    required String countryCode,
    required List<UpcomingIslamicEvent>
        calculatedEvents,
    DateTime? from,
  }) {
    final today =
        _dateOnly(
      from ?? DateTime.now(),
    );

    final resolved =
        calculatedEvents
            .map(
              (
                event,
              ) =>
                  resolve(
                countryCode:
                    countryCode,
                calculatedEvent:
                    event,
                from:
                    today,
              ),
            )
            .where(
              (
                event,
              ) =>
                  !_dateOnly(
                    event
                        .gregorianDate,
                  ).isBefore(
                    today,
                  ),
            )
            .toList();

    resolved.sort(
      (
        a,
        b,
      ) =>
          a.gregorianDate.compareTo(
        b.gregorianDate,
      ),
    );

    return resolved;
  }

  String countdownText(
    ResolvedIslamicEventDate event,
  ) {
    final days =
        event.daysRemaining;

    if (days == 0) {
      return 'Today';
    }

    if (days == 1) {
      return 'Tomorrow';
    }

    if (days < 30) {
      return '$days days';
    }

    final months =
        days ~/ 30;

    final remainingDays =
        days % 30;

    if (remainingDays == 0) {
      return months == 1
          ? '1 month'
          : '$months months';
    }

    return '$months mo '
        '$remainingDays d';
  }

  DateTime _dateOnly(
    DateTime date,
  ) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }
}