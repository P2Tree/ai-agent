# Issue tracker: GitLab

Issues and specs for this repo live as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations.

## Conventions

- **Create an issue**: `glab issue create --title "..." --description "..."`. Use a heredoc for multi-line descriptions. Pass `--description -` to open an editor.
- **Read an issue**: `glab issue view <number> --comments`. Use `-F json` for machine-readable output.
- **List issues**: `glab issue list -O json` with appropriate `--label` filters.
- **Comment**: `glab issue note <number> --message "..."`. GitLab calls comments "notes".
- **Apply / remove labels**: `glab issue update <number> --label "..."` / `--unlabel "..."`. Multiple labels can be comma-separated or repeated flags.
- **Close**: post the explanation first with `glab issue note <number> --message "..."`, then `glab issue close <number>`; `close` does not accept a closing comment.
- **Blocking**: use a native blocking link via the `/blocked_by #<n>` quick action (`glab issue note <child> --message "/blocked_by #<blocker>"`). Native blocking links are Premium/Ultimate; on the free tier, or where unavailable, put `Blocked by: #<n>, #<n>` at the top of the description. A ticket is unblocked when every blocker is closed.
- **Merge requests**: GitLab calls PRs "merge requests". Use `glab mr create`, `glab mr view`, `glab mr note`, etc. — the same shape as `gh pr ...` with `mr` in place of `pr` and `note`/`--message` in place of `comment`/`--body`.

Infer the repo from `git remote -v`; `glab` does this automatically inside a clone.

## Merge requests as a triage surface

**MRs as a request surface: no.** _(Set to `yes` if this repo treats external merge requests as feature requests; `triage` reads this flag.)_

When `yes`, MRs run through the same labels and states as issues:

- **Read an MR**: `glab mr view <number> --comments` and `glab mr diff <number>`.
- **List external MRs for triage**: `glab mr list -O json`, then keep only MRs whose author is not a project member/owner.
- **Comment / label / close**: `glab mr note`, `glab mr update --label`/`--unlabel`, `glab mr close`.

Unlike GitHub, GitLab numbers issues and MRs separately, so `#42` is unambiguous once you know which surface the maintainer means.

## When a skill says "publish to the issue tracker"

Create a GitLab issue.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <number> --comments`.
