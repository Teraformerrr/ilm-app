import json
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

INPUT_FILE = PROJECT_ROOT / "assets" / "data" / "quran-data.xml"
OUTPUT_FILE = PROJECT_ROOT / "assets" / "data" / "quran_surahs.json"


def fail(message):
    print(f"ERROR: {message}")
    sys.exit(1)


def main():
    if not INPUT_FILE.exists():
        fail(f"Could not find {INPUT_FILE}")

    try:
        tree = ET.parse(INPUT_FILE)
    except ET.ParseError as error:
        fail(f"Invalid XML: {error}")

    root = tree.getroot()

    surah_elements = root.findall(".//sura")

    if len(surah_elements) != 114:
        fail(
            f"Expected 114 Surahs, but found "
            f"{len(surah_elements)}."
        )

    surahs = []

    for element in surah_elements:
        try:
            number = int(element.attrib["index"])
            ayah_count = int(element.attrib["ayas"])

            arabic_name = element.attrib["name"].strip()

            # Tanzil "tname" = English transliteration.
            english_name = element.attrib["tname"].strip()

            # Tanzil "ename" = translated English meaning.
            translated_name = element.attrib["ename"].strip()

            revelation_type = element.attrib["type"].strip()
        except KeyError as error:
            fail(
                f"Missing required attribute "
                f"{error} in Surah metadata."
            )
        except ValueError as error:
            fail(
                f"Invalid numeric value in metadata: {error}"
            )

        if number < 1 or number > 114:
            fail(f"Invalid Surah number: {number}")

        if ayah_count <= 0:
            fail(
                f"Surah {number} has invalid Ayah count: "
                f"{ayah_count}"
            )

        if not arabic_name:
            fail(
                f"Surah {number} has no Arabic name."
            )

        if not english_name:
            fail(
                f"Surah {number} has no English name."
            )

        if not translated_name:
            fail(
                f"Surah {number} has no translated name."
            )

        surahs.append(
            {
                "number": number,
                "arabicName": arabic_name,
                "englishName": english_name,
                "translatedName": translated_name,
                "revelationType": revelation_type,
                "ayahCount": ayah_count,
            }
        )

    surahs.sort(
        key=lambda surah: surah["number"]
    )

    expected_numbers = list(range(1, 115))

    actual_numbers = [
        surah["number"]
        for surah in surahs
    ]

    if actual_numbers != expected_numbers:
        fail(
            "Surah numbering is incomplete "
            "or out of sequence."
        )

    total_ayahs = sum(
        surah["ayahCount"]
        for surah in surahs
    )

    if total_ayahs != 6236:
        fail(
            f"Expected 6236 numbered Ayahs, "
            f"but metadata contains {total_ayahs}."
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
            surahs,
            file,
            ensure_ascii=False,
            indent=2,
        )

    print("Qur'an metadata validation passed.")
    print(f"Surahs: {len(surahs)}")
    print(f"Numbered Ayahs: {total_ayahs}")
    print(
        f"Created: {OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()