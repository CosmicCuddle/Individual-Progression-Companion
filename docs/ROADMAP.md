# Individual Progression Companion — Development Roadmap

**Updated:** 12 October 2026
**Current published code baseline:** v5.2.0 (September 2026)
**Roadmap status:** planning baseline, not a release promise

This roadmap separates **existing features** from **proposed work**. A roadmap checkbox is not proof of a passing in-game test. Consult the handover and log before starting a milestone.

## Status definitions

- **Documented / existing** — described in release notes or observed in current source.
- **Proposed** — not implemented or not yet approved for implementation.
- **In progress** — active branch/PR work.
- **Awaiting test** — implementation exists but needs client/server validation.
- **Verified** — relevant acceptance tests passed and evidence recorded.
- **Released** — included in a published release.

## Existing baseline — documented / code-inspected

- [x] Vanilla guide and progression stages, with server-specific requirements
- [x] TBC guide, tier pages, attunements and side content
- [x] Wrath guide, tier pages, quests and side content
- [x] Step-by-step walkthroughs with required vs recommended actions
- [x] Two-panel UI, sidebar, progression display, minimap access
- [x] `/ip`, `/progression` and section navigation aliases
- [x] Server progression data request/reply handling in client code
- [x] Release history documented through version 5.2.0

**Important:** Above means present in documented code/release history, **not independently tested on 12 October 2026**.

## P0 — Establish authoritative project documentation

**Status:** In progress through the initial documentation PR; mark complete once merged.

- [ ] Store and link handover, roadmap, development log and manual test plan in GitHub
- [ ] Establish the PR/backup/test/rollback workflow
- [ ] Establish the next-chat continuation procedure

**Acceptance:** Documents are on `main` and discoverable from the README. No gameplay code is changed as part of this milestone.

## P1 — Baseline reliability and integration audit

**Status:** Proposed — recommended first code-related milestone.

- [ ] Confirm the live server still implements `.ipsvc data` / `##IPSVC##PD~...` for the installed addon
- [ ] Verify progression values at Vanilla, TBC, Wrath transitions and endgame, including the handling of `0` and `18+`
- [ ] Check missing, malformed, delayed or duplicate server responses; document observed behaviour before choosing a fix
- [ ] Check logout/login, character switching, reload, lost replies and manual `/ip refresh`
- [ ] Verify filtering affects only the intended addon system messages
- [ ] Confirm `IndividualProgressionDB` migration/persistence and non-destructive default handling
- [ ] Confirm WoW 3.3.5a Lua/API compatibility

**Acceptance:** Protocol and status semantics documented from both client and server source, with a basic real-client regression record. Any defects found get separate, focused fixes.

## P1A — Player-requested current-stage experience (12 October 2026)

