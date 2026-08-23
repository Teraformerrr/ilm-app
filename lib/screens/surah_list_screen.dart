import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../models/quran_surah.dart';
import '../widgets/ilm_card.dart';
import 'surah_reader_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({
    required this.surahs,
    super.key,
  });

  final List<QuranSurah> surahs;

  @override
  State<SurahListScreen> createState() =>
      _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController =
      TextEditingController();

  late final AnimationController _animationController;

  String _query = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _animationController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  List<QuranSurah> get _filteredSurahs {
    final query =
        _query.trim().toLowerCase();

    if (query.isEmpty) {
      return widget.surahs;
    }

    return widget.surahs.where(
      (surah) {
        return surah.number.toString() == query ||
            surah.englishName.toLowerCase().contains(
                  query,
                ) ||
            surah.translatedName.toLowerCase().contains(
                  query,
                ) ||
            surah.arabicName.contains(
              _query.trim(),
            );
      },
    ).toList();
  }

  void _clearSearch() {
    _searchController.clear();

    setState(() {
      _query = '';
    });
  }

  Future<void> _openSurah(
    QuranSurah surah,
  ) async {
    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) => SurahReaderScreen(
          surah: surah,
        ),
      ),
    );
  }

  Animation<double> _animationFor(
    double start,
    double end,
  ) {
    return CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        start,
        end,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  Widget _animatedSection({
    required Widget child,
    required double start,
    required double end,
    double verticalOffset = 16,
  }) {
    final animation =
        _animationFor(
      start,
      end,
    );

    return FadeTransition(
      opacity: animation,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (
          context,
          child,
        ) {
          return Transform.translate(
            offset: Offset(
              0,
              verticalOffset *
                  (1 - animation.value),
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final surahs =
        _filteredSurahs;

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
                    colorScheme.primaryContainer.withValues(
                      alpha: 0.22,
                    ),
                    colorScheme.surfaceContainerLowest,
                    colorScheme.surfaceContainerLowest,
                  ],
                  stops: const [
                    0,
                    0.24,
                    1,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.sm,
                  ),
                  child: _animatedSection(
                    start: 0,
                    end: 0.28,
                    verticalOffset: 10,
                    child: _SurahListHeader(
                      totalSurahs:
                          widget.surahs.length,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: _animatedSection(
                    start: 0.08,
                    end: 0.38,
                    child: TextField(
                      controller:
                          _searchController,
                      onChanged: (value) {
                        setState(() {
                          _query = value;
                        });
                      },
                      textInputAction:
                          TextInputAction.search,
                      decoration: InputDecoration(
                        hintText:
                            'Search by Surah name or number',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                        ),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip:
                                    'Clear search',
                                onPressed:
                                    _clearSearch,
                                icon: const Icon(
                                  Icons.close_rounded,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 260,
                    ),
                    switchInCurve:
                        Curves.easeOutCubic,
                    switchOutCurve:
                        Curves.easeInCubic,
                    child: surahs.isEmpty
                        ? _NoResultsView(
                            key: const ValueKey(
                              'empty',
                            ),
                            query:
                                _searchController.text,
                          )
                        : ListView.separated(
                            key: ValueKey(
                              'list-${surahs.length}-$_query',
                            ),
                            physics:
                                const BouncingScrollPhysics(),
                            padding:
                                const EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              0,
                              AppSpacing.lg,
                              AppSpacing.xl,
                            ),
                            itemCount:
                                surahs.length,
                            separatorBuilder: (
                              _,
                              _,
                            ) =>
                                const SizedBox(
                              height: AppSpacing.sm,
                            ),
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              final surah =
                                  surahs[index];

                              final start =
                                  (0.16 +
                                          (index * 0.018))
                                      .clamp(
                                0.16,
                                0.72,
                              );

                              final end =
                                  (start + 0.22).clamp(
                                0.38,
                                0.98,
                              );

                              return _animatedSection(
                                start:
                                    start.toDouble(),
                                end:
                                    end.toDouble(),
                                verticalOffset: 12,
                                child: _SurahCard(
                                  surah: surah,
                                  onTap: () {
                                    _openSurah(
                                      surah,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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

class _SurahListHeader extends StatelessWidget {
  const _SurahListHeader({
    required this.totalSurahs,
  });

  final int totalSurahs;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        IconButton(
          tooltip:
              'Back',
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),

        const SizedBox(
          width: AppSpacing.sm,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'All Surahs',
                style: theme
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing:
                      -0.8,
                ),
              ),

              const SizedBox(
                height: 3,
              ),

              Text(
                '$totalSurahs chapters of the Noble Qur’an',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: colorScheme
                      .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration:
              BoxDecoration(
            color: colorScheme
                .primaryContainer,
            borderRadius:
                BorderRadius.circular(
              999,
            ),
          ),
          child: Text(
            '$totalSurahs',
            style: theme
                .textTheme
                .labelLarge
                ?.copyWith(
              color:
                  colorScheme.primary,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _SurahCard extends StatelessWidget {
  const _SurahCard({
    required this.surah,
    required this.onTap,
  });

  final QuranSurah surah;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return IlmCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration:
                BoxDecoration(
              color: colorScheme
                  .primaryContainer,
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child: Text(
              surah.number.toString(),
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                color:
                    colorScheme.primary,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  surah.englishName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing:
                        -0.2,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  surah.translatedName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color: colorScheme
                        .onSurfaceVariant,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _MetaChip(
                      label:
                          surah.revelationType,
                    ),
                    _MetaChip(
                      label:
                          '${surah.ayahCount} Ayahs',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(
            width: AppSpacing.md,
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                surah.arabicName,
                textDirection:
                    TextDirection.rtl,
                style: theme
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  color:
                      colorScheme.primary,
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme
                    .onSurfaceVariant
                    .withValues(
                  alpha: 0.65,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration:
          BoxDecoration(
        color: colorScheme
            .surfaceContainerLow,
        borderRadius:
            BorderRadius.circular(
          999,
        ),
      ),
      child: Text(
        label,
        style: theme
            .textTheme
            .labelSmall
            ?.copyWith(
          color: colorScheme
              .onSurfaceVariant,
          fontWeight:
              FontWeight.w600,
        ),
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView({
    required this.query,
    super.key,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration:
                  BoxDecoration(
                color: colorScheme
                    .primaryContainer,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              child: Icon(
                Icons
                    .search_off_rounded,
                size: 34,
                color:
                    colorScheme.primary,
              ),
            ),

            const SizedBox(
              height: AppSpacing.lg,
            ),

            Text(
              'No Surahs found',
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height: AppSpacing.sm,
            ),

            Text(
              query.trim().isEmpty
                  ? 'Try another search.'
                  : 'No results for "$query".',
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme
                    .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}