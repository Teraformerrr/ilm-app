import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

ARABIC_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_symbols_ar.json"
)

ENGLISH_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_english_full.json"
)


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    sys.exit(1)


def main() -> None:
    arabic = json.loads(
        ARABIC_FILE.read_text(
            encoding="utf-8",
        )
    )

    english = json.loads(
        ENGLISH_FILE.read_text(
            encoding="utf-8",
        )
    )

    arabic_entries = arabic.get(
        "symbols"
    )

    english_entries = english.get(
        "translations"
    )

    if not isinstance(
        arabic_entries,
        list,
    ):
        fail(
            "Arabic symbol list is invalid."
        )

    if not isinstance(
        english_entries,
        list,
    ):
        fail(
            "English translation list is invalid."
        )

    if len(arabic_entries) != len(
        english_entries
    ):
        fail(
            "Arabic/English entry count mismatch. "
            f"Arabic: {len(arabic_entries)}, "
            f"English: {len(english_entries)}"
        )

    arabic_by_id = {
        entry["id"]: entry
        for entry in arabic_entries
    }

    seen_ids = set()

    pending = 0
    translated = 0

    allowed_statuses = {
        "pending",
        "machine_unreviewed",
        "reviewed",
    }

    for english_entry in english_entries:
        entry_id = english_entry.get(
            "id"
        )

        if not entry_id:
            fail(
                "English entry has no ID."
            )

        if entry_id in seen_ids:
            fail(
                f"Duplicate English ID: "
                f"{entry_id}"
            )

        seen_ids.add(
            entry_id
        )

        arabic_entry = arabic_by_id.get(
            entry_id
        )

        if arabic_entry is None:
            fail(
                f"English entry references "
                f"unknown Arabic ID: {entry_id}"
            )

        expected_title = arabic_entry.get(
            "titleArabic"
        )

        actual_title = english_entry.get(
            "titleArabic"
        )

        if expected_title != actual_title:
            fail(
                f"Arabic title mismatch for "
                f"{entry_id}.\n"
                f"Expected: {expected_title}\n"
                f"Found:    {actual_title}"
            )

        status = english_entry.get(
            "translationStatus"
        )

        if status not in allowed_statuses:
            fail(
                f"Invalid translation status "
                f"for {entry_id}: {status}"
            )

        title_english = (
            english_entry.get(
                "titleEnglish"
            )
            or ""
        ).strip()

        interpretation_english = (
            english_entry.get(
                "interpretationEnglish"
            )
            or ""
        ).strip()

        if status == "pending":
            pending += 1

            if (
                title_english
                or interpretation_english
            ):
                fail(
                    f"Pending entry {entry_id} "
                    f"already contains English text."
                )

        else:
            translated += 1

            if not title_english:
                fail(
                    f"Translated entry "
                    f"{entry_id} has no "
                    f"English title."
                )

            if not interpretation_english:
                fail(
                    f"Translated entry "
                    f"{entry_id} has no "
                    f"English interpretation."
                )

    missing_ids = (
        set(arabic_by_id)
        - seen_ids
    )

    if missing_ids:
        fail(
            f"{len(missing_ids)} Arabic "
            f"entries have no English record."
        )

    print(
        "Nabulsi English translation "
        "validation passed."
    )

    print(
        f"Arabic entries: "
        f"{len(arabic_entries)}"
    )

    print(
        f"English records: "
        f"{len(english_entries)}"
    )

    print(
        f"Pending: {pending}"
    )

    print(
        f"Translated: {translated}"
    )


if __name__ == "__main__":
    main()