import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../data/home_hadiths.dart';
import '../models/home_hadith.dart';
import '../models/prayer_time.dart';
import '../models/user_profile.dart';
import '../services/location_service.dart';
import '../services/prayer_calculation_service.dart';
import '../services/prayer_service.dart';
import '../services/user_profile_service.dart';
import '../widgets/dynamic_sky_background.dart';
import '../widgets/ilm_card.dart';
import '../widgets/prayer_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onNavigateToTab,
    required this.onOpenQiblaFinder,
    required this.onOpenDuas,
    super.key,
  });

  final ValueChanged<int>
      onNavigateToTab;

  final VoidCallback
      onOpenQiblaFinder;

  final VoidCallback
      onOpenDuas;

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final HomeHadith
      _launchHadith;

  late final AnimationController
      _animationController;

  UserProfile? _profile;

  double? _latitude;
  double? _longitude;

  bool _isLoadingLocation = true;
  bool _isLoadingProfile = true;

  String? _locationError;

  SkyPreviewMode _skyPreviewMode =
      SkyPreviewMode.automatic;

  @override
  void initState() {
    super.initState();

    _launchHadith =
        homeHadiths[
      Random().nextInt(
        homeHadiths.length,
      )
    ];

    _animationController =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds:
            1100,
      ),
    );

    _loadProfile();
    _loadLocation();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (
        _,
      ) {
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

  Future<void> _loadProfile() async {
    const service =
        UserProfileService();

    final profile =
        await service
            .loadProfile();

    if (!mounted) {
      return;
    }

    setState(() {
      _profile =
          profile;

      _isLoadingProfile =
          false;
    });
  }

  Future<void> _loadLocation() async {
    const locationService =
        LocationService();

    try {
      final position =
          await locationService
              .getCurrentPosition();

      if (!mounted) {
        return;
      }

      setState(() {
        _latitude =
            position.latitude;

        _longitude =
            position.longitude;

        _isLoadingLocation =
            false;

        _locationError =
            null;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingLocation =
            false;

        _locationError =
            'Location unavailable. Using Dubai fallback.';
      });
    }
  }

  String get _firstName {
    return _profile?.firstName ??
        '';
  }

  String _timeGreeting(
    DateTime now,
  ) {
    final hour =
        now.hour;

    if (hour < 12) {
      return 'Good morning';
    }

    if (hour < 17) {
      return 'Good afternoon';
    }

    return 'Good evening';
  }

  PrayerTime? _findPrayer(
    List<PrayerTime> prayers,
    PrayerType type,
  ) {
    for (final prayer
        in prayers) {
      if (prayer.type ==
          type) {
        return prayer;
      }
    }

    return null;
  }

  bool _useLightSkyForeground({
    required DateTime now,
    required PrayerTime? fajr,
    required PrayerTime? maghrib,
  }) {
    switch (_skyPreviewMode) {
      case SkyPreviewMode.dawn:
      case SkyPreviewMode.sunset:
      case SkyPreviewMode.night:
      case SkyPreviewMode.lateNight:
        return true;

      case SkyPreviewMode.morning:
      case SkyPreviewMode.day:
      case SkyPreviewMode.afternoon:
        return false;

      case SkyPreviewMode.automatic:
        break;
    }

    if (fajr == null ||
        maghrib == null) {
      return false;
    }

    final dawnStart =
        fajr.time.subtract(
      const Duration(
        minutes: 50,
      ),
    );

    final sunsetStart =
        maghrib.time.subtract(
      const Duration(
        minutes: 55,
      ),
    );

    if (now.isBefore(
      dawnStart,
    )) {
      return true;
    }

    if (now.isBefore(
      fajr.time,
    )) {
      return true;
    }

    if (!now.isBefore(
      sunsetStart,
    )) {
      return true;
    }

    return false;
  }

  Animation<double> _animationFor(
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
            Curves
                .easeOutCubic,
      ),
    );
  }

  Widget _animatedSection({
    required Widget child,
    required double start,
    required double end,
    double verticalOffset = 22,
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
        builder: (
          context,
          child,
        ) {
          return Transform.translate(
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
    const prayerCalculationService =
        PrayerCalculationService();

    const prayerService =
        PrayerService();

    final now =
        DateTime.now();

    final latitude =
        _latitude ??
            25.2048;

    final longitude =
        _longitude ??
            55.2708;

    final locationStatus =
        _isLoadingLocation
            ? 'Loading your location...'
            : _locationError ??
                'Using your current location.';

    final prayerTimes =
        prayerCalculationService
            .calculatePrayerTimes(
      latitude:
          latitude,
      longitude:
          longitude,
      date:
          now,
    );

    final tomorrowFajr =
        prayerCalculationService
            .calculateTomorrowFajr(
      latitude:
          latitude,
      longitude:
          longitude,
      date:
          now,
    );

    final nextPrayer =
        prayerService
            .getNextPrayer(
      prayerTimes:
          prayerTimes,
      tomorrowFajr:
          tomorrowFajr,
      now:
          now,
    );

    final fajr =
        _findPrayer(
      prayerTimes,
      PrayerType.fajr,
    );

    final maghrib =
        _findPrayer(
      prayerTimes,
      PrayerType.maghrib,
    );

    final useLightForeground =
        _useLightSkyForeground(
      now:
          now,
      fajr:
          fajr,
      maghrib:
          maghrib,
    );

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body:
          Stack(
        children: [
          if (fajr != null &&
              maghrib != null)
            DynamicSkyBackground(
              now:
                  now,
              fajr:
                  fajr.time,
              maghrib:
                  maghrib.time,
              previewMode:
                  _skyPreviewMode,
            ),

          SafeArea(
            child:
                SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _animatedSection(
                    start:
                        0.00,
                    end:
                        0.32,
                    verticalOffset:
                        14,
                    child:
                        _HomeHeader(
                      name:
                          _firstName,
                      loading:
                          _isLoadingProfile,
                      timeGreeting:
                          _timeGreeting(
                        now,
                      ),
                      lightForeground:
                          useLightForeground,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),

                  _animatedSection(
                    start:
                        0.10,
                    end:
                        0.45,
                    child:
                        _HadithCard(
                      hadith:
                          _launchHadith,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.lg,
                  ),

                  if (nextPrayer !=
                      null)
                    _animatedSection(
                      start:
                          0.20,
                      end:
                          0.55,
                      child:
                          PrayerStatusCard(
                        prayer:
                            nextPrayer,
                        statusText:
                            locationStatus,
                      ),
                    ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),

                  _animatedSection(
                    start:
                        0.30,
                    end:
                        0.62,
                    verticalOffset:
                        16,
                    child:
                        _ExploreHeader(
                      lightForeground:
                          useLightForeground,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.md,
                  ),

                  GridView.count(
                    crossAxisCount:
                        2,
                    shrinkWrap:
                        true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisSpacing:
                        AppSpacing.md,
                    mainAxisSpacing:
                        AppSpacing.md,
                    childAspectRatio:
                        1.18,
                    children: [
                      _animatedSection(
                        start:
                            0.38,
                        end:
                            0.68,
                        child:
                            _HomeFeatureCard(
                          title:
                              'Qur’an',
                          subtitle:
                              'Read, listen and reflect',
                          icon:
                              Icons.menu_book_rounded,
                          motion:
                              _FeatureMotion.scale,
                          onTap: () {
                            widget
                                .onNavigateToTab(
                              1,
                            );
                          },
                        ),
                      ),

                      _animatedSection(
                        start:
                            0.43,
                        end:
                            0.73,
                        child:
                            _HomeFeatureCard(
                          title:
                              'Prayer',
                          subtitle:
                              'Times, Tahajjud and Salah',
                          icon:
                              Icons.mosque_rounded,
                          motion:
                              _FeatureMotion.lift,
                          onTap: () {
                            widget
                                .onNavigateToTab(
                              2,
                            );
                          },
                        ),
                      ),

                      _animatedSection(
                        start:
                            0.48,
                        end:
                            0.78,
                        child:
                            _HomeFeatureCard(
                          title:
                              'Hadith',
                          subtitle:
                              'Authentic collections',
                          icon:
                              Icons.library_books_rounded,
                          motion:
                              _FeatureMotion.emphasis,
                          onTap: () {
                            widget
                                .onNavigateToTab(
                              3,
                            );
                          },
                        ),
                      ),

                      _animatedSection(
                        start:
                            0.53,
                        end:
                            0.83,
                        child:
                            _HomeFeatureCard(
                          title:
                              'Qibla Finder',
                          subtitle:
                              'Find the direction of the Kaaba',
                          icon:
                              Icons.explore_rounded,
                          motion:
                              _FeatureMotion.tilt,
                          onTap:
                              widget
                                  .onOpenQiblaFinder,
                        ),
                      ),

                      _animatedSection(
                        start:
                            0.58,
                        end:
                            0.88,
                        child:
                            _HomeFeatureCard(
                          title:
                              'Duas & Adhkar',
                          subtitle:
                              'Daily remembrance',
                          icon:
                              Icons.favorite_rounded,
                          motion:
                              _FeatureMotion.pulse,
                          onTap:
                              widget
                                  .onOpenDuas,
                        ),
                      ),

                      _animatedSection(
                        start:
                            0.63,
                        end:
                            0.93,
                        child:
                            _HomeFeatureCard(
                          title:
                              'More',
                          subtitle:
                              'Tasbih, calendar and more',
                          icon:
                              Icons.grid_view_rounded,
                          motion:
                              _FeatureMotion.rotate,
                          onTap: () {
                            widget
                                .onNavigateToTab(
                              4,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top:
                12,
            right:
                12,
            child:
                SafeArea(
              child:
                  _SkyPreviewButton(
                mode:
                    _skyPreviewMode,
                lightForeground:
                    useLightForeground,
                onChanged: (
                  mode,
                ) {
                  setState(() {
                    _skyPreviewMode =
                        mode;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader
    extends StatelessWidget {
  const _HomeHeader({
    required this.name,
    required this.loading,
    required this.timeGreeting,
    required this.lightForeground,
  });

  final String name;
  final bool loading;
  final String timeGreeting;
  final bool lightForeground;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final displayName =
        name.trim();

    final primaryText =
        lightForeground
            ? Colors.white
            : theme
                .colorScheme
                .onSurface;

    final secondaryText =
        lightForeground
            ? Colors.white
                .withValues(
                alpha:
                    0.78,
              )
            : theme
                .colorScheme
                .onSurfaceVariant;

    final accentText =
        lightForeground
            ? const Color(
                0xFFA9F0D8,
              )
            : theme
                .colorScheme
                .primary;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration:
                        const Duration(
                      milliseconds:
                          450,
                    ),
                    curve:
                        Curves
                            .easeOutCubic,
                    style:
                        theme
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                              color:
                                  accentText,
                              fontWeight:
                                  FontWeight.w600,
                            ) ??
                            TextStyle(
                              color:
                                  accentText,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                    child:
                        Text(
                      timeGreeting,
                    ),
                  ),

                  const SizedBox(
                    height:
                        4,
                  ),

                  AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds:
                          350,
                    ),
                    child:
                        loading
                            ? Container(
                                key:
                                    const ValueKey(
                                  'loading',
                                ),
                                width:
                                    210,
                                height:
                                    34,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      lightForeground
                                          ? Colors.white
                                              .withValues(
                                              alpha:
                                                  0.16,
                                            )
                                          : theme
                                              .colorScheme
                                              .surfaceContainerHigh,
                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              )
                            : AnimatedDefaultTextStyle(
                                key:
                                    ValueKey(
                                  displayName,
                                ),
                                duration:
                                    const Duration(
                                  milliseconds:
                                      450,
                                ),
                                style:
                                    theme
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                          color:
                                              primaryText,
                                          fontWeight:
                                              FontWeight.w800,
                                          letterSpacing:
                                              -0.8,
                                          height:
                                              1.15,
                                        ) ??
                                        TextStyle(
                                          color:
                                              primaryText,
                                          fontWeight:
                                              FontWeight.w800,
                                        ),
                                child:
                                    Text(
                                  displayName.isEmpty
                                      ? 'Assalamu Alaikum'
                                      : 'Assalamu Alaikum, $displayName',
                                ),
                              ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              width:
                  56,
            ),
          ],
        ),

        const SizedBox(
          height:
              AppSpacing.sm,
        ),

        AnimatedDefaultTextStyle(
          duration:
              const Duration(
            milliseconds:
                450,
          ),
          curve:
              Curves
                  .easeOutCubic,
          style:
              theme
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    color:
                        secondaryText,
                    height:
                        1.45,
                  ) ??
                  TextStyle(
                    color:
                        secondaryText,
                    height:
                        1.45,
                  ),
          child:
              const Text(
            'A peaceful space for knowledge, prayer and reflection.',
          ),
        ),
      ],
    );
  }
}

class _HadithCard
    extends StatelessWidget {
  const _HadithCard({
    required this.hadith,
  });

  final HomeHadith hadith;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return IlmCard(
      child:
          Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:
                    38,
                height:
                    38,
                decoration:
                    BoxDecoration(
                  color:
                      theme
                          .colorScheme
                          .primary
                          .withValues(
                        alpha:
                            0.10,
                      ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child:
                    Icon(
                  Icons
                      .auto_awesome_rounded,
                  size:
                      19,
                  color:
                      theme
                          .colorScheme
                          .primary,
                ),
              ),

              const SizedBox(
                width:
                    AppSpacing.sm,
              ),

              Expanded(
                child:
                    Text(
                  'Hadith Reminder',
                  style:
                      theme
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height:
                AppSpacing.lg,
          ),

          Text(
            '“${hadith.text}”',
            style:
                theme
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                  height:
                      1.55,
                  fontWeight:
                      FontWeight.w500,
                ),
          ),

          const SizedBox(
            height:
                AppSpacing.md,
          ),

          Text(
            hadith.source,
            style:
                theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                      theme
                          .colorScheme
                          .primary,
                  fontWeight:
                      FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ExploreHeader
    extends StatelessWidget {
  const _ExploreHeader({
    required this.lightForeground,
  });

  final bool lightForeground;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final titleColor =
        lightForeground
            ? Colors.white
            : theme
                .colorScheme
                .onSurface;

    final accentColor =
        lightForeground
            ? const Color(
                0xFFA9F0D8,
              )
            : theme
                .colorScheme
                .primary;

    return Row(
      children: [
        Expanded(
          child:
              AnimatedDefaultTextStyle(
            duration:
                const Duration(
              milliseconds:
                  450,
            ),
            style:
                theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      color:
                          titleColor,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing:
                          -0.5,
                    ) ??
                    TextStyle(
                      color:
                          titleColor,
                      fontWeight:
                          FontWeight.w800,
                    ),
            child:
                const Text(
              'Explore ILM',
            ),
          ),
        ),

        AnimatedDefaultTextStyle(
          duration:
              const Duration(
            milliseconds:
                450,
          ),
          style:
              theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color:
                        accentColor,
                    fontWeight:
                        FontWeight.w700,
                  ) ??
                  TextStyle(
                    color:
                        accentColor,
                    fontWeight:
                        FontWeight.w700,
                  ),
          child:
              const Text(
            'For you',
          ),
        ),
      ],
    );
  }
}

enum _FeatureMotion {
  scale,
  lift,
  emphasis,
  tilt,
  pulse,
  rotate,
}

class _HomeFeatureCard
    extends StatefulWidget {
  const _HomeFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.motion,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final _FeatureMotion motion;
  final VoidCallback onTap;

  @override
  State<_HomeFeatureCard>
      createState() =>
          _HomeFeatureCardState();
}

class _HomeFeatureCardState
    extends State<_HomeFeatureCard> {
  bool _pressed = false;

  void _setPressed(
    bool value,
  ) {
    if (_pressed == value) {
      return;
    }

    setState(() {
      _pressed = value;
    });
  }

  Widget _animatedIcon(
    Widget icon,
  ) {
    switch (widget.motion) {
      case _FeatureMotion.scale:
        return AnimatedScale(
          scale:
              _pressed
                  ? 1.12
                  : 1,
          duration:
              const Duration(
            milliseconds:
                180,
          ),
          curve:
              Curves.easeOutBack,
          child:
              icon,
        );

      case _FeatureMotion.lift:
        return AnimatedSlide(
          offset:
              _pressed
                  ? const Offset(
                      0,
                      -0.10,
                    )
                  : Offset.zero,
          duration:
              const Duration(
            milliseconds:
                180,
          ),
          curve:
              Curves.easeOutCubic,
          child:
              icon,
        );

      case _FeatureMotion.emphasis:
        return AnimatedScale(
          scale:
              _pressed
                  ? 1.09
                  : 1,
          duration:
              const Duration(
            milliseconds:
                180,
          ),
          curve:
              Curves.easeOutBack,
          child:
              AnimatedOpacity(
            opacity:
                _pressed
                    ? 0.82
                    : 1,
            duration:
                const Duration(
              milliseconds:
                  140,
            ),
            child:
                icon,
          ),
        );

      case _FeatureMotion.tilt:
        return AnimatedRotation(
          turns:
              _pressed
                  ? -0.025
                  : 0,
          duration:
              const Duration(
            milliseconds:
                200,
          ),
          curve:
              Curves.easeOutBack,
          child:
              icon,
        );

      case _FeatureMotion.pulse:
        return AnimatedScale(
          scale:
              _pressed
                  ? 1.15
                  : 1,
          duration:
              const Duration(
            milliseconds:
                170,
          ),
          curve:
              Curves.easeOutBack,
          child:
              icon,
        );

      case _FeatureMotion.rotate:
        return AnimatedRotation(
          turns:
              _pressed
                  ? 0.035
                  : 0,
          duration:
              const Duration(
            milliseconds:
                220,
          ),
          curve:
              Curves.easeOutBack,
          child:
              icon,
        );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final iconWidget =
        Icon(
      widget.icon,
      size:
          24,
      color:
          theme
              .colorScheme
              .primary,
    );

    return Listener(
      onPointerDown: (
        _,
      ) {
        _setPressed(
          true,
        );
      },
      onPointerUp: (
        _,
      ) {
        _setPressed(
          false,
        );
      },
      onPointerCancel: (
        _,
      ) {
        _setPressed(
          false,
        );
      },
      child:
          IlmCard(
        onTap:
            widget.onTap,
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration:
                  const Duration(
                milliseconds:
                    180,
              ),
              curve:
                  Curves
                      .easeOutCubic,
              width:
                  46,
              height:
                  46,
              decoration:
                  BoxDecoration(
                color:
                    theme
                        .colorScheme
                        .primary
                        .withValues(
                      alpha:
                          _pressed
                              ? 0.15
                              : 0.10,
                    ),
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child:
                  Center(
                child:
                    _animatedIcon(
                  iconWidget,
                ),
              ),
            ),

            const Spacer(),

            Text(
              widget.title,
              maxLines:
                  2,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing:
                        -0.25,
                  ),
            ),

            const SizedBox(
              height:
                  AppSpacing.xs,
            ),

            Text(
              widget.subtitle,
              maxLines:
                  2,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        theme
                            .colorScheme
                            .onSurfaceVariant,
                    height:
                        1.35,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkyPreviewButton
    extends StatelessWidget {
  const _SkyPreviewButton({
    required this.mode,
    required this.lightForeground,
    required this.onChanged,
  });

  final SkyPreviewMode mode;

  final bool lightForeground;

  final ValueChanged<SkyPreviewMode>
      onChanged;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final backgroundColor =
        lightForeground
            ? const Color(
                0xFF16263A,
              ).withValues(
                alpha:
                    0.72,
              )
            : Colors.white
                .withValues(
                alpha:
                    0.88,
              );

    final borderColor =
        lightForeground
            ? Colors.white
                .withValues(
                alpha:
                    0.18,
              )
            : Colors.white
                .withValues(
                alpha:
                    0.65,
              );

    final iconColor =
        lightForeground
            ? Colors.white
            : theme
                .colorScheme
                .onSurface;

    return PopupMenuButton<
        SkyPreviewMode>(
      tooltip:
          'Preview sky',
      initialValue:
          mode,
      onSelected:
          onChanged,
      color:
          theme
              .colorScheme
              .surface,
      surfaceTintColor:
          Colors.transparent,
      elevation:
          8,
      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      itemBuilder: (
        context,
      ) {
        return const [
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .automatic,
            child:
                Text(
              'Automatic',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .dawn,
            child:
                Text(
              'Dawn',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .morning,
            child:
                Text(
              'Morning',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .day,
            child:
                Text(
              'Day',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .afternoon,
            child:
                Text(
              'Afternoon',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .sunset,
            child:
                Text(
              'Sunset',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .night,
            child:
                Text(
              'Night',
            ),
          ),
          PopupMenuItem(
            value:
                SkyPreviewMode
                    .lateNight,
            child:
                Text(
              'Late Night',
            ),
          ),
        ];
      },
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds:
              450,
        ),
        curve:
            Curves.easeOutCubic,
        width:
            46,
        height:
            46,
        decoration:
            BoxDecoration(
          color:
              backgroundColor,
          borderRadius:
              BorderRadius.circular(
            15,
          ),
          border:
              Border.all(
            color:
                borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withValues(
                alpha:
                    lightForeground
                        ? 0.18
                        : 0.07,
              ),
              blurRadius:
                  22,
              offset:
                  const Offset(
                0,
                7,
              ),
            ),
          ],
        ),
        child:
            Icon(
          Icons.palette_outlined,
          size:
              20,
          color:
              iconColor,
        ),
      ),
    );
  }
}