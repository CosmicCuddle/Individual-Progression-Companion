#!/usr/bin/env python3
"""Create a deterministic, internal-review-only WoW 3.3.5a Companion ZIP.

For paired N-WhatsTraining IP-stage tests. Contains only addon source and
original README; never publishes SavedVariables, account info or server data.
"""
from pathlib import Path
import hashlib
import zipfile
import argparse

ROOT = Path(__file__).resolve().parents[1]
ADDON = "IndividualProgressionAddon"
FILES = ("IndividualProgressionAddon.lua", "IndividualProgressionAddon.toc", "README.md")

def package(output):
    toc = (ROOT / "IndividualProgressionAddon.toc").read_text(encoding="utf-8")
    assert "## Interface: 30300" in toc
    assert "IndividualProgressionAddon.lua" in toc
    for name in FILES:
        path = ROOT / name
        if not path.is_file() or path.is_symlink():
            raise SystemExit("Missing or unsafe file: " + str(path))
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, "w") as archive:
        for name in sorted(FILES):
            entry = zipfile.ZipInfo(ADDON + "/" + name, (1980, 1, 1, 0, 0, 0))
            entry.compress_type = zipfile.ZIP_STORED
            entry.external_attr = 0o100644 << 16
            archive.writestr(entry, (ROOT / name).read_bytes())
    with zipfile.ZipFile(output) as archive:
        expected = {ADDON + "/" + f for f in FILES}
        if set(archive.namelist()) != expected or archive.testzip() is not None:
            raise SystemExit("Unsafe or broken addon archive")
    print("PASS: review-only Companion source ZIP", output, output.stat().st_size)
    print("SHA256:", hashlib.sha256(output.read_bytes()).hexdigest())

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    package(parser.parse_args().output)
