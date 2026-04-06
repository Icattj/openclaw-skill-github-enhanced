---
name: github-enhanced
description: Advanced GitHub operations via the gh CLI. Search repos, issues, PRs, view code, manage repos, and more. Use when asked to search GitHub, find repositories, look up issues/PRs, view repo details, compare projects, or perform any GitHub operation beyond basic git. Requires gh CLI with authentication.
---

# GitHub Enhanced

Wraps the `gh` CLI for advanced GitHub operations.

## Prerequisites

```bash
# Check if gh is installed and authenticated
gh auth status
```

If not installed: `sudo apt install gh` or `brew install gh`
If not authenticated: `gh auth login`

## Common Operations

### Search repositories
```bash
scripts/gh-search.sh "AI OCR accounting"
gh search repos "query" --limit 10 --sort stars
gh search repos "query" --language python --sort updated
```

### Search issues/PRs
```bash
gh search issues "bug label:critical" --repo owner/repo
gh search prs "feature" --state open --limit 20
```

### View repository
```bash
gh repo view owner/repo
gh repo view owner/repo --json description,stargazerCount,forkCount,issues
```

### Browse code
```bash
gh api repos/owner/repo/contents/path/to/file | python3 -c "
import json,sys,base64; d=json.load(sys.stdin)
print(base64.b64decode(d['content']).decode())
"
```

### Issues & PRs
```bash
gh issue list --repo owner/repo --state open --limit 20
gh issue view 123 --repo owner/repo
gh pr list --repo owner/repo --state open
gh pr view 456 --repo owner/repo
```

### Repository stats
```bash
gh api repos/owner/repo --jq '{stars:.stargazers_count,forks:.forks_count,issues:.open_issues_count,language:.language,updated:.updated_at}'
```

### Clone & explore
```bash
gh repo clone owner/repo -- --depth 1
```

### Trending (via API)
```bash
gh api search/repositories -f q="created:>$(date -d '7 days ago' +%Y-%m-%d)" -f sort=stars -f per_page=10 --jq '.items[]|"\(.stargazers_count)⭐ \(.full_name) — \(.description // "no desc")"'
```

## Script

`scripts/gh-search.sh` provides a quick search with formatted output.
