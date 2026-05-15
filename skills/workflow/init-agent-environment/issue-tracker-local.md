# Issue tracker: Local Markdown

Issues and PRDs for this repo live as markdown files under `docs/`.

## Conventions

- PRDs live at `docs/prd/<prd_topic_name>.md`
- Implementation issues live at `docs/issues/<NN>-<issue_description>.md`, numbered from `01`
- Triage state is recorded as a `Status:` line near the top of each issue file (see `triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

- **PRD:** Create `docs/prd/<prd_topic_name>.md` (creating the directory if needed)
- **Issue:** Create `docs/issues/<NN>-<issue_description>.md` (creating the directory if needed). `<NN>` is a zero-padded sequential number — scan existing files to determine the next number.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.
