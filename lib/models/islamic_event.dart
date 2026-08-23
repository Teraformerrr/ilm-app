enum IslamicEventType {
  newYear,
  ashura,
  mawlid,
  israMiraj,
  nisfShaban,
  ramadan,
  laylatulQadr,
  eidAlFitr,
  arafah,
  eidAlAdha,
}

class IslamicEvent {
  const IslamicEvent({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.hijriMonth,
    required this.hijriDay,
    required this.type,
    this.estimated = false,
  });

  final String id;
  final String name;
  final String subtitle;

  final int hijriMonth;
  final int hijriDay;

  final IslamicEventType type;

  /// True when the observed date may differ according
  /// to local moon sighting or local authority.
  final bool estimated;
}

class UpcomingIslamicEvent {
  const UpcomingIslamicEvent({
    required this.event,
    required this.hijriYear,
    required this.gregorianDate,
    required this.daysRemaining,
  });

  final IslamicEvent event;
  final int hijriYear;
  final DateTime gregorianDate;
  final int daysRemaining;

  bool get isToday =>
      daysRemaining == 0;
}