import 'package:flutter/material.dart';

import '../core/app_spacing.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    required this.onOpenDreamInterpretation,
    required this.onOpenDuas,
    super.key,
  });

  final VoidCallback onOpenDreamInterpretation;
  final VoidCallback onOpenDuas;

  void _showComingSoon(
    BuildContext context,
    String feature,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature section is coming next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'Explore More',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Additional Islamic tools and learning resources.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _MoreTile(
            icon: Icons.nights_stay_outlined,
            title: 'Dream Interpretation',
            subtitle: 'Source-based Islamic dream guidance',
            onTap: onOpenDreamInterpretation,
          ),

          _MoreTile(
            icon: Icons.favorite_border,
            title: 'Duas & Adhkar',
            subtitle: 'Daily duas and remembrance',
            onTap: onOpenDuas,
          ),

          _MoreTile(
            icon: Icons.touch_app_outlined,
            title: 'Tasbih',
            subtitle: 'Digital dhikr counter',
            onTap: () {
              _showComingSoon(
                context,
                'Tasbih',
              );
            },
          ),

          _MoreTile(
            icon: Icons.calendar_month_outlined,
            title: 'Islamic Calendar',
            subtitle: 'Hijri dates and important occasions',
            onTap: () {
              _showComingSoon(
                context,
                'Islamic Calendar',
              );
            },
          ),

          _MoreTile(
            icon: Icons.auto_stories_outlined,
            title: 'Tafsir',
            subtitle: 'Qur’an explanation and commentary',
            onTap: () {
              _showComingSoon(
                context,
                'Tafsir',
              );
            },
          ),

          _MoreTile(
            icon: Icons.school_outlined,
            title: 'Hifz',
            subtitle: 'Memorization and revision tools',
            onTap: () {
              _showComingSoon(
                context,
                'Hifz',
              );
            },
          ),

          _MoreTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Language, appearance and preferences',
            onTap: () {
              _showComingSoon(
                context,
                'Settings',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.chevron_right,
        ),
        onTap: onTap,
      ),
    );
  }
}