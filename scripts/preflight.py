#!/usr/bin/env python3
"""Check a documented notebook's input paths without loading scientific data.

The reviewed manifest records literal paths, not complete runtime dependencies.
Passing this check does not imply that a notebook will execute successfully.
"""

import argparse
import json
import os
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("notebook", nargs="?", help="Unique notebook filename or repository path")
    parser.add_argument("--list", action="store_true", help="List available notebooks")
    parser.add_argument("--experiments", default=os.environ.get("CLONESWEEPER_EXPERIMENTS"))
    parser.add_argument("--prepare-output-dirs", action="store_true",
                        help="Create documented output parents only after all inputs exist")
    args = parser.parse_args()
    entries = json.loads((REPO / "docs/notebooks.json").read_text())
    if args.list:
        for entry in entries:
            print(Path(entry["notebook"]).name)
        return 0
    if not args.notebook:
        parser.error("supply a notebook or --list")
    matches = [e for e in entries if args.notebook in (e["notebook"], Path(e["notebook"]).name)]
    if len(matches) != 1:
        parser.error("notebook name is not unique or not documented; use --list")
    if not args.experiments:
        parser.error("set CLONESWEEPER_EXPERIMENTS or supply --experiments")
    root = Path(args.experiments).expanduser().resolve()
    if not root.is_dir():
        parser.error("Experiments directory does not exist")
    entry = matches[0]
    data_root = root / entry["data_root"]
    print("Notebook:", entry["notebook"])
    print("Working directory:", data_root)
    missing = []
    for relative in entry["inputs"]:
        present = any(data_root.glob(relative)) if "*" in relative else (data_root / relative).exists()
        print(("FOUND   " if present else "MISSING ") + relative)
        if not present:
            missing.append(relative)
    print("R packages:", ", ".join(entry["packages"]))
    if missing:
        print(f"Missing {len(missing)} documented input(s). See docs/DATA.md.")
        return 1
    if args.prepare_output_dirs:
        for parent in sorted({str(Path(p).parent) for p in entry["outputs"]}):
            (data_root / parent).mkdir(parents=True, exist_ok=True)
            print("Output directory:", parent)
    print("Documented input paths exist. File contents, packages, and analysis results are not checked.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
