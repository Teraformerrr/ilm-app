import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../models/quran_ayah.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../services/quran_text_service.dart';
import '../services/quran_translation_service.dart';
import '../widgets/ilm_card.dart';
import 'tafsir_screen.dart';

class TafsirAyahListScreen extends StatefulWidget {
  const TafsirAyahListScreen({required this.surah, super.key});

  final QuranSurah surah;

  @override
  State<TafsirAyahListScreen> createState() => _TafsirAyahListScreenState();
}

class _TafsirAyahListScreenState extends State<TafsirAyahListScreen> {
  late final Future<_AyahData> _dataFuture;

  @override
  void initState() {
    super.initState();

    _dataFuture = _loadData();
  }

  Future<_AyahData> _loadData() async {
    const textService = QuranTextService();

    const translationService = QuranTranslationService();

    final results = await Future.wait([
      textService.loadSurahAyahs(widget.surah.number),
      translationService.loadSurahTranslations(widget.surah.number),
    ]);

    final ayahs = results[0] as List<QuranAyah>;

    final translations = results[1] as List<QuranTranslation>;

    if (ayahs.length != translations.length) {
      throw const FormatException('Ayah and translation counts do not match.');
    }

    for (var i = 0; i < ayahs.length; i++) {
      if (ayahs[i].ayahNumber != translations[i].ayahNumber) {
        throw FormatException('Ayah mapping mismatch at index $i.');
      }
    }

    return _AyahData(ayahs: ayahs, translations: translations);
  }

  Future<void> _openTafsir({
    required QuranAyah ayah,
    required QuranTranslation translation,
  }) async {
    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) {
          return TafsirScreen(
            surah: widget.surah,
            ayah: ayah,
            englishTranslation: translation,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.22),
                    colorScheme.surfaceContainerLowest,
                    colorScheme.surfaceContainerLowest,
                  ],
                  stops: const [0, 0.26, 1],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<_AyahData>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _LoadingView();
                }

                if (snapshot.hasError) {
                  return _ErrorView(error: snapshot.error);
                }

                final data = snapshot.data;

                if (data == null || data.ayahs.isEmpty) {
                  return const _ErrorView(error: 'No Ayahs found.');
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        AppSpacing.md,
                        AppSpacing.lg,
                        AppSpacing.md,
                      ),
                      child: _Header(surah: widget.surah),
                    ),

                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.sm,
                          AppSpacing.lg,
                          AppSpacing.xl,
                        ),
                        itemCount: data.ayahs.length,
                        separatorBuilder: (_, _) {
                          return const SizedBox(height: AppSpacing.sm);
                        },
                        itemBuilder: (context, index) {
                          final ayah = data.ayahs[index];

                          final translation = data.translations[index];

                          return _AyahCard(
                            ayah: ayah,
                            translation: translation,
                            onTap: () {
                              _openTafsir(ayah: ayah, translation: translation);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.surah});

  final QuranSurah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        IconButton(
          tooltip: 'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                surah.englishName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Choose an Ayah for Tafsir • '
                '${surah.ayahCount} Ayahs',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Text(
          surah.arabicName,
          textDirection: TextDirection.rtl,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
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
    required this.onTap,
  });

  final QuranAyah ayah;
  final QuranTranslation translation;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                ),
                child: Text(
                  ayah.ayahNumber.toString(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const Spacer(),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Read Tafsir',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(width: 5),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            ayah.arabicText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              height: 1.8,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Divider(color: colorScheme.outlineVariant),

          const SizedBox(height: AppSpacing.sm),

          Text(
            translation.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: IconButton(
              tooltip: 'Back',
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
        ),

        const Expanded(child: Center(child: CircularProgressIndicator())),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: theme.colorScheme.primary,
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              'Unable to load Ayahs',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              error?.toString() ?? 'Unknown error.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahData {
  const _AyahData({required this.ayahs, required this.translations});

  final List<QuranAyah> ayahs;

  final List<QuranTranslation> translations;
}
