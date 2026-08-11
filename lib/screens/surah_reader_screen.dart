import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_ayah.dart';
import '../models/quran_surah.dart';
import '../services/quran_text_service.dart';

class SurahReaderScreen extends StatefulWidget {
  const SurahReaderScreen({
    required this.surah,
    super.key,
  });

  final QuranSurah surah;

  @override
  State<SurahReaderScreen> createState() =>
      _SurahReaderScreenState();
}

class _SurahReaderScreenState
    extends State<SurahReaderScreen> {
  late final Future<List<QuranAyah>> _ayahsFuture;

  @override
  void initState() {
    super.initState();

    const quranTextService = QuranTextService();

    _ayahsFuture = quranTextService.loadSurahAyahs(
      widget.surah.number,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surah.englishName,
        ),
      ),
      body: FutureBuilder<List<QuranAyah>>(
        future: _ayahsFuture,
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
                      'Unable to load Qur’an text.',
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

          final ayahs =
              snapshot.data ?? const <QuranAyah>[];

          return ListView(
            padding: const EdgeInsets.all(
              AppSpacing.lg,
            ),
            children: [
              _SurahHeader(
                surah: widget.surah,
              ),

              const SizedBox(
                height: AppSpacing.xl,
              ),

              ...ayahs.map(
                (ayah) {
                  return _AyahCard(
                    ayah: ayah,
                  );
                },
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              Center(
                child: Text(
                  'Qur’an text source: Tanzil',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({
    required this.surah,
  });

  final QuranSurah surah;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          surah.arabicName,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          surah.englishName,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),

        const SizedBox(
          height: AppSpacing.xs,
        ),

        Text(
          '${surah.translatedName} • '
          '${surah.revelationType} • '
          '${surah.ayahCount} Ayahs',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(
                color: Colors.black54,
              ),
        ),
      ],
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({
    required this.ayah,
  });

  final QuranAyah ayah;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: AppSpacing.md,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  child: Text(
                    ayah.ayahNumber.toString(),
                  ),
                ),

                const Spacer(),

                IconButton(
                  tooltip: 'Bookmark',
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Bookmarks will be added next.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.bookmark_border,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: AppSpacing.md,
            ),

            SelectableText(
              ayah.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 26,
                height: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}