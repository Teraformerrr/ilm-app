import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../data/home_hadiths.dart';
import '../models/home_hadith.dart';
import '../services/location_service.dart';
import '../services/prayer_calculation_service.dart';
import '../services/prayer_service.dart';
import '../widgets/ilm_card.dart';
import '../widgets/prayer_status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.onNavigateToTab,
    required this.onOpenDreamInterpretation,
    required this.onOpenDuas,
    super.key,
  });

  final ValueChanged<int> onNavigateToTab;
  final VoidCallback onOpenDreamInterpretation;
  final VoidCallback onOpenDuas;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeHadith _launchHadith;

  double? _latitude;
  double? _longitude;

  bool _isLoadingLocation = true;
  String? _locationError;

  @override
  void initState() {
    super.initState();

    _launchHadith =
        homeHadiths[Random().nextInt(homeHadiths.length)];

    _loadLocation();
  }

  Future<void> _loadLocation() async {
    const locationService = LocationService();

    try {
      final position =
          await locationService.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLoadingLocation = false;
        _locationError = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
        _locationError =
            'Location unavailable. Using Dubai fallback.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const prayerCalculationService =
        PrayerCalculationService();

    const prayerService = PrayerService();

    final now = DateTime.now();

    final latitude =
        _latitude ?? 25.2048;

    final longitude =
        _longitude ?? 55.2708;

    final locationStatus =
        _isLoadingLocation
            ? 'Loading your location...'
            : _locationError ??
                'Using your current location.';

    final prayerTimes =
        prayerCalculationService.calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: now,
    );

    final tomorrowFajr =
        prayerCalculationService.calculateTomorrowFajr(
      latitude: latitude,
      longitude: longitude,
      date: now,
    );

    final nextPrayer =
        prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      tomorrowFajr: tomorrowFajr,
      now: now,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ILM'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Assalamu Alaikum',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),

              const SizedBox(
                height: AppSpacing.xs,
              ),

              Text(
                'A reminder for your day',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color: Colors.black54,
                    ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              IlmCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          size: 20,
                        ),
                        SizedBox(
                          width: AppSpacing.sm,
                        ),
                        Text(
                          'Hadith Reminder',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: AppSpacing.md,
                    ),

                    Text(
                      '“${_launchHadith.text}”',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            height: 1.5,
                          ),
                    ),

                    const SizedBox(
                      height: AppSpacing.md,
                    ),

                    Text(
                      _launchHadith.source,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color:
                                Colors.black54,
                            fontWeight:
                                FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              if (nextPrayer != null)
                PrayerStatusCard(
                  prayer: nextPrayer,
                  statusText:
                      locationStatus,
                ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              Text(
                'Explore ILM',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),

              const SizedBox(
                height: AppSpacing.md,
              ),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisSpacing:
                    AppSpacing.md,
                mainAxisSpacing:
                    AppSpacing.md,
                childAspectRatio: 1.35,
                children: [
                  _HomeFeatureCard(
                    title: 'Qur’an',
                    subtitle:
                        'Read, listen and reflect',
                    icon:
                        Icons.menu_book_outlined,
                    onTap: () {
                      widget.onNavigateToTab(1);
                    },
                  ),

                  _HomeFeatureCard(
                    title: 'Prayer',
                    subtitle:
                        'Times, Tahajjud and Qibla',
                    icon:
                        Icons.mosque_outlined,
                    onTap: () {
                      widget.onNavigateToTab(2);
                    },
                  ),

                  _HomeFeatureCard(
                    title: 'Hadith',
                    subtitle:
                        'Authentic collections',
                    icon:
                        Icons.library_books_outlined,
                    onTap: () {
                      widget.onNavigateToTab(3);
                    },
                  ),

                  _HomeFeatureCard(
                    title:
                        'Dream Interpretation',
                    subtitle:
                        'Source-based guidance',
                    icon:
                        Icons.nights_stay_outlined,
                    onTap:
                        widget.onOpenDreamInterpretation,
                  ),

                  _HomeFeatureCard(
                    title: 'Duas & Adhkar',
                    subtitle:
                        'Daily remembrance',
                    icon:
                        Icons.favorite_border,
                    onTap: widget.onOpenDuas,
                  ),

                  _HomeFeatureCard(
                    title: 'More',
                    subtitle:
                        'Tasbih, calendar and more',
                    icon:
                        Icons.grid_view_outlined,
                    onTap: () {
                      widget.onNavigateToTab(4);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFeatureCard extends StatelessWidget {
  const _HomeFeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(16),
      onTap: onTap,
      child: IlmCard(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const Spacer(),

            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),

            const SizedBox(
              height: AppSpacing.xs,
            ),

            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}