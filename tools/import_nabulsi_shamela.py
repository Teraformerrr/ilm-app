import json
import re
import sys
import time
from http.client import RemoteDisconnected
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

from bs4 import BeautifulSoup


BOOK_ID = 1217
AUTHOR_ID = 916

EXPECTED_TITLE = "تعطير الأنام في تعبير المنام"
EXPECTED_AUTHOR = "عبد الغني النابلسي"

BASE_URL = f"https://shamela.ws/book/{BOOK_ID}"

PROJECT_ROOT = Path(__file__).resolve().parent.parent

CACHE_DIR = (
    PROJECT_ROOT
    / "tools"
    / "cache"
    / "nabulsi_shamela"
)

OUTPUT_DIR = (
    PROJECT_ROOT
    / "assets"
    / "data"
    / "dream_sources"
)

OUTPUT_FILE = (
    OUTPUT_DIR
    / "nabulsi_tatir_al_anam_ar.json"
)

SOURCE_INFO_FILE = (
    OUTPUT_DIR
    / "nabulsi_tatir_al_anam_source_info.json"
)

USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) "
    "Chrome/150.0 Safari/537.36"
)

REQUEST_DELAY_SECONDS = 1.0
MAX_RETRIES = 8

# Safety limit in case the website starts returning an
# unexpected pagination loop.
MAX_PAGE_REQUESTS = 500


def fail(message: str) -> None:
    print(f"\nERROR: {message}")
    sys.exit(1)


