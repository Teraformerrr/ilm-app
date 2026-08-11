import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_ayah.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../services/quran_text_service.dart';
import '../services/quran_translation_service.dart';

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
  late final Future<List<QuranTranslation>>
      _translationsFuture;

  @override
  void initState() {
    super.initState();

    const quranTextService = QuranTextService();
    const translationService =
        QuranTranslationService();

    _ayahsFuture =
        quranTextService.loadSurahAyahs(
      widget.surah.number,
    );

    _translationsFuture =
        translationService.loadSurahTranslations(
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
        builder: (context, ayahSnapshot) {
          if (ayahSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (ayahSnapshot.hasError) {
            return _ErrorView(
              message:
                  'Unable to load Qur’an text.',
              error: ayahSnapshot.error,
            );
          }

          return FutureBuilder<
              List<QuranTranslation>>(
            future: _translationsFuture,
            builder:
                (context, translationSnapshot) {
              if (translationSnapshot
                      .connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (translationSnapshot.hasError) {
                return _ErrorView(
                  message:
                      'Unable to load English translation.',
                  error:
                      translationSnapshot.error,
                );
              }

              final ayahs =
                  ayahSnapshot.data ??
                      const <QuranAyah>[];

              final translations =
                  translationSnapshot.data ??
                      const <QuranTranslation>[];

              if (ayahs.length !=
                  translations.length) {
                return const _ErrorView(
                  message:
                      'Qur’an text and translation counts do not match.',
                );
              }

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

                  ...List.generate(
                    ayahs.length,
                    (index) {
                      final ayah =
                          ayahs[index];

                      final translation =
                          translations[index];

                      if (ayah.ayahNumber !=
                          translation
                              .ayahNumber) {
                        return const _ErrorView(
                          message:
                              'Qur’an Ayah and translation mapping mismatch.',
                        );
                      }

                      return _AyahCard(
                        ayah: ayah,
                        translation:
                            translation,
                      );
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  Center(
                    child: Text(
                      'Qur’an text: Tanzil • English: Marmaduke Pickthall',
                      textAlign:
                          TextAlign.center,
                      style:
                          Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color:
                                    Colors.black54,
                              ),
                    ),
                  ),
                ],
              );
            },
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
                fontWeight:
                    FontWeight.w700,
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
                fontWeight:
                    FontWeight.w700,
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
    required this.translation,
  });

  final QuranAyah ayah;
  final QuranTranslation translation;

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
                    ayah.ayahNumber
                        .toString(),
                  ),
                ),

                const Spacer(),

                IconButton(
                  tooltip: 'Bookmark',
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Bookmarks will be added later.',
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
              textDirection:
                  TextDirection.rtl,
              style: const TextStyle(
                fontSize: 26,
                height: 2,
                fontWeight:
                    FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            const Divider(),

            const SizedBox(
              height: AppSpacing.md,
            ),

            Text(
              'English',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            SelectableText(
              translation.text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    height: 1.6,
                  ),
            ),

            const SizedBox(
              height: AppSpacing.xs,
            ),

            Text(
              'Marmaduke Pickthall',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        Colors.black54,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    this.error,
  });

  final String message;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),

            const SizedBox(
              height: AppSpacing.md,
            ),

            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),

            if (error != null) ...[
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Text(
                error.toString(),
                textAlign:
                    TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color:
                          Colors.black54,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}