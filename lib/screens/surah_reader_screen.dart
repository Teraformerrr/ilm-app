import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../core/app_spacing.dart';
import '../core/premium_route.dart';
import '../models/quran_ayah.dart';
import '../models/quran_reader_preferences.dart';
import '../models/quran_surah.dart';
import '../models/quran_translation.dart';
import '../services/quran_bookmark_service.dart';
import '../services/quran_reader_preferences_service.dart';
import '../services/quran_reading_position_service.dart';
import '../services/quran_text_service.dart';
import '../services/quran_translation_service.dart';
import '../services/quran_urdu_translation_service.dart';
import 'tafsir_screen.dart';

class SurahReaderScreen extends StatefulWidget {
  const SurahReaderScreen({
    required this.surah,
    this.initialAyahNumber,
    super.key,
  });

  final QuranSurah surah;
  final int? initialAyahNumber;

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  late final Future<List<QuranAyah>> _ayahsFuture;

  late final Future<List<QuranTranslation>> _englishTranslationsFuture;

  late final Future<List<QuranTranslation>> _urduTranslationsFuture;

  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  QuranReaderPreferences _readerPreferences = const QuranReaderPreferences();

  final Set<int> _bookmarkedAyahNumbers = <int>{};

  Timer? _readingPositionTimer;

  int? _lastSavedAyahNumber;
  int? _pendingAyahNumber;

  bool _isLoadingPreferences = true;
  bool _isLoadingBookmarks = true;

  @override
  void initState() {
    super.initState();

    const quranTextService = QuranTextService();

    const englishTranslationService = QuranTranslationService();

    const urduTranslationService = QuranUrduTranslationService();

    _ayahsFuture = quranTextService.loadSurahAyahs(widget.surah.number);

    _englishTranslationsFuture = englishTranslationService
        .loadSurahTranslations(widget.surah.number);

    _urduTranslationsFuture = urduTranslationService.loadSurahTranslations(
      widget.surah.number,
    );

    _itemPositionsListener.itemPositions.addListener(
      _handleVisibleItemsChanged,
    );

    _loadReaderPreferences();
    _loadBookmarks();
  }

  @override
  void dispose() {
    _readingPositionTimer?.cancel();

    _itemPositionsListener.itemPositions.removeListener(
      _handleVisibleItemsChanged,
    );

    final pendingAyah = _pendingAyahNumber;

    if (pendingAyah != null && pendingAyah != _lastSavedAyahNumber) {
      unawaited(_saveReadingPosition(pendingAyah));
    }

    super.dispose();
  }

