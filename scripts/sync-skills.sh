#!/usr/bin/env bash
# sync-skills.sh — Sync ZeroSpec prompt packs into skills/ and optionally install to ~/.claude/skills/
#
# Usage:
#   bash scripts/sync-skills.sh            # Sync skills/ directory only
#   bash scripts/sync-skills.sh --install  # Sync AND install to ~/.claude/skills/zerospec/
#   bash scripts/sync-skills.sh --check    # Check whether skills/ is up to date (exit 1 if drift)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/prompts"
DEST_DIR="$REPO_ROOT/skills/zerospec/prompts"
INSTALL_DIR="$HOME/.claude/skills/zerospec"

usage() {
  echo "Usage: bash scripts/sync-skills.sh [--install|--check]"
}

MODE="sync"
case "${1:-}" in
  "") ;;
  --install) MODE="install" ;;
  --check) MODE="check" ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

# ── Check mode: report drift, do not write ────────────────────────────────────
if [[ "$MODE" == "check" ]]; then
  DRIFT=0
  for f in "$SRC_DIR"/*.md; do
    name="$(basename "$f")"
    dest="$DEST_DIR/$name"
    if [[ ! -f "$dest" ]]; then
      echo "MISSING  $name in skills/zerospec/prompts/"
      DRIFT=1
    elif ! diff -q "$f" "$dest" > /dev/null 2>&1; then
      echo "OUTDATED $name"
      DRIFT=1
    fi
  done
  for f in "$DEST_DIR"/*.md; do
    [[ -e "$f" ]] || continue
    name="$(basename "$f")"
    if [[ ! -f "$SRC_DIR/$name" ]]; then
      echo "EXTRA    $name in skills/zerospec/prompts/"
      DRIFT=1
    fi
  done
  if [[ $DRIFT -eq 0 ]]; then
    echo "OK  skills/zerospec/prompts/ is in sync with prompts/"
  else
    echo ""
    echo "Run 'bash scripts/sync-skills.sh' to update."
    exit 1
  fi
  exit 0
fi

# ── Sync mode: copy prompts/*.md → skills/zerospec/prompts/ ──────────────────
echo "Syncing prompts/ → skills/zerospec/prompts/ ..."
mkdir -p "$DEST_DIR"
for f in "$SRC_DIR"/*.md; do
  name="$(basename "$f")"
  dest="$DEST_DIR/$name"
  if ! diff -q "$f" "$dest" > /dev/null 2>&1; then
    cp "$f" "$dest"
    echo "  updated: $name"
  fi
done
for f in "$DEST_DIR"/*.md; do
  [[ -e "$f" ]] || continue
  name="$(basename "$f")"
  if [[ ! -f "$SRC_DIR/$name" ]]; then
    rm "$f"
    echo "  removed: $name"
  fi
done
echo "Done."

# ── Install mode: also copy to ~/.claude/skills/zerospec/ ─────────────────────
if [[ "$MODE" == "install" ]]; then
  echo ""
  echo "Installing to $INSTALL_DIR ..."
  mkdir -p "$INSTALL_DIR/prompts"
  cp "$REPO_ROOT/skills/zerospec/SKILL.md" "$INSTALL_DIR/SKILL.md"
  cp "$DEST_DIR"/*.md "$INSTALL_DIR/prompts/"
  echo "Installed: $INSTALL_DIR"
  echo ""
  echo "Verify installation:"
  echo "  ls $INSTALL_DIR"
  echo "  ls $INSTALL_DIR/prompts"
fi
