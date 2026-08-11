import csv
import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

INPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_urdu_junagarhi_source.csv"
)

METADATA_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_surahs.json"
)

OUTPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_urdu_junagarhi.json"
)

SOURCE_INFO_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_urdu_junagarhi_source_info.json"
)


def fail(message):
    print(f"ERROR: {message}")
    sys.exit(1)


def load_metadata():
    if not METADATA_FILE.exists():
        fail(
            f"Could not find metadata file: "
            f"{METADATA_FILE}"
        )

    with METADATA_FILE.open(
        "r",
        encoding="utf-8",
    ) as file:
        metadata = json.load(file)

    if len(metadata) != 114:
        fail(
            f"Expected 114 Surahs in metadata, "
            f"found {len(metadata)}."
        )

    return {
        surah["number"]: surah["ayahCount"]
        for surah in metadata
    }


def read_source_info():
    if not INPUT_FILE.exists():
        fail(
            f"Could not find Urdu source: "
            f"{INPUT_FILE}"
        )

    header_lines = []

    with INPUT_FILE.open(
        "r",
        encoding="utf-8-sig",
        newline="",
    ) as file:
        for line in file:
            header_lines.append(line.rstrip("\n\r"))

            if line.strip().startswith(
                "# PLEASE DON'T REMOVE"
            ):
                break

    joined = "\n".join(header_lines)

    required_markers = [
        "Translation ID: urdu_junagarhi",
        "Source: https://quranenc.com",
        "v1.1.3-csv.1",
    ]

    for marker in required_markers:
        if marker not in joined:
            fail(
                f"Required QuranEnc source marker "
                f"not found: {marker}"
            )

    return {
        "translationId": "urdu_junagarhi",
        "language": "Urdu",
        "publisher": "QuranEnc",
        "source": "https://quranenc.com",
        "version": "v1.1.3-csv.1",
        "lastUpdate": "2025-08-13",
    }


def find_csv_start(lines):
    for index, line in enumerate(lines):
        if line.strip() == (
            "id,sura,aya,translation,footnotes"
        ):
            return index

    return None


def main():
    if not INPUT_FILE.exists():
        fail(
            f"Could not find Urdu source: "
            f"{INPUT_FILE}"
        )

    expected_counts = load_metadata()

    source_info = read_source_info()

    with INPUT_FILE.open(
        "r",
        encoding="utf-8-sig",
        newline="",
    ) as file:
        all_lines = file.readlines()

    csv_start = find_csv_start(
        all_lines
    )

    if csv_start is None:
        fail(
            "Could not find CSV column header."
        )

    csv_lines = all_lines[
        csv_start:
    ]

    reader = csv.DictReader(
        csv_lines
    )

    required_columns = {
        "id",
        "sura",
        "aya",
        "translation",
        "footnotes",
    }

    if reader.fieldnames is None:
        fail(
            "CSV header could not be read."
        )

    if set(reader.fieldnames) != required_columns:
        fail(
            f"Unexpected CSV columns: "
            f"{reader.fieldnames}"
        )

    translations = {}
    surah_counts = {
        surah_number: 0
        for surah_number in range(
            1,
            115,
        )
    }

    for row_number, row in enumerate(
        reader,
        start=csv_start + 2,
    ):
        try:
            surah_number = int(
                row["sura"]
            )

            ayah_number = int(
                row["aya"]
            )
        except (
            TypeError,
            ValueError,
        ):
            fail(
                f"Invalid Surah/Ayah number "
                f"near source line "
                f"{row_number}."
            )

        if (
            surah_number < 1
            or surah_number > 114
        ):
            fail(
                f"Invalid Surah number "
                f"{surah_number}."
            )

        expected_count = (
            expected_counts[
                surah_number
            ]
        )

        if (
            ayah_number < 1
            or ayah_number > expected_count
        ):
            fail(
                f"Invalid Ayah "
                f"{surah_number}:"
                f"{ayah_number}. "
                f"Expected range "
                f"1-{expected_count}."
            )

        translation = (
            row["translation"] or ""
        ).strip()

        if not translation:
            fail(
                f"Empty Urdu translation at "
                f"{surah_number}:"
                f"{ayah_number}."
            )

        key = (
            surah_number,
            ayah_number,
        )

        if key in translations:
            fail(
                f"Duplicate Urdu translation: "
                f"{surah_number}:"
                f"{ayah_number}."
            )

        translations[key] = (
            translation
        )

        surah_counts[
            surah_number
        ] += 1

    if len(translations) != 6236:
        fail(
            f"Expected 6236 Urdu "
            f"translations, found "
            f"{len(translations)}."
        )

    output = []

    for surah_number in range(
        1,
        115,
    ):
        expected_count = (
            expected_counts[
                surah_number
            ]
        )

        actual_count = (
            surah_counts[
                surah_number
            ]
        )

        if actual_count != expected_count:
            fail(
                f"Surah {surah_number} "
                f"contains {actual_count} "
                f"Urdu translations, "
                f"expected "
                f"{expected_count}."
            )

        for ayah_number in range(
            1,
            expected_count + 1,
        ):
            key = (
                surah_number,
                ayah_number,
            )

            if key not in translations:
                fail(
                    f"Missing Urdu "
                    f"translation: "
                    f"{surah_number}:"
                    f"{ayah_number}."
                )

            output.append(
                {
                    "surahNumber":
                        surah_number,
                    "ayahNumber":
                        ayah_number,
                    "translation":
                        translations[key],
                }
            )

    with OUTPUT_FILE.open(
        "w",
        encoding="utf-8",
    ) as file:
        json.dump(
            output,
            file,
            ensure_ascii=False,
            indent=2,
        )

    with SOURCE_INFO_FILE.open(
        "w",
        encoding="utf-8",
    ) as file:
        json.dump(
            source_info,
            file,
            ensure_ascii=False,
            indent=2,
        )

    print(
        "Urdu translation validation passed."
    )
    print(
        "Translation: Muhammad Junagarhi"
    )
    print(
        "Source: QuranEnc"
    )
    print(
        "Version: v1.1.3-csv.1"
    )
    print(
        "Surahs: 114"
    )
    print(
        f"Translated Ayahs: "
        f"{len(output)}"
    )
    print(
        f"Created: {OUTPUT_FILE}"
    )
    print(
        f"Created: "
        f"{SOURCE_INFO_FILE}"
    )


if __name__ == "__main__":
    main()