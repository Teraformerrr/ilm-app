import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DuaAdhkarProgressService {
  const DuaAdhkarProgressService();

  static const String _progressPrefix =
      'ilm_dua_adhkar_progress_v1';

  Future<Map<String, int>> loadProgress({
    required String categoryId,
    required DateTime date,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    final key =
        _storageKey(
      categoryId: categoryId,
      date: date,
    );

    final raw =
        preferences.getString(
      key,
    );

    if (raw == null ||
        raw.trim().isEmpty) {
      return <String, int>{};
    }

    try {
      final decoded =
          jsonDecode(
        raw,
      );

      if (decoded is! Map) {
        return <String, int>{};
      }

      final result =
          <String, int>{};

      for (final entry
          in decoded.entries) {
        final itemId =
            entry.key.toString();

        final value =
            entry.value;

        if (value is int) {
          result[itemId] =
              value;
        } else if (value is num) {
          result[itemId] =
              value.toInt();
        }
      }

      return result;
    } catch (_) {
      return <String, int>{};
    }
  }

  Future<void> saveProgress({
    required String categoryId,
    required DateTime date,
    required Map<String, int> counts,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    final key =
        _storageKey(
      categoryId: categoryId,
      date: date,
    );

    if (counts.isEmpty) {
      await preferences.remove(
        key,
      );

      return;
    }

    await preferences.setString(
      key,
      jsonEncode(
        counts,
      ),
    );
  }

  Future<void> clearProgress({
    required String categoryId,
    required DateTime date,
  }) async {
    final preferences =
        await SharedPreferences.getInstance();

    await preferences.remove(
      _storageKey(
        categoryId: categoryId,
        date: date,
      ),
    );
  }

  Future<void> clearAllAdhkarProgress() async {
    final preferences =
        await SharedPreferences.getInstance();

    final keys =
        preferences.getKeys();

    final progressKeys =
        keys
            .where(
              (
                key,
              ) =>
                  key.startsWith(
                _progressPrefix,
              ),
            )
            .toList();

    for (final key
        in progressKeys) {
      await preferences.remove(
        key,
      );
    }
  }

  String _storageKey({
    required String categoryId,
    required DateTime date,
  }) {
    final normalizedCategory =
        categoryId
            .trim()
            .toLowerCase();

    return '${_progressPrefix}_'
        '${normalizedCategory}_'
        '${_dateKey(date)}';
  }

  String _dateKey(
    DateTime date,
  ) {
    final year =
        date.year
            .toString()
            .padLeft(
              4,
              '0',
            );

    final month =
        date.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    final day =
        date.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$year-$month-$day';
  }
}