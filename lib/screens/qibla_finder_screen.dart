import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../core/app_spacing.dart';
import '../widgets/ilm_card.dart';

class QiblaFinderScreen extends StatefulWidget {
  const QiblaFinderScreen({super.key});

  @override
  State<QiblaFinderScreen> createState() => _QiblaFinderScreenState();
}

class _QiblaFinderScreenState extends State<QiblaFinderScreen>
    with WidgetsBindingObserver {
  static const double _kaabaLatitude = 21.422487;

  static const double _kaabaLongitude = 39.826206;

  static const Duration _locationTimeout = Duration(seconds: 12);

  static const Duration _lastKnownTimeout = Duration(seconds: 3);

  late Future<_QiblaLocationResult> _locationFuture;

  bool _refreshWhenResumed = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _locationFuture = _loadLocation();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || !_refreshWhenResumed) {
      return;
    }

    _refreshWhenResumed = false;

    _refreshLocation();
  }

  Future<_QiblaLocationResult> _loadLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled()
          .timeout(const Duration(seconds: 5));

      if (!serviceEnabled) {
        return const _QiblaLocationResult(
          status: _LocationStatus.serviceDisabled,
        );
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const _QiblaLocationResult(
          status: _LocationStatus.permissionDenied,
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const _QiblaLocationResult(
          status: _LocationStatus.permissionDeniedForever,
        );
      }

      Position? position;

      var usingLastKnownLocation = false;

      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).timeout(_locationTimeout);
      } on TimeoutException {
        position = await _getLastKnownPosition();

        usingLastKnownLocation = position != null;
      } catch (_) {
        position = await _getLastKnownPosition();

        usingLastKnownLocation = position != null;
      }

      if (position == null) {
        return const _QiblaLocationResult(status: _LocationStatus.timedOut);
      }

      final qiblaBearing = _calculateQiblaBearing(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      final distanceMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _kaabaLatitude,
        _kaabaLongitude,
      );

      return _QiblaLocationResult(
        status: _LocationStatus.ready,
        position: position,
        qiblaBearing: qiblaBearing,
        distanceKm: distanceMeters / 1000,
        usingLastKnownLocation: usingLastKnownLocation,
      );
    } on TimeoutException {
      return const _QiblaLocationResult(status: _LocationStatus.timedOut);
    } catch (_) {
      return const _QiblaLocationResult(status: _LocationStatus.error);
    }
  }

  Future<Position?> _getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition().timeout(_lastKnownTimeout);
    } catch (_) {
      return null;
    }
  }

  void _refreshLocation() {
    if (!mounted) {
      return;
    }

    setState(() {
      _locationFuture = _loadLocation();
    });
  }

  Future<void> _openLocationSettings() async {
    _refreshWhenResumed = true;

    await Geolocator.openLocationSettings();
  }

  Future<void> _openAppSettings() async {
    _refreshWhenResumed = true;

    await Geolocator.openAppSettings();
  }

  static double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  static double _radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }

  static double _normalizeDegrees(double value) {
    return (value % 360 + 360) % 360;
  }

  static double _shortestAngularDifference(double from, double to) {
    return ((to - from + 540) % 360) - 180;
  }

  static double _calculateQiblaBearing({
    required double latitude,
    required double longitude,
  }) {
    final latitudeRadians = _degreesToRadians(latitude);

    final kaabaLatitudeRadians = _degreesToRadians(_kaabaLatitude);

    final longitudeDifference = _degreesToRadians(_kaabaLongitude - longitude);

    final y = math.sin(longitudeDifference);

    final x =
        math.cos(latitudeRadians) * math.tan(kaabaLatitudeRadians) -
        math.sin(latitudeRadians) * math.cos(longitudeDifference);

    return _normalizeDegrees(_radiansToDegrees(math.atan2(y, x)));
  }

  static String _directionName(double bearing) {
    const directions = <String>['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];

    final index = ((bearing + 22.5) / 45).floor() % directions.length;

    return directions[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.30),
                    colorScheme.surfaceContainerLowest,
                    colorScheme.surfaceContainerLowest,
                  ],
                  stops: const [0, 0.36, 1],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<_QiblaLocationResult>(
              future: _locationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _LoadingView();
                }

                final result =
                    snapshot.data ??
                    const _QiblaLocationResult(status: _LocationStatus.error);

                switch (result.status) {
                  case _LocationStatus.ready:
                    return _QiblaContent(
                      result: result,
                      onRefresh: _refreshLocation,
                    );

                  case _LocationStatus.serviceDisabled:
                    return _StateView(
                      icon: Icons.location_off_rounded,
                      title: 'Location is turned off',
                      message:
                          'Turn on location services so ILM can calculate your Qibla direction.',
                      buttonText: 'Open Location Settings',
                      onPressed: _openLocationSettings,
                    );

                  case _LocationStatus.permissionDenied:
                    return _StateView(
                      icon: Icons.location_disabled_rounded,
                      title: 'Location permission needed',
                      message:
                          'Qibla direction depends on your current location. Allow location access and try again.',
                      buttonText: 'Try Again',
                      onPressed: () async {
                        _refreshLocation();
                      },
                    );

                  case _LocationStatus.permissionDeniedForever:
                    return _StateView(
                      icon: Icons.location_disabled_rounded,
                      title: 'Location permission blocked',
                      message:
                          'Location access has been blocked. Enable it from the app settings.',
                      buttonText: 'Open App Settings',
                      onPressed: _openAppSettings,
                    );

                  case _LocationStatus.timedOut:
                    return _StateView(
                      icon: Icons.gps_off_rounded,
                      title: 'GPS is taking too long',
                      message:
                          'ILM could not get a location fix. Move somewhere with a clearer GPS signal and try again.',
                      buttonText: 'Try Again',
                      onPressed: () async {
                        _refreshLocation();
                      },
                    );

                  case _LocationStatus.error:
                    return _StateView(
                      icon: Icons.error_outline_rounded,
                      title: 'Location unavailable',
                      message:
                          'ILM could not determine your current location. Check GPS and location permission, then try again.',
                      buttonText: 'Try Again',
                      onPressed: () async {
                        _refreshLocation();
                      },
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QiblaContent extends StatelessWidget {
  const _QiblaContent({required this.result, required this.onRefresh});

  final _QiblaLocationResult result;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _QiblaHeader(onRefresh: onRefresh),

              if (result.usingLastKnownLocation) ...[
                const SizedBox(height: AppSpacing.md),

                const _CachedLocationNotice(),
              ],

              const SizedBox(height: AppSpacing.xl),

              _LiveCompassSection(bearing: result.qiblaBearing!),

              const SizedBox(height: AppSpacing.lg),

              _LocationDetailsCard(result: result),

              const SizedBox(height: AppSpacing.lg),

              const _CalibrationCard(),

              const SizedBox(height: AppSpacing.xl),
            ]),
          ),
        ),
      ],
    );
  }
}