def normalize_space(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip()


def contains_arabic(value: str) -> bool:
    return bool(
        re.search(
            r"[\u0600-\u06FF]",
            value,
        )
    )


def fetch_url(url: str) -> str:
    request = Request(
        url,
        headers={
            "User-Agent": USER_AGENT,
            "Accept-Language": "ar,en;q=0.8",
        },
    )

    last_error = None

    for attempt in range(
        1,
        MAX_RETRIES + 1,
    ):
        try:
            with urlopen(
                request,
                timeout=30,
            ) as response:
                raw = response.read()

            return raw.decode(
                "utf-8",
                errors="replace",
            )

        except (
            HTTPError,
            URLError,
            TimeoutError,
            RemoteDisconnected,
            ConnectionResetError,
        ) as error:
            last_error = error

            print(
                f"Request failed "
                f"(attempt {attempt}/{MAX_RETRIES}): "
                f"{url}"
            )

            if attempt < MAX_RETRIES:
                time.sleep(
                    attempt * 2,
                )

    raise RuntimeError(
        f"Could not fetch {url}: "
        f"{last_error}"
    )


def get_cached_page(
    page_id: int,
) -> str:
    CACHE_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    cache_file = (
        CACHE_DIR
        / f"page_{page_id:04d}.html"
    )

    if cache_file.exists():
        return cache_file.read_text(
            encoding="utf-8",
        )

    url = f"{BASE_URL}/{page_id}"

    html = fetch_url(url)

    cache_file.write_text(
        html,
        encoding="utf-8",
    )

    time.sleep(
        REQUEST_DELAY_SECONDS,
    )

    return html


def validate_book_page(
    soup: BeautifulSoup,
    page_id: int,
) -> None:
    page_text = normalize_space(
        soup.get_text(
            " ",
            strip=True,
        )
    )

    if EXPECTED_TITLE not in page_text:
        fail(
            f"Book title was not found "
            f"on Shamela page id "
            f"{page_id}."
        )

    author_link = soup.find(
        "a",
        href=re.compile(
            rf"/author/{AUTHOR_ID}$"
        ),
    )

    if author_link is None:
        fail(
            f"Expected author link was "
            f"not found on page id "
            f"{page_id}."
        )

    author_text = normalize_space(
        author_link.get_text(
            " ",
            strip=True,
        )
    )

    if EXPECTED_AUTHOR not in author_text:
        fail(
            f"Unexpected author on page "
            f"id {page_id}: "
            f"{author_text}"
        )


def extract_toc(
    soup: BeautifulSoup,
) -> list[dict]:
    toc = []

    for link in soup.find_all(
        "a",
        href=re.compile(
            rf"^https://shamela\.ws/book/"
            rf"{BOOK_ID}/\d+$"
        ),
    ):
        label = normalize_space(
            link.get_text(
                " ",
                strip=True,
            )
        )

        if not label:
            continue

        if not (
            label.startswith("باب ")
            or label == "مقدمة"
            or "خاتمة" in label
        ):
            continue

        href = link.get(
            "href",
            "",
        )

        match = re.search(
            rf"/book/{BOOK_ID}/(\d+)$",
            href,
        )

        if not match:
            continue

        start_page_id = int(
            match.group(1)
        )

        item = {
            "title": label,
            "startPageId":
                start_page_id,
        }

        if item not in toc:
            toc.append(item)

    toc.sort(
        key=lambda item:
            item["startPageId"]
    )

    if not toc:
        fail(
            "Could not extract the "
            "Shamela table of contents."
        )

    return toc


def chapter_for_page(
    page_id: int,
    toc: list[dict],
) -> str:
    chapter = "مقدمة"

    for item in toc:
        if (
            item["startPageId"]
            <= page_id
        ):
            chapter = item["title"]
        else:
            break

    return chapter


def extract_page_record(
    soup: BeautifulSoup,
    requested_page_id: int,
    chapter: str,
) -> dict:
    content = soup.find(
        "div",
        class_=lambda classes:
            classes
            and "nass" in classes,
    )

    if content is None:
        fail(
            f"Book text container "
            f"was not found on "
            f"page id "
            f"{requested_page_id}."
        )

    raw_page_id = content.get(
        "data-page-id"
    )

    raw_page_num = content.get(
        "data-page-num"
    )

    if raw_page_id is None:
        fail(
            f"Missing data-page-id "
            f"on requested page "
            f"{requested_page_id}."
        )

    try:
        internal_page_id = int(
            raw_page_id
        )
    except ValueError:
        fail(
            f"Invalid data-page-id "
            f"on requested page "
            f"{requested_page_id}: "
            f"{raw_page_id}"
        )

    if (
        internal_page_id
        != requested_page_id
    ):
        fail(
            f"Shamela page mismatch. "
            f"Requested page id "
            f"{requested_page_id}, "
            f"received "
            f"{internal_page_id}."
        )

    page_number = None

    if raw_page_num:
        try:
            page_number = int(
                raw_page_num
            )
        except ValueError:
            page_number = (
                raw_page_num
            )

    paragraphs = []

    for paragraph in content.find_all(
        "p",
        recursive=False,
    ):
        anchor = paragraph.find(
            "span",
            class_=lambda classes:
                classes
                and "anchor"
                in classes,
        )

        anchor_id = None

        if anchor is not None:
            anchor_id = anchor.get(
                "id"
            )

        # Remove copy-link buttons from the
        # paragraph before extracting text.
        paragraph_copy = BeautifulSoup(
            str(paragraph),
            "html.parser",
        )

        for button in (
            paragraph_copy.select(
                ".btn_tag"
            )
        ):
            button.decompose()

        text = normalize_space(
            paragraph_copy.get_text(
                " ",
                strip=True,
            )
        )

        if not text:
            continue

        if not contains_arabic(text):
            continue

        paragraphs.append(
            {
                "anchor":
                    anchor_id,
                "text":
                    text,
            }
        )

    if not paragraphs:
        fail(
            f"No Arabic book "
            f"paragraphs found on "
            f"page id "
            f"{requested_page_id}."
        )

    full_text = "\n".join(
        paragraph["text"]
        for paragraph in paragraphs
    )

    if not contains_arabic(
        full_text
    ):
        fail(
            f"Arabic validation failed "
            f"on page id "
            f"{requested_page_id}."
        )

    return {
        "pageId":
            requested_page_id,
        "pageNumber":
            page_number,
        "chapter":
            chapter,
        "url":
            f"{BASE_URL}/"
            f"{requested_page_id}",
        "paragraphs":
            paragraphs,
    }


def extract_next_page_id(
    soup: BeautifulSoup,
) -> int | None:
    next_button = soup.find(
        id="bu_load_next",
    )

    if next_button is None:
        return None

    raw_next = next_button.get(
        "data-next-id"
    )

    if not raw_next:
        return None

    try:
        return int(
            raw_next
        )
    except ValueError:
        fail(
            f"Invalid next page id: "
            f"{raw_next}"
        )


def main() -> None:
    print(
        "ILM Nabulsi Shamela importer"
    )
    print(
        "----------------------------"
    )
    print(
        f"Book ID: {BOOK_ID}"
    )
    print(
        f"Expected title: "
        f"{EXPECTED_TITLE}"
    )
    print()

    OUTPUT_DIR.mkdir(
        parents=True,
        exist_ok=True,
    )

    # Page id 1 is sufficient to identify
    # the book and contains the TOC.
    first_html = get_cached_page(
        1
    )

    first_soup = BeautifulSoup(
        first_html,
        "html.parser",
    )

    validate_book_page(
        first_soup,
        1,
    )

    toc = extract_toc(
        first_soup,
    )

    print(
        "Book identity validation "
        "passed."
    )
    print(
        f"TOC sections detected: "
        f"{len(toc)}"
    )

    for item in toc:
        print(
            f"  {item['startPageId']:>3} "
            f"-> "
            f"{item['title']}"
        )

    print()
    print(
        "Downloading structured "
        "book pages..."
    )

    pages = []

    visited_page_ids = set()

    page_id = 1

    request_count = 0

    while page_id is not None:
        request_count += 1

        if (
            request_count
            > MAX_PAGE_REQUESTS
        ):
            fail(
                "Maximum page safety "
                "limit reached. "
                "Possible pagination loop."
            )

        if page_id in visited_page_ids:
            fail(
                f"Pagination loop "
                f"detected at "
                f"page id {page_id}."
            )

        visited_page_ids.add(
            page_id
        )

        html = get_cached_page(
            page_id
        )

        soup = BeautifulSoup(
            html,
            "html.parser",
        )

        validate_book_page(
            soup,
            page_id,
        )

        chapter = chapter_for_page(
            page_id,
            toc,
        )

        record = extract_page_record(
            soup,
            page_id,
            chapter,
        )

        pages.append(
            record
        )

        print(
            f"Page ID "
            f"{page_id:>3} | "
            f"Printed page "
            f"{str(record['pageNumber']):>4} | "
            f"{chapter}"
        )

        next_page_id = (
            extract_next_page_id(
                soup
            )
        )

        if next_page_id is None:
            break

        if next_page_id <= page_id:
            fail(
                f"Unexpected next page "
                f"id {next_page_id} "
                f"after {page_id}."
            )

        page_id = next_page_id

    if len(pages) < 300:
        fail(
            f"Only {len(pages)} pages "
            f"were extracted. "
            f"Expected a substantially "
            f"larger book."
        )

    total_paragraphs = sum(
        len(
            page["paragraphs"]
        )
        for page in pages
    )

    if total_paragraphs < 500:
        fail(
            f"Only "
            f"{total_paragraphs} "
            f"Arabic paragraphs were "
            f"extracted."
        )

    all_text = "\n".join(
        paragraph["text"]
        for page in pages
        for paragraph
        in page["paragraphs"]
    )

    if EXPECTED_TITLE not in (
        first_soup.get_text(
            " ",
            strip=True,
        )
    ):
        fail(
            "Final title validation "
            "failed."
        )

    if len(all_text) < 100_000:
        fail(
            "Extracted Arabic text is "
            "unexpectedly small."
        )

    source_document = {
        "schemaVersion": 1,
        "sourceId":
            "nabulsi_tatir_al_anam",
        "bookId":
            BOOK_ID,
        "titleArabic":
            EXPECTED_TITLE,
        "authorArabic":
            EXPECTED_AUTHOR,
        "language":
            "ar",
        "provider":
            "Al-Maktaba al-Shamela",
        "providerBookUrl":
            BASE_URL,
        "tableOfContents":
            toc,
        "pageCount":
            len(pages),
        "paragraphCount":
            total_paragraphs,
        "pages":
            pages,
    }

    source_info = {
        "schemaVersion": 1,
        "sourceId":
            "nabulsi_tatir_al_anam",
        "titleArabic":
            EXPECTED_TITLE,
        "authorArabic":
            EXPECTED_AUTHOR,
        "provider":
            "Al-Maktaba al-Shamela",
        "providerBookId":
            BOOK_ID,
        "providerAuthorId":
            AUTHOR_ID,
        "providerBookUrl":
            BASE_URL,
        "language":
            "Arabic",
        "importMethod":
            "Structured HTML text extraction",
        "ocrUsed":
            False,
        "notes": (
            "Arabic source text was "
            "extracted from Shamela's "
            "searchable text pages. "
            "Paragraph anchors and "
            "page references are "
            "preserved."
        ),
    }

    OUTPUT_FILE.write_text(
        json.dumps(
            source_document,
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )

    SOURCE_INFO_FILE.write_text(
        json.dumps(
            source_info,
            ensure_ascii=False,
            indent=2,
        ),
        encoding="utf-8",
    )

    print()
    print(
        "Nabulsi source import "
        "validation passed."
    )
    print(
        f"Pages: "
        f"{len(pages)}"
    )
    print(
        f"Paragraphs: "
        f"{total_paragraphs}"
    )
    print(
        f"Characters: "
        f"{len(all_text)}"
    )
    print(
        f"Created: "
        f"{OUTPUT_FILE}"
    )
    print(
        f"Created: "
        f"{SOURCE_INFO_FILE}"
    )


if __name__ == "__main__":
    main()