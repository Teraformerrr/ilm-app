import csv
import json
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

SOURCE_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_symbols_ar.json"
)

OUTPUT_FILE = (
    PROJECT_ROOT
    / "tools"
    / "nabulsi_translation_work.csv"
)


def main():
    data = json.loads(
        SOURCE_FILE.read_text(
            encoding="utf-8",
        )
    )

    symbols = data["symbols"]

    with OUTPUT_FILE.open(
        "w",
        encoding="utf-8-sig",
        newline="",
    ) as file:
        writer = csv.writer(file)

        writer.writerow(
            [
                "id",
                "title_arabic",
                "title_english",
                "interpretation_arabic",
                "interpretation_english",
            ]
        )

        for symbol in symbols:
            writer.writerow(
                [
                    symbol["id"],
                    symbol["titleArabic"],
                    "",
                    symbol["interpretationArabic"],
                    "",
                ]
            )

    print(
        "Nabulsi English translation work file created."
    )

    print(
        f"Entries: {len(symbols)}"
    )

    print(
        f"Created: {OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()