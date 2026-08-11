import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_ayah.dart';
import '../models/quran_reader_preferences.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../services/quran_reader_preferences_service.dart';
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

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  late final Future<List<QuranAyah>> _ayahsFuture;
  late final Future<List<QuranTranslation>> _translationsFuture;

  QuranReaderPreferences _readerPreferences =
      const QuranReaderPreferences();

  bool _isLoadingPreferences = true;

  @override
  void initState() {
    super.initState();

    const quranTextService = QuranTextService();
    const translationService = QuranTranslationService();

    _ayahsFuture = quranTextService.loadSurahAyahs(
      widget.surah.number,
    );

    _translationsFuture =
        translationService.loadSurahTranslations(
      widget.surah.number,
    );

    _loadReaderPreferences();
  }

  Future<void> _loadReaderPreferences() async {
    const service = QuranReaderPreferencesService();

    final preferences = await service.loadPreferences();

    if (!mounted) return;

    setState(() {
      _readerPreferences = preferences;
      _isLoadingPreferences = false;
    });
  }

  Future<void> _setShowEnglish(bool value) async {
    const service = QuranReaderPreferencesService();

    await service.saveShowEnglish(value);

    if (!mounted) return;

    setState(() {
      _readerPreferences =
          _readerPreferences.copyWith(
        showEnglish: value,
      );
    });
  }

  Future<void> _setArabicFontSize(double value) async {
    const service = QuranReaderPreferencesService();

    await service.saveArabicFontSize(value);

    if (!mounted) return;

    setState(() {
      _readerPreferences =
          _readerPreferences.copyWith(
        arabicFontSize: value,
      );
    });
  }

  Future<void> _setEnglishFontSize(double value) async {
    const service = QuranReaderPreferencesService();

    await service.saveEnglishFontSize(value);

    if (!mounted) return;

    setState(() {
      _readerPreferences =
          _readerPreferences.copyWith(
        englishFontSize: value,
      );
    });
  }

  Future<void> _openReaderSettings() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reader Options',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w700,
                          ),
                    ),

                    const SizedBox(
                      height: AppSpacing.lg,
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'English Translation',
                      ),
                      subtitle: const Text(
                        'Show Marmaduke Pickthall translation.',
                      ),
                      value:
                          _readerPreferences.showEnglish,
                      onChanged: (value) async {
                        await _setShowEnglish(value);

                        setModalState(() {});
                      },
                    ),

                    const Divider(),

                    Text(
                      'Arabic Font Size',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ),
                    ),

                    Slider(
                      value:
                          _readerPreferences.arabicFontSize,
                      min: 20,
                      max: 40,
                      divisions: 10,
                      label: _readerPreferences
                          .arabicFontSize
                          .round()
                          .toString(),
                      onChanged: (value) async {
                        await _setArabicFontSize(value);

                        setModalState(() {});
                      },
                    ),

                    Text(
                      '${_readerPreferences.arabicFontSize.round()}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    const SizedBox(
                      height: AppSpacing.md,
                    ),

                    Text(
                      'English Font Size',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight:
                                FontWeight.w600,
                          ),
                    ),

                    Slider(
                      value:
                          _readerPreferences.englishFontSize,
                      min: 12,
                      max: 26,
                      divisions: 14,
                      label: _readerPreferences
                          .englishFontSize
                          .round()
                          .toString(),
                      onChanged: _readerPreferences.showEnglish
                          ? (value) async {
                              await _setEnglishFontSize(
                                value,
                              );

                              setModalState(() {});
                            }
                          : null,
                    ),

                    Text(
                      '${_readerPreferences.englishFontSize.round()}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall,
                    ),

                    const SizedBox(
                      height: AppSpacing.md,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surah.englishName,
        ),
        actions: [
          IconButton(
            tooltip: 'Reader Options',
            onPressed: _openReaderSettings,
            icon: const Icon(
              Icons.tune,
            ),
          ),
        ],
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

          return FutureBuilder<List<QuranTranslation>>(
            future: _translationsFuture,
            builder: (
              context,
              translationSnapshot,
            ) {
              if (translationSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (translationSnapshot.hasError) {
                return _ErrorView(
                  message:
                      'Unable to load English translation.',
                  error: translationSnapshot.error,
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
                      final ayah = ayahs[index];
                      final translation =
                          translations[index];

                      if (ayah.ayahNumber !=
                          translation.ayahNumber) {
                        return const _ErrorView(
                          message:
                              'Qur’an Ayah and translation mapping mismatch.',
                        );
                      }

                      return _AyahCard(
                        ayah: ayah,
                        translation: translation,
                        preferences:
                            _readerPreferences,
                      );
                    },
                  ),

                  const SizedBox(
                    height: AppSpacing.lg,
                  ),

                  Center(
                    child: Text(
                      'Qur’an text: Tanzil • English: Marmaduke Pickthall',
                      textAlign: TextAlign.center,
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
    required this.translation,
    required this.preferences,
  });

  final QuranAyah ayah;
  final QuranTranslation translation;
  final QuranReaderPreferences preferences;

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
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize:
                    preferences.arabicFontSize,
                height: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (preferences.showEnglish) ...[
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
                style: TextStyle(
                  fontSize:
                      preferences.englishFontSize,
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
                      color: Colors.black54,
                    ),
              ),
            ],
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
              textAlign: TextAlign.center,
            ),
            if (error != null) ...[
              const SizedBox(
                height: AppSpacing.sm,
              ),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}