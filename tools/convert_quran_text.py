import json
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

INPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_uthmani.txt"
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
    / "quran_ayahs.json"
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


def main():
    if not INPUT_FILE.exists():
        fail(
            f"Could not find Qur’an text: "
            f"{INPUT_FILE}"
        )

    expected_ayah_counts = load_metadata()

    ayahs = []
    seen_keys = set()

    surah_counts = {
        surah_number: 0
        for surah_number in range(1, 115)
    }

    with INPUT_FILE.open(
        "r",
        encoding="utf-8",
    ) as file:
        for line_number, raw_line in enumerate(
            file,
            start=1,
        ):
            line = raw_line.rstrip("\n\r")
            stripped_line = line.strip()

            # Ignore blank lines.
            if not stripped_line:
                continue

            # Preserve the original Tanzil source file unchanged,
            # but ignore its copyright/comment block during conversion.
            if stripped_line.startswith("#"):
                continue

            parts = line.split("|", 2)

            if len(parts) != 3:
                fail(
                    f"Invalid format on line "
                    f"{line_number}: {line}"
                )

            surah_raw, ayah_raw, arabic_text = parts

            try:
                surah_number = int(
                    surah_raw.strip()
                )

                ayah_number = int(
                    ayah_raw.strip()
                )
            except ValueError:
                fail(
                    f"Invalid Surah or Ayah number "
                    f"on line {line_number}."
                )

            if (
                surah_number < 1
                or surah_number > 114
            ):
                fail(
                    f"Invalid Surah number "
                    f"{surah_number} "
                    f"on line {line_number}."
                )

            expected_count = (
                expected_ayah_counts[
                    surah_number
                ]
            )

            if (
                ayah_number < 1
                or ayah_number > expected_count
            ):
                fail(
                    f"Invalid Ayah number "
                    f"{surah_number}:{ayah_number}. "
                    f"Expected range: "
                    f"1-{expected_count}."
                )

            if not arabic_text.strip():
                fail(
                    f"Empty Arabic text at "
                    f"{surah_number}:{ayah_number}."
                )

            key = (
                surah_number,
                ayah_number,
            )

            if key in seen_keys:
                fail(
                    f"Duplicate Ayah found: "
                    f"{surah_number}:{ayah_number}."
                )

            seen_keys.add(key)

            surah_counts[
                surah_number
            ] += 1

            ayahs.append(
                {
                    "surahNumber":
                        surah_number,
                    "ayahNumber":
                        ayah_number,
                    "arabicText":
                        arabic_text,
                }
            )

    if len(ayahs) != 6236:
        fail(
            f"Expected 6236 Ayahs, "
            f"found {len(ayahs)}."
        )

    for surah_number in range(
        1,
        115,
    ):
        actual_count = surah_counts[
            surah_number
        ]

        expected_count = (
            expected_ayah_counts[
                surah_number
            ]
        )

        if actual_count != expected_count:
            fail(
                f"Surah {surah_number} "
                f"contains {actual_count} Ayahs, "
                f"expected {expected_count}."
            )

        for ayah_number in range(
            1,
            expected_count + 1,
        ):
            if (
                surah_number,
                ayah_number,
            ) not in seen_keys:
                fail(
                    f"Missing Ayah: "
                    f"{surah_number}:{ayah_number}."
                )

    ayahs.sort(
        key=lambda ayah: (
            ayah["surahNumber"],
            ayah["ayahNumber"],
        )
    )

    with OUTPUT_FILE.open(
        "w",
        encoding="utf-8",
    ) as file:
        json.dump(
            ayahs,
            file,
            ensure_ascii=False,
            indent=2,
        )

    print(
        "Qur'an Arabic text validation passed."
    )
    print(
        f"Surahs: {len(surah_counts)}"
    )
    print(
        f"Numbered Ayahs: {len(ayahs)}"
    )
    print(
        f"Created: {OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()