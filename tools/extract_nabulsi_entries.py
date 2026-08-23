import json
import re
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

SOURCE_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_ar.json"
)

OUTPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_entries_raw.json"
)

SOURCE_ID = "nabulsi_tatir_al_anam"

ENTRY_PATTERN = re.compile(
    r"^\s*-\s*\(([^)]+)\)\s*(.*)$",
    re.DOTALL,
)


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    sys.exit(1)


def normalize_space(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def load_source() -> dict:
    if not SOURCE_FILE.exists():
        fail(
            f"Source file not found: "
            f"{SOURCE_FILE}"
        )

    with SOURCE_FILE.open(
        "r",
        encoding="utf-8",
    ) as file:
        data = json.load(file)

    if data.get("sourceId") != SOURCE_ID:
        fail(
            "Unexpected source ID."
        )

    pages = data.get("pages")

    if not isinstance(pages, list):
        fail(
            "Source pages are missing "
            "or invalid."
        )

    return data


def build_paragraph_stream(
    source: dict,
) -> list[dict]:
    stream = []

    for page in source["pages"]:
        page_id = page.get(
            "pageId"
        )

        page_number = page.get(
            "pageNumber"
        )

        chapter = page.get(
            "chapter"
        )

        url = page.get(
            "url"
        )

        paragraphs = page.get(
            "paragraphs"
        )

        if not isinstance(
            paragraphs,
            list,
        ):
            continue

        for paragraph in paragraphs:
            text = paragraph.get(
                "text",
                "",
            )

            if not isinstance(
                text,
                str,
            ):
                continue

            text = normalize_space(
                text
            )

            if not text:
                continue

            stream.append(
                {
                    "text": text,
                    "anchor":
                        paragraph.get(
                            "anchor"
                        ),
                    "pageId":
                        page_id,
                    "pageNumber":
                        page_number,
                    "chapterArabic":
                        chapter,
                    "sourceUrl":
                        url,
                }
            )

    return stream


def main() -> None:
    source = load_source()

    paragraph_stream = (
        build_paragraph_stream(
            source
        )
    )

    if not paragraph_stream:
        fail(
            "No source paragraphs found."
        )

    entries = []
    seen_ids = set()

    current_entry = None
    heading_count = 0

    def finalize_current_entry():
        nonlocal current_entry

        if current_entry is None:
            return

        interpretation_parts = (
            current_entry[
                "_interpretationParts"
            ]
        )

        interpretation = normalize_space(
            " ".join(
                interpretation_parts
            )
        )

        if not interpretation:
            print(
                "WARNING: Skipping "
                "heading with no "
                "interpretation: "
                f"{current_entry['titleArabic']} "
                f"(page "
                f"{current_entry['pageId']})"
            )

            current_entry = None
            return

        final_entry = {
            "id":
                current_entry["id"],
            "titleArabic":
                current_entry[
                    "titleArabic"
                ],
            "interpretationArabic":
                interpretation,
            "sourceId":
                SOURCE_ID,
            "chapterArabic":
                current_entry[
                    "chapterArabic"
                ],
            "pageId":
                current_entry[
                    "pageId"
                ],
            "pageNumber":
                current_entry[
                    "pageNumber"
                ],
            "anchor":
                current_entry[
                    "anchor"
                ],
            "sourceUrl":
                current_entry[
                    "sourceUrl"
                ],
        }

        entries.append(
            final_entry
        )

        current_entry = None

    for paragraph in paragraph_stream:
        text = paragraph["text"]

        match = ENTRY_PATTERN.match(
            text
        )

        if match:
            finalize_current_entry()

            heading_count += 1

            title = normalize_space(
                match.group(1)
            )

            same_paragraph_text = (
                normalize_space(
                    match.group(2)
                )
            )

            if not title:
                fail(
                    f"Empty heading on "
                    f"page "
                    f"{paragraph['pageId']}."
                )

            anchor = paragraph.get(
                "anchor"
            )

            entry_id = (
                f"nabulsi_"
                f"{paragraph['pageId']}_"
                f"{anchor or heading_count}"
            )

            if entry_id in seen_ids:
                fail(
                    f"Duplicate entry id: "
                    f"{entry_id}"
                )

            seen_ids.add(
                entry_id
            )

            current_entry = {
                "id":
                    entry_id,
                "titleArabic":
                    title,
                "chapterArabic":
                    paragraph[
                        "chapterArabic"
                    ],
                "pageId":
                    paragraph[
                        "pageId"
                    ],
                "pageNumber":
                    paragraph[
                        "pageNumber"
                    ],
                "anchor":
                    anchor,
                "sourceUrl":
                    paragraph[
                        "sourceUrl"
                    ],
                "_interpretationParts":
                    [],
            }

            if same_paragraph_text:
                current_entry[
                    "_interpretationParts"
                ].append(
                    same_paragraph_text
                )

            continue

        # Any non-heading paragraph after
        # a heading is treated as part of
        # that entry until the next explicit
        # "- (...)" heading appears.
        if current_entry is not None:
            current_entry[
                "_interpretationParts"
            ].append(
                text
            )

    finalize_current_entry()

    if len(entries) < 500:
        fail(
            f"Only {len(entries)} "
            f"explicit entries found. "
            f"Expected substantially more."
        )

    output = {
        "schemaVersion": 2,
        "sourceId":
            SOURCE_ID,
        "entryCount":
            len(entries),
        "entries":
            entries,
    }

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

    print(
        "Nabulsi entry extraction passed."
    )

    print(
        f"Explicit headings found: "
        f"{heading_count}"
    )

    print(
        f"Entries created: "
        f"{len(entries)}"
    )

    print(
        f"Created: "
        f"{OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()