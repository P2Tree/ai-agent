# Tracker Commands

Quick reference for GitHub (`gh`) and GitLab (`glab`). Detect the forge from `git remote -v`; never mix commands from both.

## GitHub

```bash
gh issue list --state open --label "needs-triage"
gh issue view <n> --json number,title,body,labels,comments
gh issue comment <n> --body "..."
gh issue edit <n> --add-label "..." --remove-label "..."
gh issue close <n>
gh label list
gh pr list --state open
gh pr view <n> --comments
gh pr diff <n>
```

## GitLab

```bash
glab issue list --label "needs-triage"
glab issue view <n> --comments
glab issue note <n> --message "..."
glab issue update <n> --label "..." --unlabel "..."
glab issue close <n>
glab label list
glab mr list
glab mr view <n> --comments
glab mr diff <n>
```

## Canonical roles and default labels

Use these strings only when the tracker has no semantic equivalent. Confirm before creating a label.

| Canonical role | Default label |
|----------------|---------------|
| needs-triage | `needs-triage` |
| needs-info | `needs-info` |
| ready-for-agent | `ready-for-agent` |
| ready-for-human | `ready-for-human` |
| wontfix | `wontfix` |

## Resolution order

1. List existing labels.
2. Reuse a label that matches the role semantically.
3. If none matches, use the default string.
4. Before creating a new label, ask the user.
