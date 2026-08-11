import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_radius.dart';
import '../core/app_spacing.dart';
import '../models/prayer_time.dart';
import 'prayer_countdown.dart';

class PrayerStatusCard extends StatelessWidget {
  const PrayerStatusCard({
    required this.prayer,
    required this.statusText,
    super.key,
  });

  final PrayerTime prayer;
  final String statusText;

  @override
  Widget build(BuildContext context) {
    final fardRakah = prayer.fardRakah;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.22),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.mosque_outlined,
                size: 22,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Next Prayer',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            prayer.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            _formatTime(prayer.time),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (fardRakah != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                '$fardRakah Rak‘ah Fard',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          PrayerCountdown(
            prayer: prayer,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

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
}