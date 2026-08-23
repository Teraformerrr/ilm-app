import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_spacing.dart';
import '../models/dua_adhkar_category.dart';
import '../models/dua_adhkar_item.dart';
import '../services/dua_adhkar_progress_service.dart';
import '../widgets/ilm_card.dart';

class DuaCategoryReaderScreen extends StatefulWidget {
  const DuaCategoryReaderScreen({
    required this.category,
    required this.items,
    super.key,
  });

  final DuaAdhkarCategory category;
  final List<DuaAdhkarItem> items;

  @override
  State<DuaCategoryReaderScreen> createState() =>
      _DuaCategoryReaderScreenState();
}

class _DuaCategoryReaderScreenState
    extends State<DuaCategoryReaderScreen> {
  static const _progressService =
      DuaAdhkarProgressService();

  final Map<String, int> _counts =
      <String, int>{};

  final Set<String> _completed =
      <String>{};

  late final DateTime _sessionDate;

  bool _isLoadingProgress = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _sessionDate = DateTime(
      now.year,
      now.month,
      now.day,
    );

    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final storedCounts =
        await _progressService.loadProgress(
      categoryId: widget.category.id,
      date: _sessionDate,
    );

    final validCounts =
        <String, int>{};

    final completed =
        <String>{};

    for (final item in widget.items) {
      final target =
          item.repeatCount ?? 1;

      final stored =
          storedCounts[item.id] ?? 0;

      final safeCount =
          stored
              .clamp(
                0,
                target,
              )
              .toInt();

      if (safeCount > 0) {
        validCounts[item.id] =
            safeCount;
      }

      if (safeCount >= target) {
        completed.add(
          item.id,
        );
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _counts
        ..clear()
        ..addAll(
          validCounts,
        );

      _completed
        ..clear()
        ..addAll(
          completed,
        );

      _isLoadingProgress =
          false;
    });
  }

  Future<void> _persistProgress() async {
    if (_isSaving) {
      return;
    }

    _isSaving = true;

    try {
      await _progressService
          .saveProgress(
        categoryId:
            widget.category.id,
        date:
            _sessionDate,
        counts:
            Map<String, int>.from(
          _counts,
        ),
      );
    } finally {
      _isSaving = false;
    }
  }

  int _currentCountFor(
    DuaAdhkarItem item,
  ) {
    return _counts[item.id] ?? 0;
  }

  int get _completedCount {
    return _completed.length;
  }

  double get _progress {
    if (widget.items.isEmpty) {
      return 0;
    }

    return _completedCount /
        widget.items.length;
  }

  Future<void> _increment(
    DuaAdhkarItem item,
  ) async {
    final target =
        item.repeatCount ?? 1;

    final current =
        _currentCountFor(
      item,
    );

    if (current >= target) {
      return;
    }

    final next =
        current + 1;

    setState(() {
      _counts[item.id] =
          next;

      if (next >= target) {
        _completed.add(
          item.id,
        );
      }
    });

    if (next >= target) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.selectionClick();
    }

    await _persistProgress();
  }

  Future<void> _resetItem(
    DuaAdhkarItem item,
  ) async {
    setState(() {
      _counts.remove(
        item.id,
      );

      _completed.remove(
        item.id,
      );
    });

    HapticFeedback.selectionClick();

    await _persistProgress();
  }

  Future<void> _resetAll() async {
    final shouldReset =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title:
              const Text(
            'Reset Progress?',
          ),
          content:
              const Text(
            'This will reset today’s progress for this collection.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(
                  false,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(
                  true,
                );
              },
              child:
                  const Text(
                'Reset',
              ),
            ),
          ],
        );
      },
    );

    if (shouldReset != true) {
      return;
    }

    setState(() {
      _counts.clear();
      _completed.clear();
    });

    await _progressService
        .clearProgress(
      categoryId:
          widget.category.id,
      date:
          _sessionDate,
    );

    HapticFeedback.mediumImpact();
  }

  String _sessionDateLabel() {
    final now =
        DateTime.now();

    final today =
        DateTime(
      now.year,
      now.month,
      now.day,
    );

    if (_sessionDate == today) {
      return 'Today';
    }

    return '${_sessionDate.day}/'
        '${_sessionDate.month}/'
        '${_sessionDate.year}';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    if (_isLoadingProgress) {
      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  0,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip:
                          'Back',
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pop();
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
                      child: Text(
                        widget
                            .category
                            .title,
                        style: theme
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
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
                    _ReaderHeader(
                      title:
                          widget.category.title,
                      entryCount:
                          widget.items.length,
                      canReset:
                          _counts.isNotEmpty ||
                              _completed.isNotEmpty,
                      onReset:
                          _resetAll,
                    ),
                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),
                    _ProgressCard(
                      dateLabel:
                          _sessionDateLabel(),
                      completed:
                          _completedCount,
                      total:
                          widget.items.length,
                      progress:
                          _progress,
                    ),
                    const SizedBox(
                      height:
                          AppSpacing.xl,
                    ),
                  ],
                ),
              ),
            ),
            if (widget.items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody:
                    false,
                child:
                    _EmptyReaderView(),
              )
            else
              SliverPadding(
                padding:
                    const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.xl,
                ),
                sliver: SliverList(
                  delegate:
                      SliverChildBuilderDelegate(
                    (
                      context,
                      index,
                    ) {
                      final item =
                          widget.items[index];

                      final count =
                          _currentCountFor(
                        item,
                      );

                      final target =
                          item.repeatCount ?? 1;

                      final complete =
                          _completed.contains(
                        item.id,
                      );

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom:
                              AppSpacing.lg,
                        ),
                        child:
                            _DuaReaderCard(
                          number:
                              index + 1,
                          total:
                              widget.items.length,
                          item:
                              item,
                          count:
                              count,
                          target:
                              target,
                          complete:
                              complete,
                          onCount: () {
                            _increment(
                              item,
                            );
                          },
                          onReset: () {
                            _resetItem(
                              item,
                            );
                          },
                        ),
                      );
                    },
                    childCount:
                        widget.items.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReaderHeader
    extends StatelessWidget {
  const _ReaderHeader({
    required this.title,
    required this.entryCount,
    required this.canReset,
    required this.onReset,
  });

  final String title;
  final int entryCount;
  final bool canReset;
  final VoidCallback onReset;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

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
                title,
                style: theme
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                  letterSpacing:
                      -0.7,
                ),
              ),
              Text(
                '$entryCount entries',
                style: theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color:
                      colorScheme
                          .onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip:
              'Reset today’s progress',
          onPressed:
              canReset
                  ? onReset
                  : null,
          icon:
              const Icon(
            Icons
                .restart_alt_rounded,
          ),
        ),
      ],
    );
  }
}