  Future<void> _loadReaderPreferences() async {
    const service = QuranReaderPreferencesService();

    final preferences = await service.loadPreferences();

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = preferences;

      _isLoadingPreferences = false;
    });
  }

  Future<void> _loadBookmarks() async {
    const service = QuranBookmarkService();

    final bookmarks = await service.loadBookmarks();

    if (!mounted) {
      return;
    }

    final surahBookmarks = bookmarks
        .where((bookmark) => bookmark.surahNumber == widget.surah.number)
        .map((bookmark) => bookmark.ayahNumber)
        .toSet();

    setState(() {
      _bookmarkedAyahNumbers
        ..clear()
        ..addAll(surahBookmarks);

      _isLoadingBookmarks = false;
    });
  }

  void _handleVisibleItemsChanged() {
    final positions = _itemPositionsListener.itemPositions.value;

    if (positions.isEmpty) {
      return;
    }

    final visibleAyahItems =
        positions
            .where(
              (position) =>
                  position.index >= 1 &&
                  position.index <= widget.surah.ayahCount &&
                  position.itemTrailingEdge > 0 &&
                  position.itemLeadingEdge < 1,
            )
            .toList()
          ..sort((a, b) => a.index.compareTo(b.index));

    if (visibleAyahItems.isEmpty) {
      return;
    }

    // Item 0 is the Surah header.
    // Item 1 = Ayah 1,
    // Item 2 = Ayah 2, etc.
    final visibleAyahNumber = visibleAyahItems.first.index;

    if (visibleAyahNumber == _lastSavedAyahNumber ||
        visibleAyahNumber == _pendingAyahNumber) {
      return;
    }

    _pendingAyahNumber = visibleAyahNumber;

    _readingPositionTimer?.cancel();

    _readingPositionTimer = Timer(const Duration(milliseconds: 600), () {
      final ayahNumber = _pendingAyahNumber;

      if (ayahNumber == null || ayahNumber == _lastSavedAyahNumber) {
        return;
      }

      unawaited(_saveReadingPosition(ayahNumber));
    });
  }

  Future<void> _saveReadingPosition(int ayahNumber) async {
    if (ayahNumber < 1 || ayahNumber > widget.surah.ayahCount) {
      return;
    }

    const service = QuranReadingPositionService();

    await service.savePosition(
      surahNumber: widget.surah.number,
      ayahNumber: ayahNumber,
      surahName: widget.surah.englishName,
    );

    _lastSavedAyahNumber = ayahNumber;
  }

  Future<void> _toggleBookmark(QuranAyah ayah) async {
    const service = QuranBookmarkService();

    final isCurrentlyBookmarked = _bookmarkedAyahNumbers.contains(
      ayah.ayahNumber,
    );

    if (isCurrentlyBookmarked) {
      await service.removeBookmark(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
    } else {
      await service.addBookmark(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        surahName: widget.surah.englishName,
      );
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (isCurrentlyBookmarked) {
        _bookmarkedAyahNumbers.remove(ayah.ayahNumber);
      } else {
        _bookmarkedAyahNumbers.add(ayah.ayahNumber);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCurrentlyBookmarked ? 'Bookmark removed.' : 'Ayah bookmarked.',
        ),
      ),
    );
  }

  Future<void> _openTafsir({
    required QuranAyah ayah,
    required QuranTranslation englishTranslation,
  }) async {
    await Navigator.of(context).push(
      premiumRoute(
        builder: (_) {
          return TafsirScreen(
            surah: widget.surah,
            ayah: ayah,
            englishTranslation: englishTranslation,
          );
        },
      ),
    );
  }

  Future<void> _setShowEnglish(bool value) async {
    const service = QuranReaderPreferencesService();

    await service.saveShowEnglish(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = _readerPreferences.copyWith(showEnglish: value);
    });
  }

  Future<void> _setShowUrdu(bool value) async {
    const service = QuranReaderPreferencesService();

    await service.saveShowUrdu(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = _readerPreferences.copyWith(showUrdu: value);
    });
  }

  Future<void> _setArabicFontSize(double value) async {
    const service = QuranReaderPreferencesService();

    await service.saveArabicFontSize(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = _readerPreferences.copyWith(arabicFontSize: value);
    });
  }

  Future<void> _setEnglishFontSize(double value) async {
    const service = QuranReaderPreferencesService();

    await service.saveEnglishFontSize(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = _readerPreferences.copyWith(englishFontSize: value);
    });
  }

  Future<void> _setUrduFontSize(double value) async {
    const service = QuranReaderPreferencesService();

    await service.saveUrduFontSize(value);

    if (!mounted) {
      return;
    }

    setState(() {
      _readerPreferences = _readerPreferences.copyWith(urduFontSize: value);
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reader Options',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('English Translation'),
                      subtitle: const Text(
                        'Show Marmaduke Pickthall translation.',
                      ),
                      value: _readerPreferences.showEnglish,
                      onChanged: (value) async {
                        await _setShowEnglish(value);

                        setModalState(() {});
                      },
                    ),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Urdu Translation'),
                      subtitle: const Text(
                        'Show Muhammad Junagarhi translation.',
                      ),
                      value: _readerPreferences.showUrdu,
                      onChanged: (value) async {
                        await _setShowUrdu(value);

                        setModalState(() {});
                      },
                    ),

                    const Divider(),

                    Text(
                      'Arabic Font Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Slider(
                      value: _readerPreferences.arabicFontSize,
                      min: 20,
                      max: 40,
                      divisions: 10,
                      label: _readerPreferences.arabicFontSize
                          .round()
                          .toString(),
                      onChanged: (value) async {
                        await _setArabicFontSize(value);

                        setModalState(() {});
                      },
                    ),

                    Text('${_readerPreferences.arabicFontSize.round()}'),

                    const SizedBox(height: AppSpacing.md),

                    Text(
                      'English Font Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Slider(
                      value: _readerPreferences.englishFontSize,
                      min: 12,
                      max: 26,
                      divisions: 14,
                      label: _readerPreferences.englishFontSize
                          .round()
                          .toString(),
                      onChanged: _readerPreferences.showEnglish
                          ? (value) async {
                              await _setEnglishFontSize(value);

                              setModalState(() {});
                            }
                          : null,
                    ),

                    Text('${_readerPreferences.englishFontSize.round()}'),

                    const SizedBox(height: AppSpacing.md),

                    Text(
                      'Urdu Font Size',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Slider(
                      value: _readerPreferences.urduFontSize,
                      min: 14,
                      max: 30,
                      divisions: 16,
                      label: _readerPreferences.urduFontSize.round().toString(),
                      onChanged: _readerPreferences.showUrdu
                          ? (value) async {
                              await _setUrduFontSize(value);

                              setModalState(() {});
                            }
                          : null,
                    ),

                    Text('${_readerPreferences.urduFontSize.round()}'),

                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  int _initialListIndex() {
    final ayahNumber = widget.initialAyahNumber;

    if (ayahNumber == null) {
      return 0;
    }

    if (ayahNumber < 1 || ayahNumber > widget.surah.ayahCount) {
      return 0;
    }

    return ayahNumber;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences || _isLoadingBookmarks) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.surah.englishName)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah.englishName),
        actions: [
          IconButton(
            tooltip: 'Reader Options',
            onPressed: _openReaderSettings,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: FutureBuilder<List<QuranAyah>>(
        future: _ayahsFuture,
        builder: (context, ayahSnapshot) {
          if (ayahSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (ayahSnapshot.hasError) {
            return _ErrorView(
              message: 'Unable to load Qur’an text.',
              error: ayahSnapshot.error,
            );
          }

          return FutureBuilder<List<QuranTranslation>>(
            future: _englishTranslationsFuture,
            builder: (context, englishSnapshot) {
              if (englishSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (englishSnapshot.hasError) {
                return _ErrorView(
                  message: 'Unable to load English translation.',
                  error: englishSnapshot.error,
                );
              }

              return FutureBuilder<List<QuranTranslation>>(
                future: _urduTranslationsFuture,
                builder: (context, urduSnapshot) {
                  if (urduSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (urduSnapshot.hasError) {
                    return _ErrorView(
                      message: 'Unable to load Urdu translation.',
                      error: urduSnapshot.error,
                    );
                  }

                  final ayahs = ayahSnapshot.data ?? const <QuranAyah>[];

                  final english =
                      englishSnapshot.data ?? const <QuranTranslation>[];

                  final urdu = urduSnapshot.data ?? const <QuranTranslation>[];

                  if (ayahs.length != english.length ||
                      ayahs.length != urdu.length) {
                    return const _ErrorView(
                      message:
                          'Qur’an text and translation counts do not match.',
                    );
                  }

                  if (ayahs.isEmpty) {
                    return const _ErrorView(
                      message: 'No Ayahs were found for this Surah.',
                    );
                  }

                  final itemCount = ayahs.length + 2;

                  return ScrollablePositionedList.builder(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemPositionsListener: _itemPositionsListener,
                    itemCount: itemCount,
                    initialScrollIndex: _initialListIndex(),
                    initialAlignment: widget.initialAyahNumber == null
                        ? 0
                        : 0.08,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                          child: _SurahHeader(surah: widget.surah),
                        );
                      }

                      if (index == itemCount - 1) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: AppSpacing.sm,
                            bottom: AppSpacing.lg,
                          ),
                          child: Center(
                            child: Text(
                              'Qur’an text: Tanzil • '
                              'English: Marmaduke Pickthall • '
                              'Urdu: Muhammad Junagarhi / QuranEnc',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        );
                      }

                      final ayahIndex = index - 1;

                      final ayah = ayahs[ayahIndex];

                      final englishTranslation = english[ayahIndex];

                      final urduTranslation = urdu[ayahIndex];

                      if (ayah.ayahNumber != englishTranslation.ayahNumber ||
                          ayah.ayahNumber != urduTranslation.ayahNumber) {
                        return const _ErrorView(
                          message:
                              'Qur’an Ayah and translation mapping mismatch.',
                        );
                      }

                      final isBookmarked = _bookmarkedAyahNumbers.contains(
                        ayah.ayahNumber,
                      );

                      final isInitialAyah =
                          widget.initialAyahNumber == ayah.ayahNumber;

                      return _AyahCard(
                        key: ValueKey('${ayah.surahNumber}:${ayah.ayahNumber}'),
                        ayah: ayah,
                        englishTranslation: englishTranslation,
                        urduTranslation: urduTranslation,
                        preferences: _readerPreferences,
                        isBookmarked: isBookmarked,
                        isInitialAyah: isInitialAyah,
                        onToggleBookmark: () {
                          _toggleBookmark(ayah);
                        },
                        onOpenTafsir: () {
                          _openTafsir(
                            ayah: ayah,
                            englishTranslation: englishTranslation,
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surah});

  final QuranSurah surah;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            surah.arabicName,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          Text(
            surah.englishName,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            '${surah.translatedName} • '
            '${surah.revelationType} • '
            '${surah.ayahCount} Ayahs',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AyahCard extends StatelessWidget {
  const _AyahCard({
    required this.ayah,
    required this.englishTranslation,
    required this.urduTranslation,
    required this.preferences,
    required this.isBookmarked,
    required this.isInitialAyah,
    required this.onToggleBookmark,
    required this.onOpenTafsir,
    super.key,
  });

  final QuranAyah ayah;

  final QuranTranslation englishTranslation;

  final QuranTranslation urduTranslation;

  final QuranReaderPreferences preferences;

  final bool isBookmarked;
  final bool isInitialAyah;

  final VoidCallback onToggleBookmark;

  final VoidCallback onOpenTafsir;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isInitialAyah
              ? colorScheme.primary
              : colorScheme.outlineVariant,
          width: isInitialAyah ? 2 : 1,
        ),
      ),
      child: Padding(
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

                if (isInitialAyah) ...[
                  const SizedBox(width: AppSpacing.sm),

                  Expanded(
                    child: Text(
                      'Selected Ayah',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ] else
                  const Spacer(),

                TextButton.icon(
                  onPressed: onOpenTafsir,
                  icon: const Icon(Icons.auto_stories_rounded, size: 18),
                  label: const Text('Tafsir'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),

                const SizedBox(width: 2),

                IconButton(
                  tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
                  onPressed: onToggleBookmark,
                  icon: Icon(
                    isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            SelectableText(
              ayah.arabicText,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: preferences.arabicFontSize,
                height: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (preferences.showEnglish) ...[
              const SizedBox(height: AppSpacing.lg),

              Divider(color: colorScheme.outlineVariant),

              const SizedBox(height: AppSpacing.md),

              Text(
                'English',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              SelectableText(
                englishTranslation.text,
                style: TextStyle(
                  fontSize: preferences.englishFontSize,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'Marmaduke Pickthall',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],

            if (preferences.showUrdu) ...[
              const SizedBox(height: AppSpacing.lg),

              Divider(color: colorScheme.outlineVariant),

              const SizedBox(height: AppSpacing.md),

              Text(
                'اردو',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              SelectableText(
                urduTranslation.text,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: preferences.urduFontSize,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              Text(
                'محمد جوناگڑھی • QuranEnc',
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
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
  const _ErrorView({required this.message, this.error});

  final String message;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: colorScheme.primary,
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            if (error != null) ...[
              const SizedBox(height: AppSpacing.sm),

              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
