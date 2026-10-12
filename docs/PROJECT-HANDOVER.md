# Individual Progression Companion — Project Handover

**Project:** Individual Progression Companion (IP Companion)
**Maintainer:** CosmicCuddle
**Established:** 12 October 2026
**Repository:** https://github.com/CosmicCuddle/Individual-Progression-Companion
**Default branch:** `main`
**Confirmed baseline:** v5.2.0; last pre-documentation commit `6872cc726052f7d271a28ba48baa9bb5c7ad36e9` (11 September 2026)
**Client:** World of Warcraft 3.3.5a (TOC interface `30300`)

> This is the canonical continuation brief for future development sessions. Read it alongside [ROADMAP.md](ROADMAP.md), [DEVELOPMENT-LOG.md](DEVELOPMENT-LOG.md), [TESTING.md](TESTING.md), the root README, and CHANGELOG. Before editing, verify the current `main` branch, recent PRs, and code; this snapshot may be superseded.

## 1. Project mission

An in-game, server-specific handbook that explains what a character can do now, what is required to advance, and what unlocks next across Vanilla, The Burning Crusade, and Wrath of the Lich King. It accompanies the Grimfeather Individual Progression system on a customised AzerothCore server.

**Boundaries:**
- The addon reads progression information supplied by the server. It does **not** determine or grant progression by tracking boss kills on its own.
- This is client-side guide and UI work, not authority over server progression rules.
- Do not generalise CosmicCuddle-specific rules to other servers without explicitly configurable sources.
- Do not implement new server commands, character mutations, or progression overrides as part of presentation work.

## 2. Current repository layout

| Path | Role |
| --- | --- |
| `IndividualProgressionAddon.toc` | 3.3.5a addon metadata, `IndividualProgressionDB` SavedVariables registration, Lua loading |
| `IndividualProgressionAddon.lua` | Progression pages, guide content, status mapping, slash commands, UI and server-message handling |
| `README.md` | User features, installation and server-specific usage |
| `CHANGELOG.md` | Historical release notes, 1.0.0–5.2.0 |
| `docs/PROJECT-HANDOVER.md` | Session continuation and project boundaries |
| `docs/ROADMAP.md` | Priorities and acceptance criteria |
| `docs/DEVELOPMENT-LOG.md` | Decision and implementation history |
| `docs/TESTING.md` | Regression checklist and result template |

At the baseline the addon is implemented in a single approximately 3,410-line Lua file. Any later split into modules must preserve its TOC load order and 3.3.5a Lua compatibility.

## 3. Confirmed behaviour in the baseline

- Slash commands include `/ip` and `/progression`, plus navigation and `/ip refresh`.
- The UI has a scrollable navigation sidebar, current stage summary, stage walkthroughs, status colours, and a minimap toggle.
- Vanilla tiers cover Molten Core through Pre-TBC; TBC and Wrath tiers follow, with optional guidance on reputations, professions, PvP, world bosses, dungeons, attunements, Wintergrasp and more.
- Guide stages distinguish **Required to Advance** from **Recommended Before Advancing**.
- A SavedVariables table `IndividualProgressionDB` stores UI preferences, including minimap angle and last page.
- Stage display maps progression values `0` through `17`; the current code treats values `18` and above as progression-complete. **Verify this assumption against the current server before changing it.**

### Server message contract — preserve unless jointly updated

Client request:
```text
.ipsvc data
```

Sent using WoW SAY chat via `SendChatMessage`.

Expected server system-chat reply:
```text
##IPSVC##PD~<progression value>
```

The client processes `CHAT_MSG_SYSTEM`, parses the `PD` value, and filters messages with the `##IPSVC##` prefix from normal chat display. This contract is observed in the client source; server-side implementation and behaviour must be verified separately before modifying it.

Do **not** silently replace the protocol or hide unrelated system messages.

## 4. Engineering rules

1. **Backups first.** Before gameplay-related changes, preserve a copy of the current addon folder and `WTF/Account/<account>/SavedVariables/IndividualProgressionAddon.lua` if it exists; safeguard any server-side database/config before work involving those components. Never ask for destructive production tests.
2. **One scope per PR.** Work in a separate branch and submit a descriptive pull request. Do not directly rewrite `main` or merge without review/permission.
3. **Preserve functionality.** Keep the existing 3.3.5a UI APIs, slash-command aliases, progression guide coverage, saved-variable compatibility, and server messaging intact unless a change is explicitly approved.
4. **Avoid module conflict.** Check proposed integrations against Individual Progression, Mod-Naxxramas-Core, N-MultiBot-Chatless, N-Addon-Collection and the client setup system when relevant. Never assume another repository's API or release contents.
5. **Evidence matters.** Distinguish documented behaviour, code-inspected behaviour, in-game verified behaviour, and unverified assumptions. A successful code review is not equivalent to an in-game test.
6. **Accessibility matters.** Prefer short, readable instructions and clear UI labels; avoid overlapping text, illegible scaling, and unnecessary manual steps.
7. **Reversible changes.** Record affected files, migration needs, testing evidence and rollback procedure for each meaningful change.
8. **No automatic gameplay changes.** The addon should not silently spend gold, set talents, trigger progression, manipulate character records, or issue privileged server commands.

## 5. Standard development cycle

1. Review current repository state, open PRs, this handover, roadmap and latest development-log entry.
2. Identify one high-priority milestone; check if it is already shipped or blocked.
3. Inspect the exact existing code and server-side integration before proposing edits.
4. Create a branch and implement a focused change; protect backups if required.
5. Run code/static checks and use [TESTING.md](TESTING.md) for in-game regression tests when possible.
6. Open a PR with summary, affected files, risk, test evidence and rollback notes.
7. After verification/merge, update the roadmap state, append a dated log entry, update the README if user-facing behaviour changed, and update CHANGELOG for release-worthy changes.
8. Do not mark a feature complete solely because its PR exists or code was written. Keep statuses explicit: Proposed → In progress → Implemented / awaiting in-game verification → Verified → Released.

## 6. Continuation protocol

When starting a new conversation, provide the following official entry points:

- Repository: https://github.com/CosmicCuddle/Individual-Progression-Companion
- Handover: https://github.com/CosmicCuddle/Individual-Progression-Companion/blob/main/docs/PROJECT-HANDOVER.md
- Roadmap: https://github.com/CosmicCuddle/Individual-Progression-Companion/blob/main/docs/ROADMAP.md
- Development log: https://github.com/CosmicCuddle/Individual-Progression-Companion/blob/main/docs/DEVELOPMENT-LOG.md
- Test checklist: https://github.com/CosmicCuddle/Individual-Progression-Companion/blob/main/docs/TESTING.md

**Paste into the next chat:**

> Continue development of Individual Progression Companion from the GitHub repository and official project handover. Read docs/PROJECT-HANDOVER.md, docs/ROADMAP.md, docs/DEVELOPMENT-LOG.md, docs/TESTING.md and the latest open/merged PRs before making changes. Follow the project's backup, compatibility, versioning, test and documentation rules. Resume the highest-priority unfinished milestone. Keep a log of decisions, changes, test results and next actions so the project can be resumed again.

## 7. Immediate starting point

The repository was documented as v5.2.0 on 12 October 2026. No current post-5.2.0 in-game regression test is evidenced by these baseline documents. Start with the **read-only functionality audit and regression test plan** in the roadmap, rather than presuming a defect or changing server rules.

If another session makes changes, record the PR and updated state in the development log; future chats should not rely on this snapshot alone.

