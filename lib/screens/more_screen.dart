import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../widgets/ilm_card.dart';
import 'islamic_calendar_screen.dart';
import 'qibla_finder_screen.dart';
import 'tafsir_library_screen.dart';
import 'tasbih_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({required this.onOpenDuas, super.key});

  final VoidCallback onOpenDuas;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature section is coming next.')));
  }

  void _openTasbih(BuildContext context) {
    Navigator.of(
      context,
    ).push(premiumRoute(builder: (_) => const TasbihScreen()));
  }

  void _openIslamicCalendar(BuildContext context) {
    Navigator.of(
      context,
    ).push(premiumRoute(builder: (_) => const IslamicCalendarScreen()));
  }

  void _openQiblaFinder(BuildContext context) {
    Navigator.of(
      context,
    ).push(premiumRoute(builder: (_) => const QiblaFinderScreen()));
  }

  void _openTafsir(BuildContext context) {
    Navigator.of(
      context,
    ).push(premiumRoute(builder: (_) => const TafsirLibraryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Text(
              'More',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            Text(
              'Islamic tools for your everyday journey.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            _MoreTile(
              icon: Icons.explore_rounded,
              title: 'Qibla Finder',
              subtitle: 'Find the direction of the Kaaba from your location',
              badge: 'New',
              onTap: () {
                _openQiblaFinder(context);
              },
            ),

            _MoreTile(
              icon: Icons.favorite_rounded,
              title: 'Duas & Adhkar',
              subtitle: 'Daily duas and remembrance',
              onTap: onOpenDuas,
            ),

            _MoreTile(
              icon: Icons.touch_app_rounded,
              title: 'Tasbih',
              subtitle: 'Animated dhikr counter with haptic feedback',
              onTap: () {
                _openTasbih(context);
              },
            ),

            _MoreTile(
              icon: Icons.calendar_month_rounded,
              title: 'Islamic Calendar',
              subtitle: 'Hijri calendar, occasions and live countdowns',
              badge: 'New',
              onTap: () {
                _openIslamicCalendar(context);
              },
            ),

            _MoreTile(
              icon: Icons.auto_stories_rounded,
              title: 'Tafsir',
              subtitle: 'Tafsir Ibn Kathir, Surah by Surah and Ayah by Ayah',
              badge: 'New',
              onTap: () {
                _openTafsir(context);
              },
            ),

            _MoreTile(
              icon: Icons.school_rounded,
              title: 'Hifz',
              subtitle: 'Memorization and revision tools',
              onTap: () {
                _showComingSoon(context, 'Hifz');
              },
            ),

            _MoreTile(
              icon: Icons.settings_rounded,
              title: 'Settings',
              subtitle: 'Language, appearance and preferences',
              onTap: () {
                _showComingSoon(context, 'Settings');
              },
            ),
          ],
        ),
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
    this.badge,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: IlmCard(
        onTap: onTap,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: colorScheme.primary, size: 24),
            ),

            const SizedBox(width: AppSpacing.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      if (badge != null) ...[
                        const SizedBox(width: AppSpacing.sm),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badge!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
