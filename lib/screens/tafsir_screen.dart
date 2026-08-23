import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_ayah.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../models/tafsir_entry.dart';
import '../services/tafsir_history_service.dart';
import '../services/tafsir_service.dart';
import '../widgets/ilm_card.dart';

class TafsirScreen extends StatefulWidget {
  const TafsirScreen({
    required this.surah,
    required this.ayah,
    required this.englishTranslation,
    super.key,
  });

  final QuranSurah surah;
  final QuranAyah ayah;
  final QuranTranslation englishTranslation;

  @override
  State<TafsirScreen> createState() => _TafsirScreenState();
}

class _TafsirScreenState extends State<TafsirScreen> {
  late Future<TafsirEntry?> _tafsirFuture;

  bool _isBookmarked = false;
  bool _bookmarkLoading = true;

  @override
  void initState() {
    super.initState();

    _tafsirFuture = _loadTafsir();

    _loadBookmarkState();
  }

  Future<void> _loadBookmarkState() async {
    const service = TafsirHistoryService();

    final bookmarked = await service.isBookmarked(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayah.ayahNumber,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isBookmarked = bookmarked;

      _bookmarkLoading = false;
    });
  }

  Future<TafsirEntry?> _loadTafsir() async {
    const service = TafsirService();

    final tafsir = await service.loadIbnKathirAyah(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayah.ayahNumber,
    );

    if (tafsir != null) {
      const history = TafsirHistoryService();

      await history.addRecent(
        surahNumber: widget.surah.number,
        ayahNumber: widget.ayah.ayahNumber,
        surahName: widget.surah.englishName,
      );
    }

    return tafsir;
  }

  void _retry() {
    setState(() {
      _tafsirFuture = _loadTafsir();
    });
  }

  Future<void> _toggleBookmark() async {
    if (_bookmarkLoading) {
      return;
    }

    setState(() {
      _bookmarkLoading = true;
    });

    const service = TafsirHistoryService();

    final bookmarked = await service.toggleBookmark(
      surahNumber: widget.surah.number,
      ayahNumber: widget.ayah.ayahNumber,
      surahName: widget.surah.englishName,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isBookmarked = bookmarked;

      _bookmarkLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          bookmarked ? 'Tafsir bookmarked.' : 'Tafsir bookmark removed.',
        ),
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
                    colorScheme.primaryContainer.withValues(alpha: 0.25),
                    colorScheme.surface,
                    colorScheme.surface,
                  ],
                  stops: const [0, 0.28, 1],
                ),
              ),
            ),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _TafsirHeader(
                        surah: widget.surah,
                        ayahNumber: widget.ayah.ayahNumber,
                        isBookmarked: _isBookmarked,
                        bookmarkLoading: _bookmarkLoading,
                        onBookmark: _toggleBookmark,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      _AyahPreviewCard(
                        ayah: widget.ayah,
                        translation: widget.englishTranslation,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      FutureBuilder<TafsirEntry?>(
                        future: _tafsirFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState !=
                              ConnectionState.done) {
                            return const _TafsirLoadingCard();
                          }

                          if (snapshot.hasError) {
                            return _TafsirErrorCard(
                              error: snapshot.error,
                              onRetry: _retry,
                            );
                          }

                          final tafsir = snapshot.data;

                          if (tafsir == null) {
                            return const _NoTafsirCard();
                          }

                          return _TafsirContentCard(tafsir: tafsir);
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      const _SourceNotice(),

                      const SizedBox(height: AppSpacing.xl),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirHeader extends StatelessWidget {
  const _TafsirHeader({
    required this.surah,
    required this.ayahNumber,
    required this.isBookmarked,
    required this.bookmarkLoading,
    required this.onBookmark,
  });

  final QuranSurah surah;
  final int ayahNumber;

  final bool isBookmarked;
  final bool bookmarkLoading;

  final VoidCallback onBookmark;

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
                'Tafsir',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
              ),

              Text(
                '${surah.englishName} • '
                '$ayahNumber',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          decoration: BoxDecoration(
            color: isBookmarked
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            tooltip: isBookmarked
                ? 'Remove Tafsir bookmark'
                : 'Bookmark Tafsir',
            onPressed: bookmarkLoading ? null : onBookmark,
            icon: bookmarkLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.primary,
                    ),
                  )
                : Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: colorScheme.primary,
                  ),
          ),
        ),
      ],
    );
  }
}

class _AyahPreviewCard extends StatelessWidget {
  const _AyahPreviewCard({required this.ayah, required this.translation});

  final QuranAyah ayah;
  final QuranTranslation translation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
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

              const SizedBox(width: AppSpacing.sm),

              Text(
                'Ayah',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          SelectableText(
            ayah.arabicText,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.headlineSmall?.copyWith(
              height: 2,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Divider(color: colorScheme.outlineVariant),

          const SizedBox(height: AppSpacing.md),

          SelectableText(
            translation.text,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Marmaduke Pickthall',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirContentCard extends StatelessWidget {
  const _TafsirContentCard({required this.tafsir});

  final TafsirEntry tafsir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 21,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tafsir.sourceName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    Text(
                      'Tafsir • ${tafsir.reference}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          SelectableText(
            tafsir.text,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.75),
          ),
        ],
      ),
    );
  }
}

class _TafsirLoadingCard extends StatelessWidget {
  const _TafsirLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const IlmCard(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _NoTafsirCard extends StatelessWidget {
  const _NoTafsirCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 46,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Tafsir unavailable for this Ayah',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TafsirErrorCard extends StatelessWidget {
  const _TafsirErrorCard({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 46,
            color: colorScheme.primary,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            'Unable to load Tafsir',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            error?.toString() ?? 'Unknown error.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

class _SourceNotice extends StatelessWidget {
  const _SourceNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_outlined, size: 20, color: colorScheme.primary),

          const SizedBox(width: AppSpacing.sm),

          Expanded(
            child: Text(
              'ILM displays Tafsir with its source clearly identified. '
              'Tafsir text is kept separate from the Qur’an itself.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
