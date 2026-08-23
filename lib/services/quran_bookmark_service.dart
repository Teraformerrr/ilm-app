import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/quran_bookmark.dart';

class QuranBookmarkService {
  const QuranBookmarkService();

  static const String _bookmarksKey =
      'quran_bookmarks';

  Future<List<QuranBookmark>> loadBookmarks() async {
    final preferences =
        await SharedPreferences.getInstance();

    final rawBookmarks =
        preferences.getStringList(_bookmarksKey) ??
            const <String>[];

    final bookmarks = <QuranBookmark>[];

    for (final rawBookmark in rawBookmarks) {
      try {
        final decoded = jsonDecode(rawBookmark);

        if (decoded is! Map<String, dynamic>) {
          continue;
        }

        bookmarks.add(
          QuranBookmark.fromJson(decoded),
        );
      } catch (_) {
        // Ignore corrupted bookmark entries
        // instead of breaking the entire reader.
      }
    }

    bookmarks.sort(
      (a, b) =>
          b.createdAt.compareTo(a.createdAt),
    );

    return bookmarks;
  }

  Future<bool> isBookmarked({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final bookmarks = await loadBookmarks();

    return bookmarks.any(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber,
    );
  }

  Future<void> addBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final bookmarks = await loadBookmarks();

    final alreadyExists = bookmarks.any(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber,
    );

    if (alreadyExists) {
      return;
    }

    bookmarks.add(
      QuranBookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        createdAt: DateTime.now(),
      ),
    );

    await _saveBookmarks(bookmarks);
  }

  Future<void> removeBookmark({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final bookmarks = await loadBookmarks();

    bookmarks.removeWhere(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber,
    );

    await _saveBookmarks(bookmarks);
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final bookmarked = await isBookmarked(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );

    if (bookmarked) {
      await removeBookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
      );
    } else {
      await addBookmark(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
      );
    }
  }

  Future<void> clearBookmarks() async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _bookmarksKey,
    );
  }

  Future<void> _saveBookmarks(
    List<QuranBookmark> bookmarks,
  ) async {
    final preferences =
        await SharedPreferences.getInstance();

    final encoded = bookmarks
        .map(
          (bookmark) => jsonEncode(
            bookmark.toJson(),
          ),
        )
        .toList();

    await preferences.setStringList(
      _bookmarksKey,
      encoded,
    );
  }
}