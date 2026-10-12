# Individual Progression Companion — Development Log

This is the **working project record**. Keep chronological entries with clear status and links to GitHub PRs/commits. Published user-facing changes belong in the root [CHANGELOG.md](../CHANGELOG.md).

## 12 October 2026 — Development documentation foundation

**Status:** Documentation-only PR prepared; pending review/merge.
**Current addon baseline:** v5.2.0, commit `6872cc726052f7d271a28ba48baa9bb5c7ad36e9`.
**Scope:** Establish a durable GitHub handover/roadmap/test plan to survive chat transitions.

### Repository observations
- Existing files at baseline: `IndividualProgressionAddon.lua`, `IndividualProgressionAddon.toc`, `README.md` and `CHANGELOG.md`.
- TOC specifies interface `30300`, addon version `5.2.0` and SavedVariables `IndividualProgressionDB`.
- The source includes Vanilla/TBC/Wrath tier and side-content guides, the two-panel UI, slash commands, minimap button and server progression messages.
- The client sends `.ipsvc data` and expects system messages prefixed `##IPSVC##` with `PD~` progression data.
- A single Lua file contains approximately 3,410 lines. The current stage mapping is coded for `0`–`17`, with `18+` shown as completion. Server-side confirmation remains outstanding.

### Changes in this PR
- Added `docs/PROJECT-HANDOVER.md` for continuation, engineering safeguards and source-of-truth links.
- Added `docs/ROADMAP.md` with existing features, proposed priorities and acceptance criteria.
- Added `docs/DEVELOPMENT-LOG.md` to record decisions and evidence.
- Added `docs/TESTING.md` with manual regression procedures.
- Added README links to the documentation.

### Validation and risk
- Documentation/source review only; **no live WoW client/server test performed** for this PR.
- No Lua, TOC, DB, configuration or server commands changed.
- Rollback: revert the documentation PR.

### Open questions / next work
- Verify current server-side `ipsvc` handler and progression milestone semantics.
- Run the baseline in-game test matrix, especially stage 0, expansion boundaries, and progression-complete display.
- Reassess priorities after recording actual results instead of assuming there are bugs.

## 12 October 2026 — Player feedback captured as feature requirements

**Status:** Requirements documented only; not implemented or tested.
**Source:** Maintainer's rough IP Companion notes provided during planning.

### Requested behaviour
- Investigate a player reported as Tier 0 but displayed as Tier 1; treat stage accuracy as highest priority.
- Top-right Refresh should request authoritative progress and reset the guide to the actual current stage.
- Closing and reopening the addon should refresh and reselect the current stage.
- Default navigation should hide unreached progression content. Example: a Tier 0 player sees Tier 0, Tier 1, Vanilla Side Content and General; TBC/Wrath and later Vanilla tiers are hidden.
- Add a Settings panel near the bottom with an unchecked-by-default **Show all content** checkbox to restore all content when preferred.
- Escape should close the window.

### Initial code-reading observations (not a diagnosis)
- The current top-right Refresh calls `RequestData()`. The window's `OnShow` also requests data.
- OnShow restores `IndividualProgressionDB.lastPage` before receiving the new reply. After a valid reply, `UpdateDisplay()` updates status and reselects the existing `data.selectedPage`, rather than necessarily navigating to the current stage.
- The current mapping defines progression value `0` as Tier 0 and `1` as Tier 1. An actual backend reply of `1` for a Tier 0 character would be a separate issue from simply showing the Tier 1 guide.
- No server-side evidence, test log or confirmed root cause has yet been recorded.

### Next action
Complete baseline P1 verification, then deliver P1A in small reviewed PRs with checks in `docs/TESTING.md`. Do not silently change server authority or force-progress characters.

## 12 October 2026 — Candidate progressive navigation and refresh behaviour

**Status:** Feature branch implemented, unmerged; awaiting automatic Lua 5.1 syntax check and in-game verification. **Not yet released.**
**Branch:** `feat/ip-companion-stage-navigation-2026-10-12` (based on the documentation branch; feature PR targets that documentation branch until it is merged).

