#!/usr/bin/env bash
# Search GitHub repos with formatted output
# Usage: gh-search.sh <query> [--language <lang>] [--limit <n>]
set -euo pipefail

QUERY="${1:?Usage: gh-search.sh <query> [--language <lang>] [--limit <n>]}"
shift
LANG=""
LIMIT="10"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --language|-l) LANG="$2"; shift 2 ;;
        --limit|-n) LIMIT="$2"; shift 2 ;;
        *) shift ;;
    esac
done

if ! command -v gh &>/dev/null; then
    echo "❌ gh CLI not installed. Install: sudo apt install gh"
    exit 1
fi

ARGS=(search repos "$QUERY" --limit "$LIMIT" --sort stars)
if [ -n "$LANG" ]; then
    ARGS+=(--language "$LANG")
fi

echo "🔍 Searching GitHub: $QUERY"
echo ""

gh "${ARGS[@]}" --json fullName,description,stargazersCount,language,updatedAt | python3 -c "
import json, sys
repos = json.load(sys.stdin)
for r in repos:
    stars = r.get('stargazersCount', 0)
    lang = r.get('language', '?')
    name = r.get('fullName', '?')
    desc = (r.get('description') or 'No description')[:80]
    print(f'{stars:>6}⭐  {name} [{lang}]')
    print(f'        {desc}')
    print()
print(f'Total: {len(repos)} results')
"
