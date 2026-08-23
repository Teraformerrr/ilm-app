import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/services/daily_widget_content_service.dart';

void main() {
  const service = DailyWidgetContentService();

  test('same date always returns same widget content', () {
    final date = DateTime(2026, 8, 21);

    final first = service.getContentForDate(date);

    final second = service.getContentForDate(date);

    expect(first.ayahReference, second.ayahReference);

    expect(first.ayahArabic, second.ayahArabic);

    expect(first.hadithText, second.hadithText);

    expect(first.hadithReference, second.hadithReference);
  });

  test('daily widget content contains valid religious references', () {
    final content = service.getContentForDate(DateTime(2026, 8, 21));

    expect(content.ayahArabic.trim().isNotEmpty, true);

    expect(content.ayahTranslation.trim().isNotEmpty, true);

    expect(content.ayahReference.trim().isNotEmpty, true);

    expect(content.hadithText.trim().isNotEmpty, true);

    expect(content.hadithReference.trim().isNotEmpty, true);

    expect(content.surahNumber, greaterThanOrEqualTo(1));

    expect(content.surahNumber, lessThanOrEqualTo(114));

    expect(content.ayahNumber, greaterThan(0));
  });

  test('date key is stable', () {
    final content = service.getContentForDate(DateTime(2026, 8, 21, 18, 30));

    expect(content.dateKey, '2026-08-21');
  });
}
