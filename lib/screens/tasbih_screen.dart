import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_spacing.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({
    super.key,
  });

  @override
  State<TasbihScreen> createState() =>
      _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with TickerProviderStateMixin {
  late final AnimationController _tapController;
  late final AnimationController _completionController;
  late final AnimationController _entranceController;

  int _count = 0;
  int _target = 33;
  int _completedRounds = 0;

  bool _hapticsEnabled = true;
  bool _showCompletion = false;

  @override
  void initState() {
    super.initState();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 170,
      ),
    );

    _completionController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 700,
      ),
    );

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 850,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _entranceController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _tapController.dispose();
    _completionController.dispose();
    _entranceController.dispose();

    super.dispose();
  }

  double get _progress {
    if (_target <= 0) {
      return 0;
    }

    return (_count / _target).clamp(
      0.0,
      1.0,
    );
  }

  void _increment() {
    if (_showCompletion) {
      return;
    }

    final newCount = _count + 1;

    setState(() {
      _count = newCount;
    });

    _tapController.forward(
      from: 0,
    );

    if (newCount >= _target) {
      _completeRound();
      return;
    }

    if (_hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  Future<void> _completeRound() async {
    setState(() {
      _showCompletion = true;
      _completedRounds++;
    });

    _completionController.forward(
      from: 0,
    );

    if (_hapticsEnabled) {
      await HapticFeedback.heavyImpact();

      await Future<void>.delayed(
        const Duration(
          milliseconds: 120,
        ),
      );

      if (mounted) {
        await HapticFeedback.mediumImpact();
      }
    }

    await Future<void>.delayed(
      const Duration(
        milliseconds: 850,
      ),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _count = 0;
      _showCompletion = false;
    });
  }

  Future<void> _reset() async {
    if (_count == 0) {
      return;
    }

    final shouldReset =
        await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (
        sheetContext,
      ) {
        final theme =
            Theme.of(sheetContext);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset counter?',
                  style: theme
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.sm,
                ),

                Text(
                  'Your current count of $_count will return to zero.',
                  style: theme
                      .textTheme
                      .bodyLarge
                      ?.copyWith(
                    color: theme
                        .colorScheme
                        .onSurfaceVariant,
                  ),
                ),

                const SizedBox(
                  height: AppSpacing.lg,
                ),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(
                            sheetContext,
                          ).pop(
                            false,
                          );
                        },
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: AppSpacing.sm,
                    ),

                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(
                            sheetContext,
                          ).pop(
                            true,
                          );
                        },
                        child: const Text(
                          'Reset',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldReset != true ||
        !mounted) {
      return;
    }

    setState(() {
      _count = 0;
      _showCompletion = false;
    });

    if (_hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _chooseTarget() async {
    int? customValue;

    final selected =
        await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (
        sheetContext,
      ) {
        final customController =
            TextEditingController();

        return StatefulBuilder(
          builder: (
            context,
            setSheetState,
          ) {
            final theme =
                Theme.of(context);

            final colorScheme =
                theme.colorScheme;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                MediaQuery.of(context)
                        .viewInsets
                        .bottom +
                    AppSpacing.lg,
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set Target',
                        style: theme
                            .textTheme
                            .titleLarge
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),

                      const SizedBox(
                        height: AppSpacing.xs,
                      ),

                      Text(
                        'Choose a preset or enter your own target.',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(
                        height: AppSpacing.lg,
                      ),

                      Wrap(
                        spacing:
                            AppSpacing.sm,
                        runSpacing:
                            AppSpacing.sm,
                        children: [
                          33,
                          34,
                          99,
                          100,
                          500,
                          1000,
                        ].map(
                          (
                            target,
                          ) {
                            return ChoiceChip(
                              label: Text(
                                '$target',
                              ),
                              selected:
                                  target ==
                                      _target,
                              onSelected: (
                                _,
                              ) {
                                Navigator.of(
                                  sheetContext,
                                ).pop(
                                  target,
                                );
                              },
                            );
                          },
                        ).toList(),
                      ),

                      const SizedBox(
                        height: AppSpacing.xl,
                      ),

                      Text(
                        'Custom target',
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: AppSpacing.sm,
                      ),

                      TextField(
                        controller:
                            customController,
                        keyboardType:
                            TextInputType.number,
                        textInputAction:
                            TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly,
                          LengthLimitingTextInputFormatter(
                            7,
                          ),
                        ],
                        decoration:
                            const InputDecoration(
                          hintText:
                              'Example: 58',
                          prefixIcon:
                              Icon(
                            Icons.flag_outlined,
                          ),
                        ),
                        onChanged: (
                          value,
                        ) {
                          setSheetState(
                            () {
                              final parsed =
                                  int.tryParse(
                                value,
                              );

                              if (parsed !=
                                      null &&
                                  parsed >
                                      0) {
                                customValue =
                                    parsed;
                              } else {
                                customValue =
                                    null;
                              }
                            },
                          );
                        },
                        onSubmitted: (
                          _,
                        ) {
                          final value =
                              customValue;

                          if (value ==
                              null) {
                            return;
                          }

                          Navigator.of(
                            sheetContext,
                          ).pop(
                            value,
                          );
                        },
                      ),

                      const SizedBox(
                        height: AppSpacing.md,
                      ),

                      SizedBox(
                        width: double.infinity,
                        child:
                            FilledButton.icon(
                          onPressed:
                              customValue ==
                                      null
                                  ? null
                                  : () {
                                      Navigator.of(
                                        sheetContext,
                                      ).pop(
                                        customValue,
                                      );
                                    },
                          icon:
                              const Icon(
                            Icons.check_rounded,
                          ),
                          label:
                              const Text(
                            'Set Custom Target',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    if (!mounted ||
        selected == null) {
      return;
    }

    _setTarget(
      selected,
    );
  }

  void _setTarget(
    int target,
  ) {
    if (target <= 0) {
      return;
    }

    setState(() {
      _target = target;
      _count = 0;
      _completedRounds = 0;
      _showCompletion = false;
    });

    if (_hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  Animation<double> _entranceAnimation(
    double start,
    double end,
  ) {
    return CurvedAnimation(
      parent:
          _entranceController,
      curve: Interval(
        start,
        end,
        curve:
            Curves.easeOutCubic,
      ),
    );
  }

  Widget _entrance({
    required Widget child,
    required double start,
    required double end,
    double offset = 18,
  }) {
    final animation =
        _entranceAnimation(
      start,
      end,
    );

    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (
          context,
          child,
        ) {
          return Transform.translate(
            offset: Offset(
              0,
              offset *
                  (1 -
                      animation.value),
            ),
            child: child,
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

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,
                  colors: [
                    colorScheme
                        .primaryContainer
                        .withValues(
                      alpha:
                          0.34,
                    ),
                    colorScheme
                        .surfaceContainerLowest,
                    colorScheme
                        .surfaceContainerLowest,
                  ],
                  stops:
                      const [
                    0,
                    0.34,
                    1,
                  ],
                ),
              ),
            ),
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
              child: Column(
                children: [
                  _entrance(
                    start: 0,
                    end: 0.28,
                    offset: 10,
                    child:
                        _TasbihHeader(
                      hapticsEnabled:
                          _hapticsEnabled,
                      onHapticsChanged:
                          (
                        value,
                      ) {
                        setState(() {
                          _hapticsEnabled =
                              value;
                        });

                        if (value) {
                          HapticFeedback
                              .selectionClick();
                        }
                      },
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),

                  _entrance(
                    start:
                        0.08,
                    end:
                        0.45,
                    offset:
                        22,
                    child:
                        _TasbihCounter(
                      count:
                          _count,
                      target:
                          _target,
                      progress:
                          _progress,
                      completed:
                          _showCompletion,
                      tapController:
                          _tapController,
                      completionController:
                          _completionController,
                      onTap:
                          _increment,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),

                  _entrance(
                    start:
                        0.20,
                    end:
                        0.56,
                    child:
                        _ProgressInformation(
                      count:
                          _count,
                      target:
                          _target,
                      rounds:
                          _completedRounds,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.lg,
                  ),

                  _entrance(
                    start:
                        0.30,
                    end:
                        0.66,
                    child: Row(
                      children: [
                        Expanded(
                          child:
                              _ActionButton(
                            icon:
                                Icons
                                    .flag_outlined,
                            label:
                                'Target',
                            onTap:
                                _chooseTarget,
                          ),
                        ),

                        const SizedBox(
                          width:
                              AppSpacing.md,
                        ),

                        Expanded(
                          child:
                              _ActionButton(
                            icon:
                                Icons
                                    .restart_alt_rounded,
                            label:
                                'Reset',
                            onTap:
                                _reset,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xl,
                  ),

                  _entrance(
                    start:
                        0.40,
                    end:
                        0.76,
                    child: Text(
                      'Tap the counter to count. Your device will give stronger feedback when the target is reached.',
                      textAlign:
                          TextAlign.center,
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
          ),
        ],
      ),
    );
  }
}

class _TasbihHeader
    extends StatelessWidget {
  const _TasbihHeader({
    required this.hapticsEnabled,
    required this.onHapticsChanged,
  });

  final bool hapticsEnabled;
  final ValueChanged<bool>
      onHapticsChanged;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip:
              'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons
                .arrow_back_ios_new_rounded,
          ),
        ),

        const SizedBox(
          width:
              AppSpacing.sm,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Tasbih',
                style: theme
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing:
                      -0.8,
                ),
              ),

              Text(
                'Digital dhikr counter',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: theme
                      .colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        IconButton(
          tooltip: hapticsEnabled
              ? 'Disable haptics'
              : 'Enable haptics',
          onPressed: () {
            onHapticsChanged(
              !hapticsEnabled,
            );
          },
          icon: AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds: 200,
            ),
            child: Icon(
              hapticsEnabled
                  ? Icons
                      .vibration_rounded
                  : Icons
                      .notifications_off_outlined,
              key: ValueKey(
                hapticsEnabled,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TasbihCounter
    extends StatelessWidget {
  const _TasbihCounter({
    required this.count,
    required this.target,
    required this.progress,
    required this.completed,
    required this.tapController,
    required this.completionController,
    required this.onTap,
  });

  final int count;
  final int target;
  final double progress;
  final bool completed;

  final AnimationController
      tapController;

  final AnimationController
      completionController;

  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return AnimatedBuilder(
      animation:
          Listenable.merge(
        [
          tapController,
          completionController,
        ],
      ),
      builder: (
        context,
        child,
      ) {
        final tapWave =
            math.sin(
          tapController.value *
              math.pi,
        );

        final completionWave =
            math.sin(
          completionController.value *
              math.pi,
        );

        final scale =
            1 -
                (tapWave *
                    0.025) +
                (completionWave *
                    0.03);

        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: GestureDetector(
        behavior:
            HitTestBehavior.opaque,
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment:
                Alignment.center,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter:
                      _ProgressRingPainter(
                    progress:
                        progress,
                    trackColor:
                        colorScheme
                            .primary
                            .withValues(
                      alpha:
                          0.10,
                    ),
                    progressColor:
                        colorScheme
                            .primary,
                  ),
                ),
              ),

              FractionallySizedBox(
                widthFactor:
                    0.82,
                heightFactor:
                    0.82,
                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds: 250,
                  ),
                  decoration:
                      BoxDecoration(
                    shape:
                        BoxShape.circle,
                    gradient:
                        RadialGradient(
                      colors: [
                        colorScheme
                            .surface,
                        colorScheme
                            .primaryContainer
                            .withValues(
                          alpha:
                              0.45,
                        ),
                      ],
                    ),
                    border:
                        Border.all(
                      color:
                          colorScheme
                              .primary
                              .withValues(
                        alpha:
                            0.14 +
                                (progress *
                                    0.12),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            colorScheme
                                .primary
                                .withValues(
                          alpha:
                              0.08 +
                                  (progress *
                                      0.12),
                        ),
                        blurRadius:
                            42 +
                                (progress *
                                    18),
                        spreadRadius:
                            -8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration:
                            const Duration(
                          milliseconds: 220,
                        ),
                        transitionBuilder:
                            (
                          child,
                          animation,
                        ) {
                          return FadeTransition(
                            opacity:
                                animation,
                            child:
                                ScaleTransition(
                              scale:
                                  animation,
                              child:
                                  child,
                            ),
                          );
                        },
                        child: completed
                            ? Icon(
                                Icons
                                    .check_rounded,
                                key:
                                    const ValueKey(
                                  'complete',
                                ),
                                size:
                                    72,
                                color:
                                    colorScheme
                                        .primary,
                              )
                            : Text(
                                '$count',
                                key:
                                    ValueKey(
                                  count,
                                ),
                                style: theme
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                  color:
                                      colorScheme
                                          .primary,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  letterSpacing:
                                      -2,
                                ),
                              ),
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.sm,
                      ),

                      Text(
                        completed
                            ? 'Target reached'
                            : 'Tap to count',
                        style: theme
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                          color:
                              colorScheme
                                  .onSurfaceVariant,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),

                      const SizedBox(
                        height:
                            AppSpacing.xs,
                      ),

                      Text(
                        '$count / $target',
                        style: theme
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          color:
                              colorScheme.primary,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressInformation
    extends StatelessWidget {
  const _ProgressInformation({
    required this.count,
    required this.target,
    required this.rounds,
  });

  final int count;
  final int target;
  final int rounds;

  @override
  Widget build(
    BuildContext context,
  ) {
    final progress =
        target <= 0
            ? 0.0
            : (count / target).clamp(
                0.0,
                1.0,
              );

    final percentage =
        (progress * 100).round();

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Progress',
            value:
                '$percentage%',
          ),
        ),

        const SizedBox(
          width:
              AppSpacing.sm,
        ),

        Expanded(
          child: _StatCard(
            label: 'Target',
            value:
                '$target',
          ),
        ),

        const SizedBox(
          width:
              AppSpacing.sm,
        ),

        Expanded(
          child: _StatCard(
            label: 'Rounds',
            value:
                '$rounds',
          ),
        ),
      ],
    );
  }
}

class _StatCard
    extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.sm,
        vertical:
            AppSpacing.md,
      ),
      decoration:
          BoxDecoration(
        color:
            theme.colorScheme.surface
                .withValues(
          alpha:
              0.86,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              theme
                  .colorScheme
                  .outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const SizedBox(
            height: 3,
          ),

          Text(
            label,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color: theme
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton
    extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal:
              AppSpacing.sm,
          vertical:
              AppSpacing.md,
        ),
        decoration:
            BoxDecoration(
          color:
              theme.colorScheme.surface,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border:
              Border.all(
            color:
                theme
                    .colorScheme
                    .outlineVariant,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color:
                  theme
                      .colorScheme
                      .primary,
            ),

            const SizedBox(
              height:
                  AppSpacing.xs,
            ),

            Text(
              label,
              style: theme
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter
    extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    const strokeWidth =
        10.0;

    final center =
        Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(
              size.width,
              size.height,
            ) /
            2 -
        strokeWidth;

    final rect =
        Rect.fromCircle(
      center: center,
      radius: radius,
    );

    final trackPaint =
        Paint()
          ..color =
              trackColor
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              strokeWidth
          ..strokeCap =
              StrokeCap.round;

    final progressPaint =
        Paint()
          ..color =
              progressColor
          ..style =
              PaintingStyle.stroke
          ..strokeWidth =
              strokeWidth
          ..strokeCap =
              StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2,
      false,
      trackPaint,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi *
          2 *
          progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ProgressRingPainter
        oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.trackColor !=
            trackColor ||
        oldDelegate.progressColor !=
            progressColor;
  }
}