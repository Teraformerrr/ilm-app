import 'dart:async';

import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/prayer_time.dart';
import '../services/location_service.dart';
import '../services/prayer_calculation_service.dart';
import '../services/prayer_service.dart';
import '../services/tahajjud_service.dart';
import '../widgets/daily_prayer_times_card.dart';
import '../widgets/ilm_card.dart';
import '../widgets/prayer_status_card.dart';
import '../widgets/tahajjud_card.dart';
import 'prayer_settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? _latitude;
  double? _longitude;

  bool _isLoadingLocation = true;
  String? _locationError;

  Timer? _prayerRefreshTimer;

  @override
  void initState() {
    super.initState();

    _loadLocation();
    _startPrayerRefreshTimer();
  }

  void _startPrayerRefreshTimer() {
    _prayerRefreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) {
        if (!mounted) return;

        setState(() {});
      },
    );
  }

  Future<void> _loadLocation() async {
    const locationService = LocationService();

    try {
      final position = await locationService.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _isLoadingLocation = false;
        _locationError = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
        _locationError =
            'Location unavailable. Using temporary Dubai location.';
      });
    }
  }

  @override
  void dispose() {
    _prayerRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const prayerCalculationService = PrayerCalculationService();
    const prayerService = PrayerService();
    const tahajjudService = TahajjudService();

    final now = DateTime.now();

    final locationStatus = _isLoadingLocation
        ? 'Using temporary Dubai location while GPS loads.'
        : _locationError != null
            ? _locationError!
            : 'Using your current location.';

    // Dubai is used only as a safe fallback if GPS is unavailable.
    final latitude = _latitude ?? 25.2048;
    final longitude = _longitude ?? 55.2708;

    final prayerTimes = prayerCalculationService.calculatePrayerTimes(
      latitude: latitude,
      longitude: longitude,
      date: now,
    );

    final tomorrowFajr = prayerCalculationService.calculateTomorrowFajr(
      latitude: latitude,
      longitude: longitude,
      date: now,
    );

    final nextPrayer = prayerService.getNextPrayer(
      prayerTimes: prayerTimes,
      tomorrowFajr: tomorrowFajr,
      now: now,
    );

    final maghrib = prayerTimes.firstWhere(
      (prayer) => prayer.type == PrayerType.maghrib,
    );

    final tahajjudWindow = tahajjudService.calculate(
      maghrib: maghrib.time,
      nextFajr: tomorrowFajr.time,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('ILM'),
        actions: [
          IconButton(
            tooltip: 'Prayer Settings',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PrayerSettingsScreen(
                    latitude: latitude,
                    longitude: longitude,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.sm),

              Text(
                'Assalamu Alaikum',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Welcome to ILM',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
              ),

              const SizedBox(height: AppSpacing.xl),

              const IlmCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Islamic companion',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      'Qur’an • Prayer • Hadith • Guidance',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              if (nextPrayer != null)
                PrayerStatusCard(
                  prayer: nextPrayer,
                  statusText: locationStatus,
                ),

              const SizedBox(height: AppSpacing.lg),

              DailyPrayerTimesCard(
                prayerTimes: prayerTimes,
                nextPrayer: nextPrayer,
              ),

              const SizedBox(height: AppSpacing.lg),

              TahajjudCard(
                window: tahajjudWindow,
              ),
            ],
          ),
        ),
      ),
    );
  }
}