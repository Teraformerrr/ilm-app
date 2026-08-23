import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/quran_bookmark_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const service = QuranBookmarkService();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts with no bookmarks', () async {
    final bookmarks = await service.loadBookmarks();

    expect(bookmarks, isEmpty);
  });

  test('adds a bookmark', () async {
    await service.addBookmark(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
    );

    final bookmarks = await service.loadBookmarks();

    expect(bookmarks.length, 1);
    expect(bookmarks.first.surahNumber, 1);
    expect(bookmarks.first.ayahNumber, 1);
    expect(bookmarks.first.surahName, 'Al-Fatihah');
  });

  test('does not add the same bookmark twice', () async {
    await service.addBookmark(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
    );

    await service.addBookmark(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
    );

    final bookmarks = await service.loadBookmarks();

    expect(bookmarks.length, 1);
  });

  test('checks whether an Ayah is bookmarked', () async {
    await service.addBookmark(
      surahNumber: 2,
      ayahNumber: 255,
      surahName: 'Al-Baqarah',
    );

    expect(
      await service.isBookmarked(
        surahNumber: 2,
        ayahNumber: 255,
      ),
      isTrue,
    );

    expect(
      await service.isBookmarked(
        surahNumber: 2,
        ayahNumber: 256,
      ),
      isFalse,
    );
  });

  test('removes a bookmark', () async {
    await service.addBookmark(
      surahNumber: 1,
      ayahNumber: 7,
      surahName: 'Al-Fatihah',
    );

    await service.removeBookmark(
      surahNumber: 1,
      ayahNumber: 7,
    );

    final bookmarks = await service.loadBookmarks();

    expect(bookmarks, isEmpty);
  });

  test('toggle adds and then removes bookmark', () async {
    await service.toggleBookmark(
      surahNumber: 112,
      ayahNumber: 1,
      surahName: 'Al-Ikhlas',
    );

    expect(
      await service.isBookmarked(
        surahNumber: 112,
        ayahNumber: 1,
      ),
      isTrue,
    );

    await service.toggleBookmark(
      surahNumber: 112,
      ayahNumber: 1,
      surahName: 'Al-Ikhlas',
    );

    expect(
      await service.isBookmarked(
        surahNumber: 112,
        ayahNumber: 1,
      ),
      isFalse,
    );
  });

  test('clears all bookmarks', () async {
    await service.addBookmark(
      surahNumber: 1,
      ayahNumber: 1,
      surahName: 'Al-Fatihah',
    );

    await service.addBookmark(
      surahNumber: 114,
      ayahNumber: 6,
      surahName: 'An-Nas',
    );

    await service.clearBookmarks();

    final bookmarks = await service.loadBookmarks();

    expect(bookmarks, isEmpty);
  });
}