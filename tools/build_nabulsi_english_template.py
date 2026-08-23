import csv
import json
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

CSV_FILE = (
    PROJECT_ROOT
    / "tools"
    / "nabulsi_translation_work.csv"
)

OUTPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_english_full.json"
)


def main():
    rows = []

    with CSV_FILE.open(
        "r",
        encoding="utf-8-sig",
        newline="",
    ) as file:
        reader = csv.DictReader(file)

        for row in reader:
            rows.append(
                {
                    "id": row["id"],
                    "titleArabic":
                        row["title_arabic"],
                    "titleEnglish":
                        row["title_english"],
                    "interpretationEnglish":
                        row["interpretation_english"],
                    "englishKeywords": [],
                    "translationStatus":
                        "pending",
                }
            )

    output = {
        "schemaVersion": 1,
        "sourceId":
            "nabulsi_tatir_al_anam",
        "translationLanguage":
            "en",
        "translationType":
            "secondary_translation",
        "entryCount":
            len(rows),
        "translations":
            rows,
    }

    OUTPUT_FILE.write_text(
        json.dumps(
            output,
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )

    print(
        "Nabulsi English translation template created."
    )
    print(
        f"Entries: {len(rows)}"
    )
    print(
        f"Created: {OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()