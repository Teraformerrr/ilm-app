import 'package:hijri/hijri_calendar.dart';

import '../models/islamic_event.dart';

class IslamicCalendarService {
  const IslamicCalendarService();

  static const List<IslamicEvent> events = [
    IslamicEvent(
      id: 'islamic_new_year',
      name: 'Islamic New Year',
      subtitle: '1 Muharram',
      hijriMonth: 1,
      hijriDay: 1,
      type: IslamicEventType.newYear,
      estimated: true,
    ),
    IslamicEvent(
      id: 'ashura',
      name: 'Day of Ashura',
      subtitle: '10 Muharram',
      hijriMonth: 1,
      hijriDay: 10,
      type: IslamicEventType.ashura,
      estimated: true,
    ),
    IslamicEvent(
      id: 'mawlid',
      name: 'Mawlid an-Nabi ﷺ',
      subtitle: '12 Rabi al-Awwal',
      hijriMonth: 3,
      hijriDay: 12,
      type: IslamicEventType.mawlid,
      estimated: true,
    ),
    IslamicEvent(
      id: 'isra_miraj',
      name: 'Isra and Mi‘raj',
      subtitle: '27 Rajab',
      hijriMonth: 7,
      hijriDay: 27,
      type: IslamicEventType.israMiraj,
      estimated: true,
    ),
    IslamicEvent(
      id: 'nisf_shaban',
      name: '15 Sha‘ban',
      subtitle: '15 Sha‘ban',
      hijriMonth: 8,
      hijriDay: 15,
      type: IslamicEventType.nisfShaban,
      estimated: true,
    ),
    IslamicEvent(
      id: 'ramadan',
      name: 'Ramadan Begins',
      subtitle: '1 Ramadan',
      hijriMonth: 9,
      hijriDay: 1,
      type: IslamicEventType.ramadan,
      estimated: true,
    ),
    IslamicEvent(
      id: 'laylatul_qadr_21',
      name: '21st Night of Ramadan',
      subtitle: '21 Ramadan',
      hijriMonth: 9,
      hijriDay: 21,
      type: IslamicEventType.laylatulQadr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'laylatul_qadr_23',
      name: '23rd Night of Ramadan',
      subtitle: '23 Ramadan',
      hijriMonth: 9,
      hijriDay: 23,
      type: IslamicEventType.laylatulQadr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'laylatul_qadr_25',
      name: '25th Night of Ramadan',
      subtitle: '25 Ramadan',
      hijriMonth: 9,
      hijriDay: 25,
      type: IslamicEventType.laylatulQadr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'laylatul_qadr_27',
      name: '27th Night of Ramadan',
      subtitle: '27 Ramadan',
      hijriMonth: 9,
      hijriDay: 27,
      type: IslamicEventType.laylatulQadr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'laylatul_qadr_29',
      name: '29th Night of Ramadan',
      subtitle: '29 Ramadan',
      hijriMonth: 9,
      hijriDay: 29,
      type: IslamicEventType.laylatulQadr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'eid_al_fitr',
      name: 'Eid al-Fitr',
      subtitle: '1 Shawwal',
      hijriMonth: 10,
      hijriDay: 1,
      type: IslamicEventType.eidAlFitr,
      estimated: true,
    ),
    IslamicEvent(
      id: 'arafah',
      name: 'Day of Arafah',
      subtitle: '9 Dhul Hijjah',
      hijriMonth: 12,
      hijriDay: 9,
      type: IslamicEventType.arafah,
      estimated: true,
    ),
    IslamicEvent(
      id: 'eid_al_adha',
      name: 'Eid al-Adha',
      subtitle: '10 Dhul Hijjah',
      hijriMonth: 12,
      hijriDay: 10,
      type: IslamicEventType.eidAlAdha,
      estimated: true,
    ),
  ];

  HijriCalendar hijriFromGregorian(
    DateTime date,
  ) {
    return HijriCalendar.fromDate(
      DateTime(
        date.year,
        date.month,
        date.day,
      ),
    );
  }

  DateTime gregorianFromHijri({
    required int year,
    required int month,
    required int day,
  }) {
    final calendar =
        HijriCalendar();

    final result =
        calendar.hijriToGregorian(
      year,
      month,
      day,
    );

    return DateTime(
      result.year,
      result.month,
      result.day,
    );
  }

  DateTime applyHijriAdjustment(
    DateTime date,
    int adjustmentDays,
  ) {
    return date.add(
      Duration(
        days: adjustmentDays,
      ),
    );
  }

