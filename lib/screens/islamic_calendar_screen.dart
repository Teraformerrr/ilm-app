import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/app_spacing.dart';
import '../services/islamic_calendar_service.dart';
import '../services/islamic_calendar_settings_service.dart';
import '../services/official_islamic_dates_service.dart';
import '../widgets/hijri_month_calendar.dart';
import '../widgets/ilm_card.dart';

class IslamicCalendarScreen
    extends StatefulWidget {
  const IslamicCalendarScreen({
    super.key,
  });

  @override
  State<IslamicCalendarScreen>
      createState() =>
          _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState
    extends State<IslamicCalendarScreen>
    with SingleTickerProviderStateMixin {
  static const _calendarService =
      IslamicCalendarService();

  static const _settingsService =
      IslamicCalendarSettingsService();

  static const _officialDatesService =
      OfficialIslamicDatesService();

  late final AnimationController
      _animationController;

  late DateTime _now;

  int _hijriAdjustmentDays = 0;

  bool _isLoadingSettings = true;

  String _selectedCountryCode =
      'AE';

  String _selectedCountryName =
      'United Arab Emirates';

  String _selectedCountryFlag =
      '🇦🇪';

  @override
  void initState() {
    super.initState();

    _now =
        DateTime.now();

    _animationController =
        AnimationController(
      vsync:
          this,
      duration:
          const Duration(
        milliseconds: 1000,
      ),
    );

    _loadCalendarSettings();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (mounted) {
          _animationController
              .forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController
        .dispose();

    super.dispose();
  }

  Future<void>
      _loadCalendarSettings() async {
    final savedAdjustment =
        await _settingsService
            .loadAdjustmentDays();

    final savedCountryCode =
        await _settingsService
            .loadCountryCode();

    final country =
        Country.tryParse(
      savedCountryCode,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _hijriAdjustmentDays =
          savedAdjustment;

      _selectedCountryCode =
          savedCountryCode
              .toUpperCase();

      if (country != null) {
        _selectedCountryName =
            country.name;

        _selectedCountryFlag =
            country.flagEmoji;
      }

      _isLoadingSettings =
          false;
    });
  }

  Future<void>
      _showHijriAdjustment() async {
    final selected =
        await showModalBottomSheet<int>(
      context:
          context,
      showDragHandle:
          true,
      builder:
          (
        sheetContext,
      ) {
        final theme =
            Theme.of(
          sheetContext,
        );

        final colorScheme =
            theme.colorScheme;

        return SafeArea(
          child:
              Padding(
            padding:
                const EdgeInsets
                    .fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize
                      .min,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Hijri Date Adjustment',
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),

                const SizedBox(
                  height:
                      AppSpacing.sm,
                ),

                Text(
                  'Adjust the calculated Hijri date to match your local moon-sighting authority.',
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                    height:
                        1.5,
                  ),
                ),

                const SizedBox(
                  height:
                      AppSpacing.lg,
                ),

                Wrap(
                  spacing:
                      AppSpacing.sm,
                  runSpacing:
                      AppSpacing.sm,
                  children: [
                    -2,
                    -1,
                    0,
                    1,
                    2,
                  ].map(
                    (
                      value,
                    ) {
                      String label;

                      if (value ==
                          0) {
                        label =
                            'Default';
                      } else if (value >
                          0) {
                        label =
                            '+$value day';
                      } else {
                        label =
                            '$value day';
                      }

                      return ChoiceChip(
                        label:
                            Text(
                          label,
                        ),
                        selected:
                            value ==
                                _hijriAdjustmentDays,
                        onSelected:
                            (
                          _,
                        ) {
                          Navigator.of(
                            sheetContext,
                          ).pop(
                            value,
                          );
                        },
                      );
                    },
                  ).toList(),
                ),

                const SizedBox(
                  height:
                      AppSpacing.lg,
                ),

                Container(
                  width:
                      double.infinity,
                  padding:
                      const EdgeInsets
                          .all(
                    AppSpacing.md,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        colorScheme
                            .surfaceContainerHigh,
                    borderRadius:
                        BorderRadius
                            .circular(
                      18,
                    ),
                  ),
                  child:
                      Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Icon(
                        Icons
                            .info_outline_rounded,
                        size:
                            20,
                        color:
                            colorScheme
                                .primary,
                      ),

                      const SizedBox(
                        width:
                            AppSpacing
                                .sm,
                      ),

                      Expanded(
                        child:
                            Text(
                          'Use this only when your local Islamic authority announces a Hijri date that differs from the calculated calendar.',
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            color:
                                colorScheme
                                    .onSurfaceVariant,
                            height:
                                1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    await _settingsService
        .saveAdjustmentDays(
      selected,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _hijriAdjustmentDays =
          selected;
    });
  }

  void _showCountrySelector() {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    showCountryPicker(
      context:
          context,
      showPhoneCode:
          false,
      showSearch:
          true,
      searchAutofocus:
          true,
      showDragHandle:
          true,
      countryListTheme:
          CountryListThemeData(
        borderRadius:
            const BorderRadius
                .vertical(
          top:
              Radius.circular(
            28,
          ),
        ),
        bottomSheetHeight:
            MediaQuery.sizeOf(
                  context,
                ).height *
                0.78,
        backgroundColor:
            colorScheme.surface,
        textStyle:
            theme
                .textTheme
                .bodyLarge,
        inputDecoration:
            InputDecoration(
          labelText:
              'Search country',
          hintText:
              'Country name or code',
          prefixIcon:
              const Icon(
            Icons.search_rounded,
          ),
          filled:
              true,
          fillColor:
              colorScheme
                  .surfaceContainerLow,
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            borderSide:
                BorderSide.none,
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            borderSide:
                BorderSide.none,
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius
                    .circular(
              18,
            ),
            borderSide:
                BorderSide(
              color:
                  colorScheme
                      .primary,
              width:
                  1.3,
            ),
          ),
        ),
      ),
      onSelect:
          (
        Country country,
      ) async {
        await _settingsService
            .saveCountryCode(
          country.countryCode,
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _selectedCountryCode =
              country.countryCode
                  .toUpperCase();

          _selectedCountryName =
              country.name;

          _selectedCountryFlag =
              country.flagEmoji;
        });
      },
    );
  }

  Animation<double>
      _animationFor(
    double start,
    double end,
  ) {
    return CurvedAnimation(
      parent:
          _animationController,
      curve:
          Interval(
        start,
        end,
        curve:
            Curves.easeOutCubic,
      ),
    );
  }

  Widget _animatedSection({
    required Widget child,
    required double start,
    required double end,
    double verticalOffset = 18,
  }) {
    final animation =
        _animationFor(
      start,
      end,
    );

    return FadeTransition(
      opacity:
          animation,
      child:
          AnimatedBuilder(
        animation:
            animation,
        child:
            child,
        builder:
            (
          context,
          child,
        ) {
          return Transform
              .translate(
            offset:
                Offset(
              0,
              verticalOffset *
                  (1 -
                      animation
                          .value),
            ),
            child:
                child,
          );
        },
      ),
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

    if (_isLoadingSettings) {
      return Scaffold(
        body:
            Center(
          child:
              SizedBox(
            width:
                36,
            height:
                36,
            child:
                CircularProgressIndicator(
              strokeWidth:
                  3,
              color:
                  colorScheme
                      .primary,
            ),
          ),
        ),
      );
    }

    final hijri =
        _calendarService
            .hijriFromGregorianAdjusted(
      _now,
      adjustmentDays:
          _hijriAdjustmentDays,
    );

    final hijriDate =
        _calendarService
            .formatHijriDateAdjusted(
      _now,
      adjustmentDays:
          _hijriAdjustmentDays,
    );

    final gregorianDate =
        DateFormat(
      'EEEE, d MMMM yyyy',
    ).format(
      _now,
    );

    final calculatedUpcoming =
        _calendarService
            .upcomingEventsAdjusted(
      from:
          _now,
      limit:
          20,
      adjustmentDays:
          _hijriAdjustmentDays,
    );

    final upcoming =
        _officialDatesService
            .resolveUpcomingEvents(
      countryCode:
          _selectedCountryCode,
      calculatedEvents:
          calculatedUpcoming,
      from:
          _now,
    );

    final nextEvent =
        upcoming.isEmpty
            ? null
            : upcoming.first;

    return Scaffold(
      body:
          Stack(
        children: [
          Positioned.fill(
            child:
                DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment
                          .topCenter,
                  end:
                      Alignment
                          .bottomCenter,
                  colors: [
                    colorScheme
                        .primaryContainer
                        .withValues(
                      alpha:
                          0.30,
                    ),
                    colorScheme
                        .surfaceContainerLowest,
                    colorScheme
                        .surfaceContainerLowest,
                  ],
                  stops:
                      const [
                    0,
                    0.30,
                    1,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child:
                CustomScrollView(
              physics:
                  const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets
                          .fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver:
                      SliverList(
                    delegate:
                        SliverChildListDelegate(
                      [
                        _animatedSection(
                          start:
                              0,
                          end:
                              0.25,
                          verticalOffset:
                              10,
                          child:
                              _CalendarHeader(
                            onAdjustHijri:
                                _showHijriAdjustment,
                            adjustmentDays:
                                _hijriAdjustmentDays,
                            onSelectCountry:
                                _showCountrySelector,
                            countryFlag:
                                _selectedCountryFlag,
                          ),
                        ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .lg,
                        ),

                        _animatedSection(
                          start:
                              0.04,
                          end:
                              0.30,
                          verticalOffset:
                              8,
                          child:
                              _CountryRegionCard(
                            countryName:
                                _selectedCountryName,
                            countryFlag:
                                _selectedCountryFlag,
                            onTap:
                                _showCountrySelector,
                          ),
                        ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .md,
                        ),

                        _animatedSection(
                          start:
                              0.08,
                          end:
                              0.38,
                          child:
                              _HijriHeroCard(
                            hijriDate:
                                hijriDate,
                            gregorianDate:
                                gregorianDate,
                            hijriMonth:
                                _calendarService
                                    .hijriMonthName(
                              hijri.hMonth,
                            ),
                            adjustmentDays:
                                _hijriAdjustmentDays,
                          ),
                        ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .lg,
                        ),

                        _animatedSection(
                          start:
                              0.14,
                          end:
                              0.46,
                          child:
                              HijriMonthCalendar(
                            adjustmentDays:
                                _hijriAdjustmentDays,
                          ),
                        ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .lg,
                        ),

                        if (nextEvent !=
                            null)
                          _animatedSection(
                            start:
                                0.20,
                            end:
                                0.52,
                            child:
                                _NextEventCard(
                              event:
                                  nextEvent,
                              countryName:
                                  _selectedCountryName,
                            ),
                          ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .xl,
                        ),

                        _animatedSection(
                          start:
                              0.28,
                          end:
                              0.60,
                          verticalOffset:
                              14,
                          child:
                              const _SectionHeader(
                            title:
                                'Upcoming Events',
                            subtitle:
                                'Islamic occasions ahead',
                          ),
                        ),

                        const SizedBox(
                          height:
                              AppSpacing
                                  .md,
                        ),
                      ],
                    ),
                  ),
                ),

                if (upcoming.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _EmptyEventsView(),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets
                            .fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    sliver:
                        SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          context,
                          index,
                        ) {
                          final event =
                              upcoming[index];

                          final start =
                              (0.34 +
                                      (index *
                                          0.025))
                                  .clamp(
                            0.34,
                            0.74,
                          );

                          final end =
                              (start +
                                      0.22)
                                  .clamp(
                            0.56,
                            0.98,
                          );

                          return Padding(
                            padding:
                                EdgeInsets.only(
                              bottom: index ==
                                      upcoming.length -
                                          1
                                  ? 0
                                  : AppSpacing
                                      .sm,
                            ),
                            child:
                                _animatedSection(
                              start:
                                  start.toDouble(),
                              end:
                                  end.toDouble(),
                              verticalOffset:
                                  12,
                              child:
                                  _IslamicEventCard(
                                resolvedEvent:
                                    event,
                              ),
                            ),
                          );
                        },
                        childCount:
                            upcoming.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarHeader
    extends StatelessWidget {
  const _CalendarHeader({
    required this.onAdjustHijri,
    required this.adjustmentDays,
    required this.onSelectCountry,
    required this.countryFlag,
  });

  final VoidCallback onAdjustHijri;
  final int adjustmentDays;

  final VoidCallback onSelectCountry;
  final String countryFlag;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Row(
      children: [
        IconButton(
          tooltip:
              'Back',
          onPressed:
              () {
            Navigator.of(context)
                .pop();
          },
          icon:
              const Icon(
            Icons
                .arrow_back_ios_new_rounded,
          ),
        ),

        const SizedBox(
          width:
              AppSpacing.sm,
        ),

        Expanded(
          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,
            children: [
              Text(
                'Islamic Calendar',
                style: theme
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight
                          .w800,
                  letterSpacing:
                      -0.8,
                ),
              ),

              Text(
                'Hijri dates & occasions',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                      colorScheme
                          .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip:
              'Select country',
          onPressed:
              onSelectCountry,
          icon:
              Text(
            countryFlag,
            style:
                const TextStyle(
              fontSize:
                  24,
            ),
          ),
        ),

        IconButton(
          tooltip:
              'Adjust Hijri date',
          onPressed:
              onAdjustHijri,
          icon:
              Badge(
            isLabelVisible:
                adjustmentDays !=
                    0,
            label:
                Text(
              adjustmentDays > 0
                  ? '+$adjustmentDays'
                  : '$adjustmentDays',
            ),
            child:
                const Icon(
              Icons.tune_rounded,
            ),
          ),
        ),
      ],
    );
  }
}

class _CountryRegionCard
    extends StatelessWidget {
  const _CountryRegionCard({
    required this.countryName,
    required this.countryFlag,
    required this.onTap,
  });

  final String countryName;
  final String countryFlag;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return IlmCard(
      onTap:
          onTap,
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      child:
          Row(
        children: [
          Container(
            width:
                48,
            height:
                48,
            alignment:
                Alignment.center,
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .surfaceContainerLow,
              borderRadius:
                  BorderRadius
                      .circular(
                16,
              ),
            ),
            child:
                Text(
              countryFlag,
              style:
                  const TextStyle(
                fontSize:
                    27,
              ),
            ),
          ),

          const SizedBox(
            width:
                AppSpacing.md,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  'Calendar region',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                  ),
                ),

                const SizedBox(
                  height:
                      3,
                ),

                Text(
                  countryName,
                  maxLines:
                      1,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),

                const SizedBox(
                  height:
                      2,
                ),

                Text(
                  'Official local dates are used when verified data is available',
                  maxLines:
                      2,
                  overflow:
                      TextOverflow
                          .ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons
                .expand_more_rounded,
            color:
                colorScheme
                    .onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _HijriHeroCard
    extends StatelessWidget {
  const _HijriHeroCard({
    required this.hijriDate,
    required this.gregorianDate,
    required this.hijriMonth,
    required this.adjustmentDays,
  });

  final String hijriDate;
  final String gregorianDate;
  final String hijriMonth;
  final int adjustmentDays;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          begin:
              Alignment.topLeft,
          end:
              Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary
                .withValues(
              alpha:
                  0.82,
            ),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          28,
        ),
        boxShadow: [
          BoxShadow(
            color:
                colorScheme.primary
                    .withValues(
              alpha:
                  0.22,
            ),
            blurRadius:
                30,
            offset:
                const Offset(
              0,
              12,
            ),
          ),
        ],
      ),
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Row(
            children: [
              Container(
                width:
                    42,
                height:
                    42,
                decoration:
                    BoxDecoration(
                  color:
                      Colors.white
                          .withValues(
                    alpha:
                        0.14,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    14,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .nights_stay_rounded,
                  color:
                      Colors.white,
                  size:
                      21,
                ),
              ),

              const SizedBox(
                width:
                    AppSpacing.sm,
              ),

              Expanded(
                child:
                    Text(
                  'Today',
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    color:
                        Colors.white,
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
              ),

              if (adjustmentDays !=
                  0)
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal:
                        9,
                    vertical:
                        5,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white
                            .withValues(
                      alpha:
                          0.14,
                    ),
                    borderRadius:
                        BorderRadius
                            .circular(
                      999,
                    ),
                  ),
                  child:
                      Text(
                    adjustmentDays >
                            0
                        ? '+$adjustmentDays day'
                        : '$adjustmentDays day',
                    style: theme
                        .textTheme
                        .labelSmall
                        ?.copyWith(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(
            height:
                AppSpacing.xl,
          ),

          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds:
                  350,
            ),
            child:
                Text(
              hijriDate,
              key:
                  ValueKey(
                hijriDate,
              ),
              style: theme
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                color:
                    Colors.white,
                fontWeight:
                    FontWeight
                        .w800,
              ),
            ),
          ),

          const SizedBox(
            height:
                6,
          ),

          Text(
            gregorianDate,
            style: theme
                .textTheme
                .bodyLarge
                ?.copyWith(
              color:
                  Colors.white
                      .withValues(
                alpha:
                    0.82,
              ),
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.lg,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  12,
              vertical:
                  7,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withValues(
                alpha:
                    0.12,
              ),
              borderRadius:
                  BorderRadius
                      .circular(
                999,
              ),
            ),
            child:
                Text(
              hijriMonth,
              style: theme
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                color:
                    Colors.white,
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextEventCard
    extends StatelessWidget {
  const _NextEventCard({
    required this.event,
    required this.countryName,
  });

  final ResolvedIslamicEventDate
      event;

  final String countryName;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return IlmCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(
            'Next Islamic Event',
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
                  colorScheme
                      .onSurfaceVariant,
              fontWeight:
                  FontWeight
                      .w600,
            ),
          ),

          const SizedBox(
            height:
                4,
          ),

          Text(
            event.event.name,
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight:
                  FontWeight
                      .w800,
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.xl,
          ),

          Text(
            event.isToday
                ? 'Today'
                : event.daysRemaining ==
                        1
                    ? 'Tomorrow'
                    : '${event.daysRemaining} days remaining',
            style: theme
                .textTheme
                .headlineMedium
                ?.copyWith(
              color:
                  colorScheme
                      .primary,
              fontWeight:
                  FontWeight
                      .w800,
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.md,
          ),

          Text(
            '${event.event.subtitle} • '
            '${DateFormat('d MMMM yyyy').format(event.gregorianDate)}',
            style: theme
                .textTheme
                .bodyMedium
                ?.copyWith(
              color:
                  colorScheme
                      .onSurfaceVariant,
            ),
          ),

          const SizedBox(
            height:
                AppSpacing.md,
          ),

          _DateStatusBadge(
            event:
                event,
            countryName:
                countryName,
          ),
        ],
      ),
    );
  }
}

class _DateStatusBadge
    extends StatelessWidget {
  const _DateStatusBadge({
    required this.event,
    required this.countryName,
  });

  final ResolvedIslamicEventDate
      event;

  final String countryName;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final official =
        event.officialDate;

    if (official == null) {
      return Container(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal:
              10,
          vertical:
              6,
        ),
        decoration:
            BoxDecoration(
          color:
              colorScheme
                  .surfaceContainerHigh,
          borderRadius:
              BorderRadius.circular(
            999,
          ),
        ),
        child:
            Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .schedule_rounded,
              size:
                  15,
              color:
                  colorScheme
                      .onSurfaceVariant,
            ),

            const SizedBox(
              width:
                  5,
            ),

            Flexible(
              child:
                  Text(
                'Estimated for $countryName',
                style: theme
                    .textTheme
                    .labelSmall
                    ?.copyWith(
                  color:
                      colorScheme
                          .onSurfaceVariant,
                  fontWeight:
                      FontWeight
                          .w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal:
            10,
        vertical:
            6,
      ),
      decoration:
          BoxDecoration(
        color:
            colorScheme
                .primaryContainer,
        borderRadius:
            BorderRadius.circular(
          999,
        ),
      ),
      child:
          Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            official.isConfirmed
                ? Icons
                    .verified_rounded
                : Icons
                    .campaign_rounded,
            size:
                15,
            color:
                colorScheme
                    .primary,
          ),

          const SizedBox(
            width:
                5,
          ),

          Flexible(
            child:
                Text(
              '${official.statusLabel} • ${official.sourceName}',
              style: theme
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color:
                    colorScheme
                        .primary,
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader
    extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment
              .start,
      children: [
        Text(
          title,
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
              3,
        ),

        Text(
          subtitle,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color:
                theme
                    .colorScheme
                    .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _IslamicEventCard
    extends StatelessWidget {
  const _IslamicEventCard({
    required this.resolvedEvent,
  });

  final ResolvedIslamicEventDate
      resolvedEvent;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final event =
        resolvedEvent.event;

    return IlmCard(
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      child:
          Row(
        children: [
          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(
                        event.name,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),

                    if (resolvedEvent
                        .hasOfficialDate)
                      Icon(
                        resolvedEvent
                                .isOfficiallyConfirmed
                            ? Icons
                                .verified_rounded
                            : Icons
                                .campaign_rounded,
                        size:
                            17,
                        color:
                            colorScheme
                                .primary,
                      )
                    else
                      Container(
                        width:
                            7,
                        height:
                            7,
                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape
                                  .circle,
                          color:
                              colorScheme
                                  .primary,
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height:
                      4,
                ),

                Text(
                  '${event.subtitle} • ${resolvedEvent.hijriYear} AH',
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                  ),
                ),

                const SizedBox(
                  height:
                      4,
                ),

                Text(
                  DateFormat(
                    'd MMMM yyyy',
                  ).format(
                    resolvedEvent
                        .gregorianDate,
                  ),
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                  ),
                ),

                const SizedBox(
                  height:
                      4,
                ),

                Text(
                  resolvedEvent
                          .hasOfficialDate
                      ? resolvedEvent
                          .officialDate!
                          .statusLabel
                      : 'Estimated',
                  style: theme
                      .textTheme
                      .labelSmall
                      ?.copyWith(
                    color:
                        resolvedEvent
                                .hasOfficialDate
                            ? colorScheme
                                .primary
                            : colorScheme
                                .onSurfaceVariant,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width:
                AppSpacing.sm,
          ),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal:
                  10,
              vertical:
                  7,
            ),
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .primaryContainer,
              borderRadius:
                  BorderRadius
                      .circular(
                999,
              ),
            ),
            child:
                Text(
              _OfficialCountdownText(
                event:
                    resolvedEvent,
              ).value,
              style: theme
                  .textTheme
                  .labelMedium
                  ?.copyWith(
                color:
                    colorScheme
                        .primary,
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficialCountdownText {
  const _OfficialCountdownText({
    required this.event,
  });

  final ResolvedIslamicEventDate
      event;

  String get value {
    const service =
        OfficialIslamicDatesService();

    return service.countdownText(
      event,
    );
  }
}

class _EmptyEventsView
    extends StatelessWidget {
  const _EmptyEventsView();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child:
            Text(
          'No upcoming events found.',
          textAlign:
              TextAlign.center,
          style:
              Theme.of(context)
                  .textTheme
                  .bodyLarge,
        ),
      ),
    );
  }
}