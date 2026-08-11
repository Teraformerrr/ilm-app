import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_surah.dart';
import '../services/quran_metadata_service.dart';
import 'surah_list_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late final Future<List<QuranSurah>> _surahsFuture;

  @override
  void initState() {
    super.initState();

    const metadataService = QuranMetadataService();

    _surahsFuture = metadataService.loadSurahs();
  }

  void _openSurahs(
    List<QuranSurah> surahs,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahListScreen(
          surahs: surahs,
        ),
      ),
    );
  }

  void _showComingSoon(
    String feature,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature is coming next.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qur’an'),
      ),
      body: FutureBuilder<List<QuranSurah>>(
        future: _surahsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                    ),
                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                    const Text(
                      'Unable to load Qur’an metadata.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: AppSpacing.sm,
                    ),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          final surahs =
              snapshot.data ?? const <QuranSurah>[];

          return ListView(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            children: [
              Text(
                'The Noble Qur’an',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight:
                          FontWeight.w700,
                    ),
              ),

              const SizedBox(
                height: AppSpacing.xs,
              ),

              Text(
                'Read, listen, translate and continue where you left off.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color: Colors.black54,
                    ),
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.menu_book_outlined,
                  ),
                  title: const Text(
                    'Surahs',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'Browse all ${surahs.length} Surahs',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _openSurahs(
                      surahs,
                    );
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.bookmark_outline,
                  ),
                  title: const Text(
                    'Bookmarks',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Saved Ayahs and reading positions',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _showComingSoon(
                      'Bookmarks',
                    );
                  },
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.history,
                  ),
                  title: const Text(
                    'Continue Reading',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'Resume your last Qur’an session',
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                  onTap: () {
                    _showComingSoon(
                      'Continue Reading',
                    );
                  },
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              Text(
                'Qur’an metadata source: Tanzil.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          );
        },
      ),
    );
  }
}