class _CachedLocationNotice extends StatelessWidget {
  const _CachedLocationNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history_rounded,
            size: 19,
            color: colorScheme.onSecondaryContainer,
          ),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              'Using your last known location because a fresh GPS fix was unavailable.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveCompassSection extends StatefulWidget {
  const _LiveCompassSection({required this.bearing});

  final double bearing;

  @override
  State<_LiveCompassSection> createState() => _LiveCompassSectionState();
}

class _LiveCompassSectionState extends State<_LiveCompassSection>
    with SingleTickerProviderStateMixin {
  static const double _sensorSmoothing = 0.48;

  static const double _visualResponse = 18.0;

  StreamSubscription<CompassEvent>? _subscription;

  late final Ticker _ticker;

  final ValueNotifier<double?> _displayHeading = ValueNotifier<double?>(null);

  double? _targetHeading;

  Duration? _lastFrameTime;

  int _invalidReadingCount = 0;

  bool _compassUnavailable = false;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onFrame);

    _ticker.start();

    _startCompass();
  }

  void _startCompass() {
    final events = FlutterCompass.events;

    if (events == null) {
      setState(() {
        _compassUnavailable = true;
      });

      return;
    }

    _subscription = events.listen(
      _handleCompassEvent,
      onError: (_) {
        if (!mounted) {
          return;
        }

        setState(() {
          _compassUnavailable = true;
        });
      },
    );
  }

  void _handleCompassEvent(CompassEvent event) {
    if (!mounted) {
      return;
    }

    final rawHeading = event.heading;

    if (rawHeading == null || rawHeading.isNaN || rawHeading.isInfinite) {
      _invalidReadingCount++;

      if (_invalidReadingCount >= 8 && !_compassUnavailable) {
        setState(() {
          _compassUnavailable = true;
        });
      }

      return;
    }

    _invalidReadingCount = 0;

    if (_compassUnavailable) {
      setState(() {
        _compassUnavailable = false;
      });
    }

    final normalizedRaw = _QiblaFinderScreenState._normalizeDegrees(rawHeading);

    final target = _targetHeading;

    if (target == null) {
      _targetHeading = normalizedRaw;

      _displayHeading.value = normalizedRaw;

      return;
    }

    final normalizedTarget = _QiblaFinderScreenState._normalizeDegrees(target);

    final difference = _QiblaFinderScreenState._shortestAngularDifference(
      normalizedTarget,
      normalizedRaw,
    );

    _targetHeading = target + difference * _sensorSmoothing;
  }

  void _onFrame(Duration elapsed) {
    final target = _targetHeading;

    if (target == null) {
      _lastFrameTime = elapsed;

      return;
    }

    final previousFrame = _lastFrameTime;

    _lastFrameTime = elapsed;

    if (previousFrame == null) {
      return;
    }

    final frameDelta = elapsed - previousFrame;

    var dt = frameDelta.inMicroseconds / 1000000.0;

    if (dt <= 0) {
      return;
    }

    if (dt > 0.05) {
      dt = 0.05;
    }

    final current = _displayHeading.value;

    if (current == null) {
      _displayHeading.value = target;

      return;
    }

    final error = target - current;

    final blend = 1 - math.exp(-_visualResponse * dt);

    var next = current + error * blend;

    if (error.abs() < 0.005) {
      next = target;
    }

    if ((next - current).abs() < 0.001) {
      return;
    }

    _displayHeading.value = next;
  }

  @override
  void dispose() {
    _ticker.dispose();

    final subscription = _subscription;

    _subscription = null;

    subscription?.cancel();

    _displayHeading.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_compassUnavailable) {
      return _CompassUnavailableCard(bearing: widget.bearing);
    }

    return ValueListenableBuilder<double?>(
      valueListenable: _displayHeading,
      builder: (context, heading, child) {
        return RepaintBoundary(
          child: _CompassCard(heading: heading, bearing: widget.bearing),
        );
      },
    );
  }
}