**Status:** Implemented in PR [#2](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2). **Lua 5.1 syntax and mocked UI tests passed; actual 3.3.5a in-game testing and review are still required.** The backend Tier 0/Tier 1 discrepancy remains unverified and unresolved.

**Reported problem:** A player understood to be at **Tier 0** is labelled **Tier 1**. The source currently maps incoming value `1` to Tier 1, and the Refresh/reopen paths request data but do not necessarily select the current-stage page afterward. These are different possible causes: verify the actual server response before changing mapping.

- [ ] **Tier accuracy first:** compare the server's authoritative progression value, client status label, selected guide page and highlighted navigation item on an affected character. A read-only **Server progression value** readout has been added to the Settings page in the feature branch for this diagnosis.
- [ ] **Refresh means sync and navigate:** top-right Refresh requests fresh server data and, once a valid reply is received, navigates to the actual current-tier guide; do not claim success or move based on stale local data.
- [ ] **Reopening refreshes:** every close/reopen requests fresh state and selects the newly verified current tier. Preserve manual browsing *while open* unless Refresh is invoked.
- [ ] **Progressive visibility, default:** in Vanilla Tier 0 show only Tier 0 and Tier 1 under the progression stages, plus Vanilla Side Content and General. Hide later Vanilla tiers and the TBC/Wrath groups. As progression advances, reveal appropriate tiers; agree how completed tiers and earlier-expansion guides should remain accessible.
- [ ] **Always accessible:** General and a new Settings section remain visible; current-expansion side content remains accessible.
- [ ] **Show all content:** Settings panel near the bottom with a checkbox labelled **Show all content**. Default unchecked on clean installation. When checked, show all expansion/stage sections as they are in v5.2.0; save this preference without breaking existing SavedVariables.
- [ ] **Escape closes:** pressing Escape closes the main addon window using a WoW 3.3.5a-safe technique without interfering with ordinary game UI behaviour.
- [ ] **Graceful loading:** when server progression is unknown or a reply fails, show a truthful pending/unavailable state and ensure Settings/support navigation remains reachable.

**Acceptance:** Run S04–S07 and S12–S15 in [TESTING.md](TESTING.md), plus the Tier 0 visibility checks. Demonstrate both Show all modes, current-tier detection, Refresh and reopen behaviour using known test characters. Any changes to server-tier mapping require direct server-side evidence. No server-side modifications are authorised by this roadmap.

## P2 — UI quality and accessibility

**Status:** Proposed, subject to baseline test findings.

- [ ] Review text clipping, long guide pages, readability and navigation scrolling
- [ ] Check multiple resolutions and UI scales; avoid overlapping labels and controls
- [ ] Check current-stage button, selected-page behaviour, done/now/locked legend and minimap button behaviour
- [ ] Assess optional font/spacing improvements without losing the native WoW appearance
- [ ] Evaluate optional search or quicker section jumping **only if** it materially improves navigation

**Acceptance:** No UI collisions in test cases, all pages readable, keyboard/slash and mouse routes remain available, persistent preferences survive `/reload`.

## P2A — Resource Hub copying and responsive guide layout

**Status:** Implemented in [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6), simulated Lua 5.1 checks passed; in-game UI/clipboard verification pending.

- [x] Build a selectable/focusable edit field for the official Resource Hub URL instead of claiming direct clipboard access
- [x] Add a General Information copy button and `/ip hub` slash shortcut
- [x] Reflow navigation rows for enlarged fonts and keep guide text within the available width
- [ ] Verify Ctrl+C, popup keyboard handling, UI scale, non-overlap and tier-detection regression in the actual WoW 3.3.5a client

**Acceptance:** Player can copy/paste the exact URL, close the popup by Escape, and read both ordinary and long guides without clipping at normal and enlarged font settings.

### Compact sidebar — final maintainer preference (13 October 2026)

**Status:** Restored in [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6); automated regression passed; in-game confirmation of restored compact appearance pending.

- [x] Maintainer **rejected** the expanded / multi-line / "chunky" sidebar after inspecting it in WoW. This explicitly supersedes earlier full-label hard-wrap plans.
- [x] Restore the original **225px sidebar**, compact **28px single-line navigation rows**, and normal scroll behaviour. Do not automatically grow rows for larger fonts.
- [x] Keep optional full-name tooltip when hovering a truncated sidebar label, without increasing row height.
- [x] Retain concise unclipped footer text, copyable Resource Hub link and read-only progression detection.
- [ ] Confirm the restored compact appearance is preferred in the maintainer's actual custom-font client.
- [ ] Verify the URL popup and Ctrl+C in the game before release.

**Important:** Some long labels necessarily abbreviate visually in the compact bar. This is an accepted compromise; hovering provides the complete label. Future sidebar redesigns require renewed approval.

## P2B — Tier-specific personal preparation checklists

**Status:** Revised detailed checklist popup implemented in **draft [PR #7](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/7)**; Lua 5.1 mocks passed; revised **actual-client appearance, SavedVariables persistence and content review remain pending**. See [PERSONAL-TIER-CHECKLISTS.md](PERSONAL-TIER-CHECKLISTS.md).

- [x] Add 81 guide-derived manual checklist tasks (4–5 per tier) across Vanilla, TBC and Wrath; separate access, progression, recommended and optional labels
- [x] Store user marks per realm, character, tier and stable task ID in additive SavedVariables, retaining existing settings
- [x] Keep notes explicitly non-authoritative: ticking a box does not modify quests, boss kills, gold, reputations, server tiers or database values
- [x] Support independent completion per tier and prevent marks being shared by characters or realms in mocked tests
- [x] Add individual unchecking and **two-click confirmation** to reset only the selected tier; clear confirmation on dialog close
- [x] Keep the maintainer-approved **compact single-line sidebar** unchanged (button is on tier pages, not new navigation rows)
- [x] Respond to screenshot feedback: fully opaque scrollable task cards, meaningful descriptions for all 81 tasks, visual mark progress and prominent personal-notes disclaimer
- [ ] Review each task for accurate wording against live server rules and the Resource Hub before a stable release
- [ ] Test in WoW 3.3.5a with custom fonts, `/reload` persistence, logout/login, tier changes and cross-character isolation

**Acceptance:** Manual per-character preparation state survives reload, can be reversed safely, and never alters server-side progression.

## P3 — Content accuracy and expansion-rule alignment

**Status:** Proposed.

- [ ] Compare all player-facing progression claims against current live AzerothCore/IP/Naxxramas module behaviour
- [ ] Revalidate first-entry rules, boss/gate unlocks, attunements, War Effort/Scarab Gong steps, Vezrath services and costs
- [ ] Check talent restrictions, professions, flight paths, PvP seasons, world bosses and phased features for Vanilla/TBC/Wrath
- [ ] Keep required vs recommended steps separated consistently
- [ ] Flag server-configuration-dependent statements clearly
- [ ] Align relevant pages with changes to Naxxramas Resource Hub, but do not assume website guidance automatically changes server rules

**Acceptance:** Every updated claim has a confirmed source or recorded in-game test; uncertain rules are identified rather than presented as guarantees.

## P4 — Maintainability and performance

**Status:** Proposed; do not begin with a large rewrite.

- [ ] Evaluate splitting the current ~3,410-line Lua file into data, guide-content, UI and protocol modules
- [ ] If approved, use incremental PRs and preserve TOC load order and all slash-command aliases
- [ ] Check that large pages remain rendered correctly; guard against the historic long-page truncation issue
- [ ] Avoid unnecessary page rebuilding, frame allocations or saved-variable breaking changes
- [ ] Consider a lightweight syntax/static-check workflow compatible with older Lua

**Acceptance:** Function and appearance equivalence demonstrated before retiring the monolithic source; rollback is a simple code revert.

## P5 — Packaging, regression and release discipline

**Status:** Proposed.

- [ ] Test clean installation and overwrite-upgrade with the correct `Interface/AddOns/IndividualProgressionAddon/` layout
- [ ] Compare `.toc` version, README version, CHANGELOG and release tag
- [x] Draft standalone-to-collection release/import checklist in [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) (documented; not released)
- [ ] After release approval, import the exact standalone source SHA into N-Addon-Collection and update `sources.lock.json` through a separate reviewed PR
- [ ] Confirm compatibility with the current N-Addon-Collection distribution workflow, if included there
- [ ] Maintain a repeatable pre-release checklist and manually tested release notes
- [ ] Retain a known-good backup and rollback instructions

**Acceptance:** A release package installs, loads and passes smoke tests on the supported client; versioned documentation matches shipped files.

## Deferred ideas — not agreed features

Optional stage checklists, more context-sensitive guidance, an advanced diagnostics panel, and configurable server-rule profiles may be considered after reliability and content accuracy are established. These are **ideas**, not approved commitments. They must not override server authority or make silent character changes.

## Suggested next action

1. Merge the documentation-only PR after reviewing its wording.
2. Perform the P1 read-only client/server integration audit.
3. Record verified test outcomes in [DEVELOPMENT-LOG.md](DEVELOPMENT-LOG.md) and [TESTING.md](TESTING.md).
4. Select the smallest needed code fix or the first UI improvement based on evidence.

