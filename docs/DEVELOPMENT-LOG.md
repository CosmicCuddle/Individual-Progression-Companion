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

