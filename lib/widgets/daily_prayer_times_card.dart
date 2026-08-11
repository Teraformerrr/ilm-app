import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/prayer_time.dart';
import 'ilm_card.dart';

class DailyPrayerTimesCard extends StatelessWidget {
  const DailyPrayerTimesCard({
    required this.prayerTimes,
    required this.nextPrayer,
    super.key,
  });

  final List<PrayerTime> prayerTimes;
  final PrayerTime? nextPrayer;

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
            ? time.hour - 12
            : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  String _prayerName(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return 'Fajr';
      case PrayerType.sunrise:
        return 'Sunrise';
      case PrayerType.dhuhr:
        return 'Dhuhr';
      case PrayerType.asr:
        return 'Asr';
      case PrayerType.maghrib:
        return 'Maghrib';
      case PrayerType.isha:
        return 'Isha';
      case PrayerType.tahajjud:
        return 'Tahajjud';
    }
  }

  IconData _prayerIcon(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return Icons.nights_stay_outlined;
      case PrayerType.sunrise:
        return Icons.wb_twilight_outlined;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.light_mode_outlined;
      case PrayerType.maghrib:
        return Icons.wb_twilight_outlined;
      case PrayerType.isha:
        return Icons.dark_mode_outlined;
      case PrayerType.tahajjud:
        return Icons.bedtime_outlined;
    }
  }

  String _formatRakahBreakdown(PrayerTime prayer) {
    if (prayer.rakahBreakdown.isEmpty) {
      return '';
    }

    return prayer.rakahBreakdown
        .map(
          (part) => '${part.rakah} ${part.label}',
        )
        .join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return IlmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Prayer Times',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...prayerTimes.map(
            (prayer) {
              final isNextPrayer = nextPrayer?.type == prayer.type;
              final rakahText = _formatRakahBreakdown(prayer);

              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xs,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isNextPrayer
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(
                        _prayerIcon(prayer.type),
                        size: 20,
                        color: isNextPrayer
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _prayerName(prayer.type),
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: isNextPrayer
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isNextPrayer
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                ),
                          ),
                          if (rakahText.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              rakahText,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isNextPrayer
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.8)
                                        : Colors.black54,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _formatTime(prayer.time),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: isNextPrayer
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isNextPrayer
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}