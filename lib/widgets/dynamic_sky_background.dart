import 'dart:math' as math;

import 'package:flutter/material.dart';

enum SkyPreviewMode {
  automatic,
  dawn,
  morning,
  day,
  afternoon,
  sunset,
  night,
  lateNight,
}

class DynamicSkyBackground extends StatefulWidget {
  const DynamicSkyBackground({
    required this.now,
    required this.fajr,
    required this.maghrib,
    this.previewMode = SkyPreviewMode.automatic,
    super.key,
  });

  final DateTime now;
  final DateTime fajr;
  final DateTime maghrib;

  final SkyPreviewMode previewMode;

  @override
  State<DynamicSkyBackground> createState() =>
      _DynamicSkyBackgroundState();
}

class _DynamicSkyBackgroundState
    extends State<DynamicSkyBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 18,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _SkyPhase get _phase {
    switch (widget.previewMode) {
      case SkyPreviewMode.automatic:
        return _SkyPhase.fromTimes(
          now: widget.now,
          fajr: widget.fajr,
          maghrib: widget.maghrib,
        );

      case SkyPreviewMode.dawn:
        return _SkyPhase.dawn;

      case SkyPreviewMode.morning:
        return _SkyPhase.morning;

      case SkyPreviewMode.day:
        return _SkyPhase.day;

      case SkyPreviewMode.afternoon:
        return _SkyPhase.afternoon;

      case SkyPreviewMode.sunset:
        return _SkyPhase.sunset;

      case SkyPreviewMode.night:
        return _SkyPhase.night;

      case SkyPreviewMode.lateNight:
        return _SkyPhase.lateNight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (
          context,
          child,
        ) {
          final phase =
              _phase;

          final palette =
              _paletteForPhase(
            phase,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 1400,
                ),
                curve:
                    Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment.topCenter,
                    end:
                        Alignment.bottomCenter,
                    colors:
                        palette.background,
                    stops:
                        palette.stops,
                  ),
                ),
              ),

              _buildHorizonGlow(
                phase,
                palette,
              ),

              _buildCelestialGlow(
                phase,
                palette,
              ),

              if (phase ==
                      _SkyPhase.night ||
                  phase ==
                      _SkyPhase.lateNight ||
                  phase ==
                      _SkyPhase.dawn)
                _buildStars(
                  phase,
                  palette,
                ),

              if (phase ==
                  _SkyPhase.sunset)
                _buildSunsetHorizon(
                  palette,
                ),

              _buildSoftOverlay(
                phase,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHorizonGlow(
    _SkyPhase phase,
    _SkyPalette palette,
  ) {
    if (phase != _SkyPhase.dawn &&
        phase != _SkyPhase.afternoon &&
        phase != _SkyPhase.sunset) {
      return const SizedBox.shrink();
    }

    double bottom;

    switch (phase) {
      case _SkyPhase.dawn:
        bottom = 160;

      case _SkyPhase.afternoon:
        bottom = 100;

      case _SkyPhase.sunset:
        bottom = 40;

      case _SkyPhase.morning:
      case _SkyPhase.day:
      case _SkyPhase.night:
      case _SkyPhase.lateNight:
        bottom = 0;
    }

    return Positioned(
      left: -100,
      right: -100,
      bottom: bottom,
      height: 360,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            gradient:
                RadialGradient(
              radius: 0.85,
              colors: [
                palette.horizonGlow
                    .withValues(
                  alpha:
                      palette
                          .horizonAlpha,
                ),
                palette.horizonGlow
                    .withValues(
                  alpha: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCelestialGlow(
    _SkyPhase phase,
    _SkyPalette palette,
  ) {
    final progress =
        _controller.value;

    final horizontalDrift =
        math.sin(
              progress *
                  math.pi *
                  2,
            ) *
            5;

    Alignment alignment;

    double size;

    switch (phase) {
      case _SkyPhase.dawn:
        alignment =
            const Alignment(
          -0.55,
          0.15,
        );
        size = 280;

      case _SkyPhase.morning:
        alignment =
            const Alignment(
          -0.55,
          -0.55,
        );
        size = 300;

      case _SkyPhase.day:
        alignment =
            const Alignment(
          0.05,
          -0.75,
        );
        size = 320;

      case _SkyPhase.afternoon:
        alignment =
            const Alignment(
          0.55,
          -0.10,
        );
        size = 320;

      case _SkyPhase.sunset:
        alignment =
            const Alignment(
          0.60,
          0.55,
        );
        size = 330;

      case _SkyPhase.night:
        alignment =
            const Alignment(
          0.58,
          -0.55,
        );
        size = 230;

      case _SkyPhase.lateNight:
        alignment =
            const Alignment(
          0.45,
          -0.62,
        );
        size = 220;
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment:
              alignment,
          child: Transform.translate(
            offset: Offset(
              horizontalDrift,
              0,
            ),
            child: Container(
              width: size,
              height: size,
              decoration:
                  BoxDecoration(
                shape:
                    BoxShape.circle,
                gradient:
                    RadialGradient(
                  colors: [
                    palette.celestialGlow
                        .withValues(
                      alpha:
                          palette
                              .celestialAlpha,
                    ),
                    palette.celestialGlow
                        .withValues(
                      alpha:
                          palette
                                  .celestialAlpha *
                              0.35,
                    ),
                    palette.celestialGlow
                        .withValues(
                      alpha: 0,
                    ),
                  ],
                  stops: const [
                    0,
                    0.35,
                    1,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStars(
    _SkyPhase phase,
    _SkyPalette palette,
  ) {
    double opacity;

    switch (phase) {
      case _SkyPhase.dawn:
        opacity = 0.30;

      case _SkyPhase.night:
        opacity = 0.75;

      case _SkyPhase.lateNight:
        opacity = 0.90;

      case _SkyPhase.morning:
      case _SkyPhase.day:
      case _SkyPhase.afternoon:
      case _SkyPhase.sunset:
        opacity = 0;
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity:
              opacity,
          child: CustomPaint(
            painter:
                _StarFieldPainter(
              progress:
                  _controller.value,
              color:
                  palette.starColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSunsetHorizon(
    _SkyPalette palette,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 380,
      child: IgnorePointer(
        child: Container(
          decoration:
              BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                palette.sunsetBand
                    .withValues(
                  alpha: 0.08,
                ),
                palette.sunsetBand
                    .withValues(
                  alpha: 0.24,
                ),
                palette.sunsetBand
                    .withValues(
                  alpha: 0.10,
                ),
              ],
              stops: const [
                0,
                0.42,
                0.72,
                1,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoftOverlay(
    _SkyPhase phase,
  ) {
    final isDark =
        phase == _SkyPhase.night ||
            phase ==
                _SkyPhase.lateNight;

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              begin:
                  Alignment.topCenter,
              end:
                  Alignment.bottomCenter,
              colors: [
                Colors.white.withValues(
                  alpha:
                      isDark
                          ? 0.005
                          : 0.025,
                ),
                Colors.transparent,
                Colors.black.withValues(
                  alpha:
                      isDark
                          ? 0.08
                          : 0.015,
                ),
              ],
              stops: const [
                0,
                0.55,
                1,
              ],
            ),
          ),
        ),
      ),
    );
  }

  _SkyPalette _paletteForPhase(
    _SkyPhase phase,
  ) {
    switch (phase) {
      case _SkyPhase.dawn:
        return const _SkyPalette(
          background: [
            Color(0xFF243453),
            Color(0xFF59627D),
            Color(0xFFB57F82),
            Color(0xFFE8AD83),
            Color(0xFFF5D6A5),
          ],
          stops: [
            0,
            0.22,
            0.48,
            0.72,
            1,
          ],
          celestialGlow:
              Color(0xFFFFC879),
          celestialAlpha:
              0.28,
          horizonGlow:
              Color(0xFFFFB96B),
          horizonAlpha:
              0.28,
          sunsetBand:
              Color(0xFFFF9B58),
          starColor:
              Colors.white,
        );

      case _SkyPhase.morning:
        return const _SkyPalette(
          background: [
            Color(0xFFDDEFF1),
            Color(0xFFEAF4EF),
            Color(0xFFF5EEDB),
            Color(0xFFF8F7F1),
          ],
          stops: [
            0,
            0.32,
            0.68,
            1,
          ],
          celestialGlow:
              Color(0xFFFFD77D),
          celestialAlpha:
              0.24,
          horizonGlow:
              Color(0xFFFFDCA1),
          horizonAlpha:
              0.10,
          sunsetBand:
              Color(0xFFFFC97E),
          starColor:
              Colors.white,
        );

      case _SkyPhase.day:
        return const _SkyPalette(
          background: [
            Color(0xFFDCEDEF),
            Color(0xFFE7F3EF),
            Color(0xFFF2F6EF),
            Color(0xFFF8F7F2),
          ],
          stops: [
            0,
            0.35,
            0.72,
            1,
          ],
          celestialGlow:
              Color(0xFFFFE5A5),
          celestialAlpha:
              0.18,
          horizonGlow:
              Color(0xFFCFEBDD),
          horizonAlpha:
              0.08,
          sunsetBand:
              Color(0xFFE5B96B),
          starColor:
              Colors.white,
        );

      case _SkyPhase.afternoon:
        return const _SkyPalette(
          background: [
            Color(0xFFD9E8E6),
            Color(0xFFECEAD8),
            Color(0xFFF4E2C1),
            Color(0xFFF8F5EA),
          ],
          stops: [
            0,
            0.34,
            0.70,
            1,
          ],
          celestialGlow:
              Color(0xFFFFC65E),
          celestialAlpha:
              0.24,
          horizonGlow:
              Color(0xFFF0B85F),
          horizonAlpha:
              0.16,
          sunsetBand:
              Color(0xFFE19B51),
          starColor:
              Colors.white,
        );

      case _SkyPhase.sunset:
        return const _SkyPalette(
          background: [
            Color(0xFF283456),
            Color(0xFF4E5271),
            Color(0xFF8A6376),
            Color(0xFFD27A66),
            Color(0xFFF1A25E),
            Color(0xFFF6D89F),
          ],
          stops: [
            0,
            0.18,
            0.38,
            0.58,
            0.78,
            1,
          ],
          celestialGlow:
              Color(0xFFFFB24F),
          celestialAlpha:
              0.38,
          horizonGlow:
              Color(0xFFFF9B4F),
          horizonAlpha:
              0.35,
          sunsetBand:
              Color(0xFFFF7F45),
          starColor:
              Colors.white,
        );

      case _SkyPhase.night:
        return const _SkyPalette(
          background: [
            Color(0xFF0A1429),
            Color(0xFF10243D),
            Color(0xFF153944),
            Color(0xFF183F3D),
          ],
          stops: [
            0,
            0.34,
            0.70,
            1,
          ],
          celestialGlow:
              Color(0xFFB9D5E5),
          celestialAlpha:
              0.15,
          horizonGlow:
              Color(0xFF1C5A58),
          horizonAlpha:
              0.08,
          sunsetBand:
              Color(0xFF183B4A),
          starColor:
              Color(0xFFF4F7FF),
        );

      case _SkyPhase.lateNight:
        return const _SkyPalette(
          background: [
            Color(0xFF050C1B),
            Color(0xFF09162A),
            Color(0xFF0D2635),
            Color(0xFF102F31),
          ],
          stops: [
            0,
            0.35,
            0.72,
            1,
          ],
          celestialGlow:
              Color(0xFFC7DDEC),
          celestialAlpha:
              0.13,
          horizonGlow:
              Color(0xFF173F43),
          horizonAlpha:
              0.06,
          sunsetBand:
              Color(0xFF102B3B),
          starColor:
              Color(0xFFF4F7FF),
        );
    }
  }
}

enum _SkyPhase {
  dawn,
  morning,
  day,
  afternoon,
  sunset,
  night,
  lateNight;

  static _SkyPhase fromTimes({
    required DateTime now,
    required DateTime fajr,
    required DateTime maghrib,
  }) {
    final dawnStart =
        fajr.subtract(
      const Duration(
        minutes: 50,
      ),
    );

    final morningEnd =
        fajr.add(
      const Duration(
        hours: 3,
      ),
    );

    final afternoonStart =
        maghrib.subtract(
      const Duration(
        hours: 3,
      ),
    );

    final sunsetStart =
        maghrib.subtract(
      const Duration(
        minutes: 55,
      ),
    );

    final sunsetEnd =
        maghrib.add(
      const Duration(
        minutes: 45,
      ),
    );

    final lateNightStart =
        DateTime(
      now.year,
      now.month,
      now.day,
      23,
      30,
    );

    /*
     * Before dawnStart we are still in late-night sky.
     */
    if (now.isBefore(
      dawnStart,
    )) {
      return _SkyPhase.lateNight;
    }

    /*
     * Roughly 50 minutes leading into Fajr.
     */
    if (now.isBefore(
      fajr,
    )) {
      return _SkyPhase.dawn;
    }

    /*
     * Early morning after Fajr.
     */
    if (now.isBefore(
      morningEnd,
    )) {
      return _SkyPhase.morning;
    }

    /*
     * Main daylight period.
     */
    if (now.isBefore(
      afternoonStart,
    )) {
      return _SkyPhase.day;
    }

    /*
     * Warm light before sunset.
     */
    if (now.isBefore(
      sunsetStart,
    )) {
      return _SkyPhase.afternoon;
    }

    /*
     * Maghrib transition.
     */
    if (now.isBefore(
      sunsetEnd,
    )) {
      return _SkyPhase.sunset;
    }

    /*
     * Regular evening/night.
     */
    if (now.isBefore(
      lateNightStart,
    )) {
      return _SkyPhase.night;
    }

    return _SkyPhase.lateNight;
  }
}

class _SkyPalette {
  const _SkyPalette({
    required this.background,
    required this.stops,
    required this.celestialGlow,
    required this.celestialAlpha,
    required this.horizonGlow,
    required this.horizonAlpha,
    required this.sunsetBand,
    required this.starColor,
  });

  final List<Color> background;
  final List<double> stops;

  final Color celestialGlow;
  final double celestialAlpha;

  final Color horizonGlow;
  final double horizonAlpha;

  final Color sunsetBand;
  final Color starColor;
}

class _StarFieldPainter
    extends CustomPainter {
  const _StarFieldPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final random =
        math.Random(42);

    for (var i = 0; i < 48; i++) {
      final x =
          random.nextDouble() *
              size.width;

      final y =
          random.nextDouble() *
              size.height *
              0.66;

      final radius =
          0.55 +
              random.nextDouble() *
                  1.25;

      final phase =
          random.nextDouble() *
              math.pi *
              2;

      final brightness =
          0.35 +
              0.65 *
                  ((math.sin(
                                progress *
                                        math.pi *
                                        2 +
                                    phase,
                              ) +
                              1) /
                          2);

      final paint =
          Paint()
            ..color =
                color.withValues(
              alpha:
                  brightness,
            );

      canvas.drawCircle(
        Offset(
          x,
          y,
        ),
        radius,
        paint,
      );

      if (radius > 1.45) {
        final flarePaint =
            Paint()
              ..strokeWidth =
                  0.45
              ..strokeCap =
                  StrokeCap.round
              ..color =
                  color.withValues(
                alpha:
                    brightness *
                        0.45,
              );

        canvas.drawLine(
          Offset(
            x - 2.2,
            y,
          ),
          Offset(
            x + 2.2,
            y,
          ),
          flarePaint,
        );

        canvas.drawLine(
          Offset(
            x,
            y - 2.2,
          ),
          Offset(
            x,
            y + 2.2,
          ),
          flarePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(
    covariant _StarFieldPainter
        oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.color !=
            color;
  }
}