  HijriCalendar hijriFromGregorianAdjusted(
    DateTime date, {
    int adjustmentDays = 0,
  }) {
    final adjustedDate =
        applyHijriAdjustment(
      date,
      adjustmentDays,
    );

    return hijriFromGregorian(
      adjustedDate,
    );
  }

  DateTime gregorianFromHijriAdjusted({
    required int year,
    required int month,
    required int day,
    int adjustmentDays = 0,
  }) {
    final baseDate =
        gregorianFromHijri(
      year: year,
      month: month,
      day: day,
    );

    return baseDate.subtract(
      Duration(
        days: adjustmentDays,
      ),
    );
  }

  String formatHijriDate(
    DateTime date,
  ) {
    final hijri =
        hijriFromGregorian(
      date,
    );

    return '${hijri.hDay} '
        '${hijriMonthName(hijri.hMonth)} '
        '${hijri.hYear} AH';
  }

  String formatHijriDateAdjusted(
    DateTime date, {
    int adjustmentDays = 0,
  }) {
    final hijri =
        hijriFromGregorianAdjusted(
      date,
      adjustmentDays:
          adjustmentDays,
    );

    return '${hijri.hDay} '
        '${hijriMonthName(hijri.hMonth)} '
        '${hijri.hYear} AH';
  }

  List<UpcomingIslamicEvent> upcomingEvents({
    DateTime? from,
    int limit = 20,
  }) {
    return upcomingEventsAdjusted(
      from: from,
      limit: limit,
    );
  }

  List<UpcomingIslamicEvent>
      upcomingEventsAdjusted({
    DateTime? from,
    int limit = 20,
    int adjustmentDays = 0,
  }) {
    final now =
        _dateOnly(
      from ?? DateTime.now(),
    );

    final hijriNow =
        hijriFromGregorianAdjusted(
      now,
      adjustmentDays:
          adjustmentDays,
    );

    final candidates =
        <UpcomingIslamicEvent>[];

    for (final year in [
      hijriNow.hYear,
      hijriNow.hYear + 1,
    ]) {
      for (final event in events) {
        final date =
            gregorianFromHijriAdjusted(
          year: year,
          month:
              event.hijriMonth,
          day:
              event.hijriDay,
          adjustmentDays:
              adjustmentDays,
        );

        final normalizedDate =
            _dateOnly(
          date,
        );

        if (normalizedDate.isBefore(
          now,
        )) {
          continue;
        }

        final daysRemaining =
            normalizedDate
                .difference(
                  now,
                )
                .inDays;

        candidates.add(
          UpcomingIslamicEvent(
            event: event,
            hijriYear: year,
            gregorianDate:
                normalizedDate,
            daysRemaining:
                daysRemaining,
          ),
        );
      }
    }

    candidates.sort(
      (
        a,
        b,
      ) =>
          a.gregorianDate.compareTo(
        b.gregorianDate,
      ),
    );

    return candidates
        .take(
          limit,
        )
        .toList();
  }

  UpcomingIslamicEvent? nextEvent({
    DateTime? from,
  }) {
    final upcoming =
        upcomingEvents(
      from: from,
      limit: 1,
    );

    if (upcoming.isEmpty) {
      return null;
    }

    return upcoming.first;
  }

  UpcomingIslamicEvent?
      nextEventAdjusted({
    DateTime? from,
    int adjustmentDays = 0,
  }) {
    final upcoming =
        upcomingEventsAdjusted(
      from: from,
      limit: 1,
      adjustmentDays:
          adjustmentDays,
    );

    if (upcoming.isEmpty) {
      return null;
    }

    return upcoming.first;
  }

  String hijriMonthName(
    int month,
  ) {
    switch (month) {
      case 1:
        return 'Muharram';

      case 2:
        return 'Safar';

      case 3:
        return 'Rabi al-Awwal';

      case 4:
        return 'Rabi al-Thani';

      case 5:
        return 'Jumada al-Awwal';

      case 6:
        return 'Jumada al-Thani';

      case 7:
        return 'Rajab';

      case 8:
        return 'Sha‘ban';

      case 9:
        return 'Ramadan';

      case 10:
        return 'Shawwal';

      case 11:
        return 'Dhul Qa‘dah';

      case 12:
        return 'Dhul Hijjah';

      default:
        return 'Unknown';
    }
  }

  String countdownText(
    UpcomingIslamicEvent event,
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

    return '$months mo $remainingDays d';
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