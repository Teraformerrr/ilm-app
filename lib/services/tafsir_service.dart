import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/tafsir_entry.dart';

class TafsirService {
  const TafsirService({this._client});

  final http.Client? _client;

  static const String _sourceId = 'ibn_kathir_en';

  static const String _sourceName = 'Tafsir Ibn Kathir';

  /// Local ILM backend during development.
  ///
  /// Your Windows PC Wi-Fi address:
  /// 192.168.1.26
  ///
  /// Your phone must be connected to the same Wi-Fi.
  static const String backendBaseUrl = 'http://192.168.1.26:8787';

  Future<TafsirEntry?> loadIbnKathirAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    _validateReference(surahNumber: surahNumber, ayahNumber: ayahNumber);

    final client = _client ?? http.Client();

    try {
      final uri = Uri.parse(
        '$backendBaseUrl/api/tafsir/ibn-kathir',
      ).replace(queryParameters: {'verse': '$surahNumber:$ayahNumber'});

      final response = await client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 404) {
        return null;
      }

      if (response.statusCode != 200) {
        throw TafsirServiceException(
          'Tafsir request failed with HTTP '
          '${response.statusCode}.',
        );
      }

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (decoded is! Map<String, dynamic>) {
        throw const TafsirServiceException('Invalid Tafsir response.');
      }

      final returnedSurah = decoded['surahNumber'];

      final returnedAyah = decoded['ayahNumber'];

      final rawText = decoded['text'];

      final returnedSource = decoded['sourceName'];

      final returnedVerseKey = decoded['verseKey'];

      if (returnedSurah is! int || returnedAyah is! int || rawText is! String) {
        throw const TafsirServiceException(
          'Tafsir response is missing required fields.',
        );
      }

      if (returnedSurah != surahNumber || returnedAyah != ayahNumber) {
        throw TafsirServiceException(
          'Tafsir mapping mismatch. '
          'Requested $surahNumber:$ayahNumber but '
          'received $returnedSurah:$returnedAyah.',
        );
      }

      final expectedVerseKey = '$surahNumber:$ayahNumber';

      if (returnedVerseKey is String &&
          returnedVerseKey.isNotEmpty &&
          returnedVerseKey != expectedVerseKey) {
        throw TafsirServiceException(
          'Tafsir verse key mismatch. '
          'Requested $expectedVerseKey but '
          'received $returnedVerseKey.',
        );
      }

      final text = _cleanTafsirText(rawText);

      if (text.isEmpty) {
        throw const TafsirServiceException('Tafsir text is empty.');
      }

      return TafsirEntry(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        text: text,
        sourceId: _sourceId,
        sourceName: returnedSource is String && returnedSource.trim().isNotEmpty
            ? returnedSource.trim()
            : _sourceName,
        languageCode: 'en',
      );
    } on TafsirServiceException {
      rethrow;
    } on http.ClientException catch (error) {
      throw TafsirServiceException(
        'Could not connect to the ILM Tafsir server. '
        '${error.message}',
      );
    } catch (error) {
      throw TafsirServiceException('Unable to load Tafsir. $error');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  String _cleanTafsirText(String value) {
    var text = value;

    text = text.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

    text = text.replaceAll(RegExp(r'</p\s*>', caseSensitive: false), '\n\n');

    text = text.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '');

    text = text.replaceAll(RegExp(r'<h[1-6][^>]*>', caseSensitive: false), '');

    text = text.replaceAll(
      RegExp(r'</h[1-6]\s*>', caseSensitive: false),
      '\n\n',
    );

    text = text.replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '• ');

    text = text.replaceAll(RegExp(r'</li\s*>', caseSensitive: false), '\n');

    text = text.replaceAll(
      RegExp(r'</?(ul|ol)[^>]*>', caseSensitive: false),
      '\n',
    );

    text = text.replaceAll(RegExp(r'<[^>]+>', caseSensitive: false), '');

    text = _decodeHtmlEntities(text);

    text = text.replaceAll('\r\n', '\n');

    text = text.replaceAll('\r', '\n');

    text = text.replaceAll(RegExp(r'[ \t]+\n'), '\n');

    text = text.replaceAll(RegExp(r'[ \t]{2,}'), ' ');

    text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    return text.trim();
  }

  String _decodeHtmlEntities(String value) {
    return value
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#160;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#34;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&apos;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }

  void _validateReference({required int surahNumber, required int ayahNumber}) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw ArgumentError.value(
        surahNumber,
        'surahNumber',
        'Surah number must be between 1 and 114.',
      );
    }

    if (ayahNumber < 1) {
      throw ArgumentError.value(
        ayahNumber,
        'ayahNumber',
        'Ayah number must be greater than 0.',
      );
    }
  }
}

class TafsirServiceException implements Exception {
  const TafsirServiceException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
