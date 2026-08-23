import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../models/daily_widget_content.dart';
import 'daily_widget_content_service.dart';

class WidgetBridgeService {
  const WidgetBridgeService();

  static const String androidCombinedWidgetName =
      'IlmDailyWidgetProvider';

  static const String androidAyahWidgetName =
      'IlmAyahWidgetProvider';

  static const String androidHadithWidgetName =
      'IlmHadithWidgetProvider';

  static const String keyDate =
      'ilm_widget_date';

  static const String keyAyahArabic =
      'ilm_widget_ayah_arabic';

  static const String keyAyahTranslation =
      'ilm_widget_ayah_translation';

  static const String keyAyahReference =
      'ilm_widget_ayah_reference';

  static const String keySurahNumber =
      'ilm_widget_surah_number';

  static const String keyAyahNumber =
      'ilm_widget_ayah_number';

  static const String keyHadithText =
      'ilm_widget_hadith_text';

  static const String keyHadithReference =
      'ilm_widget_hadith_reference';

  static const String keyContentType =
      'ilm_widget_content_type';

  static const String keyLastUpdated =
      'ilm_widget_last_updated';

  Future<void> syncToday() async {
    if (!Platform.isAndroid) {
      return;
    }

    const contentService =
        DailyWidgetContentService();

    final content =
        contentService.getTodayContent();

    await syncContent(
      content,
    );
  }

  Future<void> syncContent(
    DailyWidgetContent content,
  ) async {
    if (!Platform.isAndroid) {
      return;
    }

    await Future.wait([
      HomeWidget.saveWidgetData<String>(
        keyDate,
        content.dateKey,
      ),
      HomeWidget.saveWidgetData<String>(
        keyAyahArabic,
        content.ayahArabic,
      ),
      HomeWidget.saveWidgetData<String>(
        keyAyahTranslation,
        content.ayahTranslation,
      ),
      HomeWidget.saveWidgetData<String>(
        keyAyahReference,
        content.ayahReference,
      ),
      HomeWidget.saveWidgetData<int>(
        keySurahNumber,
        content.surahNumber,
      ),
      HomeWidget.saveWidgetData<int>(
        keyAyahNumber,
        content.ayahNumber,
      ),
      HomeWidget.saveWidgetData<String>(
        keyHadithText,
        content.hadithText,
      ),
      HomeWidget.saveWidgetData<String>(
        keyHadithReference,
        content.hadithReference,
      ),
      HomeWidget.saveWidgetData<String>(
        keyContentType,
        _contentTypeForDate(
          content.date,
        ),
      ),
      HomeWidget.saveWidgetData<String>(
        keyLastUpdated,
        DateTime.now().toIso8601String(),
      ),
    ]);

    await refreshWidgets();
  }

  Future<void> refreshWidgets() async {
    if (!Platform.isAndroid) {
      return;
    }

    await Future.wait([
      HomeWidget.updateWidget(
        name:
            androidCombinedWidgetName,
        androidName:
            androidCombinedWidgetName,
      ),
      HomeWidget.updateWidget(
        name:
            androidAyahWidgetName,
        androidName:
            androidAyahWidgetName,
      ),
      HomeWidget.updateWidget(
        name:
            androidHadithWidgetName,
        androidName:
            androidHadithWidgetName,
      ),
    ]);
  }

  Future<bool> hasWidgetData() async {
    if (!Platform.isAndroid) {
      return false;
    }

    final date =
        await HomeWidget
            .getWidgetData<String>(
      keyDate,
    );

    return date != null &&
        date.trim().isNotEmpty;
  }

  Future<bool> needsDailyRefresh() async {
    if (!Platform.isAndroid) {
      return false;
    }

    final storedDate =
        await HomeWidget
            .getWidgetData<String>(
      keyDate,
    );

    return storedDate !=
        _dateKey(
          DateTime.now(),
        );
  }

  Future<void> syncIfNeeded() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await needsDailyRefresh()) {
      return;
    }

    await syncToday();
  }

  Future<void> syncIfNeededSafely() async {
    try {
      await syncIfNeeded();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'ILM widget sync failed: $error',
        );

        debugPrintStack(
          stackTrace:
              stackTrace,
        );
      }
    }
  }

  Future<void> syncTodaySafely() async {
    try {
      await syncToday();
    } catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'ILM widget sync failed: $error',
        );

        debugPrintStack(
          stackTrace:
              stackTrace,
        );
      }
    }
  }

  String _contentTypeForDate(
    DateTime date,
  ) {
    final normalized =
        DateTime(
      date.year,
      date.month,
      date.day,
    );

    final number =
        normalized
            .difference(
              DateTime(
                2026,
                1,
                1,
              ),
            )
            .inDays;

    return number.isEven
        ? 'ayah'
        : 'hadith';
  }

  String _dateKey(
    DateTime date,
  ) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}