class _QiblaHeader extends StatelessWidget {
  const _QiblaHeader({required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Qibla Finder',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),

              Text(
                'Find the direction of the Kaaba',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: 'Refresh location',
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
    );
  }
}

class _CompassCard extends StatelessWidget {
  const _CompassCard({required this.heading, required this.bearing});

  final double? heading;
  final double bearing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final currentHeading = heading;

    final double? difference;

    if (currentHeading == null) {
      difference = null;
    } else {
      difference = _QiblaFinderScreenState._shortestAngularDifference(
        _QiblaFinderScreenState._normalizeDegrees(currentHeading),
        bearing,
      );
    }

    final facingQibla = difference != null && difference.abs() <= 3.5;

    final nearQibla = difference != null && difference.abs() <= 15;

    final qiblaRotation = difference == null ? 0.0 : difference * math.pi / 180;

    final dialRotation = currentHeading == null
        ? 0.0
        : -currentHeading * math.pi / 180;

    final instruction = _instructionFor(difference);

    final alignmentStrength = difference == null
        ? 0.0
        : (1 - (difference.abs() / 25).clamp(0.0, 1.0)).toDouble();

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 18,
                color: colorScheme.primary,
              ),

              const SizedBox(width: 6),

              Text(
                '${bearing.toStringAsFixed(1)}° '
                '${_QiblaFinderScreenState._directionName(bearing)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),

          Text(
            'Qibla bearing',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: 300,
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 296,
                  height: 296,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surfaceContainerLow,
                    border: Border.all(
                      color: facingQibla
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: facingQibla ? 3 : 1,
                    ),
                    boxShadow: [
                      if (nearQibla)
                        BoxShadow(
                          color: colorScheme.primary.withValues(
                            alpha: 0.08 + alignmentStrength * 0.14,
                          ),
                          blurRadius: 24 + alignmentStrength * 22,
                          spreadRadius: alignmentStrength * 3,
                        ),
                    ],
                  ),
                ),

