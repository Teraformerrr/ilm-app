import 'package:flutter_test/flutter_test.dart';

import 'package:ilm/data/adhkar/adhkar_library.dart';
import 'package:ilm/models/dua_adhkar_item.dart';

void main() {
  group(
    'AdhkarLibrary integrity',
    () {
      test(
        'library is not empty',
        () {
          expect(
            AdhkarLibrary.allItems,
            isNotEmpty,
          );
        },
      );

      test(
        'all item IDs are unique',
        () {
          final duplicates =
              AdhkarLibrary.duplicateIds();

          expect(
            duplicates,
            isEmpty,
            reason:
                'Duplicate DuaAdhkarItem IDs found: '
                '${duplicates.join(', ')}',
          );
        },
      );

      test(
        'required text fields are not empty',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            expect(
              item.id.trim(),
              isNotEmpty,
              reason:
                  'An item has an empty id.',
            );

            expect(
              item.title.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has an empty title.',
            );

            expect(
              item.categoryId.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has an empty categoryId.',
            );

            expect(
              item.arabic.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has empty Arabic text.',
            );

            expect(
              item.transliteration.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has empty transliteration.',
            );

            expect(
              item.englishTranslation.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has empty English translation.',
            );

            expect(
              item.reference.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has an empty reference.',
            );
          }
        },
      );

      test(
        'repeat counts are positive when present',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final repeatCount =
                item.repeatCount;

            if (repeatCount == null) {
              continue;
            }

            expect(
              repeatCount,
              greaterThan(0),
              reason:
                  'Item ${item.id} has invalid '
                  'repeatCount $repeatCount.',
            );
          }
        },
      );

      test(
        'Quran locations are valid',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final location =
                item.quranLocation;

            if (location == null) {
              continue;
            }

            expect(
              location.surahNumber,
              inInclusiveRange(
                1,
                114,
              ),
              reason:
                  'Item ${item.id} has invalid '
                  'surah number '
                  '${location.surahNumber}.',
            );

            expect(
              location.startAyah,
              greaterThan(0),
              reason:
                  'Item ${item.id} has invalid '
                  'start ayah '
                  '${location.startAyah}.',
            );

            final endAyah =
                location.endAyah;

            if (endAyah != null) {
              expect(
                endAyah,
                greaterThanOrEqualTo(
                  location.startAyah,
                ),
                reason:
                    'Item ${item.id} has endAyah '
                    '$endAyah before startAyah '
                    '${location.startAyah}.',
              );
            }
          }
        },
      );

      test(
        'Quran source items use Quran authenticity',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (item.sourceType !=
                DuaSourceType.quran) {
              continue;
            }

            expect(
              item.authenticity,
              DuaAuthenticity.quran,
              reason:
                  'Quran item ${item.id} '
                  'should use '
                  'DuaAuthenticity.quran.',
            );
          }
        },
      );

      test(
        'Quran authenticity items use Quran source',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (item.authenticity !=
                DuaAuthenticity.quran) {
              continue;
            }

            expect(
              item.sourceType,
              DuaSourceType.quran,
              reason:
                  'Item ${item.id} is marked '
                  'as Quran authenticity but '
                  'is not a Quran source.',
            );
          }
        },
      );

      test(
        'Quran locations belong only to Quran items',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (item.quranLocation == null) {
              continue;
            }

            expect(
              item.sourceType,
              DuaSourceType.quran,
              reason:
                  'Item ${item.id} has a '
                  'QuranLocation but sourceType '
                  'is ${item.sourceType}.',
            );
          }
        },
      );

      test(
        'structured references are valid',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            for (final reference
                in item.references) {
              expect(
                reference.source.trim(),
                isNotEmpty,
                reason:
                    'Item ${item.id} has a '
                    'structured reference with '
                    'an empty source.',
              );

              expect(
                reference.reference.trim(),
                isNotEmpty,
                reason:
                    'Item ${item.id} has a '
                    'structured reference with '
                    'an empty reference.',
              );
            }
          }
        },
      );

      test(
        'weak and disputed items include explanation',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final requiresNote =
                item.authenticity ==
                        DuaAuthenticity.weak ||
                    item.authenticity ==
                        DuaAuthenticity.disputed;

            if (!requiresNote) {
              continue;
            }

            expect(
              item.hasAuthenticityNote,
              isTrue,
              reason:
                  'Weak/disputed item '
                  '${item.id} must include '
                  'authenticityNote.',
            );
          }
        },
      );

      test(
        'items requiring method instruction have method text',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (!item
                .requiresMethodInstruction) {
              continue;
            }

            expect(
              item.hasMethod,
              isTrue,
              reason:
                  'Item ${item.id} requires '
                  'method instructions but '
                  'has no method.',
            );
          }
        },
      );

      test(
        'directly sourced benefits contain benefit text',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (!item
                .benefitDirectlySourced) {
              continue;
            }

            expect(
              item.hasBenefit,
              isTrue,
              reason:
                  'Item ${item.id} marks '
                  'its benefit as directly '
                  'sourced but has no benefit text.',
            );

            expect(
              item.reference.trim(),
              isNotEmpty,
              reason:
                  'Item ${item.id} has a '
                  'sourced benefit but no '
                  'reference.',
            );
          }
        },
      );

      test(
        'general duas use notApplicable authenticity',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (item.sourceType !=
                DuaSourceType.generalDua) {
              continue;
            }

            expect(
              item.authenticity,
              DuaAuthenticity.notApplicable,
              reason:
                  'General dua ${item.id} '
                  'should use '
                  'DuaAuthenticity.notApplicable.',
            );
          }
        },
      );

      test(
        'user routines use notApplicable authenticity',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            if (item.sourceType !=
                DuaSourceType.userRoutine) {
              continue;
            }

            expect(
              item.authenticity,
              DuaAuthenticity.notApplicable,
              reason:
                  'User routine ${item.id} '
                  'should use '
                  'DuaAuthenticity.notApplicable.',
            );
          }
        },
      );

      test(
        'all category IDs are normalized',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final categoryId =
                item.categoryId;

            expect(
              categoryId,
              categoryId
                  .trim()
                  .toLowerCase(),
              reason:
                  'Item ${item.id} has '
                  'non-normalized categoryId: '
                  '$categoryId.',
            );

            expect(
              categoryId.contains(' '),
              isFalse,
              reason:
                  'Item ${item.id} '
                  'categoryId contains spaces.',
            );
          }
        },
      );

      test(
        'all item IDs are normalized',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final id =
                item.id;

            expect(
              id,
              id
                  .trim()
                  .toLowerCase(),
              reason:
                  'Item ID is not normalized: '
                  '$id.',
            );

            expect(
              id.contains(' '),
              isFalse,
              reason:
                  'Item ID contains spaces: '
                  '$id.',
            );
          }
        },
      );

      test(
        'library category map contains every item',
        () {
          final categories =
              AdhkarLibrary.itemsByCategory;

          var mappedCount = 0;

          for (final items
              in categories.values) {
            mappedCount +=
                items.length;
          }

          expect(
            mappedCount,
            AdhkarLibrary.allItems.length,
            reason:
                'itemsByCategory does not '
                'contain every library item.',
          );
        },
      );

      test(
        'findById returns every item',
        () {
          for (final item
              in AdhkarLibrary.allItems) {
            final found =
                AdhkarLibrary.findById(
              item.id,
            );

            expect(
              found,
              isNotNull,
              reason:
                  'findById could not find '
                  '${item.id}.',
            );

            expect(
              found!.id,
              item.id,
            );
          }
        },
      );
    },
  );
}