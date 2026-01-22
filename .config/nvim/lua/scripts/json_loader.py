#!/usr/bin/env python3
"""Load JSON files for DAP debugging."""
import json
import sys
import pathlib
import debugpy
from json import JSONDecodeError


def load_json_smart(path):
    """Load normal JSON or newline-delimited JSON (one JSON per line)."""
    with open(path, "r", encoding="utf-8") as f:
        try:
            return json.load(f)
        except JSONDecodeError:
            f.seek(0)
            objs = []
            as_dict = {}
            count = 0
            for _, line in enumerate(f):
                line = line.strip()
                if not line:
                    continue
                obj = json.loads(line)
                objs.append(obj)
                if isinstance(obj, dict) and len(obj) == 1:
                    (k, v), = obj.items()
                    as_dict[k] = v
                    count += 1
            if count == len(objs) and count > 0:
                return as_dict
            return objs


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python json_loader.py <path_to_json>")
        sys.exit(1)

    p = pathlib.Path(sys.argv[1])
    data = load_json_smart(str(p))

    debugpy.breakpoint()

    print(f"[json-dap] Loaded: {p} type={type(data).__name__} size={len(data)}")
