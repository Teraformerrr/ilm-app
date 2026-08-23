import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../core/app_spacing.dart';
import '../models/islamic_event.dart';
import '../services/islamic_calendar_service.dart';

class HijriMonthCalendar extends StatefulWidget {
  const HijriMonthCalendar({
    required this.adjustmentDays,
    super.key,
  });

  final int adjustmentDays;

  @override
  State<HijriMonthCalendar> createState() =>
      _HijriMonthCalendarState();
}

class _HijriMonthCalendarState
    extends State<HijriMonthCalendar> {
  static const _service =
      IslamicCalendarService();

  late int _year;
  late int _month;

  int? _selectedDay;

  @override
  void initState() {
    super.initState();

    _setToToday();
  }

  @override
  void didUpdateWidget(
    covariant HijriMonthCalendar oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget.adjustmentDays !=
        widget.adjustmentDays) {
      setState(() {
        _setToToday();
      });
    }
  }

  void _setToToday() {
    final nowHijri =
        _service
            .hijriFromGregorianAdjusted(
      DateTime.now(),
      adjustmentDays:
          widget.adjustmentDays,
    );

    _year =
        nowHijri.hYear;

    _month =
        nowHijri.hMonth;

    _selectedDay =
        nowHijri.hDay;
  }

  void _previousMonth() {
    HapticFeedback.selectionClick();

    setState(() {
      _month--;

      if (_month < 1) {
        _month = 12;
        _year--;
      }

      _selectedDay =
          _todayDayForCurrentMonth();
    });
  }

  void _nextMonth() {
    HapticFeedback.selectionClick();

    setState(() {
      _month++;

      if (_month > 12) {
        _month = 1;
        _year++;
      }

      _selectedDay =
          _todayDayForCurrentMonth();
    });
  }

  void _goToToday() {
    HapticFeedback.selectionClick();

    setState(() {
      _setToToday();
    });
  }

  int? _todayDayForCurrentMonth() {
    final today =
        _service
            .hijriFromGregorianAdjusted(
      DateTime.now(),
      adjustmentDays:
          widget.adjustmentDays,
    );

    if (today.hYear == _year &&
        today.hMonth == _month) {
      return today.hDay;
    }

    return null;
  }

  int _daysInMonth() {
    for (var day = 30;
        day >= 29;
        day--) {
      try {
        final date =
            _service
                .gregorianFromHijriAdjusted(
          year: _year,
          month: _month,
          day: day,
          adjustmentDays:
              widget.adjustmentDays,
        );

        final converted =
            _service
                .hijriFromGregorianAdjusted(
          date,
          adjustmentDays:
              widget.adjustmentDays,
        );

        if (converted.hYear ==
                _year &&
            converted.hMonth ==
                _month &&
            converted.hDay ==
                day) {
          return day;
        }
      } catch (_) {
        // Try the next smaller day.
      }
    }

    return 29;
  }

  int _weekdayOffset() {
    final firstDay =
        _service
            .gregorianFromHijriAdjusted(
      year: _year,
      month: _month,
      day: 1,
      adjustmentDays:
          widget.adjustmentDays,
    );

    return firstDay.weekday - 1;
  }

  List<IslamicEvent> _eventsForDay(
    int day,
  ) {
    return IslamicCalendarService.events
        .where(
      (
        event,
      ) =>
          event.hijriMonth ==
              _month &&
          event.hijriDay ==
              day,
    )
        .toList();
  }

  bool _isToday(
    int day,
  ) {
    final today =
        _service
            .hijriFromGregorianAdjusted(
      DateTime.now(),
      adjustmentDays:
          widget.adjustmentDays,
    );

    return today.hYear == _year &&
        today.hMonth == _month &&
        today.hDay == day;
  }

  bool _isCurrentMonth() {
    final today =
        _service
            .hijriFromGregorianAdjusted(
      DateTime.now(),
      adjustmentDays:
          widget.adjustmentDays,
    );

    return today.hYear == _year &&
        today.hMonth == _month;
  }

  Future<void> _selectDay(
    int day,
  ) async {
    HapticFeedback.selectionClick();

    setState(() {
      _selectedDay =
          day;
    });

    final gregorianDate =
        _service
            .gregorianFromHijriAdjusted(
      year: _year,
      month: _month,
      day: day,
      adjustmentDays:
          widget.adjustmentDays,
    );

    final events =
        _eventsForDay(
      day,
    );

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (
        context,
      ) {
        return _DateDetailsSheet(
          hijriYear:
              _year,
          hijriMonth:
              _month,
          hijriDay:
              day,
          gregorianDate:
              gregorianDate,
          events:
              events,
          adjustmentDays:
              widget.adjustmentDays,
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final days =
        _daysInMonth();

    final offset =
        _weekdayOffset();

    final totalCells =
        offset + days;

    final rows =
        (totalCells / 7).ceil();

    return GestureDetector(
      behavior:
          HitTestBehavior.translucent,
      onHorizontalDragEnd: (
        details,
      ) {
        final velocity =
            details.primaryVelocity ??
                0;

        if (velocity.abs() <
            200) {
          return;
        }

        if (velocity < 0) {
          _nextMonth();
        } else {
          _previousMonth();
        }
      },
      child: Container(
        width:
            double.infinity,
        padding:
            const EdgeInsets.all(
          AppSpacing.lg,
        ),
        decoration:
            BoxDecoration(
          color: colorScheme.surface
              .withValues(
            alpha: 0.92,
          ),
          borderRadius:
              BorderRadius.circular(
            26,
          ),
          border:
              Border.all(
            color: colorScheme
                .outlineVariant
                .withValues(
              alpha: 0.65,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(
                alpha: 0.045,
              ),
              blurRadius:
                  24,
              spreadRadius:
                  -5,
              offset:
                  const Offset(
                0,
                8,
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _CalendarArrowButton(
                  tooltip:
                      'Previous month',
                  icon: Icons
                      .chevron_left_rounded,
                  onTap:
                      _previousMonth,
                ),

                Expanded(
                  child: Column(
                    children: [
                      AnimatedSwitcher(
                        duration:
                            const Duration(
                          milliseconds:
                              240,
                        ),
                        child: Text(
                          _service
                              .hijriMonthName(
                            _month,
                          ),
                          key: ValueKey(
                            '$_year-$_month',
                          ),
                          style: theme
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 2,
                      ),

                      Text(
                        '$_year AH',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                _CalendarArrowButton(
                  tooltip:
                      'Next month',
                  icon: Icons
                      .chevron_right_rounded,
                  onTap:
                      _nextMonth,
                ),
              ],
            ),

            if (widget.adjustmentDays !=
                0) ...[
              const SizedBox(
                height:
                    AppSpacing.sm,
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration:
                    BoxDecoration(
                  color: colorScheme
                      .primaryContainer,
                  borderRadius:
                      BorderRadius.circular(
                    999,
                  ),
                ),
                child: Text(
                  widget.adjustmentDays >
                          0
                      ? 'Hijri adjustment +${widget.adjustmentDays}'
                      : 'Hijri adjustment ${widget.adjustmentDays}',
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color:
                        colorScheme.primary,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ],

            const SizedBox(
              height:
                  AppSpacing.md,
            ),

            if (!_isCurrentMonth())
              TextButton.icon(
                onPressed:
                    _goToToday,
                icon:
                    const Icon(
                  Icons
                      .today_rounded,
                  size: 17,
                ),
                label:
                    const Text(
                  'Back to today',
                ),
              ),

            const SizedBox(
              height:
                  AppSpacing.sm,
            ),

            const Row(
              children: [
                _WeekdayLabel(
                  text: 'Mon',
                ),
                _WeekdayLabel(
                  text: 'Tue',
                ),
                _WeekdayLabel(
                  text: 'Wed',
                ),
                _WeekdayLabel(
                  text: 'Thu',
                ),
                _WeekdayLabel(
                  text: 'Fri',
                ),
                _WeekdayLabel(
                  text: 'Sat',
                ),
                _WeekdayLabel(
                  text: 'Sun',
                ),
              ],
            ),

            const SizedBox(
              height:
                  AppSpacing.sm,
            ),

            AnimatedSwitcher(
              duration:
                  const Duration(
                milliseconds: 300,
              ),
              child: Column(
                key: ValueKey(
                  'grid-$_year-$_month-${widget.adjustmentDays}',
                ),
                children:
                    List.generate(
                  rows,
                  (
                    row,
                  ) {
                    return Row(
                      children:
                          List.generate(
                        7,
                        (
                          column,
                        ) {
                          final cellIndex =
                              (row * 7) +
                                  column;

                          final day =
                              cellIndex -
                                  offset +
                                  1;

                          if (day < 1 ||
                              day >
                                  days) {
                            return const Expanded(
                              child:
                                  SizedBox(
                                height:
                                    54,
                              ),
                            );
                          }

                          final events =
                              _eventsForDay(
                            day,
                          );

                          return Expanded(
                            child:
                                _DayCell(
                              day:
                                  day,
                              isToday:
                                  _isToday(
                                day,
                              ),
                              selected:
                                  _selectedDay ==
                                      day,
                              hasEvent:
                                  events
                                      .isNotEmpty,
                              events:
                                  events,
                              onTap:
                                  () {
                                _selectDay(
                                  day,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.md,
            ),

            const Divider(),

            const SizedBox(
              height:
                  AppSpacing.md,
            ),

            Row(
              children: [
                _LegendDot(
                  color:
                      colorScheme.primary,
                  label:
                      'Today',
                  filled:
                      true,
                ),

                const SizedBox(
                  width:
                      AppSpacing.lg,
                ),

                _LegendDot(
                  color:
                      colorScheme.primary,
                  label:
                      'Islamic occasion',
                  filled:
                      false,
                ),
              ],
            ),

            const SizedBox(
              height:
                  AppSpacing.sm,
            ),

            Row(
              children: [
                Icon(
                  Icons
                      .swipe_rounded,
                  size: 15,
                  color: colorScheme
                      .onSurfaceVariant,
                ),

                const SizedBox(
                  width:
                      AppSpacing.xs,
                ),

                Expanded(
                  child: Text(
                    'Swipe left or right to change Hijri month',
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarArrowButton
    extends StatelessWidget {
  const _CalendarArrowButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final colorScheme =
        Theme.of(context)
            .colorScheme;

    return Tooltip(
      message:
          tooltip,
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          15,
        ),
        child: Container(
          width: 42,
          height: 42,
          decoration:
              BoxDecoration(
            color: colorScheme
                .surfaceContainerLow,
            borderRadius:
                BorderRadius.circular(
              15,
            ),
          ),
          child: Icon(
            icon,
            color:
                colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

class _WeekdayLabel
    extends StatelessWidget {
  const _WeekdayLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Expanded(
      child: Center(
        child: Text(
          text,
          style: theme
              .textTheme
              .labelSmall
              ?.copyWith(
            color: theme
                .colorScheme
                .onSurfaceVariant,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DayCell
    extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.selected,
    required this.hasEvent,
    required this.events,
    required this.onTap,
  });

  final int day;
  final bool isToday;
  final bool selected;
  final bool hasEvent;
  final List<IslamicEvent> events;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    Color backgroundColor;
    Color textColor;

    if (isToday) {
      backgroundColor =
          colorScheme.primary;

      textColor =
          colorScheme.onPrimary;
    } else if (selected) {
      backgroundColor =
          colorScheme
              .primaryContainer;

      textColor =
          colorScheme.primary;
    } else if (hasEvent) {
      backgroundColor =
          colorScheme
              .primaryContainer
              .withValues(
        alpha: 0.42,
      );

      textColor =
          colorScheme.primary;
    } else {
      backgroundColor =
          Colors.transparent;

      textColor =
          colorScheme.onSurface;
    }

    return GestureDetector(
      behavior:
          HitTestBehavior.opaque,
      onTap:
          onTap,
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 220,
        ),
        curve:
            Curves.easeOutCubic,
        height:
            54,
        margin:
            const EdgeInsets.all(
          2,
        ),
        decoration:
            BoxDecoration(
          color:
              backgroundColor,
          borderRadius:
              BorderRadius.circular(
            14,
          ),
          border: selected &&
                  !isToday
              ? Border.all(
                  color: colorScheme
                      .primary
                      .withValues(
                    alpha: 0.45,
                  ),
                )
              : null,
        ),
        child: Stack(
          alignment:
              Alignment.center,
          children: [
            Text(
              '$day',
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                    textColor,
                fontWeight: isToday ||
                        selected ||
                        hasEvent
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
            ),

            if (hasEvent)
              Positioned(
                bottom: 6,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    color: isToday
                        ? colorScheme
                            .onPrimary
                        : colorScheme
                            .primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateDetailsSheet
    extends StatelessWidget {
  const _DateDetailsSheet({
    required this.hijriYear,
    required this.hijriMonth,
    required this.hijriDay,
    required this.gregorianDate,
    required this.events,
    required this.adjustmentDays,
  });

  final int hijriYear;
  final int hijriMonth;
  final int hijriDay;
  final DateTime gregorianDate;
  final List<IslamicEvent> events;
  final int adjustmentDays;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    const service =
        IslamicCalendarService();

    final monthName =
        service.hijriMonthName(
      hijriMonth,
    );

    final gregorianText =
        DateFormat(
      'EEEE, d MMMM yyyy',
    ).format(
      gregorianDate,
    );

    final difference =
        _dayDifferenceFromToday(
      gregorianDate,
    );

    return SafeArea(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration:
                  BoxDecoration(
                color: colorScheme
                    .primaryContainer,
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: Icon(
                events.isEmpty
                    ? Icons
                        .calendar_today_rounded
                    : _iconForEvents(
                        events,
                      ),
                color:
                    colorScheme.primary,
                size: 26,
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.lg,
            ),

            Text(
              events.isEmpty
                  ? '$hijriDay $monthName'
                  : events.first.name,
              style: theme
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
                letterSpacing:
                    -0.7,
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.xs,
            ),

            Text(
              '$hijriDay $monthName $hijriYear AH',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color:
                    colorScheme.primary,
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              gregorianText,
              style: theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),

            if (adjustmentDays !=
                0) ...[
              const SizedBox(
                height:
                    AppSpacing.sm,
              ),

              Text(
                adjustmentDays > 0
                    ? 'Hijri adjustment: +$adjustmentDays day'
                    : 'Hijri adjustment: $adjustmentDays day',
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                      colorScheme.primary,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],

            const SizedBox(
              height:
                  AppSpacing.lg,
            ),

            _CountdownPill(
              difference:
                  difference,
            ),

            if (events.isNotEmpty) ...[
              const SizedBox(
                height:
                    AppSpacing.xl,
              ),

              for (var i = 0;
                  i < events.length;
                  i++) ...[
                _EventInformation(
                  event:
                      events[i],
                ),

                if (i <
                    events.length - 1)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical:
                          AppSpacing.lg,
                    ),
                    child:
                        Divider(),
                  ),
              ],
            ],

            if (events.any(
              (
                event,
              ) =>
                  event.estimated,
            )) ...[
              const SizedBox(
                height:
                    AppSpacing.xl,
              ),

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  AppSpacing.md,
                ),
                decoration:
                    BoxDecoration(
                  color: colorScheme
                      .surfaceContainerHigh,
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons
                          .info_outline_rounded,
                      color:
                          colorScheme.primary,
                      size: 20,
                    ),

                    const SizedBox(
                      width:
                          AppSpacing.sm,
                    ),

                    Expanded(
                      child: Text(
                        'This date is calculated for planning purposes. The observed date may differ according to local moon sighting and your local Islamic authority.',
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EventInformation
    extends StatelessWidget {
  const _EventInformation({
    required this.event,
  });

  final IslamicEvent event;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          event.name,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
                FontWeight.w800,
          ),
        ),

        const SizedBox(
          height:
              AppSpacing.sm,
        ),

        Text(
          _descriptionForEvent(
            event.type,
          ),
          style: theme
              .textTheme
              .bodyLarge
              ?.copyWith(
            color: colorScheme
                .onSurfaceVariant,
            height: 1.55,
          ),
        ),

        if (event.type ==
            IslamicEventType
                .laylatulQadr) ...[
          const SizedBox(
            height:
                AppSpacing.md,
          ),

          Container(
            padding:
                const EdgeInsets.all(
              AppSpacing.md,
            ),
            decoration:
                BoxDecoration(
              color: colorScheme
                  .primaryContainer
                  .withValues(
                alpha: 0.55,
              ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Text(
              'Laylat al-Qadr is sought during the odd nights of the last ten nights of Ramadan. This marker does not claim this specific night is definitively Laylat al-Qadr.',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                    colorScheme.primary,
                height: 1.5,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CountdownPill
    extends StatelessWidget {
  const _CountdownPill({
    required this.difference,
  });

  final int difference;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    String text;

    if (difference == 0) {
      text = 'Today';
    } else if (difference == 1) {
      text = 'Tomorrow';
    } else if (difference > 1) {
      text =
          '$difference days away';
    } else if (difference == -1) {
      text = 'Yesterday';
    } else {
      text =
          '${difference.abs()} days ago';
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration:
          BoxDecoration(
        color: colorScheme
            .primaryContainer,
        borderRadius:
            BorderRadius.circular(
          999,
        ),
      ),
      child: Text(
        text,
        style: theme
            .textTheme
            .labelLarge
            ?.copyWith(
          color:
              colorScheme.primary,
          fontWeight:
              FontWeight.w700,
        ),
      ),
    );
  }
}

class _LegendDot
    extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
    required this.filled,
  });

  final Color color;
  final String label;
  final bool filled;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisSize:
          MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration:
              BoxDecoration(
            shape:
                BoxShape.circle,
            color: filled
                ? color
                : color.withValues(
                    alpha: 0.22,
                  ),
            border: filled
                ? null
                : Border.all(
                    color: color,
                    width: 1.5,
                  ),
          ),
        ),

        const SizedBox(
          width:
              AppSpacing.xs,
        ),

        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

int _dayDifferenceFromToday(
  DateTime date,
) {
  final now =
      DateTime.now();

  final today =
      DateTime(
    now.year,
    now.month,
    now.day,
  );

  final target =
      DateTime(
    date.year,
    date.month,
    date.day,
  );

  return target
      .difference(
        today,
      )
      .inDays;
}

IconData _iconForEvents(
  List<IslamicEvent> events,
) {
  if (events.isEmpty) {
    return Icons
        .calendar_today_rounded;
  }

  switch (events.first.type) {
    case IslamicEventType.newYear:
      return Icons
          .auto_awesome_rounded;

    case IslamicEventType.ashura:
      return Icons
          .water_drop_outlined;

    case IslamicEventType.mawlid:
      return Icons
          .mosque_rounded;

    case IslamicEventType.israMiraj:
      return Icons
          .nightlight_round;

    case IslamicEventType.nisfShaban:
      return Icons
          .brightness_2_rounded;

    case IslamicEventType.ramadan:
      return Icons
          .nights_stay_rounded;

    case IslamicEventType.laylatulQadr:
      return Icons
          .star_rounded;

    case IslamicEventType.eidAlFitr:
      return Icons
          .celebration_rounded;

    case IslamicEventType.arafah:
      return Icons
          .landscape_rounded;

    case IslamicEventType.eidAlAdha:
      return Icons
          .festival_rounded;
  }
}

String _descriptionForEvent(
  IslamicEventType type,
) {
  switch (type) {
    case IslamicEventType.newYear:
      return 'The beginning of Muharram and the start of a new Hijri year.';

    case IslamicEventType.ashura:
      return 'The tenth day of Muharram. Fasting on Ashura is an established Sunnah.';

    case IslamicEventType.mawlid:
      return 'A date traditionally associated with the birth of Prophet Muhammad ﷺ. Practices relating to this occasion differ among Muslim communities and scholars.';

    case IslamicEventType.israMiraj:
      return 'A date traditionally associated with the Night Journey and Ascension of Prophet Muhammad ﷺ.';

    case IslamicEventType.nisfShaban:
      return 'The middle of Sha‘ban. Practices associated with this night differ among Muslim communities and scholars.';

    case IslamicEventType.ramadan:
      return 'The beginning of the blessed month of Ramadan, the month of fasting, Qur’an and increased worship.';

    case IslamicEventType.laylatulQadr:
      return 'One of the odd nights in the final ten nights of Ramadan during which Muslims seek Laylat al-Qadr.';

    case IslamicEventType.eidAlFitr:
      return 'Eid al-Fitr marks the completion of Ramadan and begins on the first day of Shawwal.';

    case IslamicEventType.arafah:
      return 'The ninth day of Dhul Hijjah and the central day of Hajj. Fasting is recommended for those not performing Hajj.';

    case IslamicEventType.eidAlAdha:
      return 'Eid al-Adha begins on the tenth day of Dhul Hijjah during the days of Hajj.';
  }
}