import '../../models/dua_adhkar_item.dart';

import 'debt_rizq_adhkar.dart';
import 'distress_adhkar.dart';
import 'family_children_adhkar.dart';
import 'fasting_adhkar.dart';
import 'food_drink_adhkar.dart';
import 'forgiveness_adhkar.dart';
import 'gathering_adhkar.dart';
import 'general_dhikr.dart';
import 'home_adhkar.dart';
import 'illness_healing_adhkar.dart';
import 'marriage_adhkar.dart';
import 'mosque_adhkar.dart';
import 'protection_adhkar.dart';
import 'prophetic_duas.dart';
import 'quranic_duas.dart';
import 'restroom_adhkar.dart';
import 'ruqyah_adhkar.dart';
import 'sleep_adhkar.dart';
import 'sneezing_adhkar.dart';
import 'social_daily_adhkar.dart';
import 'travel_adhkar.dart';
import 'waking_adhkar.dart';
import 'weather_adhkar.dart';
import 'wudu_adhkar.dart';

class AdhkarLibrary {
  const AdhkarLibrary._();

  static const List<DuaAdhkarItem>
      allItems = [
    ...sleepAdhkar,
    ...wakingAdhkar,
    ...foodDrinkAdhkar,
    ...homeAdhkar,
    ...restroomAdhkar,
    ...wuduAdhkar,
    ...mosqueAdhkar,
    ...travelAdhkar,
    ...weatherAdhkar,
    ...protectionAdhkar,
    ...illnessHealingAdhkar,
    ...distressAdhkar,
    ...debtRizqAdhkar,
    ...forgivenessAdhkar,
    ...ruqyahAdhkar,
    ...familyChildrenAdhkar,
    ...marriageAdhkar,
    ...fastingAdhkar,
    ...sneezingAdhkar,
    ...gatheringAdhkar,
    ...socialDailyAdhkar,
    ...quranicDuas,
    ...propheticDuas,
    ...generalDhikr,
  ];

  static List<DuaAdhkarItem>
      byCategory(
    String categoryId,
  ) {
    final normalized =
        categoryId
            .trim()
            .toLowerCase();

    return allItems.where(
      (
        item,
      ) {
        return item.categoryId
                .trim()
                .toLowerCase() ==
            normalized;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      byOccasion(
    DuaOccasion occasion,
  ) {
    return allItems.where(
      (
        item,
      ) {
        return item.occasions
            .contains(
          occasion,
        );
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      search(
    String query,
  ) {
    final normalized =
        query
            .trim()
            .toLowerCase();

    if (normalized.isEmpty) {
      return allItems;
    }

    return allItems.where(
      (
        item,
      ) {
        for (final term
            in item.searchableTerms) {
          if (term
              .toLowerCase()
              .contains(
                normalized,
              )) {
            return true;
          }
        }

        if (item.arabic
            .contains(
          query.trim(),
        )) {
          return true;
        }

        if (item.hasUrduTranslation &&
            item.urduTranslation!
                .contains(
              query.trim(),
            )) {
          return true;
        }

        return false;
      },
    ).toList();
  }

  static DuaAdhkarItem?
      findById(
    String id,
  ) {
    for (final item
        in allItems) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }

  static List<DuaAdhkarItem>
      get ruqyahItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isRuqyah;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get protectionItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isProtection;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get healingItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isHealing;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get quranicItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isQuranicDua ||
            item.isQuran;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get propheticItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isPropheticDua;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get generalDhikrItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isGeneralDhikr;
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get morningItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isMorning ||
            item.occasions.contains(
              DuaOccasion.morning,
            );
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get eveningItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isEvening ||
            item.occasions.contains(
              DuaOccasion.evening,
            );
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get sleepItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isSleep ||
            item.occasions.contains(
              DuaOccasion.beforeSleep,
            );
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get wakingItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isWakeUp ||
            item.occasions.contains(
              DuaOccasion.afterWaking,
            );
      },
    ).toList();
  }

  static List<DuaAdhkarItem>
      get weakOrDisputedItems {
    return allItems.where(
      (
        item,
      ) {
        return item.isWeakOrDisputed;
      },
    ).toList();
  }

  static Map<String, List<DuaAdhkarItem>>
      get itemsByCategory {
    final result =
        <String, List<DuaAdhkarItem>>{};

    for (final item
        in allItems) {
      result.putIfAbsent(
        item.categoryId,
        () =>
            <DuaAdhkarItem>[],
      );

      result[item.categoryId]!
          .add(
        item,
      );
    }

    return result;
  }

  static Set<String>
      get categoryIds {
    return allItems
        .map(
          (
            item,
          ) =>
              item.categoryId,
        )
        .toSet();
  }

  static Set<String>
      get allTags {
    final tags =
        <String>{};

    for (final item
        in allItems) {
      tags.addAll(
        item.tags,
      );
    }

    return tags;
  }

  static List<DuaAdhkarItem>
      byTag(
    String tag,
  ) {
    final normalized =
        tag
            .trim()
            .toLowerCase();

    return allItems.where(
      (
        item,
      ) {
        return item.tags.any(
          (
            itemTag,
          ) =>
              itemTag
                  .toLowerCase() ==
              normalized,
        );
      },
    ).toList();
  }

  static List<String>
      duplicateIds() {
    final seen =
        <String>{};

    final duplicates =
        <String>{};

    for (final item
        in allItems) {
      if (!seen.add(
        item.id,
      )) {
        duplicates.add(
          item.id,
        );
      }
    }

    final result =
        duplicates.toList()
          ..sort();

    return result;
  }

  static bool get hasDuplicateIds {
    return duplicateIds()
        .isNotEmpty;
  }
}