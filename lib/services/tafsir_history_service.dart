import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tafsir_saved_item.dart';

class TafsirHistoryService {
  const TafsirHistoryService();

  static const String _recentKey = 'ilm_tafsir_recent_v1';

  static const String _bookmarksKey = 'ilm_tafsir_bookmarks_v1';

  static const int _maxRecent = 20;

  Future<List<TafsirSavedItem>> loadRecent() async {
    return _loadList(_recentKey);
  }

  Future<List<TafsirSavedItem>> loadBookmarks() async {
    return _loadList(_bookmarksKey);
  }

  Future<void> addRecent({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final items = await loadRecent();

    final id = '$surahNumber:$ayahNumber';

    items.removeWhere((item) => item.id == id);

    items.insert(
      0,
      TafsirSavedItem(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        savedAt: DateTime.now(),
      ),
    );

    if (items.length > _maxRecent) {
      items.removeRange(_maxRecent, items.length);
    }

    await _saveList(_recentKey, items);
  }

  Future<bool> isBookmarked({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final bookmarks = await loadBookmarks();

    final id = '$surahNumber:$ayahNumber';

    return bookmarks.any((item) => item.id == id);
  }

  Future<bool> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final bookmarks = await loadBookmarks();

    final id = '$surahNumber:$ayahNumber';

    final existingIndex = bookmarks.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      bookmarks.removeAt(existingIndex);

      await _saveList(_bookmarksKey, bookmarks);

      return false;
    }

    bookmarks.insert(
      0,
      TafsirSavedItem(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        savedAt: DateTime.now(),
      ),
    );

    await _saveList(_bookmarksKey, bookmarks);

    return true;
  }

  Future<void> clearRecent() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_recentKey);
  }

  Future<List<TafsirSavedItem>> _loadList(String key) async {
    final preferences = await SharedPreferences.getInstance();

    final raw = preferences.getString(key);

    if (raw == null || raw.trim().isEmpty) {
      return <TafsirSavedItem>[];
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return <TafsirSavedItem>[];
      }

      final items = <TafsirSavedItem>[];

      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          items.add(TafsirSavedItem.fromJson(item));
        } else if (item is Map) {
          items.add(TafsirSavedItem.fromJson(Map<String, dynamic>.from(item)));
        }
      }

      items.sort((a, b) => b.savedAt.compareTo(a.savedAt));

      return items;
    } catch (_) {
      return <TafsirSavedItem>[];
    }
  }

  Future<void> _saveList(String key, List<TafsirSavedItem> items) async {
    final preferences = await SharedPreferences.getInstance();

    final encoded = jsonEncode(items.map((item) => item.toJson()).toList());

    await preferences.setString(key, encoded);
  }
}
