import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../data/adhkar/adhkar_library.dart';
import '../data/dua_adhkar_categories.dart';
import '../data/evening_adhkar.dart';
import '../data/morning_adhkar.dart';
import '../models/dua_adhkar_category.dart';
import '../models/dua_adhkar_item.dart';
import '../widgets/ilm_card.dart';
import 'dua_category_reader_screen.dart';

class DuasAdhkarScreen extends StatefulWidget {
  const DuasAdhkarScreen({
    super.key,
  });

  @override
  State<DuasAdhkarScreen> createState() =>
      _DuasAdhkarScreenState();
}

class _DuasAdhkarScreenState
    extends State<DuasAdhkarScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 950,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        _animationController.forward();
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  List<DuaAdhkarCategory> get _filteredCategories {
    final query =
        _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return duaAdhkarCategories;
    }

    return duaAdhkarCategories.where(
      (
        category,
      ) {
        if (category.title
                .toLowerCase()
                .contains(query) ||
            category.subtitle
                .toLowerCase()
                .contains(query)) {
          return true;
        }

        final items =
            _itemsForCategory(
          category.id,
        );

        if (items == null ||
            items.isEmpty) {
          return false;
        }

        for (final item in items) {
          if (_itemMatchesSearch(
            item,
            query,
          )) {
            return true;
          }
        }

        return false;
      },
    ).toList();
  }

  List<DuaAdhkarCategory> get _featuredCategories {
    return duaAdhkarCategories.where(
      (
        category,
      ) {
        return category.featured;
      },
    ).toList();
  }

  bool _itemMatchesSearch(
    DuaAdhkarItem item,
    String query,
  ) {
    if (item.title
        .toLowerCase()
        .contains(query)) {
      return true;
    }

    if (item.transliteration
        .toLowerCase()
        .contains(query)) {
      return true;
    }

    if (item.englishTranslation
        .toLowerCase()
        .contains(query)) {
      return true;
    }

    if (item.reference
        .toLowerCase()
        .contains(query)) {
      return true;
    }

    if (item.categoryId
        .toLowerCase()
        .contains(query)) {
      return true;
    }

    for (final title
        in item.alternateTitles) {
      if (title
          .toLowerCase()
          .contains(query)) {
        return true;
      }
    }

    for (final tag in item.tags) {
      if (tag
          .toLowerCase()
          .contains(query)) {
        return true;
      }
    }

    final originalQuery =
        _searchQuery.trim();

    if (originalQuery.isNotEmpty &&
        item.arabic.contains(
          originalQuery,
        )) {
      return true;
    }

    if (originalQuery.isNotEmpty &&
        item.hasUrduTranslation &&
        item.urduTranslation!.contains(
          originalQuery,
        )) {
      return true;
    }

    return false;
  }

  DuaAdhkarCategory? _findCategory(
    String id,
  ) {
    final normalized =
        id.trim().toLowerCase();

    for (final category
        in duaAdhkarCategories) {
      if (category.id
              .trim()
              .toLowerCase() ==
          normalized) {
        return category;
      }
    }

    return null;
  }

  List<DuaAdhkarItem>? _itemsForCategory(
    String categoryId,
  ) {
    final id =
        categoryId
            .trim()
            .toLowerCase();

    switch (id) {
      /*
       * Existing dedicated collections.
       *
       * We keep these for now because your
       * complete Morning and Evening data
       * currently live outside /data/adhkar/.
       */
      case 'morning':
      case 'morning_adhkar':
        return morningAdhkar;

      case 'evening':
      case 'evening_adhkar':
        return eveningAdhkar;

      /*
       * Daily journey.
       */
      case 'waking':
      case 'wake_up':
      case 'wakeup':
      case 'after_waking':
        return AdhkarLibrary.byCategory(
          'waking',
        );

      case 'sleep':
      case 'sleeping':
      case 'before_sleep':
      case 'bedtime':
        return AdhkarLibrary.byCategory(
          'sleep',
        );

      case 'food':
      case 'food_drink':
      case 'food_and_drink':
      case 'eating':
        return AdhkarLibrary.byCategory(
          'food',
        );

      case 'home':
      case 'house':
        return AdhkarLibrary.byCategory(
          'home',
        );

      /*
       * Purification & mosque.
       */
      case 'restroom':
      case 'bathroom':
      case 'toilet':
        return AdhkarLibrary.byCategory(
          'restroom',
        );

      case 'wudu':
      case 'ablution':
        return AdhkarLibrary.byCategory(
          'wudu',
        );

      case 'mosque':
      case 'masjid':
        return AdhkarLibrary.byCategory(
          'mosque',
        );

      /*
       * Travel & weather.
       */
      case 'travel':
      case 'journey':
        return AdhkarLibrary.byCategory(
          'travel',
        );

      case 'weather':
      case 'rain':
        return AdhkarLibrary.byCategory(
          'weather',
        );

      /*
       * Protection & healing.
       */
      case 'protection':
        return AdhkarLibrary
            .protectionItems;

      case 'ruqyah':
        return AdhkarLibrary
            .ruqyahItems;

      case 'illness':
      case 'healing':
      case 'illness_healing':
      case 'health':
        return AdhkarLibrary.byCategory(
          'illness_healing',
        );

      /*
       * Emotional distress.
       */
      case 'distress':
      case 'anxiety':
      case 'anxiety_distress':
      case 'grief':
        return AdhkarLibrary.byCategory(
          'distress',
        );

      /*
       * Debt, money and provision.
       */
      case 'debt':
      case 'rizq':
      case 'provision':
      case 'debt_rizq':
      case 'money':
        return AdhkarLibrary.byCategory(
          'debt_rizq',
        );

      /*
       * Forgiveness.
       */
      case 'forgiveness':
      case 'tawbah':
      case 'repentance':
      case 'istighfar':
        return AdhkarLibrary.byCategory(
          'forgiveness',
        );

      /*
       * Family.
       */
      case 'family':
      case 'children':
      case 'family_children':
        return AdhkarLibrary.byCategory(
          'family_children',
        );

      case 'marriage':
      case 'wedding':
        return AdhkarLibrary.byCategory(
          'marriage',
        );

      /*
       * Fasting.
       */
      case 'fasting':
      case 'fast':
      case 'ramadan':
        return AdhkarLibrary.byCategory(
          'fasting',
        );

      /*
       * Everyday etiquette.
       */
      case 'sneezing':
      case 'sneeze':
        return AdhkarLibrary.byCategory(
          'sneezing',
        );

      case 'gathering':
      case 'gatherings':
      case 'meeting':
        return AdhkarLibrary.byCategory(
          'gathering',
        );

      case 'social':
      case 'social_daily':
      case 'daily_life':
        return AdhkarLibrary.byCategory(
          'social_daily',
        );

      /*
       * Large collections.
       */
      case 'quranic':
      case 'quranic_duas':
      case 'quran_duas':
        return AdhkarLibrary.byCategory(
          'quranic_duas',
        );

      case 'prophetic':
      case 'prophetic_duas':
      case 'sunnah_duas':
        return AdhkarLibrary.byCategory(
          'prophetic_duas',
        );

      case 'general':
      case 'dhikr':
      case 'general_dhikr':
        return AdhkarLibrary.byCategory(
          'general_dhikr',
        );

      /*
       * Future user-created functionality.
       */
      case 'custom_routines':
      case 'my_routines':
        return null;

      default:
        /*
         * This fallback is useful if the
         * category ID already exactly matches
         * one of the library category IDs.
         */
        final items =
            AdhkarLibrary.byCategory(
          id,
        );

        if (items.isNotEmpty) {
          return items;
        }

        return null;
    }
  }

  int _categoryItemCount(
    String categoryId,
  ) {
    return _itemsForCategory(
          categoryId,
        )?.length ??
        0;
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

  Future<void> _openReader(
    DuaAdhkarCategory category,
    List<DuaAdhkarItem> items,
  ) async {
    HapticFeedback.selectionClick();

    await Navigator.of(context).push(
      premiumRoute(
        builder: (
          context,
        ) {
          return DuaCategoryReaderScreen(
            category:
                category,
            items:
                items,
          );
        },
      ),
    );
  }

  Future<void> _openCategory(
    DuaAdhkarCategory category,
  ) async {
    final items =
        _itemsForCategory(
      category.id,
    );

    if (items != null &&
        items.isNotEmpty) {
      await _openReader(
        category,
        items,
      );

      return;
    }

    HapticFeedback.selectionClick();

    if (!mounted) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle:
          true,
      isScrollControlled:
          true,
      builder: (
        sheetContext,
      ) {
        return _CategoryPreviewSheet(
          category:
              category,
        );
      },
    );
  }

  Future<void> _openMorning() async {
    final category =
        _findCategory(
      'morning',
    );

    if (category == null) {
      return;
    }

    await _openCategory(
      category,
    );
  }

  Future<void> _openEvening() async {
    final category =
        _findCategory(
      'evening',
    );

    if (category == null) {
      return;
    }

    await _openCategory(
      category,
    );
  }

  void _openFavorites() {
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Favorites are coming in the next phase.',
        ),
      ),
    );
  }

  void _openMyRoutines() {
    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Custom routines are coming in the next phase.',
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final filtered =
        _filteredCategories;

    final isSearching =
        _searchQuery
            .trim()
            .isNotEmpty;

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
                      alpha:
                          0.24,
                    ),
                    colorScheme
                        .surfaceContainerLowest,
                    colorScheme
                        .surfaceContainerLowest,
                  ],
                  stops:
                      const [
                    0,
                    0.25,
                    1,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics:
                  const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.md,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver: SliverList(
                    delegate:
                        SliverChildListDelegate(
                      [
                        _animatedSection(
                          start:
                              0,
                          end:
                              0.24,
                          offset:
                              10,
                          child:
                              const _DuasHeader(),
                        ),
                        const SizedBox(
                          height:
                              AppSpacing.xl,
                        ),
                        _animatedSection(
                          start:
                              0.06,
                          end:
                              0.32,
                          child: _DuaHeroCard(
                            onMorning:
                                _openMorning,
                            onEvening:
                                _openEvening,
                            morningCount:
                                _categoryItemCount(
                              'morning',
                            ),
                            eveningCount:
                                _categoryItemCount(
                              'evening',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height:
                              AppSpacing.lg,
                        ),
                        _animatedSection(
                          start:
                              0.12,
                          end:
                              0.40,
                          child: TextField(
                            controller:
                                _searchController,
                            textInputAction:
                                TextInputAction
                                    .search,
                            onChanged: (
                              value,
                            ) {
                              setState(() {
                                _searchQuery =
                                    value;
                              });
                            },
                            decoration:
                                InputDecoration(
                              hintText:
                                  'Search duas, adhkar, ruqyah...',
                              prefixIcon:
                                  const Icon(
                                Icons
                                    .search_rounded,
                              ),
                              suffixIcon:
                                  _searchQuery
                                          .isEmpty
                                      ? null
                                      : IconButton(
                                          tooltip:
                                              'Clear search',
                                          onPressed:
                                              () {
                                            _searchController
                                                .clear();

                                            setState(
                                              () {
                                                _searchQuery =
                                                    '';
                                              },
                                            );
                                          },
                                          icon:
                                              const Icon(
                                            Icons
                                                .close_rounded,
                                          ),
                                        ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height:
                              AppSpacing.lg,
                        ),
                        _animatedSection(
                          start:
                              0.18,
                          end:
                              0.46,
                          child: Row(
                            children: [
                              Expanded(
                                child:
                                    _QuickActionCard(
                                  icon:
                                      Icons
                                          .favorite_rounded,
                                  title:
                                      'Favorites',
                                  subtitle:
                                      'Saved duas',
                                  onTap:
                                      _openFavorites,
                                ),
                              ),
                              const SizedBox(
                                width:
                                    AppSpacing.md,
                              ),
                              Expanded(
                                child:
                                    _QuickActionCard(
                                  icon:
                                      Icons
                                          .checklist_rounded,
                                  title:
                                      'My Routines',
                                  subtitle:
                                      'Personal plans',
                                  onTap:
                                      _openMyRoutines,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isSearching) ...[
                          const SizedBox(
                            height:
                                AppSpacing.xl,
                          ),
                          _animatedSection(
                            start:
                                0.23,
                            end:
                                0.52,
                            child:
                                const _SectionTitle(
                              title:
                                  'Daily Journey',
                              subtitle:
                                  'Remembrance throughout your day',
                            ),
                          ),
                          const SizedBox(
                            height:
                                AppSpacing.md,
                          ),
                          _animatedSection(
                            start:
                                0.28,
                            end:
                                0.58,
                            child: _DailyJourney(
                              onOpen:
                                  _openCategory,
                              findCategory:
                                  _findCategory,
                              itemCount:
                                  _categoryItemCount,
                            ),
                          ),
                          const SizedBox(
                            height:
                                AppSpacing.xl,
                          ),
                          _animatedSection(
                            start:
                                0.34,
                            end:
                                0.64,
                            child:
                                const _SectionTitle(
                              title:
                                  'Featured',
                              subtitle:
                                  'Essential collections for everyday worship',
                            ),
                          ),
                          const SizedBox(
                            height:
                                AppSpacing.md,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (!isSearching)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height:
                          188,
                      child:
                          ListView.separated(
                        physics:
                            const BouncingScrollPhysics(),
                        scrollDirection:
                            Axis.horizontal,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              AppSpacing.lg,
                        ),
                        itemCount:
                            _featuredCategories
                                .length,
                        separatorBuilder:
                            (
                          _,
                          _,
                        ) {
                          return const SizedBox(
                            width:
                                AppSpacing.md,
                          );
                        },
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          final category =
                              _featuredCategories[
                                  index];

                          final count =
                              _categoryItemCount(
                            category.id,
                          );

                          return _FeaturedCard(
                            category:
                                category,
                            count:
                                count,
                            onTap: () {
                              _openCategory(
                                category,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                SliverPadding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.xl,
                    AppSpacing.lg,
                    0,
                  ),
                  sliver:
                      SliverToBoxAdapter(
                    child:
                        _animatedSection(
                      start:
                          0.40,
                      end:
                          0.70,
                      child: _SectionTitle(
                        title:
                            isSearching
                                ? 'Search Results'
                                : 'All Duas & Adhkar',
                        subtitle:
                            isSearching
                                ? '${filtered.length} collections found'
                                : '${AdhkarLibrary.allItems.length + morningAdhkar.length + eveningAdhkar.length} entries across the library',
                      ),
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody:
                        false,
                    child:
                        _NoResultsView(),
                  )
                else
                  SliverPadding(
                    padding:
                        const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.xl,
                    ),
                    sliver:
                        SliverList(
                      delegate:
                          SliverChildBuilderDelegate(
                        (
                          context,
                          index,
                        ) {
                          final category =
                              filtered[index];

                          final count =
                              _categoryItemCount(
                            category.id,
                          );

                          return Padding(
                            padding:
                                const EdgeInsets.only(
                              bottom:
                                  AppSpacing.md,
                            ),
                            child:
                                _CategoryCard(
                              category:
                                  category,
                              count:
                                  count,
                              onTap: () {
                                _openCategory(
                                  category,
                                );
                              },
                            ),
                          );
                        },
                        childCount:
                            filtered.length,
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

class _DuasHeader extends StatelessWidget {
  const _DuasHeader();

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Row(
      children: [
        IconButton(
          tooltip:
              'Back',
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
          icon:
              const Icon(
            Icons
                .arrow_back_ios_new_rounded,
          ),
        ),
        const SizedBox(
          width:
              AppSpacing.sm,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Duas & Adhkar',
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
              Text(
                'Authentic remembrance for every moment',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                      theme
                          .colorScheme
                          .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          width:
              46,
          height:
              46,
          decoration:
              BoxDecoration(
            color:
                theme
                    .colorScheme
                    .primaryContainer,
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
          child: Icon(
            Icons
                .volunteer_activism_rounded,
            color:
                theme
                    .colorScheme
                    .primary,
          ),
        ),
      ],
    );
  }
}

class _DuaHeroCard extends StatelessWidget {
  const _DuaHeroCard({
    required this.onMorning,
    required this.onEvening,
    required this.morningCount,
    required this.eveningCount,
  });

  final VoidCallback onMorning;
  final VoidCallback onEvening;

  final int morningCount;
  final int eveningCount;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        AppSpacing.xl,
      ),
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          28,
        ),
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
                  0.82,
            ),
          ],
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
                32,
            spreadRadius:
                -5,
            offset:
                const Offset(
              0,
              12,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width:
                48,
            height:
                48,
            decoration:
                BoxDecoration(
              color:
                  Colors.white
                      .withValues(
                alpha:
                    0.14,
              ),
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            child:
                const Icon(
              Icons
                  .auto_awesome_rounded,
              color:
                  Colors.white,
            ),
          ),
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          Text(
            'Remember Allah\nthroughout your day',
            style: theme
                .textTheme
                .headlineMedium
                ?.copyWith(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.w800,
              height:
                  1.15,
            ),
          ),
          const SizedBox(
            height:
                AppSpacing.sm,
          ),
          Text(
            'Authentic Qur’anic and Prophetic supplications, organized for everyday life.',
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
              height:
                  1.5,
            ),
          ),
          const SizedBox(
            height:
                AppSpacing.xl,
          ),
          Row(
            children: [
              Expanded(
                child:
                    _HeroAction(
                  icon:
                      Icons
                          .wb_sunny_rounded,
                  label:
                      'Morning',
                  count:
                      morningCount,
                  onTap:
                      onMorning,
                ),
              ),
              const SizedBox(
                width:
                    AppSpacing.sm,
              ),
              Expanded(
                child:
                    _HeroAction(
                  icon:
                      Icons
                          .nights_stay_rounded,
                  label:
                      'Evening',
                  count:
                      eveningCount,
                  onTap:
                      onEvening,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Material(
      color:
          Colors.white.withValues(
        alpha:
            0.14,
      ),
      borderRadius:
          BorderRadius.circular(
        18,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal:
                AppSpacing.sm,
            vertical:
                AppSpacing.md,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size:
                        19,
                    color:
                        Colors.white,
                  ),
                  const SizedBox(
                    width:
                        AppSpacing.xs,
                  ),
                  Text(
                    label,
                    style:
                        Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (count > 0) ...[
                const SizedBox(
                  height:
                      3,
                ),
                Text(
                  '$count entries',
                  style:
                      Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                    color:
                        Colors.white
                            .withValues(
                      alpha:
                          0.72,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
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
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return IlmCard(
      onTap:
          onTap,
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width:
                42,
            height:
                42,
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .primaryContainer,
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color:
                  colorScheme.primary,
              size:
                  21,
            ),
          ),
          const SizedBox(
            height:
                AppSpacing.md,
          ),
          Text(
            title,
            maxLines:
                1,
            overflow:
                TextOverflow.ellipsis,
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
                3,
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
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme
              .textTheme
              .titleLarge
              ?.copyWith(
            fontWeight:
                FontWeight.w800,
          ),
        ),
        const SizedBox(
          height:
              3,
        ),
        Text(
          subtitle,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            color:
                theme
                    .colorScheme
                    .onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DailyJourney extends StatelessWidget {
  const _DailyJourney({
    required this.onOpen,
    required this.findCategory,
    required this.itemCount,
  });

  final ValueChanged<DuaAdhkarCategory>
      onOpen;

  final DuaAdhkarCategory?
      Function(
    String id,
  ) findCategory;

  final int Function(
    String id,
  ) itemCount;

  @override
  Widget build(
    BuildContext context,
  ) {
    final items =
        [
      (
        'waking',
        'Wake Up',
        Icons.wb_twilight_rounded,
      ),
      (
        'morning',
        'Morning',
        Icons.wb_sunny_rounded,
      ),
      (
        'food',
        'Food',
        Icons.restaurant_rounded,
      ),
      (
        'home',
        'Home',
        Icons.home_rounded,
      ),
      (
        'evening',
        'Evening',
        Icons.nights_stay_rounded,
      ),
      (
        'sleep',
        'Sleep',
        Icons.bedtime_rounded,
      ),
    ];

    return GridView.builder(
      shrinkWrap:
          true,
      physics:
          const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            3,
        crossAxisSpacing:
            AppSpacing.sm,
        mainAxisSpacing:
            AppSpacing.sm,
        childAspectRatio:
            0.88,
      ),
      itemCount:
          items.length,
      itemBuilder: (
        context,
        index,
      ) {
        final item =
            items[index];

        final category =
            findCategory(
          item.$1,
        );

        final count =
            itemCount(
          item.$1,
        );

        return _JourneyItem(
          title:
              item.$2,
          icon:
              item.$3,
          count:
              count,
          onTap:
              category == null ||
                      count == 0
                  ? null
                  : () {
                      onOpen(
                        category,
                      );
                    },
        );
      },
    );
  }
}

class _JourneyItem extends StatelessWidget {
  const _JourneyItem({
    required this.title,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final available =
        count > 0;

    return Material(
      color:
          colorScheme.surface,
      borderRadius:
          BorderRadius.circular(
        20,
      ),
      child: InkWell(
        onTap:
            onTap,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        child: Container(
          padding:
              const EdgeInsets.all(
            AppSpacing.sm,
          ),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
            border:
                Border.all(
              color:
                  colorScheme
                      .outlineVariant,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Container(
                      width:
                          44,
                      height:
                          44,
                      decoration:
                          BoxDecoration(
                        color:
                            colorScheme
                                .primaryContainer,
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color:
                            colorScheme.primary,
                        size:
                            22,
                      ),
                    ),
                    const SizedBox(
                      height:
                          AppSpacing.sm,
                    ),
                    Text(
                      title,
                      textAlign:
                          TextAlign.center,
                      style: theme
                          .textTheme
                          .labelLarge
                          ?.copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                    if (available) ...[
                      const SizedBox(
                        height:
                            3,
                      ),
                      Text(
                        '$count',
                        style: theme
                            .textTheme
                            .labelSmall
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
              if (available)
                Positioned(
                  top:
                      0,
                  right:
                      0,
                  child:
                      Container(
                    width:
                        7,
                    height:
                        7,
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      color:
                          colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final DuaAdhkarCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return SizedBox(
      width:
          220,
      child: IlmCard(
        onTap:
            count > 0
                ? onTap
                : null,
        padding:
            const EdgeInsets.all(
          AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width:
                      46,
                  height:
                      46,
                  decoration:
                      BoxDecoration(
                    color:
                        colorScheme
                            .primaryContainer,
                    borderRadius:
                        BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Icon(
                    category.icon,
                    color:
                        colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (count > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal:
                          8,
                      vertical:
                          4,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          colorScheme.primary,
                      borderRadius:
                          BorderRadius.circular(
                        999,
                      ),
                    ),
                    child: Text(
                      '$count',
                      style: theme
                          .textTheme
                          .labelSmall
                          ?.copyWith(
                        color:
                            colorScheme.onPrimary,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              category.title,
              maxLines:
                  1,
              overflow:
                  TextOverflow.ellipsis,
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            const SizedBox(
              height:
                  4,
            ),
            Text(
              count > 0
                  ? '$count ${count == 1 ? 'entry' : 'entries'}'
                  : category.subtitle,
              maxLines:
                  2,
              overflow:
                  TextOverflow.ellipsis,
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
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final DuaAdhkarCategory category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final available =
        count > 0;

    return IlmCard(
      onTap:
          onTap,
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      child: Row(
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
            child: Icon(
              category.icon,
              color:
                  colorScheme.primary,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.title,
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ),
                    if (available)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              8,
                          vertical:
                              4,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              colorScheme
                                  .primaryContainer,
                          borderRadius:
                              BorderRadius.circular(
                            999,
                          ),
                        ),
                        child: Text(
                          '$count',
                          style: theme
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color:
                                colorScheme.primary,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height:
                      4,
                ),
                Text(
                  available
                      ? '$count ${count == 1 ? 'entry' : 'entries'} • ${category.subtitle}'
                      : category.subtitle,
                  maxLines:
                      2,
                  overflow:
                      TextOverflow.ellipsis,
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
            ),
          ),
          const SizedBox(
            width:
                AppSpacing.sm,
          ),
          Icon(
            available
                ? Icons
                    .arrow_forward_ios_rounded
                : Icons
                    .lock_outline_rounded,
            size:
                16,
            color:
                colorScheme
                    .onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

class _CategoryPreviewSheet extends StatelessWidget {
  const _CategoryPreviewSheet({
    required this.category,
  });

  final DuaAdhkarCategory category;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width:
                  58,
              height:
                  58,
              decoration:
                  BoxDecoration(
                color:
                    colorScheme
                        .primaryContainer,
                borderRadius:
                    BorderRadius.circular(
                  19,
                ),
              ),
              child: Icon(
                category.icon,
                size:
                    28,
                color:
                    colorScheme.primary,
              ),
            ),
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            Text(
              category.title,
              style: theme
                  .textTheme
                  .headlineMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
            const SizedBox(
              height:
                  AppSpacing.sm,
            ),
            Text(
              category.subtitle,
              style: theme
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
            const SizedBox(
              height:
                  AppSpacing.xl,
            ),
            Container(
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
                        .surfaceContainerHigh,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: Text(
                'This collection does not have verified content connected yet.',
                style: theme
                    .textTheme
                    .bodyMedium
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
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView();

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .search_off_rounded,
              size:
                  48,
              color:
                  theme
                      .colorScheme
                      .onSurfaceVariant,
            ),
            const SizedBox(
              height:
                  AppSpacing.md,
            ),
            Text(
              'No duas found',
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
                  AppSpacing.xs,
            ),
            Text(
              'Try another word or phrase.',
              textAlign:
                  TextAlign.center,
              style: theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color:
                    theme
                        .colorScheme
                        .onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}