import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_spacing.dart';
import '../models/prayer_time.dart';
import 'prayer_countdown.dart';

class PrayerStatusCard extends StatefulWidget {
  const PrayerStatusCard({
    required this.prayer,
    required this.statusText,
    super.key,
  });

  final PrayerTime prayer;
  final String statusText;

  @override
  State<PrayerStatusCard> createState() =>
      _PrayerStatusCardState();
}

class _PrayerStatusCardState
    extends State<PrayerStatusCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 700,
      ),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scale = Tween<double>(
      begin: 0.985,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _controller.forward();
        }
      },
    );
  }

  @override
  void didUpdateWidget(
    covariant PrayerStatusCard oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.prayer.name !=
            widget.prayer.name ||
        oldWidget.prayer.time !=
            widget.prayer.time) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final fardRakah =
        widget.prayer.fardRakah;

    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient:
                AppColors.premiumGreenGradient,
            borderRadius:
                BorderRadius.circular(
              AppRadius.lg,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(
                  alpha: 0.20,
                ),
                blurRadius: 28,
                offset:
                    const Offset(
                  0,
                  12,
                ),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -34,
                top: -38,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                        .withValues(
                      alpha: 0.06,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: -22,
                bottom: -42,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white
                        .withValues(
                      alpha: 0.045,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.14,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              13,
                            ),
                          ),
                          child: const Icon(
                            Icons.mosque_rounded,
                            size: 21,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(
                          width: AppSpacing.sm,
                        ),

                        Expanded(
                          child: Text(
                            'Next Prayer',
                            style: theme
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.white
                                .withValues(
                              alpha: 0.12,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              AppRadius.pill,
                            ),
                          ),
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Icon(
                                Icons
                                    .location_on_outlined,
                                size: 14,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.92,
                                ),
                              ),

                              const SizedBox(
                                width: 4,
                              ),

                              Text(
                                'Local',
                                style: theme
                                    .textTheme
                                    .labelMedium
                                    ?.copyWith(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.92,
                                  ),
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: AppSpacing.xl,
                    ),

                    Text(
                      widget.prayer.name,
                      style: theme
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w800,
                        letterSpacing: -0.7,
                      ),
                    ),

                    const SizedBox(
                      height: AppSpacing.xs,
                    ),

                    Text(
                      _formatTime(
                        widget.prayer.time,
                      ),
                      style: theme
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                        color: Colors.white,
                        fontWeight:
                            FontWeight.w700,
                        letterSpacing: -1.0,
                      ),
                    ),

                    const SizedBox(
                      height: AppSpacing.lg,
                    ),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(
                        AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(
                          alpha: 0.11,
                        ),
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                        border: Border.all(
                          color: Colors.white
                              .withValues(
                            alpha: 0.10,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Time remaining',
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.78,
                              ),
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),

                          const SizedBox(
                            height: AppSpacing.xs,
                          ),

                          DefaultTextStyle.merge(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            child: IconTheme.merge(
                              data:
                                  const IconThemeData(
                                color: Colors.white,
                              ),
                              child: PrayerCountdown(
                                prayer:
                                    widget.prayer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (fardRakah != null) ...[
                      const SizedBox(
                        height: AppSpacing.md,
                      ),

                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          _PrayerBadge(
                            icon: Icons
                                .format_list_numbered_rounded,
                            label:
                                '$fardRakah Rak‘ah Fard',
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(
                      height: AppSpacing.md,
                    ),

                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          widget.statusText
                                  .toLowerCase()
                                  .contains(
                                    'loading',
                                  )
                              ? Icons
                                  .my_location_rounded
                              : Icons
                                  .location_on_outlined,
                          size: 16,
                          color: Colors.white
                              .withValues(
                            alpha: 0.80,
                          ),
                        ),

                        const SizedBox(
                          width: AppSpacing.xs,
                        ),

                        Expanded(
                          child: Text(
                            widget.statusText,
                            style: theme
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: Colors.white
                                  .withValues(
                                alpha: 0.78,
                              ),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(
    DateTime time,
  ) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
            ? time.hour - 12
            : time.hour;

    final minute =
        time.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final period =
        time.hour >= 12
            ? 'PM'
            : 'AM';

    return '$hour:$minute $period';
  }
}

class _PrayerBadge
    extends StatelessWidget {
  const _PrayerBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(
          AppRadius.pill,
        ),
        border: Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.10,
          ),
        ),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white
                .withValues(
              alpha: 0.92,
            ),
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(
              color: Colors.white,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}