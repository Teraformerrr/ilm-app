import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../models/quran_reading_position.dart';
import '../models/quran_surah.dart';
import '../services/quran_metadata_service.dart';
import '../services/quran_reading_position_service.dart';
import '../widgets/ilm_card.dart';
import 'quran_bookmarks_screen.dart';
import 'surah_list_screen.dart';
import 'surah_reader_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({
    super.key,
  });

  @override
  State<QuranScreen> createState() =>
      _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen>
    with SingleTickerProviderStateMixin {
  late final Future<List<QuranSurah>>
      _surahsFuture;

  late final AnimationController
      _animationController;

  QuranReadingPosition? _readingPosition;

  bool _isLoadingReadingPosition =
      true;

  @override
  void initState() {
    super.initState();

    const metadataService =
        QuranMetadataService();

    _surahsFuture =
        metadataService.loadSurahs();

    _animationController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 950,
      ),
    );

    _loadReadingPosition();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (mounted) {
          _animationController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadReadingPosition() async {
    const service =
        QuranReadingPositionService();

    final position =
        await service.loadPosition();

    if (!mounted) {
      return;
    }

    setState(() {
      _readingPosition =
          position;

      _isLoadingReadingPosition =
          false;
    });
  }

  Future<void> _openSurahs(
    List<QuranSurah> surahs,
  ) async {
    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) =>
            SurahListScreen(
          surahs: surahs,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadReadingPosition();
  }

  Future<void> _openBookmarks() async {
    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) =>
            const QuranBookmarksScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadReadingPosition();
  }

  Future<void> _continueReading(
    List<QuranSurah> surahs,
  ) async {
    final position =
        _readingPosition;

    if (position == null) {
      return;
    }

    QuranSurah? targetSurah;

    for (final surah in surahs) {
      if (surah.number ==
          position.surahNumber) {
        targetSurah =
            surah;

        break;
      }
    }

    if (targetSurah == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to find your saved Qur’an position.',
          ),
        ),
      );

      return;
    }

    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) =>
            SurahReaderScreen(
          surah:
              targetSurah!,
          initialAyahNumber:
              position.ayahNumber,
        ),
      ),
    );

    if (!mounted) {
      return;
    }

    await _loadReadingPosition();
  }

  Animation<double> _animationFor(
    double start,
    double end,
  ) {
    return CurvedAnimation(
      parent:
          _animationController,
      curve: Interval(
        start,
        end,
        curve:
            Curves.easeOutCubic,
      ),
    );
  }

  Widget _animatedSection({
    required Widget child,
    required double start,
    required double end,
    double offset = 18,
  }) {
    final animation =
        _animationFor(
      start,
      end,
    );

    return FadeTransition(
      opacity:
          animation,
      child: AnimatedBuilder(
        animation:
            animation,
        child:
            child,
        builder: (
          context,
          child,
        ) {
          return Transform.translate(
            offset: Offset(
              0,
              offset *
                  (1 -
                      animation.value),
            ),
            child:
                child,
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

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  begin:
                      Alignment.topCenter,
                  end:
                      Alignment.bottomCenter,
                  colors: [
                    colorScheme
                        .primaryContainer
                        .withValues(
                      alpha: 0.28,
                    ),
                    colorScheme
                        .surfaceContainerLowest,
                    colorScheme
                        .surfaceContainerLowest,
                  ],
                  stops: const [
                    0,
                    0.28,
                    1,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<
                List<QuranSurah>>(
              future:
                  _surahsFuture,
              builder: (
                context,
                snapshot,
              ) {
                if (snapshot
                        .connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return _ErrorView(
                    error:
                        snapshot.error,
                  );
                }

                final surahs =
                    snapshot.data ??
                        const <
                            QuranSurah>[];

                return ListView(
                  physics:
                      const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    AppSpacing.xl,
                  ),
                  children: [
                    _animatedSection(
                      start:
                          0.00,
                      end:
                          0.28,
                      offset:
                          12,
                      child:
                          const _QuranHeader(),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),

                    _animatedSection(
                      start:
                          0.10,
                      end:
                          0.42,
                      child:
                          _ContinueReadingCard(
                        position:
                            _readingPosition,
                        loading:
                            _isLoadingReadingPosition,
                        onTap: _readingPosition ==
                                    null ||
                                _isLoadingReadingPosition
                            ? null
                            : () {
                                _continueReading(
                                  surahs,
                                );
                              },
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),

                    _animatedSection(
                      start:
                          0.20,
                      end:
                          0.50,
                      offset:
                          14,
                      child:
                          _SectionHeader(
                        title:
                            'Explore Qur’an',
                        trailing:
                            '${surahs.length} Surahs',
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.md,
                    ),

                    _animatedSection(
                      start:
                          0.27,
                      end:
                          0.58,
                      child:
                          _QuranFeatureCard(
                        icon:
                            Icons.menu_book_rounded,
                        title:
                            'All Surahs',
                        subtitle:
                            'Browse the complete Qur’an by Surah',
                        onTap: () {
                          _openSurahs(
                            surahs,
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.md,
                    ),

                    _animatedSection(
                      start:
                          0.34,
                      end:
                          0.65,
                      child:
                          _QuranFeatureCard(
                        icon:
                            Icons.bookmark_rounded,
                        title:
                            'Bookmarks',
                        subtitle:
                            'Return to saved Ayahs and reading positions',
                        onTap:
                            _openBookmarks,
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),

                    _animatedSection(
                      start:
                          0.42,
                      end:
                          0.73,
                      child:
                          const _SourceInformationCard(),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.xl,
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

class _QuranHeader
    extends StatelessWidget {
  const _QuranHeader();

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width:
                  48,
              height:
                  48,
              decoration:
                  BoxDecoration(
                color:
                    colorScheme
                        .primary,
                borderRadius:
                    BorderRadius.circular(
                  16,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        colorScheme
                            .primary
                            .withValues(
                      alpha:
                          0.20,
                    ),
                    blurRadius:
                        22,
                    offset:
                        const Offset(
                      0,
                      8,
                    ),
                  ),
                ],
              ),
              child:
                  Icon(
                Icons
                    .menu_book_rounded,
                color:
                    colorScheme
                        .onPrimary,
                size:
                    24,
              ),
            ),

            const SizedBox(
              width:
                  AppSpacing.md,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Qur’an',
                    style: theme
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontWeight:
                          FontWeight
                              .w800,
                      letterSpacing:
                          -0.8,
                    ),
                  ),

                  const SizedBox(
                    height: 2,
                  ),

                  Text(
                    'القرآن الكريم',
                    style: theme
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color:
                          colorScheme
                              .primary,
                      fontWeight:
                          FontWeight
                              .w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(
          height:
              AppSpacing.lg,
        ),

        Text(
          'Read, reflect and continue your journey through the Noble Qur’an.',
          style:
              theme
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
            color:
                colorScheme
                    .onSurfaceVariant,
            height:
                1.5,
          ),
        ),
      ],
    );
  }
}

class _ContinueReadingCard
    extends StatelessWidget {
  const _ContinueReadingCard({
    required this.position,
    required this.loading,
    required this.onTap,
  });

  final QuranReadingPosition? position;
  final bool loading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final hasPosition =
        position != null;

    return GestureDetector(
      onTap:
          onTap,
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 300,
        ),
        curve:
            Curves.easeOutCubic,
        width:
            double.infinity,
        padding:
            const EdgeInsets.all(
          AppSpacing.lg,
        ),
        decoration:
            BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment.topLeft,
            end:
                Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              colorScheme.primary
                  .withValues(
                alpha:
                    0.86,
              ),
            ],
          ),
          borderRadius:
              BorderRadius.circular(
            26,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  colorScheme.primary
                      .withValues(
                alpha:
                    0.20,
              ),
              blurRadius:
                  28,
              offset:
                  const Offset(
                0,
                12,
              ),
            ),
          ],
        ),
        child:
            Stack(
          children: [
            Positioned(
              top:
                  -42,
              right:
                  -34,
              child:
                  Container(
                width:
                    130,
                height:
                    130,
                decoration:
                    BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color:
                      Colors.white
                          .withValues(
                    alpha:
                        0.07,
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width:
                          40,
                      height:
                          40,
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white
                                .withValues(
                          alpha:
                              0.14,
                        ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          13,
                        ),
                      ),
                      child:
                          const Icon(
                        Icons
                            .history_rounded,
                        color:
                            Colors.white,
                        size:
                            21,
                      ),
                    ),

                    const SizedBox(
                      width:
                          AppSpacing.sm,
                    ),

                    Expanded(
                      child:
                          Text(
                        'Continue Reading',
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color:
                              Colors.white,
                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ),

                    if (hasPosition)
                      const Icon(
                        Icons
                            .arrow_forward_rounded,
                        color:
                            Colors.white,
                      ),
                  ],
                ),

                const SizedBox(
                  height:
                      AppSpacing.xl,
                ),

                if (loading)
                  Container(
                    width:
                        180,
                    height:
                        28,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white
                              .withValues(
                        alpha:
                            0.16,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  )
                else if (!hasPosition)
                  Text(
                    'Start reading any Surah and ILM will remember where you stopped.',
                    style: theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color:
                          Colors.white
                              .withValues(
                        alpha:
                            0.88,
                      ),
                      height:
                          1.5,
                    ),
                  )
                else ...[
                  Text(
                    position!.surahName,
                    style: theme
                        .textTheme
                        .headlineSmall
                        ?.copyWith(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight
                              .w800,
                      letterSpacing:
                          -0.5,
                    ),
                  ),

                  const SizedBox(
                    height:
                        AppSpacing.xs,
                  ),

                  Text(
                    'Ayah ${position!.ayahNumber}',
                    style: theme
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                      color:
                          Colors.white
                              .withValues(
                        alpha:
                            0.82,
                      ),
                      fontWeight:
                          FontWeight
                              .w600,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader
    extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.trailing,
  });

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    return Row(
      children: [
        Expanded(
          child:
              Text(
            title,
            style: theme
                .textTheme
                .titleLarge
                ?.copyWith(
              fontWeight:
                  FontWeight.w800,
              letterSpacing:
                  -0.4,
            ),
          ),
        ),

        Text(
          trailing,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color:
                theme
                    .colorScheme
                    .primary,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QuranFeatureCard
    extends StatelessWidget {
  const _QuranFeatureCard({
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
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return IlmCard(
      onTap:
          onTap,
      child:
          Row(
        children: [
          Container(
            width:
                52,
            height:
                52,
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .primaryContainer,
              borderRadius:
                  BorderRadius.circular(
                17,
              ),
            ),
            child:
                Icon(
              icon,
              color:
                  colorScheme.primary,
              size:
                  25,
            ),
          ),

          const SizedBox(
            width:
                AppSpacing.md,
          ),

          Expanded(
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height:
                      4,
                ),

                Text(
                  subtitle,
                  style: theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                    color:
                        colorScheme
                            .onSurfaceVariant,
                    height:
                        1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            width:
                AppSpacing.sm,
          ),

          Icon(
            Icons
                .arrow_forward_ios_rounded,
            size:
                17,
            color:
                colorScheme
                    .onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _SourceInformationCard
    extends StatelessWidget {
  const _SourceInformationCard();

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration:
          BoxDecoration(
        color:
            colorScheme
                .surfaceContainerLow
                .withValues(
          alpha:
              0.72,
        ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              colorScheme
                  .outlineVariant
                  .withValues(
            alpha:
                0.60,
          ),
        ),
      ),
      child:
          Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons
                .verified_outlined,
            size:
                20,
            color:
                colorScheme.primary,
          ),

          const SizedBox(
            width:
                AppSpacing.sm,
          ),

          Expanded(
            child:
                Text(
              'Qur’an text source: Tanzil. English translation: Marmaduke Pickthall. Urdu translation: Muhammad Junagarhi / QuranEnc.',
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                    colorScheme
                        .onSurfaceVariant,
                height:
                    1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView
    extends StatelessWidget {
  const _ErrorView({
    required this.error,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Center(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child:
            Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Container(
              width:
                  72,
              height:
                  72,
              decoration:
                  BoxDecoration(
                color:
                    colorScheme
                        .errorContainer,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
              ),
              child:
                  Icon(
                Icons
                    .error_outline_rounded,
                size:
                    34,
                color:
                    colorScheme.error,
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.lg,
            ),

            Text(
              'Unable to load Qur’an',
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),

            const SizedBox(
              height:
                  AppSpacing.sm,
            ),

            Text(
              'Please try again.',
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                    colorScheme
                        .onSurfaceVariant,
              ),
            ),

            if (error != null) ...[
              const SizedBox(
                height:
                    AppSpacing.sm,
              ),

              Text(
                error.toString(),
                textAlign:
                    TextAlign.center,
                style: theme
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color:
                      colorScheme
                          .onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}