class _ProgressCard
    extends StatelessWidget {
  const _ProgressCard({
    required this.dateLabel,
    required this.completed,
    required this.total,
    required this.progress,
  });

  final String dateLabel;

  final int completed;
  final int total;

  final double progress;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final isComplete =
        total > 0 &&
            completed == total;

    return IlmCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width:
                    44,
                height:
                    44,
                decoration:
                    BoxDecoration(
                  color:
                      theme
                          .colorScheme
                          .primaryContainer,
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
                child: Icon(
                  Icons
                      .track_changes_rounded,
                  color:
                      theme
                          .colorScheme
                          .primary,
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
                      '$dateLabel’s Progress',
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
                          2,
                    ),
                    Text(
                      'Progress saves automatically',
                      style: theme
                          .textTheme
                          .bodySmall
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
              Text(
                '$completed/$total',
                style: theme
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                  color:
                      theme
                          .colorScheme
                          .primary,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(
              999,
            ),
            child:
                LinearProgressIndicator(
              value:
                  progress,
              minHeight:
                  9,
            ),
          ),
          const SizedBox(
            height:
                AppSpacing.sm,
          ),
          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds:
                  220,
            ),
            child: Text(
              total == 0
                  ? 'No entries yet'
                  : isComplete
                      ? 'MashaAllah — collection completed.'
                      : 'Continue where you left off.',
              key:
                  ValueKey(
                '$completed-$total',
              ),
              style: theme
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                color:
                    theme
                        .colorScheme
                        .onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaReaderCard
    extends StatelessWidget {
  const _DuaReaderCard({
    required this.number,
    required this.total,
    required this.item,
    required this.count,
    required this.target,
    required this.complete,
    required this.onCount,
    required this.onReset,
  });

  final int number;
  final int total;

  final DuaAdhkarItem item;

  final int count;
  final int target;

  final bool complete;

  final VoidCallback onCount;
  final VoidCallback onReset;

  @override
  Widget build(
    BuildContext context,
  ) {
    return IlmCard(
      padding:
          EdgeInsets.zero,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _CardHeader(
            number:
                number,
            total:
                total,
            item:
                item,
            complete:
                complete,
          ),
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          _ArabicSection(
            text:
                item.arabic,
          ),
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          _TransliterationSection(
            text:
                item.transliteration,
          ),
          const SizedBox(
            height:
                AppSpacing.md,
          ),
          _EnglishTranslationSection(
            text:
                item
                    .englishTranslation,
          ),
          if (item.hasUrduTranslation) ...[
            const SizedBox(
              height:
                  AppSpacing.md,
            ),
            _UrduTranslationSection(
              text:
                  item
                      .urduTranslation!,
            ),
          ],
          if (item.hasMethod) ...[
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            _MethodSection(
              method:
                  item.method!,
            ),
          ],
          if (item.isWeakOrDisputed) ...[
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            _AuthenticityWarning(
              item:
                  item,
            ),
          ],
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          _MetadataSection(
            item:
                item,
          ),
          if (item.hasStructuredReferences) ...[
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            _ReferencesSection(
              references:
                  item.references,
            ),
          ],
          if (item.hasAuthenticityNote ||
              item.hasSourceTextNote) ...[
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            _SourceNotesSection(
              authenticityNote:
                  item.authenticityNote,
              sourceTextNote:
                  item.sourceTextNote,
            ),
          ],
          if (item.notes != null ||
              item.hasBenefit) ...[
            const SizedBox(
              height:
                  AppSpacing.lg,
            ),
            _NotesBenefitsSection(
              item:
                  item,
            ),
          ],
          const SizedBox(
            height:
                AppSpacing.lg,
          ),
          _CounterSection(
            count:
                count,
            target:
                target,
            complete:
                complete,
            onCount:
                onCount,
            onReset:
                onReset,
          ),
        ],
      ),
    );
  }
}

class _CardHeader
    extends StatelessWidget {
  const _CardHeader({
    required this.number,
    required this.total,
    required this.item,
    required this.complete,
  });

  final int number;
  final int total;

  final DuaAdhkarItem item;

  final bool complete;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal:
                  9,
              vertical:
                  5,
            ),
            decoration:
                BoxDecoration(
              color:
                  colorScheme
                      .surfaceContainerHigh,
              borderRadius:
                  BorderRadius.circular(
                999,
              ),
            ),
            child: Text(
              '$number/$total',
              style: theme
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color:
                    colorScheme
                        .onSurfaceVariant,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(
            width:
                AppSpacing.sm,
          ),
          Expanded(
            child: Text(
              item.title,
              style: theme
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
          AnimatedSwitcher(
            duration:
                const Duration(
              milliseconds:
                  220,
            ),
            child: complete
                ? Container(
                    key:
                        const ValueKey(
                      'complete',
                    ),
                    width:
                        34,
                    height:
                        34,
                    decoration:
                        BoxDecoration(
                      color:
                          colorScheme
                              .primaryContainer,
                      shape:
                          BoxShape.circle,
                    ),
                    child: Icon(
                      Icons
                          .check_rounded,
                      size:
                          20,
                      color:
                          colorScheme
                              .primary,
                    ),
                  )
                : const SizedBox(
                    key:
                        ValueKey(
                      'pending',
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ArabicSection
    extends StatelessWidget {
  const _ArabicSection({
    required this.text,
  });

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      child: Directionality(
        textDirection:
            TextDirection.rtl,
        child: SelectableText(
          text,
          textAlign:
              TextAlign.right,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(
            height:
                1.9,
            fontWeight:
                FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TransliterationSection
    extends StatelessWidget {
  const _TransliterationSection({
    required this.text,
  });

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      child: Text(
        text,
        style: theme
            .textTheme
            .bodyLarge
            ?.copyWith(
          color:
              theme
                  .colorScheme
                  .primary,
          height:
              1.55,
          fontStyle:
              FontStyle.italic,
        ),
      ),
    );
  }
}

class _EnglishTranslationSection
    extends StatelessWidget {
  const _EnglishTranslationSection({
    required this.text,
  });

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(
          height:
              1.6,
        ),
      ),
    );
  }
}

class _UrduTranslationSection
    extends StatelessWidget {
  const _UrduTranslationSection({
    required this.text,
  });

  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      child: Directionality(
        textDirection:
            TextDirection.rtl,
        child: Text(
          text,
          textAlign:
              TextAlign.right,
          style: theme
              .textTheme
              .bodyLarge
              ?.copyWith(
            height:
                1.7,
            color:
                theme
                    .colorScheme
                    .onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _MethodSection
    extends StatelessWidget {
  const _MethodSection({
    required this.method,
  });

  final String method;

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
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration:
          BoxDecoration(
        color:
            colorScheme
                .primaryContainer
                .withValues(
              alpha:
                  0.55,
            ),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons
                .format_list_numbered_rounded,
            color:
                colorScheme.primary,
            size:
                21,
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
                  'How to recite',
                  style: theme
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                    color:
                        colorScheme.primary,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  height:
                      5,
                ),
                Text(
                  method,
                  style: theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    height:
                        1.55,
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

class _MetadataSection
    extends StatelessWidget {
  const _MetadataSection({
    required this.item,
  });

  final DuaAdhkarItem item;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      child: Wrap(
        spacing:
            AppSpacing.sm,
        runSpacing:
            AppSpacing.sm,
        children: [
          _InfoBadge(
            icon:
                Icons
                    .verified_rounded,
            text:
                item
                    .authenticityLabel,
          ),
          _InfoBadge(
            icon:
                item.isQuran
                    ? Icons
                        .menu_book_rounded
                    : Icons
                        .history_edu_rounded,
            text:
                item.sourceTypeLabel,
          ),
          if (item.quranLocation != null)
            _InfoBadge(
              icon:
                  Icons
                      .menu_book_rounded,
              text:
                  item
                      .quranLocation!
                      .displayReference,
            )
          else
            _InfoBadge(
              icon:
                  Icons
                      .menu_book_rounded,
              text:
                  item.reference,
            ),
          if (item.repeatCount != null)
            _InfoBadge(
              icon:
                  Icons
                      .repeat_rounded,
              text:
                  '${item.repeatCount}×',
            ),
          if (item.isRuqyah)
            const _InfoBadge(
              icon:
                  Icons
                      .health_and_safety_rounded,
              text:
                  'Ruqyah',
            ),
          if (item.benefitDirectlySourced)
            const _InfoBadge(
              icon:
                  Icons
                      .fact_check_rounded,
              text:
                  'Sourced benefit',
            ),
        ],
      ),
    );
  }
}

class _ReferencesSection
    extends StatelessWidget {
  const _ReferencesSection({
    required this.references,
  });

  final List<DuaReference> references;

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
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
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
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons
                    .library_books_rounded,
                size:
                    19,
                color:
                    colorScheme.primary,
              ),
              const SizedBox(
                width:
                    AppSpacing.xs,
              ),
              Text(
                'Sources',
                style: theme
                    .textTheme
                    .titleSmall
                    ?.copyWith(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(
            height:
                AppSpacing.sm,
          ),
          for (var index = 0;
              index < references.length;
              index++) ...[
            _ReferenceRow(
              reference:
                  references[index],
            ),
            if (index !=
                references.length - 1)
              const Divider(
                height:
                    AppSpacing.lg,
              ),
          ],
        ],
      ),
    );
  }
}

class _ReferenceRow
    extends StatelessWidget {
  const _ReferenceRow({
    required this.reference,
  });

  final DuaReference reference;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          reference.displayText,
          style: theme
              .textTheme
              .bodyMedium
              ?.copyWith(
            fontWeight:
                FontWeight.w700,
          ),
        ),
        if (reference.grade != null) ...[
          const SizedBox(
            height:
                3,
          ),
          Text(
            'Grade: ${reference.grade}',
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
                  colorScheme.primary,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
        if (reference.note != null) ...[
          const SizedBox(
            height:
                3,
          ),
          Text(
            reference.note!,
            style: theme
                .textTheme
                .bodySmall
                ?.copyWith(
              color:
                  colorScheme
                      .onSurfaceVariant,
              height:
                  1.45,
            ),
          ),
        ],
      ],
    );
  }
}

class _SourceNotesSection
    extends StatelessWidget {
  const _SourceNotesSection({
    required this.authenticityNote,
    required this.sourceTextNote,
  });

  final String? authenticityNote;
  final String? sourceTextNote;

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
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
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
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (authenticityNote != null)
            _NoteRow(
              icon:
                  Icons
                      .verified_outlined,
              title:
                  'Authenticity',
              text:
                  authenticityNote!,
            ),
          if (authenticityNote != null &&
              sourceTextNote != null)
            const SizedBox(
              height:
                  AppSpacing.md,
            ),
          if (sourceTextNote != null)
            _NoteRow(
              icon:
                  Icons
                      .difference_outlined,
              title:
                  'Text note',
              text:
                  sourceTextNote!,
            ),
        ],
      ),
    );
  }
}

class _NoteRow
    extends StatelessWidget {
  const _NoteRow({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size:
              19,
          color:
              colorScheme.primary,
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
                title,
                style: theme
                    .textTheme
                    .labelLarge
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
                text,
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
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthenticityWarning
    extends StatelessWidget {
  const _AuthenticityWarning({
    required this.item,
  });

  final DuaAdhkarItem item;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    final isWeak =
        item.authenticity ==
            DuaAuthenticity.weak;

    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
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
          18,
        ),
        border:
            Border.all(
          color:
              colorScheme
                  .outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons
                .info_outline_rounded,
            color:
                colorScheme
                    .onSurfaceVariant,
          ),
          const SizedBox(
            width:
                AppSpacing.sm,
          ),
          Expanded(
            child: Text(
              isWeak
                  ? 'This narration is classified as weak. Review the source details before relying on a specific virtue, count, or prescription.'
                  : 'The authenticity or interpretation of this narration is disputed. Review the source notes for context.',
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

class _NotesBenefitsSection
    extends StatelessWidget {
  const _NotesBenefitsSection({
    required this.item,
  });

  final DuaAdhkarItem item;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.symmetric(
        horizontal:
            AppSpacing.lg,
      ),
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .surfaceContainerHigh,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (item.notes != null)
            _ContentBlock(
              title:
                  'When to recite',
              text:
                  item.notes!,
            ),
          if (item.notes != null &&
              item.hasBenefit)
            const SizedBox(
              height:
                  AppSpacing.md,
            ),
          if (item.hasBenefit)
            _ContentBlock(
              title:
                  item.benefitDirectlySourced
                      ? 'Established benefit'
                      : 'Context',
              text:
                  item.benefit!,
              icon:
                  item.benefitDirectlySourced
                      ? Icons
                          .fact_check_rounded
                      : Icons
                          .info_outline_rounded,
            ),
        ],
      ),
    );
  }
}

class _ContentBlock
    extends StatelessWidget {
  const _ContentBlock({
    required this.title,
    required this.text,
    this.icon,
  });

  final String title;
  final String text;
  final IconData? icon;

  @override
  Widget build(
    BuildContext context,
  ) {
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
            if (icon != null) ...[
              Icon(
                icon,
                size:
                    17,
                color:
                    colorScheme.primary,
              ),
              const SizedBox(
                width:
                    5,
              ),
            ],
            Text(
              title,
              style: theme
                  .textTheme
                  .labelLarge
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(
          height:
              4,
        ),
        Text(
          text,
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
      ],
    );
  }
}

class _CounterSection
    extends StatelessWidget {
  const _CounterSection({
    required this.count,
    required this.target,
    required this.complete,
    required this.onCount,
    required this.onReset,
  });

  final int count;
  final int target;

  final bool complete;

  final VoidCallback onCount;
  final VoidCallback onReset;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .surfaceContainerLow,
        borderRadius:
            const BorderRadius.only(
          bottomLeft:
              Radius.circular(
            20,
          ),
          bottomRight:
              Radius.circular(
            20,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip:
                'Reset count',
            onPressed:
                count == 0
                    ? null
                    : onReset,
            icon:
                const Icon(
              Icons
                  .restart_alt_rounded,
            ),
          ),
          const SizedBox(
            width:
                AppSpacing.sm,
          ),
          Expanded(
            child:
                FilledButton(
              onPressed:
                  complete
                      ? null
                      : onCount,
              child:
                  AnimatedSwitcher(
                duration:
                    const Duration(
                  milliseconds:
                      180,
                ),
                child: Text(
                  complete
                      ? 'Completed'
                      : target == 1
                          ? 'Mark Read'
                          : '$count / $target • Tap after reading',
                  key:
                      ValueKey(
                    '$count-$complete',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge
    extends StatelessWidget {
  const _InfoBadge({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(
    BuildContext context,
  ) {
    final theme =
        Theme.of(context);

    final colorScheme =
        theme.colorScheme;

    return Container(
      constraints:
          BoxConstraints(
        maxWidth:
            MediaQuery.sizeOf(
                  context,
                ).width *
                0.78,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            9,
        vertical:
            6,
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
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            size:
                14,
            color:
                colorScheme.primary,
          ),
          const SizedBox(
            width:
                4,
          ),
          Flexible(
            child: Text(
              text,
              overflow:
                  TextOverflow.ellipsis,
              style: theme
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                color:
                    colorScheme.primary,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyReaderView
    extends StatelessWidget {
  const _EmptyReaderView();

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
                  .menu_book_rounded,
              size:
                  52,
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
              'No entries available yet',
              style: theme
                  .textTheme
                  .titleMedium
                  ?.copyWith(
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}