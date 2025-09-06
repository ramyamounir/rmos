
# Requires PROJECT_ROOT already exported
: "${PROJECT_ROOT:?PROJECT_ROOT is not set}"

TBP_ENVRC="$PROJECT_ROOT/.envrc"
TBP_ENVMAP="${TBP_ENVMAP:-$HOME/.config/tbp/envmap.json}"
TBP_RUNMAP="${TBP_RUNMAP:-$HOME/.config/tbp/runmap.json}"
TBP_PICKERS_DIR="${TBP_PICKERS_DIR:-$HOME/.config/scripts/tbp_pickers}"

tbp_repo_key() {
  if [[ -n "${TBP_REPO:-}" ]]; then
    print -r -- "$TBP_REPO"
  else
    basename -- "$PROJECT_ROOT"
  fi
}

tbp_picker_path() {
  local name="$1"
  print -r -- "$TBP_PICKERS_DIR/$name"
}

# ---- envmap helpers ----
json_get_repo() {
  local repo="$1"
  python - <<'PY' "$TBP_ENVMAP" "$repo"
import json, sys
p, repo = sys.argv[1], sys.argv[2]
with open(p, 'r') as f:
    data = json.load(f)
obj = data.get(repo)
if obj is None:
    sys.exit(3)
print(json.dumps(obj))
PY
}

# ---- .envrc editing ----
envrc_set() {
  local key="$1" val="$2"
  mkdir -p -- "$(dirname -- "$TBP_ENVRC")"
  touch -- "$TBP_ENVRC"
  local tmp; tmp="$(mktemp)"
  grep -vE "^export[[:space:]]+$key=" "$TBP_ENVRC" > "$tmp" || true
  printf 'export %s=%q\n' "$key" "$val" >> "$tmp"
  mv -- "$tmp" "$TBP_ENVRC"
}

envrc_unset() {
  local key="$1"
  [[ -f "$TBP_ENVRC" ]] || return 0
  local tmp; tmp="$(mktemp)"
  grep -vE "^export[[:space:]]+$key=" "$TBP_ENVRC" > "$tmp" || true
  mv -- "$tmp" "$TBP_ENVRC"
}

direnv_apply() {
  if command -v direnv >/dev/null 2>&1; then
    direnv allow "$PROJECT_ROOT"
  fi
}

# =========================
# Run-map (dispatcher) bits
# =========================

# Read a command template from runmap.json for (repo, command_name)
# Usage: runmap_get_cmd "$(tbp_repo_key)" "tbp_run"
runmap_get_cmd() {
  local repo="$1" cmdname="$2"
  python - <<'PY' "$TBP_RUNMAP" "$repo" "$cmdname"
import json, sys
p, repo, name = sys.argv[1], sys.argv[2], sys.argv[3]
with open(p, 'r') as f:
    data = json.load(f)
cmd = (data.get(repo) or {}).get(name)
if not cmd:
    sys.exit(3)
print(cmd)
PY
}

# Render a {VAR} template using current environment (safe: leaves unknowns intact)
# Defaults: {PY} -> "python"
# Usage: rendered="$(render_template "$template")"
render_template() {
  local template="$1"
  python - <<'PY' "$template"
import os, sys
tmpl = sys.argv[1]

class SafeDict(dict):
    def __missing__(self, key):
        return "{" + key + "}"

env = dict(os.environ)
env.setdefault("PY", "python")

# Simple format_map with safe fallback
try:
    print(tmpl.format_map(SafeDict(env)))
except Exception as e:
    sys.stderr.write(f"Template render error: {e}\n")
    sys.exit(2)
PY
}
