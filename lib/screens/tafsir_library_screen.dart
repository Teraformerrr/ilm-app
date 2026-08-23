import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../models/quran_ayah.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../models/tafsir_saved_item.dart';
import '../services/quran_metadata_service.dart';
import '../services/quran_text_service.dart';
import '../services/quran_translation_service.dart';
import '../services/tafsir_history_service.dart';
import '../widgets/ilm_card.dart';
import 'tafsir_ayah_list_screen.dart';
import 'tafsir_screen.dart';

class TafsirLibraryScreen extends StatefulWidget {
  const TafsirLibraryScreen({super.key});

  @override
  State<TafsirLibraryScreen> createState() => _TafsirLibraryScreenState();
}

class _TafsirLibraryScreenState extends State<TafsirLibraryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _animationController;

  late Future<List<QuranSurah>> _surahsFuture;

  List<TafsirSavedItem> _recent = <TafsirSavedItem>[];

  List<TafsirSavedItem> _bookmarks = <TafsirSavedItem>[];

  bool _historyLoading = true;

  String _query = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _surahsFuture = _loadSurahs();

    _loadHistory();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  Future<List<QuranSurah>> _loadSurahs() {
    const service = QuranMetadataService();

    return service.loadSurahs();
  }

  Future<void> _loadHistory() async {
    const service = TafsirHistoryService();

    final results = await Future.wait([
      service.loadRecent(),
      service.loadBookmarks(),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _recent = results[0];

      _bookmarks = results[1];

      _historyLoading = false;
    });
  }

  void _retry() {
    setState(() {
      _surahsFuture = _loadSurahs();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  List<QuranSurah> _filteredSurahs(List<QuranSurah> surahs) {
    final query = _query.trim().toLowerCase();

    if (query.isEmpty) {
      return surahs;
    }

    return surahs.where((surah) {
      return surah.number.toString() == query ||
          surah.englishName.toLowerCase().contains(query) ||
          surah.translatedName.toLowerCase().contains(query) ||
          surah.arabicName.contains(_query.trim());
    }).toList();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
    });
  }

  Future<void> _openSurah(QuranSurah surah) async {
    await Navigator.of(
      context,
    ).push(premiumRoute(builder: (_) => TafsirAyahListScreen(surah: surah)));

    await _loadHistory();
  }

  Future<void> _openSavedItem(TafsirSavedItem item) async {
    try {
      const metadataService = QuranMetadataService();

      const textService = QuranTextService();

      const translationService = QuranTranslationService();

      final surahs = await metadataService.loadSurahs();

      QuranSurah? surah;

      for (final candidate in surahs) {
        if (candidate.number == item.surahNumber) {
          surah = candidate;
          break;
        }
      }

      if (surah == null) {
        throw Exception('Surah not found.');
      }

      final ayahs = await textService.loadSurahAyahs(item.surahNumber);

      final translations = await translationService.loadSurahTranslations(
        item.surahNumber,
      );

      QuranAyah? ayah;
      QuranTranslation? translation;

      for (final candidate in ayahs) {
        if (candidate.ayahNumber == item.ayahNumber) {
          ayah = candidate;
          break;
        }
      }

      for (final candidate in translations) {
        if (candidate.ayahNumber == item.ayahNumber) {
          translation = candidate;
          break;
        }
      }

      if (ayah == null || translation == null) {
        throw Exception('Ayah data not found.');
      }

      if (!mounted) {
        return;
      }

      await Navigator.of(context).push(
        premiumRoute(
          builder: (_) => TafsirScreen(
            surah: surah!,
            ayah: ayah!,
            englishTranslation: translation!,
          ),
        ),
      );

      await _loadHistory();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Unable to open Tafsir: $error')));
    }
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
                    colorScheme.primaryContainer.withValues(alpha: 0.26),
                    colorScheme.surfaceContainerLowest,
                    colorScheme.surfaceContainerLowest,
                  ],
                  stops: const [0, 0.28, 1],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<List<QuranSurah>>(
              future: _surahsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const _LoadingView();
                }

                if (snapshot.hasError) {
                  return _ErrorView(error: snapshot.error, onRetry: _retry);
                }

                final allSurahs = snapshot.data ?? const <QuranSurah>[];

                final surahs = _filteredSurahs(allSurahs);

                return CustomScrollView(
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
                          _Header(totalSurahs: allSurahs.length),

                          const SizedBox(height: AppSpacing.xl),

                          _HeroCard(surahCount: allSurahs.length),

                          if (!_historyLoading &&
                              (_recent.isNotEmpty ||
                                  _bookmarks.isNotEmpty)) ...[
                            const SizedBox(height: AppSpacing.xl),

                            if (_bookmarks.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.bookmark_rounded,
                                title: 'Bookmarks',
                                count: _bookmarks.length,
                              ),

                              const SizedBox(height: AppSpacing.sm),

                              _SavedItemsRow(
                                items: _bookmarks,
                                onTap: _openSavedItem,
                              ),
                            ],

                            if (_bookmarks.isNotEmpty && _recent.isNotEmpty)
                              const SizedBox(height: AppSpacing.xl),

                            if (_recent.isNotEmpty) ...[
                              _SectionTitle(
                                icon: Icons.history_rounded,
                                title: 'Recently Viewed',
                                count: _recent.length,
                              ),

                              const SizedBox(height: AppSpacing.sm),

                              _SavedItemsRow(
                                items: _recent.take(8).toList(),
                                onTap: _openSavedItem,
                              ),
                            ],
                          ],

                          const SizedBox(height: AppSpacing.xl),

                          TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _query = value;
                              });
                            },
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: 'Search Surah or number',
                              prefixIcon: const Icon(Icons.search_rounded),
                              suffixIcon: _query.isEmpty
                                  ? null
                                  : IconButton(
                                      tooltip: 'Clear search',
                                      onPressed: _clearSearch,
                                      icon: const Icon(Icons.close_rounded),
                                    ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          Text(
                            'All Surahs',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: AppSpacing.md),

                          if (surahs.isEmpty)
                            _NoResultsView(query: _query)
                          else
                            ...surahs.map((surah) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _SurahCard(
                                  surah: surah,
                                  onTap: () {
                                    _openSurah(surah);
                                  },
                                ),
                              );
                            }),
                        ]),
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
  const _Header({required this.totalSurahs});

  final int totalSurahs;

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
                'Understand the Qur’an through authentic commentary',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$totalSurahs',
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.surahCount});

  final int surahCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.78),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 34),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Tafsir Ibn Kathir',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Explore commentary for all $surahCount Surahs, Ayah by Ayah.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),

        const SizedBox(width: AppSpacing.sm),

        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),

        Text(
          '$count',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SavedItemsRow extends StatelessWidget {
  const _SavedItemsRow({required this.items, required this.onTap});

  final List<TafsirSavedItem> items;

  final ValueChanged<TafsirSavedItem> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) {
          return const SizedBox(width: AppSpacing.sm);
        },
        itemBuilder: (context, index) {
          final item = items[index];

          return SizedBox(
            width: 190,
            child: IlmCard(
              onTap: () {
                onTap(item);
              },
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.surahName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${item.surahNumber}:${item.ayahNumber}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    'Open Tafsir',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  const _SurahCard({required this.surah, required this.onTap});

  final QuranSurah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return IlmCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              surah.number.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.englishName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${surah.translatedName} • '
                  '${surah.ayahCount} Ayahs',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15,
            color: colorScheme.onSurfaceVariant,
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
    return const Center(child: CircularProgressIndicator());
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(onPressed: onRetry, child: const Text('Try Again')),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Center(
        child: Text(
          query.trim().isEmpty
              ? 'No Surahs found.'
              : 'No results for "$query".',
        ),
      ),
    );
  }
}
