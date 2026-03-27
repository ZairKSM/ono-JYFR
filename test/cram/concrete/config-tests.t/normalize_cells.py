#!/usr/bin/env python3

import re
import sys
from pathlib import Path


# pour lire en ocaml
def decode_ocaml_string(value):
    parts = []
    i = 0
    while i < len(value):
        if value[i] != "\\":
            parts.append(value[i])
            i += 1
            continue

        if i + 3 < len(value) and value[i + 1 : i + 4].isdigit():
            parts.append(chr(int(value[i + 1 : i + 4], 10)))
            i += 4
            continue

        escapes = {
            "\\": "\\",
            '"': '"',
            "n": "\n",
            "r": "\r",
            "t": "\t",
            "b": "\b",
        }
        parts.append(escapes.get(value[i + 1], value[i + 1]))
        i += 2

    return "".join(parts)


# pour lire les constantes dans le fichier ocaml
def read_constant(source, name):
    pattern = rf"let\s+{re.escape(name)}\s*=\s*\"((?:\\.|[^\"])*)\""
    match = re.search(pattern, source)
    if match is None:
        raise SystemExit(f"[normalize_cells.py] Constant not found: {name}")
    return decode_ocaml_string(match.group(1))


def main():
    # touver les casses vivantes et mortes
    constants_path = Path(__file__).resolve().parents[4] / "src" / "GameConstant.ml"
    constants = constants_path.read_text()
    alive = read_constant(constants, "case_en_vie")
    dead = read_constant(constants, "case_morte")

    # lire et remplacer
    output = sys.stdin.read()
    output = output.replace("\x1b[2J\x1b[H", "")
    output = output.replace(alive, "[]")
    output = output.replace(dead, "..")
    sys.stdout.write(output)


if __name__ == "__main__":
    main()
    # 🫵 🫦