                Transform.rotate(
                  angle: dialRotation,
                  child: CustomPaint(
                    size: const Size.square(272),
                    painter: _CompassTickPainter(
                      color: colorScheme.onSurfaceVariant,
                      primaryColor: colorScheme.primary,
                    ),
                  ),
                ),

                const _CompassDirections(),

                if (difference != null)
                  Transform.rotate(
                    angle: qiblaRotation,
                    child: SizedBox(
                      width: 244,
                      height: 244,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            end: facingQibla
                                ? 1.08
                                : nearQibla
                                ? 1.03
                                : 1,
                          ),
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeOutBack,
                          builder: (context, scale, child) {
                            return Transform.scale(scale: scale, child: child);
                          },
                          child: Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.primary,
                              border: Border.all(
                                color: colorScheme.onPrimary.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: facingQibla ? 0.42 : 0.22,
                                  ),
                                  blurRadius: facingQibla ? 30 : 18,
                                  spreadRadius: facingQibla ? 3 : 0,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.mosque_rounded,
                              color: colorScheme.onPrimary,
                              size: 29,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                Container(
                  width: 122,
                  height: 122,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface.withValues(alpha: 0.96),
                    border: Border.all(
                      color: facingQibla
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: facingQibla ? 2.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                ),

                AnimatedScale(
                  scale: facingQibla ? 1.08 : 1,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: facingQibla
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHigh,
                    ),
                    child: Icon(
                      facingQibla
                          ? Icons.check_rounded
                          : Icons.navigation_rounded,
                      size: 38,
                      color: colorScheme.primary,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 26,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: facingQibla
                  ? colorScheme.primaryContainer
                  : colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: facingQibla
                    ? colorScheme.primary.withValues(alpha: 0.32)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Icon(
                    facingQibla
                        ? Icons.check_circle_rounded
                        : difference != null && difference > 0
                        ? Icons.turn_right_rounded
                        : Icons.turn_left_rounded,
                    key: ValueKey(
                      facingQibla
                          ? 'aligned'
                          : difference != null && difference > 0
                          ? 'right'
                          : 'left',
                    ),
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  instruction,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: facingQibla
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            currentHeading == null
                ? 'Waiting for your phone’s compass sensor.'
                : facingQibla
                ? 'Keep the phone steady in this direction.'
                : 'Keep your phone flat and rotate slowly.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          if (currentHeading != null) ...[
            const SizedBox(height: AppSpacing.md),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SmallInfoChip(
                  icon: Icons.navigation_rounded,
                  text:
                      '${_QiblaFinderScreenState._normalizeDegrees(currentHeading).toStringAsFixed(0)}°',
                ),

                const SizedBox(width: AppSpacing.sm),

                if (difference != null)
                  _SmallInfoChip(
                    icon: Icons.explore_rounded,
                    text: '${difference.abs().toStringAsFixed(0)}° away',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _instructionFor(double? difference) {
    if (difference == null) {
      return 'Waiting for compass';
    }

    if (difference.abs() <= 3.5) {
      return 'Qibla aligned';
    }

    final degrees = difference.abs().round();

    if (difference > 0) {
      return 'Turn right $degrees°';
    }

    return 'Turn left $degrees°';
  }
}

class _CompassTickPainter extends CustomPainter {
  const _CompassTickPainter({required this.color, required this.primaryColor});

  final Color color;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final radius = size.width / 2;

    for (var degree = 0; degree < 360; degree += 5) {
      final isMajor = degree % 30 == 0;

      final isCardinal = degree % 90 == 0;

      final length = isCardinal
          ? 16.0
          : isMajor
          ? 11.0
          : 5.0;

      final width = isCardinal
          ? 2.3
          : isMajor
          ? 1.6
          : 1.0;

      final angle = _degreesToRadians(degree.toDouble() - 90);

      final outer = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      final inner = Offset(
        center.dx + math.cos(angle) * (radius - length),
        center.dy + math.sin(angle) * (radius - length),
      );

      final paint = Paint()
        ..color = isCardinal
            ? primaryColor
            : color.withValues(alpha: isMajor ? 0.52 : 0.24)
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(inner, outer, paint);
    }

    final ringPaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius - 24, ringPaint);

    canvas.drawCircle(center, radius - 44, ringPaint);
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  @override
  bool shouldRepaint(covariant _CompassTickPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.primaryColor != primaryColor;
  }
}

class _CompassDirections extends StatelessWidget {
  const _CompassDirections();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final normalStyle = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: theme.colorScheme.onSurfaceVariant,
    );

    final northStyle = normalStyle?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w900,
    );

    return SizedBox(
      width: 296,
      height: 296,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('N', style: northStyle),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text('E', style: normalStyle),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('S', style: normalStyle),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text('W', style: normalStyle),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfoChip extends StatelessWidget {
  const _SmallInfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),

          const SizedBox(width: 5),

          Text(
            text,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationDetailsCard extends StatelessWidget {
  const _LocationDetailsCard({required this.result});

  final _QiblaLocationResult result;

  @override
  Widget build(BuildContext context) {
    final position = result.position!;

    return IlmCard(
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.explore_rounded,
            title: 'Qibla Bearing',
            value: '${result.qiblaBearing!.toStringAsFixed(1)}°',
          ),

          const Divider(),

          _DetailRow(
            icon: Icons.straighten_rounded,
            title: 'Distance to Kaaba',
            value: '${result.distanceKm!.toStringAsFixed(0)} km',
          ),

          const Divider(),

          _DetailRow(
            icon: Icons.my_location_rounded,
            title: result.usingLastKnownLocation
                ? 'Last Known Location'
                : 'Your Location',
            value:
                '${position.latitude.toStringAsFixed(4)}, '
                '${position.longitude.toStringAsFixed(4)}',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalibrationCard extends StatelessWidget {
  const _CalibrationCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.screen_rotation_alt_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compass accuracy',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Keep your phone flat and away from magnets, speakers, metal objects and other electronics. '
                  'If the direction looks unstable, slowly move your phone in a figure-eight motion.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
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

class _CompassUnavailableCard extends StatelessWidget {
  const _CompassUnavailableCard({required this.bearing});

  final double bearing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Icon(
              Icons.explore_off_rounded,
              size: 36,
              color: colorScheme.primary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Compass unavailable',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Your Qibla bearing is '
            '${bearing.toStringAsFixed(1)}° '
            '${_QiblaFinderScreenState._directionName(bearing)}.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'This device is not currently providing a live compass heading.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: IconButton(
              tooltip: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),

                const SizedBox(height: AppSpacing.lg),

                Text(
                  'Finding your location...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'This should only take a few seconds.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StateView extends StatelessWidget {
  const _StateView({
    required this.icon,
    required this.title,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String message;
  final String buttonText;
  final FutureOr<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              tooltip: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),

          const Spacer(),

          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primaryContainer,
            ),
            child: Icon(icon, size: 38, color: colorScheme.primary),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          FilledButton.icon(
            onPressed: () {
              onPressed();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(buttonText),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

enum _LocationStatus {
  ready,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timedOut,
  error,
}

class _QiblaLocationResult {
  const _QiblaLocationResult({
    required this.status,
    this.position,
    this.qiblaBearing,
    this.distanceKm,
    this.usingLastKnownLocation = false,
  });

  final _LocationStatus status;

  final Position? position;

  final double? qiblaBearing;

  final double? distanceKm;

  final bool usingLastKnownLocation;
}
