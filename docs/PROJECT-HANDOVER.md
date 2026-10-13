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
| `docs/RELEASE-CHECKLIST.md` | Standalone release gates, rollback and collection source-pin synchronization |

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

## 7. Historical maintainer requirements snapshot (12 October 2026)

**Historical snapshot only.** This section describes original requests and no longer represents the current build status. The authoritative 13 October status is in section 10 and the development log.

The maintainer has supplied rough feature notes, recorded precisely in [ROADMAP.md](ROADMAP.md) under **P1A — Player-requested current-stage experience**. Treat these as **requested, not implemented**:

- Investigate a Tier 0 character displayed as Tier 1; verify the backend reply before editing stage mapping.
- Make Refresh request fresh progression and select the true current-tier page; repeat refresh and focus selection after reopening.
- By default hide unreached expansion/tier guides, while allowing current-expansion side content and General; for Tier 0, show Tier 0 and Tier 1 only in Vanilla's progression list.
- Add an accessible, bottom-placed Settings panel with default-OFF **Show all content** option, preserving user choice.
- Allow Escape to close the window.

**Important client-source distinction:** Existing Refresh and OnShow already send `.ipsvc data`, but receipt does not automatically force current-page navigation. The displayed Tier 1 issue may be a stale selection or a server-value discrepancy; do not assert a root cause without reproducing it. See [TESTING.md](TESTING.md) S04–S07/S12–S15.

## 8. Work in progress — feature branch

A candidate UI implementation exists on branch `feat/ip-companion-stage-navigation-2026-10-12`, based on `docs/ip-companion-project-handover-2026-10-12`. It introduces reply-driven page focus, a default hidden-future navigation layout, a Show all content setting, and Escape-to-close. The same branch adds a Lua 5.1 syntax-check workflow.

**The implementation is NOT a verified or published release.** Review the feature PR and test it in WoW 3.3.5a before merging. A reported Tier 0 character labelled Tier 1 still requires backend and UI evidence; the numeric mapping has intentionally not changed. See the latest Development Log entry and Testing plan for acceptance steps.

The two PRs are stacked: documentation first, then this feature. If both are merged, refresh these notes to reflect the new baseline.

## 9. Immediate starting point

The repository was documented as v5.2.0 on 12 October 2026. No current post-5.2.0 in-game regression test is evidenced by these baseline documents. Start with the **read-only functionality audit and regression test plan** in the roadmap, rather than presuming a defect or changing server rules.

If another session makes changes, record the PR and updated state in the development log; future chats should not rely on this snapshot alone.



## 10. Current branch/PR status — 13 October 2026

**This section supersedes the status in sections 7–9.** Stable `main` was still v5.2.0 when this draft work was prepared. No merges or standalone release/version bump have been authorised.

### Stacked changes (merge in dependency order only)

1. [PR #1](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/1) — documentation, base `main`.
2. [PR #2](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2) — stage focus, hidden future tiers, Settings, Escape and Resource Hub guide footer.
3. [PR #5](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/5) — authoritative read-only self-character lookup via `.ip get <name>`. The maintainer tested `Admina` (progression **2**) successfully and explicitly accepted **that GM test alone** as sufficient verification of this specific tier-detection correction. No normal-player repetition is required for their acceptance.
4. [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6) — Resource Hub copy editbox, adaptive text layout, concise footer and **the maintainer-approved ORIGINAL COMPACT sidebar**. An experimental wide, tall, multi-line sidebar was rejected in WoW as visually bulky and has been reverted. Do not reintroduce it without approval.
5. **Draft** [PR #7](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/7) — 17 tier-specific optional personal checklists, 81 stable saved task IDs with detailed guide-derived descriptions, isolated per-realm/character/tier SavedVariables, manual progress display and guarded reset. After the maintainer showed the initial popup and called it visually lacklustre and vague, the popup was rebuilt with an **opaque backdrop, scrollable detailed task cards, category/mark labels, and a Done control**, without touching the compact sidebar. **The redesign still requires in-game visual approval, `/reload` persistence and server-content review.**

### Next required step

Consult [PERSONAL-TIER-CHECKLISTS.md](PERSONAL-TIER-CHECKLISTS.md), [TESTING.md](TESTING.md) S31–S41, and the latest passing GitHub Actions PR test artifact. Back up the standalone addon folder and SavedVariables before asking the maintainer to install a new build. Check popup layout using their custom font, task persistence after `/reload`, reset cancellation, and accuracy of guide-derived checklist descriptions before release. Never treat local checkboxes as proof of actual quest completion.

Existing `N-Addon-Collection` is pinned to stable v5.2.0 until a **separately approved release**; do not update its lockfile early. No live database updates, `.ip set` commands, or server recompiles are required for these addon-only features.

