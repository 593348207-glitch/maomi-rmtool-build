#!/usr/bin/env python3
"""Convert config/all-clothes.txt into the runtime clothes.json catalog."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "config" / "all-clothes.txt"
OUTPUT = ROOT / "layout" / "Library" / "Application Support" / "RMTool" / "clothes.json"
LINE = re.compile(r"^类型\s+(\d+)\s+索引\s+(\d+)\s+(.+?)\s*$")


def main() -> None:
    records: list[dict[str, object]] = []
    seen: set[tuple[int, int, int]] = set()
    for line_number, line in enumerate(SOURCE.read_text(encoding="utf-8-sig").splitlines(), 1):
        match = LINE.fullmatch(line)
        if not match:
            raise ValueError(f"{SOURCE}:{line_number}: invalid clothing line: {line!r}")
        item_type, value, name = int(match.group(1)), int(match.group(2)), match.group(3)
        key = (item_type, value, 0)
        if key in seen:
            raise ValueError(f"{SOURCE}:{line_number}: duplicate tuple {key}")
        seen.add(key)
        records.append({
            "name": name,
            "type": item_type,
            "value": value,
            "subType": 0,
            "count": 1,
            "sourceLine": line_number,
        })

    if not records:
        raise ValueError("clothing catalog is empty")
    if any(record["type"] != 3 for record in records):
        raise ValueError("all clothing rewards must use CurrencyData type 3")

    document = {
        "title": "待领取物品",
        "label": "全部服饰",
        "itemsPerMail": 3,
        "items": records,
    }
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text(json.dumps(document, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {OUTPUT}: {len(records)} clothing rewards, {(len(records) + 2) // 3} mails")


if __name__ == "__main__":
    main()
