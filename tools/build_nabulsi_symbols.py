import json
import re
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parent.parent

RAW_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_entries_raw.json"
)

OUTPUT_FILE = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
    / "nabulsi_tatir_al_anam_symbols_ar.json"
)

SOURCE_ID = "nabulsi_tatir_al_anam"


CONTINUATION_PATTERN = re.compile(
    r"^(?:"
    r"ومن رأى"
    r"|من رأى"
    r"|وقيل من رأى"
    r"|فإن رأى"
    r"|فمن رأى"
    r"|وإن رأى"
    r"|وإن رآه"
    r"|فإن رآه"
    r"|ومن رآه"
    r"|ومن رأى أنه"
    r"|ومن رأى أن"
    r"|وإن رأت"
    r"|فإن رأت"
    r"|وإذا رأى"
    r"|إذا رأى"
    r"|وإذا رأت"
    r"|إذا رأت"
    r")(?:\s|$)"
)

META_HEADINGS = {
    "واعلم",
}


def fail(message: str) -> None:
    print(f"ERROR: {message}")
    sys.exit(1)


def normalize_space(value: str) -> str:
    return re.sub(
        r"\s+",
        " ",
        value,
    ).strip()


def load_raw_entries() -> list[dict]:
    if not RAW_FILE.exists():
        fail(
            f"Raw entry file not found: "
            f"{RAW_FILE}"
        )

    with RAW_FILE.open(
        "r",
        encoding="utf-8",
    ) as file:
        data = json.load(file)

    if (
        data.get("sourceId")
        != SOURCE_ID
    ):
        fail(
            "Unexpected source ID."
        )

    entries = data.get(
        "entries"
    )

    if not isinstance(
        entries,
        list,
    ):
        fail(
            "Raw entries are missing "
            "or invalid."
        )

    return entries


def is_continuation(
    title: str,
) -> bool:
    return bool(
        CONTINUATION_PATTERN.match(
            title
        )
    )


def make_reference(
    entry: dict,
) -> dict:
    return {
        "pageId":
            entry.get(
                "pageId"
            ),
        "pageNumber":
            entry.get(
                "pageNumber"
            ),
        "anchor":
            entry.get(
                "anchor"
            ),
        "sourceUrl":
            entry.get(
                "sourceUrl"
            ),
    }


def main() -> None:
    raw_entries = (
        load_raw_entries()
    )

    symbols = []

    current_symbol = None

    merged_continuations = 0
    skipped_meta = 0

    for entry in raw_entries:
        title = normalize_space(
            entry.get(
                "titleArabic",
                "",
            )
        )

        interpretation = (
            normalize_space(
                entry.get(
                    "interpretationArabic",
                    "",
                )
            )
        )

        if not title:
            continue

        if not interpretation:
            continue

        if title in META_HEADINGS:
            skipped_meta += 1
            continue

        if is_continuation(
            title
        ):
            if current_symbol is None:
                print(
                    "WARNING: Continuation "
                    "without previous symbol:"
                )
                print(
                    f"  {title}"
                )
                print(
                    f"  Page: "
                    f"{entry.get('pageNumber')}"
                )
                continue

            continuation_text = (
                f"{title} "
                f"{interpretation}"
            )

            current_symbol[
                "interpretationArabic"
            ] = normalize_space(
                current_symbol[
                    "interpretationArabic"
                ]
                + " "
                + continuation_text
            )

            current_symbol[
                "references"
            ].append(
                make_reference(
                    entry
                )
            )

            merged_continuations += 1
            continue

        symbol_id = (
            f"nabulsi_symbol_"
            f"{len(symbols) + 1:04d}"
        )

        current_symbol = {
            "id":
                symbol_id,
            "titleArabic":
                title,
            "interpretationArabic":
                interpretation,
            "sourceId":
                SOURCE_ID,
            "chapterArabic":
                entry.get(
                    "chapterArabic"
                ),
            "references": [
                make_reference(
                    entry
                )
            ],
        }

        symbols.append(
            current_symbol
        )

    if len(symbols) < 500:
        fail(
            f"Only {len(symbols)} "
            f"clean symbols created. "
            f"Expected substantially more."
        )

    seen_titles = {}

    duplicate_titles = []

    for symbol in symbols:
        title = symbol[
            "titleArabic"
        ]

        if title in seen_titles:
            duplicate_titles.append(
                title
            )
        else:
            seen_titles[
                title
            ] = symbol["id"]

    output = {
        "schemaVersion": 1,
        "sourceId":
            SOURCE_ID,
        "rawEntryCount":
            len(raw_entries),
        "symbolCount":
            len(symbols),
        "mergedContinuationCount":
            merged_continuations,
        "skippedMetaCount":
            skipped_meta,
        "duplicateTitleCount":
            len(
                duplicate_titles
            ),
        "symbols":
            symbols,
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
        "Nabulsi symbol build passed."
    )

    print(
        f"Raw entries: "
        f"{len(raw_entries)}"
    )

    print(
        f"Clean symbols: "
        f"{len(symbols)}"
    )

    print(
        f"Continuation entries merged: "
        f"{merged_continuations}"
    )

    print(
        f"Meta headings skipped: "
        f"{skipped_meta}"
    )

    print(
        f"Duplicate symbol titles: "
        f"{len(duplicate_titles)}"
    )

    if duplicate_titles:
        print()
        print(
            "Sample duplicate titles:"
        )

        for title in (
            duplicate_titles[:20]
        ):
            print(
                f"  {title}"
            )

    print()
    print(
        f"Created: "
        f"{OUTPUT_FILE}"
    )


if __name__ == "__main__":
    main()