### Candidate implementation
- On normal open and on top-right Refresh, request `.ipsvc data`, display a pending indicator, and select the current guide page **only after receiving a valid server reply**.
- Reject missing, negative, fractional or nonnumeric `PD` values rather than interpreting them as Tier 0.
- Treat manual navigation and direct slash page commands as explicit user choices instead of overriding them when a delayed reply arrives.
- Create default progression-aware navigation, retaining reached tiers and previewing the next tier of the current expansion. Vanilla Tier 0 sees Tier 0 and Tier 1, plus Vanilla Side Content and General. Already reached earlier-expansion tier guides remain browsable; side content defaults to current expansion only.
- Add always-visible Settings footer with a saved `showAllContent` checkbox, unchecked on clean installation. This displays all legacy pages when enabled.
- Register the main window with WoW's `UISpecialFrames` for Escape-to-close.
- Provide a GitHub Actions `luac5.1 -p` syntax check; it passed on the initial feature commit. After a follow-up change, repeat the check before treating the latest head as syntactically validated. No live client test has been run.
- Add a read-only **Server progression value** display to Settings, based only on an accepted server reply; this helps distinguish a UI selection issue from a backend tier discrepancy.

### Compatibility and risk
- No change to the `ipsvc` request or response format, numeric tier mapping, guide content, or server code.
- New SavedVariables field: `IndividualProgressionDB.showAllContent` (boolean), with nil treated as false; existing fields remain.
- The original code's last-page preference is still recorded, but reopening now intentionally focuses the current stage after a valid reply.
- **Potential risks requiring testing:** older WoW 3.3.5a frame hierarchy, dynamically reflowed sidebar scrolling, Escape priority with other game panels, delayed server responses, UI scale, and the previously reported Tier 0/Tier 1 discrepancy.
- User report does not prove the server's tier value is wrong. Backend provenance must be checked before ever changing stage mapping.

### Verification and rollback
- Static source inspection: all 40 original navigation entries are listed exactly once in their dynamic groups; Settings is a separate footer.
- CI and in-game results: **pending; not yet passed**.
- Rollback: revert the feature PR (or restore known-good addon folder/SavedVariables backup). No DB migration or server recompilation.

### Next actions
1. Confirm CI `luac5.1` check outcome and resolve any syntax errors.
2. Have the maintainer test the feature branch using [TESTING.md](TESTING.md).
3. Record pass/fail evidence and compare the Tier 0 user's server reply against the selected guide display.
4. Update the code and documentation based on actual results; publish/merge only after approval.

## Recorded release history (from existing CHANGELOG; not re-tested here)

- **5.2.0:** Expanded TBC/Wrath guides and fixes to missing Wintergrasp and Tier 17 icons.
- **5.1.0:** Step-by-step tier walkthroughs and required/recommended split.
- **5.0.0:** Wrath progression support.
- **4.0.0:** TBC progression support.
- **3.x:** Vanilla server companion, navigation, progression and talent guidance.
- **2.0.0 / 1.0.0:** Handbook redesign and initial addon.

For detailed historic changes, refer to [CHANGELOG.md](../CHANGELOG.md).

---

## Template for future entries

### YYYY-MM-DD — Short change title

- **Status:** Proposed / In progress / Awaiting test / Verified / Released
- **Issue/PR/commit:** URL or `not yet created`
- **Reason:** User-facing need or verified defect
- **Files/systems affected:** Exact files; note server changes separately
- **Implementation:** What changed and what was deliberately left unchanged
- **Testing:** Test environment, cases run, results and evidence; write `not run` when appropriate
- **Backup/rollback:** How to undo the change
- **Decision and next action:** What is pending, what is approved and who must verify

Never record a proposed change as shipped or a code review as an in-game pass. Update the roadmap and handover whenever the project's current state or continuation instructions materially change.

