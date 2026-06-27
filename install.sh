#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

# Standards directory - symlink the whole folder
ln -sf "$REPO_DIR/coding-standards" "$CLAUDE_DIR/coding-standards"
echo "Linked coding-standards -> $CLAUDE_DIR/coding-standards"

# CLAUDE.md - append if exists, symlink if not
if [[ -f "$CLAUDE_DIR/CLAUDE.md" ]]; then
    echo ""
    echo "CLAUDE.md already exists at $CLAUDE_DIR/CLAUDE.md."
    echo "Manually append the contents of $REPO_DIR/CLAUDE.md to it"
else
    ln -sf "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    echo "Linked CLAUDE.md -> $CLAUDE_DIR/CLAUDE.md"
fi