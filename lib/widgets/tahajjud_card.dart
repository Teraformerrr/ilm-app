import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_spacing.dart';
import '../services/tahajjud_service.dart';
import 'ilm_card.dart';

class TahajjudCard extends StatelessWidget {
  const TahajjudCard({
    required this.window,
    super.key,
  });

  final TahajjudWindow window;

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

  @override
  Widget build(BuildContext context) {
    return IlmCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.bedtime_outlined,
                size: 22,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Tahajjud',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _TimeRow(
            label: 'Islamic Midnight',
            time: _formatTime(window.islamicMidnight),
          ),
          const SizedBox(height: AppSpacing.md),
          _TimeRow(
            label: 'Last Third Begins',
            time: _formatTime(window.lastThirdStart),
            highlighted: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _TimeRow(
            label: 'Fajr',
            time: _formatTime(window.fajr),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'The last third is calculated from Maghrib until the following Fajr.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.time,
    this.highlighted = false,
  });

  final String label;
  final String time;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final color = highlighted
        ? Theme.of(context).colorScheme.primary
        : null;

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight:
                      highlighted ? FontWeight.w700 : FontWeight.w400,
                  color: color,
                ),
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
        ),
      ],
    );
  }
}