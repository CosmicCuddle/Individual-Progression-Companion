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

## 13 October 2026 — Live QA: Admina regression result

**Status:** Primary Tier 2 detection failure now reported as working in the installed PR #5 QA build; broader validation remains pending.

- The maintainer verified `.ip get Admina` returns **2**, installed the draft feature test build, and subsequently confirmed: **"Yep seems to work as it is supposed to now"** when asked whether the addon displays the correct tier.
- Record as a **maintainer-reported pass** for the original Admina Tier 6-vs-Tier 2 display mismatch. The user did not provide a post-fix screenshot or explicitly certify the full multi-character regression matrix.
- Client now queries read-only `.ip get <UnitName("player")>` rather than the old discrepant `.ipsvc data` service; no server progression, hidden quests or GM commands changed.
- Remaining manual checks: selecting another character/bot, login and reopening/Refresh, normal-player account, missing server response and font/UI-scale variations. Keep the PR draft until reviewed and approved.
- Rollback: restore prior addon folder and corresponding SavedVariables backup only if necessary; do not modify server data.

## 13 October 2026 — Admina progress comparison and regression test

**Status:** Live discrepancy confirmed, root cause unverified. See [bug #3](https://github.com/CosmicCuddle/Individual-Progression-Companion/issues/3).

- Maintainer supplied an in-game screenshot of `.ip get` showing **`Progression Level for Admina = 2`**. A prior IP Companion screenshot for Admina showed **Tier 6**. This is confirmed disagreement between the two displayed results, not yet proof of the `.ipsvc data` response.
- The next necessary read-only datum is Admina's **Settings → Server progression value** after a manual Refresh. Until that is provided, do not guess whether the bug is client-side stage selection or server-side `.ipsvc` reporting.
- Added synthetic Lua 5.1 regression for **PD~6 → Refresh → PD~2**, asserting the selected guide returns to Tier 2, Tier 3 preview appears, old Tier 6 hides, future TBC guide hides, and the diagnostic changes to value 2.
- GitHub Actions [run 38380306796](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38380306796): Lua 5.1 syntax, mocked UI flow including backward transitions, TOC and QA package **passed**.
- **No live server state was changed**, no client tier remapping was invented and no deployed `.ipsvc` service code was modified. A passing simulation does not validate the actual server response.

## 13 October 2026 — Live tier mismatch and command permissions clarification

**Status:** Open bug [#3](https://github.com/CosmicCuddle/Individual-Progression-Companion/issues/3); diagnosis pending. No character state, server command, or addon logic changed in response to this report.

- Screenshot shows GM character **Admina** displayed as **Tier 6 — Naxxramas**, while the maintainer expects **Tier 2**. Need to compare authoritative progression for *that character* with the addon Settings → **Server progression value** after Refresh.
- Maintainer explicitly confirms that **ordinary players can use `.ip get`** on the deployed server; **`.ip set` is GM-only**. The public upstream command definition reviewed separately marks `.ip get` GM-only, so it is not a faithful description of the deployed server's permissions. Do not copy that upstream assumption into client restrictions.
- Upstream progression getter reads the highest rewarded hidden quest `66000 + tier`. The deployed `.ipsvc data` handler still needs inspection: it may not resolve the same character or get exactly the same numeric result.
- Read-only next test: on Admina, use `/cleartarget`, then `.ip get`, and compare name/value with Settings → Refresh → **Server progression value**. Do **not** call `.ip set` to test or "correct" tier.
- UI must track confirmed progression **both downward and upward**, without rewriting quest flags or trusting stale results.
- Approved future enhancements recorded in [issue #4](https://github.com/CosmicCuddle/Individual-Progression-Companion/issues/4): copyable Resource Hub URL, font/UI-scale resilience, and local per-character tier preparation checklists. These are separate from this bug and are not implemented yet.

## 13 October 2026 — Maintainer Settings feedback and Resource Hub footer

**Status:** Changes implemented in [PR #2](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2); awaiting refreshed client test.
**Evidence received:** Maintainer screenshot shows Settings rendered in WoW, **Show all content unchecked**, and **Server progression value: 0** for the pictured character. This is useful evidence of a successful server reply for that character; it does **not** establish whether a separate friend's reported Tier 0/Tier 1 mismatch is resolved.

### Changes
- Settings now has shorter Off/On guidance, and a separate orange warning explaining that `Show all content` reveals future stages outside the companion's intended stage-by-stage experience. It does not unlock server progression.
- Settings hint, warning and diagnostic text are anchored sequentially using each preceding FontString's bottom edge, rather than using a fixed Y offset. This is to prevent overlap with large/custom fonts.
- **General Information**, at the end of its normal guide content, now includes a **Further Server Information** heading and the user-supplied Naxxramas Resource Hub URL: https://cosmiccuddle.github.io/Naxxramas-Resource-Hub/
- Added Lua 5.1 mocked regression assertions for both text changes and relative text anchors. Manual cases **S18–S19** must still be tested in the actual client.

### Scope and rollback
- No progression logic, server commands, database, saved variable format or existing URL changed.
- Revert these feature-branch commits or restore the previous addon folder if issues occur. Do not update N-Addon-Collection's locked v5.2.0 source before an approved release.

## 12 October 2026 — Automated downloadable PR test package

**Status:** Available for manual QA; not a stable release and not yet installed/tested in WoW.
**Feature PR:** [#2](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2)
**Workflow:** [Run 38312672487](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38312672487)

- Added PR-only packaging to `.github/workflows/lua-compatibility.yml`. Only after Lua 5.1 syntax, TOC and mocked UI tests succeed, Actions assembles `IndividualProgressionAddon/` with the two addon files and a `QA_BUILD_NOTICE.txt`.
- GitHub Actions upload succeeded: artifact **IP-Companion-PR-TestBuild**, artifact ID `11774694144`, 61,323 bytes compressed, source head `ad26f383e10d27b7bba7146dc69d45d964c99958`. GitHub reports expiration **26 October 2026**.
- The archive contains a test-only addon folder; it is not a GitHub Release, has not been merged to `main`, and does not update `N-Addon-Collection` or its source lock.
- Installation and rollback instructions have been added to [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md).
- **No in-game testing evidence has been supplied yet.** Do not infer that the Tier 0/Tier 1 discrepancy is resolved solely because the automated checks and packaging passed.

## 12 October 2026 — Final pending-state and release-distribution review

**Status:** Candidate fixes implemented; automated code checks passing. **No real-client test or release approval yet.**
**Feature PR:** https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2

### Changes and review findings

- Fixed pending UI display: when Refresh or reopening invalidates previously loaded progression data, the selected guide page is re-rendered. A stale **CURRENT STAGE** subtitle is replaced with **Waiting for server...** until a valid reply arrives.
- Added a regression assertion for that transition to `tests/test_ui_compatibility.lua`.
- The new test initially failed because WoW colour escape prefixes preceded the visible text, while the assertion assumed a raw string prefix. Corrected the mock test to search within the colour-formatted FontString, without stripping actual client formatting or weakening the addon behaviour.
- GitHub Actions [run 38312418823](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38312418823), feature code commit `592da0a52786b464ac2241db32fe6a9f9f103045`: **success** for Lua 5.1 syntax, client metadata/load order, and simulated UI test flow.
- Audited N-Addon-Collection source packaging: its `sources.lock.json` still pins IndividualProgressionAddon to the v5.2.0 source SHA `6872cc726052f7d271a28ba48baa9bb5c7ad36e9`. Do not update it until the standalone addon has been approved, tested and released.
- Created [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) to distinguish standalone release and suite import, backup/rollback, client test requirements, and explicit versioning. Existing addon remains labelled **v5.2.0**, as the feature PR is not a release.

### Outstanding blockers

1. Documentation PR #1 still needs review and merge to `main`; PR #2 remains stacked on that branch.
2. An affected known Tier 0 character must be inspected through Settings → **Server progression value**. If the server reply is `1`, investigate server progression mapping rather than modifying the client value arbitrarily.
3. Test the actual UI in WoW 3.3.5a, including ESC, the bottom Settings footer, visibility, `/reload` preference persistence and non-overlap at different UI scales.
4. Only after in-game acceptance, choose version, update changelog/TOC/README consistently, prepare a standalone release and later a separately approved N-Addon-Collection import.

**Rollback:** Restore a backed-up v5.2.0 addon folder (and account SavedVariables only if necessary) or revert PR #2. No server or DB changes are included in the current feature work.

## 12 October 2026 — PR #2 interface hardening and automated regression testing

**Status:** Implemented on PR #2, code review and mocked WoW 3.3.5a testing in progress; live-client verification still required.
**PR:** https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/2

### Follow-up fixes
- When Settings is selected, hide the guide's overlapping scroll frame; show it again on normal guide pages so the Settings checkbox is accessible.
- Label stage pages **Waiting for server...** while a new progression response is pending, instead of incorrectly labelling them **Available**.
- Add a Settings navigation icon and an explicit `/ip settings` / `/ip options` shortcut.
- Preserve the authoritative tier response and do not invent a correction for the previously reported Tier 0/Tier 1 mismatch.

### Repeatable tests added
- Added `tests/test_ui_compatibility.lua`, a Lua 5.1 mock of key 3.3.5a UI APIs; CI now runs it after Lua syntax and TOC checks.
- Mocked flow covers opening, refresh and reopen, values 0/1/8/13/17/18, malformed replies, hidden/visible expansion sections, manual navigation during reply, persisted Show all content, Settings panel visibility, the raw progression-value diagnostic and Settings shortcut.
- Earlier CI runs exposed flaws in the *test mock* (an uninitialised event table and optional property lookups). Both were fixed in the mock; addon syntax and TOC checks had passed throughout.
- Initial full mocked UI test passed on GitHub Actions run [38311599605](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38311599605) at commit `7edcfe234f390da23356d9e5d986820b5fb98140`. Further checks for the new Settings icon and shortcut were added afterward; verify the latest PR head checks before considering CI complete.

### Limitations and rollback
- The mock confirms internal client-side state changes; **it does not prove real WoW click handling, frame layering, textures, client sizing, or server progression semantics**.
- Test with an actual known Tier 0 character and compare the raw **Server progression value** against the guide title. A reply of 1 would require server-side investigation, not a guessed client remapping.
- No core rebuild, database migration or progression reset is needed. Restore prior addon folder and SavedVariables backup or revert this PR if live testing finds a regression.
- Keep PR #1 (documentation) as the prerequisite; PR #2 is stacked on its branch and must not be merged before documentation.

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

