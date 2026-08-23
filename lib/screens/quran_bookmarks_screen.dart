import 'package:flutter/material.dart';

import '../core/app_spacing.dart';
import '../models/quran_bookmark.dart';
import '../models/quran_surah.dart';
import '../services/quran_bookmark_service.dart';
import '../services/quran_metadata_service.dart';
import 'surah_reader_screen.dart';

class QuranBookmarksScreen extends StatefulWidget {
  const QuranBookmarksScreen({super.key});

  @override
  State<QuranBookmarksScreen> createState() =>
      _QuranBookmarksScreenState();
}

class _QuranBookmarksScreenState
    extends State<QuranBookmarksScreen> {
  late Future<List<QuranBookmark>> _bookmarksFuture;
  late Future<List<QuranSurah>> _surahsFuture;

  @override
  void initState() {
    super.initState();

    _reloadData();
  }

  void _reloadData() {
    const bookmarkService = QuranBookmarkService();
    const metadataService = QuranMetadataService();

    _bookmarksFuture =
        bookmarkService.loadBookmarks();

    _surahsFuture =
        metadataService.loadSurahs();
  }

  Future<void> _removeBookmark(
    QuranBookmark bookmark,
  ) async {
    const bookmarkService =
        QuranBookmarkService();

    await bookmarkService.removeBookmark(
      surahNumber: bookmark.surahNumber,
      ayahNumber: bookmark.ayahNumber,
    );

    if (!mounted) return;

    setState(() {
      _reloadData();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Bookmark removed.',
        ),
      ),
    );
  }

  Future<void> _openBookmark(
    QuranBookmark bookmark,
    List<QuranSurah> surahs,
  ) async {
    QuranSurah? surah;

    for (final item in surahs) {
      if (item.number ==
          bookmark.surahNumber) {
        surah = item;
        break;
      }
    }

    if (surah == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to find this Surah.',
          ),
        ),
      );

      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahReaderScreen(
          surah: surah!,
          initialAyahNumber: bookmark.ayahNumber,
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _reloadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Qur’an Bookmarks',
        ),
      ),
      body: FutureBuilder<List<QuranSurah>>(
        future: _surahsFuture,
        builder: (
          context,
          surahSnapshot,
        ) {
          if (surahSnapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (surahSnapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load Qur’an metadata.',
              ),
            );
          }

          final surahs =
              surahSnapshot.data ??
                  const <QuranSurah>[];

          return FutureBuilder<
              List<QuranBookmark>>(
            future: _bookmarksFuture,
            builder: (
              context,
              bookmarkSnapshot,
            ) {
              if (bookmarkSnapshot
                      .connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child:
                      CircularProgressIndicator(),
                );
              }

              if (bookmarkSnapshot.hasError) {
                return const Center(
                  child: Text(
                    'Unable to load bookmarks.',
                  ),
                );
              }

              final bookmarks =
                  bookmarkSnapshot.data ??
                      const <
                          QuranBookmark>[];

              if (bookmarks.isEmpty) {
                return _EmptyBookmarksView();
              }

              return ListView.separated(
                padding:
                    const EdgeInsets.all(
                  AppSpacing.lg,
                ),
                itemCount:
                    bookmarks.length,
                separatorBuilder:
                    (_, _) =>
                        const SizedBox(
                  height: AppSpacing.sm,
                ),
                itemBuilder: (
                  context,
                  index,
                ) {
                  final bookmark =
                      bookmarks[index];

                  return Card(
                    child: ListTile(
                      leading:
                          const Icon(
                        Icons.bookmark,
                      ),
                      title: Text(
                        bookmark
                            .surahName,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Ayah ${bookmark.ayahNumber}',
                      ),
                      trailing: Row(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip:
                                'Remove Bookmark',
                            onPressed: () {
                              _removeBookmark(
                                bookmark,
                              );
                            },
                            icon:
                                const Icon(
                              Icons
                                  .delete_outline,
                            ),
                          ),
                          const Icon(
                            Icons
                                .chevron_right,
                          ),
                        ],
                      ),
                      onTap: () {
                        _openBookmark(
                          bookmark,
                          surahs,
                        );
                      },
                    ),
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

class _EmptyBookmarksView
    extends StatelessWidget {
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
              Icons.bookmark_border,
              size: 56,
            ),

            const SizedBox(
              height: AppSpacing.md,
            ),

            Text(
              'No bookmarks yet',
              style: Theme.of(context)
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
              'Bookmark an Ayah while reading the Qur’an and it will appear here.',
              textAlign:
                  TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
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