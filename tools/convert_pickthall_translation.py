import json
import re
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

INPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "quran_english_source.txt"
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
    / "quran_english_pickthall.json"
)

VERSE_PATTERN = re.compile(
    r"^(\d{3})\.(\d{3})$"
)

# Verified formatting errors in Project Gutenberg eBook #16955.
# We correct them only during conversion.
# The original source file remains unchanged.
KNOWN_MARKER_CORRECTIONS = {
    "0.033": "017.033",
    "039.04": "039.046",
    "04.032": "045.032",
    "05.026": "056.026",
}


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


def normalize_text(parts):
    return " ".join(
        part.strip()
        for part in parts
        if part.strip()
    )


def main():
    if not INPUT_FILE.exists():
        fail(
            f"Could not find English source: "
            f"{INPUT_FILE}"
        )

    expected_counts = load_metadata()

    translations = {}

    current_surah = None
    current_ayah = None

    capturing_pickthall = False
    pickthall_parts = []

    correction_count = 0

    def save_current_pickthall():
        nonlocal pickthall_parts
        nonlocal capturing_pickthall

        if (
            current_surah is None
            or current_ayah is None
            or not pickthall_parts
        ):
            pickthall_parts = []
            capturing_pickthall = False
            return

        text = normalize_text(
            pickthall_parts
        )

        if not text:
            fail(
                f"Empty Pickthall translation at "
                f"{current_surah}:{current_ayah}."
            )

        key = (
            current_surah,
            current_ayah,
        )

        if key in translations:
            fail(
                f"Duplicate Pickthall translation: "
                f"{current_surah}:{current_ayah}."
            )

        translations[key] = text

        pickthall_parts = []
        capturing_pickthall = False

    with INPUT_FILE.open(
        "r",
        encoding="utf-8-sig",
    ) as file:
        for line_number, raw_line in enumerate(
            file,
            start=1,
        ):
            line = raw_line.rstrip(
                "\n\r"
            )

            stripped = line.strip()

            # Correct only explicitly verified Gutenberg
            # verse-marker formatting errors.
            if stripped in KNOWN_MARKER_CORRECTIONS:
                corrected = KNOWN_MARKER_CORRECTIONS[
                    stripped
                ]

                print(
                    f"Correcting source marker "
                    f"{stripped} -> {corrected} "
                    f"at line {line_number}"
                )

                stripped = corrected
                correction_count += 1

            verse_match = VERSE_PATTERN.match(
                stripped
            )

            if verse_match:
                save_current_pickthall()

                current_surah = int(
                    verse_match.group(1)
                )

                current_ayah = int(
                    verse_match.group(2)
                )

                if (
                    current_surah < 1
                    or current_surah > 114
                ):
                    fail(
                        f"Invalid Surah number "
                        f"on line {line_number}: "
                        f"{current_surah}"
                    )

                expected_count = (
                    expected_counts[
                        current_surah
                    ]
                )

                if (
                    current_ayah < 1
                    or current_ayah > expected_count
                ):
                    fail(
                        f"Invalid Ayah "
                        f"{current_surah}:"
                        f"{current_ayah} "
                        f"on line {line_number}. "
                        f"Expected range "
                        f"1-{expected_count}."
                    )

                continue

            if stripped.startswith("P:"):
                save_current_pickthall()

                if (
                    current_surah is None
                    or current_ayah is None
                ):
                    continue

                capturing_pickthall = True

                first_part = stripped[2:].strip()

                if first_part:
                    pickthall_parts.append(
                        first_part
                    )

                continue

            if stripped.startswith(
                ("Y:", "S:")
            ):
                if capturing_pickthall:
                    save_current_pickthall()

                continue

            if capturing_pickthall:
                if not stripped:
                    continue

                if (
                    stripped.startswith(
                        "----"
                    )
                    or stripped.startswith(
                        "Chapter "
                    )
                    or stripped.startswith(
                        "Total Verses:"
                    )
                ):
                    save_current_pickthall()
                    continue

                pickthall_parts.append(
                    stripped
                )

    save_current_pickthall()

    if correction_count != len(
        KNOWN_MARKER_CORRECTIONS
    ):
        fail(
            f"Expected to apply "
            f"{len(KNOWN_MARKER_CORRECTIONS)} "
            f"verified source corrections, "
            f"but applied {correction_count}."
        )

    if len(translations) != 6236:
        fail(
            f"Expected 6236 Pickthall "
            f"translations, found "
            f"{len(translations)}."
        )

    output = []

    for surah_number in range(
        1,
        115,
    ):
        expected_count = expected_counts[
            surah_number
        ]

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
                    f"Missing Pickthall "
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

    if len(output) != 6236:
        fail(
            f"Final output contains "
            f"{len(output)} verses "
            f"instead of 6236."
        )

    OUTPUT_FILE.parent.mkdir(
        parents=True,
        exist_ok=True,
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

    print()
    print(
        "Pickthall translation validation passed."
    )
    print(
        "Translator: Marmaduke Pickthall"
    )
    print(
        "Surahs: 114"
    )
    print(
        f"Translated Ayahs: {len(output)}"
    )
    print(
        f"Verified source corrections: "
        f"{correction_count}"
    )
    print(
        f"Created: {OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()