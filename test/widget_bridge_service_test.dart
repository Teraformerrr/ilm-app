import 'package:flutter_test/flutter_test.dart';
import 'package:ilm/models/daily_widget_content.dart';
import 'package:ilm/services/daily_widget_content_service.dart';

void main() {
  const dailyService = DailyWidgetContentService();

  test('widget content has all fields required by native widget', () {
    final content = dailyService.getContentForDate(DateTime(2026, 8, 21));

    expect(content, isA<DailyWidgetContent>());

    expect(content.dateKey, '2026-08-21');

    expect(content.ayahArabic.trim(), isNotEmpty);

    expect(content.ayahTranslation.trim(), isNotEmpty);

    expect(content.ayahReference.trim(), isNotEmpty);

    expect(content.hadithText.trim(), isNotEmpty);

    expect(content.hadithReference.trim(), isNotEmpty);

    expect(content.surahNumber, inInclusiveRange(1, 114));

    expect(content.ayahNumber, greaterThan(0));
  });

  test('consecutive days produce valid daily widget content', () {
    final first = dailyService.getContentForDate(DateTime(2026, 8, 21));

    final second = dailyService.getContentForDate(DateTime(2026, 8, 22));

    expect(first.dateKey, isNot(second.dateKey));

    expect(first.ayahReference.trim(), isNotEmpty);

    expect(second.ayahReference.trim(), isNotEmpty);
  });
}
