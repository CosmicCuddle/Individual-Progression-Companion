# Individual Progression Companion — Development Log

This is the **working project record**. Keep chronological entries with clear status and links to GitHub PRs/commits. Published user-facing changes belong in the root [CHANGELOG.md](../CHANGELOG.md).

## 13 October 2026 — Tier 9 longer-stage checklist visual acceptance

**Status:** **Maintainer-approved in-game presentation**, no code change required. Draft PR #7 remains unmerged.

- In WoW, the maintainer opened Tier 9 **Serpentshrine Cavern / Tempest Keep** and supplied a screenshot showing all five checklists, complete readable descriptions, final **Defeat Kael'thas** card and fixed Reset/Done controls.
- The display read **0 of 5 marked**, with no unexpected marks, clipping or overlapping. All five cards fit in the available panel; thus no manual scrolling was necessary.
- The maintainer confirmed **"Yes i thought it was fine."** Record **PASS for Tier 9 layout and final-task access**. Do not claim an actual in-game overflow scroll test; long-text scrolling remains covered by Lua mocked tests and is optional additional coverage.
- Already accepted in-game: Tier 0 compact visual layout, four marks surviving `/reload`, and the temporary-tier Reset confirmation/cancellation workflow.
- Keep the current compact sidebar, checklist spacing, 81 task IDs and user SavedVariables unchanged. No further redesign or download is required for this acceptance.
- Next release discussion: review dependencies PR #1 → #2 → #5 → #6 → #7 and request explicit maintainer authorization before merging or publishing; no automatic N-Addon-Collection pin change.

## 13 October 2026 — Live test accepted: two-step reset on a temporary tier

**Status:** **Maintainer-reported PASS** in WoW for the optional safe Reset workflow, following the documented six-step verification procedure.

- The maintainer replied **"Yes that worked correctly"** after testing a temporary checkbox in Tier 1 (or another initially empty tier), verifying the first reset click only armed **Confirm reset?**, closing/reopening cancelled it, and deliberate double-click confirmation removed the temporary mark.
- The procedure also instructed revisiting Tier 0 to check the four previously saved Molten Core marks were unchanged; the maintainer reported the procedure worked. This is a **user-reported acceptance**, not a separately captured screenshot of every screen.
- Previously recorded independent success: Tier 0's four checkmarks persisted across `/reload`; all five tasks fit without scrolling and the compact layout was visually approved.
- Mock tests additionally check same-character cross-tier and cross-character isolation and long task scroll overflow, [Actions run 38406545987](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38406545987).
- **Still not separately tested in-game:** longer TBC/Wrath task overflow, optional other-character/realm persistence, remaining deployment-specific rule review. Do not mark these as passed by inference.
- No runtime addon source, SavedVariables schema, server commands or database changed for this acceptance. Draft PR #7 remains unmerged pending final integration/release review.

## 13 October 2026 — Reset isolation and longer-tier scroll review

**Status:** Automated test expansion passed; in-game confirmation of temporary-tier reset and longer guide readability remains optional/pending. Draft PR #7 remains unmerged.

- Maintainer explicitly confirmed the Tier 0 screenshot showing **4 of 5** marks was captured **after `/reload`**. The prior Tier 0 SavedVariables test therefore stays passed and need not be repeated.
- Reviewed the Reset code: one click arms `Confirm reset?` without deleting any flags; closing/Done cancels the pending reset, and a second deliberate click clears **only the selected tier** for the current realm/character.
- Extended Lua 5.1 mocked tests to create temporary Molten Core notes while retaining a Blackwing Lair mark on the **same character**. Verified cancel and confirmed Reset both preserve the Blackwing Lair data, as well as another character's Molten Core marks.
- Extended mocked longer-tier overflow test: unusually tall task descriptions enable wheel scrolling; reopening resets to the top.
- [GitHub Actions run 38406545987](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38406545987) **passed** Lua 5.1 parsing, 3.3.5a client load/TOC checks, mocked UI and PR-only packaging.
- To avoid risking the maintainer's **four existing Tier 0 marks**, any optional in-game Reset test should use a **different, initially empty tier** with a temporary single mark. The full reset must never be tested on meaningful saved Tier 0 progress.
- No production addon logic, task IDs, SavedVariables schema, live server, SQL or character progression was changed during this review. The current installed test build remains sufficient for manual QA.

## 13 October 2026 — Tier 0 follow-up: four marks shown

**Evidence:** Following the request to tick Hydraxian Waterlords rune dousing and test persistence with `/reload`, the maintainer supplied an in-game Molten Core screenshot showing **4 of 5 marked**, including the newly marked Hydraxian task. The previous visual acceptance screenshot showed **3 of 5 marked**.

- All five compact task cards remain visible without scrolling; the mark count and progress bar agree; Ragnaros remains unchecked.
- **PASS — confirmed by the maintainer:** The screenshot was captured **after `/reload`**. The four manual Molten Core marks, including Hydraxian Waterlords rune dousing, survived the reload, and the 4/5 progress bar remained correct. This verifies this character's Tier 0 SavedVariables persistence in game; other characters/tiers have not been independently tested.
- No change to task IDs, saved state, UI layout, server progression or database. PR #7 is still a draft/unmerged.
- No need to repeat the Tier 0 reload test. Remaining distinct release checks include longer-tier overflow, reset confirmation if desired, and selected server-specific task wording.

## 13 October 2026 — Maintainer confirms custom Pre-AQ signet requirement

- The maintainer explicitly confirms the Pre-AQ War Effort requirement was **manually changed to 1,500 Commendation Signets** on the server. This explains why the official companion/Resource Hub documentation differs from public upstream SQL at 1,000.
- Treat **1,500** as the current intended server rule. Do not ask for extra quest screenshots merely to reconcile the upstream default; optional direct DB verification remains outside this source audit.
- Keep the same checklist IDs, task states, addon layout and progression detection. No SQL, world DB, quests or server modules were changed as part of recording this clarification.
- [Content audit](TIER-CHECKLIST-CONTENT-AUDIT.md) updated accordingly; other server-custom rule checks and SavedVariables `/reload` acceptance remain distinct tasks.

## 13 October 2026 — Source review: 81 checklist items

**Status:** Completed a **source-derived content audit of all 81 tasks** against the 17 built-in stage guides and available Naxxramas Resource Hub information. **Deployed server-rule verification is not complete**. Full per-tier review: [TIER-CHECKLIST-CONTENT-AUDIT.md](TIER-CHECKLIST-CONTENT-AUDIT.md).

- Confirmed stable task IDs and saved per-character/realm/tier keys are unchanged. Checked category assignments and how each summary relates to **Required to Advance** versus optional/recommended preparation.
- Corrected **Pre-AQ Commendation Signets** from `Recommended` to **`Required`**. Current official companion guide and Resource Hub state **1,500 signets**; the public upstream `aq_war_effort.sql` specifies **1,000**. **The maintainer has since confirmed that they deliberately changed the server requirement to 1,500**, explaining the divergence. No live database inspection was performed.
- Separated Tier 7's **Into the Breach progression quest** from the separately paid **2,500g Chronomancer Vezrath TBC service**.
- Labelled Nightbane's Blazing Signet **Future Access** for SSC, Hyjal's attunement sequence as **Access** rather than merely recommended, and Ruby Sanctum's outer bosses as the access path to Halion. Avoided implying only Normal Halion kills can satisfy the progression boss requirement.
- Added concrete instructions from source guides: seven rune douses/Aqual versus Eternal, Pre-AQ gong shortcut/Mallet, Karazhan Master's Key dungeon fragments, Gruul and Nightbane SSC signets, Trials of the Naaru, Magisters' Terrace Hard to Kill, Naxx attunement reputation, Wrath's early emblem gear and Sapphiron/Malygos link.
- Expanded Lua 5.1 mocked coverage to assert **81** task rows across **17** tiers plus key gate categories and details.
- **No GM `.ip set`, world/character DB, actual quest progress, existing task IDs, or compact navigation design was modified.** Changes are limited to client wording/category presentation and tests.

### Remaining accuracy and release checks
- **Maintainer-confirmed custom rule:** the Pre-AQ `Complete the War Effort` requirement was manually changed to **1,500 signets**, differing from upstream's 1,000. No additional screenshot is required; optional DB inspection is separate.
- **Medium:** get evidence for any further server-specific custom access/attunement rule if doubts arise; the deployed custom handler was not provided.
- **Client:** `/reload` SavedVariables persistence and longer-tier scrolling are not yet independently tested in-game.
- PR #7 remains a draft/unmerged. No stable release/N-Addon-Collection update was performed.

## 13 October 2026 — PR #7 compact checklist visually accepted

**Status:** **Maintainer-approved in-game visual layout** for the Tier 0 Molten Core checklist. Draft PR #7 remains unmerged; this is not complete release approval.

- Maintainer installed the latest compact-card test build, provided a screenshot, and confirmed **"Yes i like it works really well."**
- The screenshot confirms **all five Molten Core checklist cards and descriptions are visible together without scrolling**; the marked count is **3 of 5**, three checkboxes are visibly checked, the progress bar displays their proportion, and **Reset this tier** / **Done** remain accessible.
- Layout includes clear compact headings, categories, detailed descriptions and an opaque background. The maintainer's preferred **compact main sidebar** remains unchanged.
- This establishes an **in-game pass for the Tier 0 checklist layout**. The screenshot alone does **not** verify reloading SavedVariables, character/realm isolation, the reset confirmation flow, or how longer TBC/Wrath tiers scroll. These remain separately tracked and should not be recorded as passed.
- No code change was needed in response to the successful screenshot; existing PR build is retained. The published v5.2.0 addon and N-Addon-Collection are unchanged.
- Next development steps: check persistent checkmarks across `/reload` if practical, and review all checklist task descriptions against the currently deployed server rules and the Resource Hub before a release.

## 13 October 2026 — PR #7 compact adaptive task cards

**Status:** Revision implemented, automated checks under review, latest client layout not yet re-tested.

### Maintainer feedback
- The redesigned opaque/detailed popup is **visually accepted in principle** ("looks good i think") based on two in-game screenshots showing MC **3/5 marked** and scrolling through the final item.
- One remaining request: the short five-item Molten Core list unnecessarily required scrolling because every card reserved at least 100 pixels plus broad gaps. The maintainer prefers **all five tasks in view where they fit** while retaining scrolling for tiers with longer descriptions.
- These screenshots demonstrate existing checkmarks and actual scrolling, but do not independently verify SavedVariables persistence through `/reload`.

### Layout refinement
- Preserve **the same 770x590 opaque dialog**, task content, progress display, Done/reset controls, 81 stable task IDs and compact original navigation sidebar.
- Combine the category and task name into the heading line, move the task index into the checkbox gutter, and reduce the empty minimum card height from 100 to **62**.
- Derive each card height from actual title and description text heights; keep larger cards and scrolling when a custom font or longer tier needs room. Reduce the between-card gap from 8 to 5.
- Shorten the explanatory disclaimer while preserving the statement that notes are **not server verified**. Reclaim some unnecessary header/footer spacing for the scroll viewport.
- Add mock regression checks for five short tasks fitting in a simulated checklist viewport **without scrolling**, while simulated enlarged text forces natural overflow and remains reachable by mouse wheel.
- No changes to `.ip get`, server quests/database, per-character persistence or the existing checkmarks. PR #7 stays a draft until the revised fit is confirmed in the actual game.

## 13 October 2026 — PR #7 checklist presentation redesign after in-game feedback

**Status:** Implemented and automated tests passed; updated visual layout **not yet tested in WoW**.

### Maintainer evidence
- The first draft checklist popup was installed and shown on **Admina** with Tier 0, showing 3/5 marks. This demonstrates that the initial window displayed and accepted manual marks, but it is **not** proof of persistence through `/reload`.
- Maintainer described the interface as **lacklustre and vague**. Screenshot shows background guide text/characters visible through the checklist's dark area, little separation between tasks, no explanatory task details and a prominent bare reset button.

### Changes
- Retained **17 tier lists with the original 81 stable item IDs**, so the saved notes from the first draft remain compatible.
- Added a separate **guide-derived description for every one of the 81 tasks**. For example, MC attunement now names Lothos Riftwaker, the Blackrock Depths Core Fragment, and returning the quest rather than just saying "complete attunement".
- Rebuilt the popup as a **770 x 590** scrollable, opaque dark panel with a dedicated title/stage header, explicit personal-notes disclaimer, **X of Y marked** progress indicator and proportionate progress bar.
- Each task appears in a distinct darker card with category, mark state, clear task name and a wrapping explanation. Rows are height-measured and scrollable so the larger/custom WoW font does not have to fit everything into a small rigid space.
- Added an explicit **Done** button, and kept the double-click **Reset this tier** confirmation. Existing per-realm, per-character, per-tier persistence logic and read-only safety rules are unchanged.
- **No change to the maintainer-approved compact single-line sidebar**, progression detection, database, quests, server commands or N-Addon-Collection.
- GitHub Actions [run 38393048129](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38393048129) passed Lua 5.1 syntax, TOC, UI mocks and artifact upload after code/test improvements.

### Pending acceptance
- Inspect the actual opacity, contrast, task-card wrapping, scroll-wheel and Reset/Done controls in WoW with the maintainer's font.
- Confirm previously checked tasks are retained and `/reload` keeps the marks; validate that reset still requires confirmation.
- Review task descriptions against the deployed server. These are **source-guide-derived descriptions, not live quest verification**.
- Backup the previously installed addon folder and SavedVariables before testing the new PR artifact; restore them if needed.

## 13 October 2026 — Optional personal tier checklists (draft PR #7)

**Status:** Draft [PR #7](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/7). Lua 5.1 mocked integration tests passed in the current feature branch; the actual WoW client, persistence over `/reload`, and checklist task wording **have not been accepted or reviewed in game**.

- Based on the 17 tier-specific guides already in the Lua source, prepared **81 concise starter checklist tasks** covering access/attunement, reputation, equipment, optional activities and progression milestones.
- Added a **Preparation Checklist** action in the fixed space below each stage's scrollable guide body. **No new sidebar rows and no changes to the compact single-line navigation design.**
- A popup offers 4–5 manual checkboxes, a status count and a prominent reminder that ticking is **not server verified** and cannot unlock a tier.
- New additive SavedVariables scope: `IndividualProgressionDB.personalChecklists[realm][character][tier][task_id]` stores checked flags only, leaving prior settings intact.
- Ticking/unticking is reversible. A **two-click** `Reset this tier` action clears only the current character's selected tier; hiding the popup cancels confirmation.
- In Lua 5.1 mocked tests, checked status persists across closing/reopening, characters and realms are isolated, tier-specific entries do not leak, all 17 stage pages load the right note set, and no new server commands are issued.
- Popup notice and checkbox positions were anchored relative to preceding text for variable/custom WoW font heights. The compact sidebar was left unchanged.
- New dedicated specification/test instructions: [PERSONAL-TIER-CHECKLISTS.md](PERSONAL-TIER-CHECKLISTS.md). Manual cases **S31–S37** added to [TESTING.md](TESTING.md).
- Source and tests are stacked on [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6), itself dependent on #5, #2 and #1. **No merges, release tags, N-Addon-Collection imports, quest changes, server commands or SQL updates.**

### Before marking this feature ready
- Confirm popup layout, manual marks, `/reload` persistence, unchecking and reset cancellation in WoW 3.3.5a with the maintainer's custom font.
- Review the starter task wording against server-specific progression guidance; categories are labels for **manual notes** rather than automated quest verification.
- Keep a backup of the previous addon folder and SavedVariables. Restore those for rollback if needed.

## 13 October 2026 — Maintainer design decision: restore compact sidebar

**Status:** User rejected the enlarged, multi-line sidebar after testing its appearance in WoW. The compact navigation restoration is implemented in [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6), with Lua 5.1 mock tests passed and client appearance awaiting quick confirmation.

- Maintainer described the new multi-line navigation as **"awful and clunky/chunky"**, explicitly preferring the sidebar **as it looked before**. This takes priority over the previous proposal to force full labels on multiple lines.
- Reverted the experimental **260px-wide sidebar**, explicit whole-word multiline wrapping, and 44px+ tall navigation rows. Restored the original **225px sidebar, 178x28px buttons, single-line labels, and 29px layout increments** from the tested compact navigation implementation.
- Retained optional **full-label tooltip on hover**, the concise one-line footer, `/ip hub` URL-copy action, adaptable guide text, Settings, and the authoritative read-only `.ip get <player>` tier detection.
- Accepted tradeoff: long labels may visually truncate in a compact single-line row, but hovering reveals the complete title. Do not reintroduce expanded multi-line sidebar rows without explicit maintainer approval.
- Extended mock tests to assert compact dimensions and prevent automatic row growth even when custom font metrics are large, while covering hover, Settings, Resource Hub and tier regression.
- [GitHub Actions run 38388470790](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38388470790) **passed** Lua 5.1 syntax, TOC, simulated UI checks and PR-only artifact upload.
- **No live server/DB data, saved-variable schema, or actual character progression changed.** Revert the isolated UI commits or restore the last working addon folder and SavedVariables backup if necessary.

## 12 October 2026 — Development documentation foundation

**Status:** Documentation-only PR prepared; pending review/merge.
**Current addon baseline:** v5.2.0, commit `6872cc726052f7d271a28ba48baa9bb5c7ad36e9`.
**Scope:** Establish a durable GitHub project reference, roadmap and test plan to maintain continuity across development cycles.

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

## 13 October 2026 — Second enlarged-font screenshot: hard-wrap sidebar titles

**Status:** Follow-up client change in [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6); simulated tests passed, revised real-client test pending.

- Maintainer's new in-game screenshots show that **Tier 0 → Molten Core** now displays on two lines and the shortened grey footer fits; however longer sidebar names still show ellipses including **World Boss Timeline**, **General Information**, **Vanilla Reputations**, and longer TBC stage/side-page titles. The old `SetWordWrap(true)` and resized rows were insufficient for the supplied custom font.
- The companion correctly identified **Takali** as progression 0 in the screenshots. No tier-detection regression observed.
- An **ElvUI help/tutorial panel** is visible across the top of the screen; it is external overlay content, not a title or tooltip added by IP Companion. Dismiss using its own **HIDE** control for a clean layout test.
- New `WrapNavWords` explicitly inserts line breaks between words, limiting each line to at most 14 characters when practical while preserving whole words. Stage rows retain a separate `Tier N` line. Each row reserves minimum height for the actual number of lines, independent of unreliable old-client FontString height metrics.
- The original full names remain in `btn.fullLabel` and its hover tooltip. Normal navigation and automated test lookups use the unabridged label; no progression commands or server rules changed.
- [GitHub Actions run 38387540965](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38387540965) passed syntax, TOC, mocked UI flow, and artifact creation after the code and tests.
- Real-game validation pending at the maintainer's custom font: check explicit two-line/further-line titles and sidebar scrolling, keeping the original tier detection and Resource Hub features.

## 13 October 2026 — PR #6 enlarged-font sidebar and footer correction

**Status:** Implemented and simulated tests passed; maintainer's in-game recheck pending. This is not a published release.

### Evidence
- The maintainer supplied two WoW 3.3.5a screenshots using an enlarged/custom font on character **Takali**, Level 60, with addon Settings showing authoritative server progression value **0**.
- The Settings warning, tier headline and long World Boss guide wrapped legibly. However, multiple sidebar labels were visually cut off (for example Overview / Roadmap, Tier 0's Molten Core label, World Boss Timeline, Vanilla Reputations), and the original long grey footer was truncated.
- The sidebar had a fixed 225px width, 178px navigation button, small single-row label area, and row-height calculations that did not explicitly enable label word wrapping.

### Changes
- Increased sidebar width to 260px and adjusted its navigation child and button widths consistently, preserving main content space.
- Moved navigation label anchors to TOPLEFT/TOPRIGHT, enabled ordinary and non-space word wrapping, and split **Tier N** from the location/raid name onto separate lines for stage buttons.
- Measured label/heading height after wrap and gave rows a minimum 44px for stage titles; preserved scrollable navigation and fixed Settings footer.
- Added a complete original-label GameTooltip on hover as a fallback for unusual font metrics.
- Replaced the truncated footer with the short non-authoritative reminder: **Guide only - server progression is unchanged.**
- Expanded Lua 5.1 mock checks for the new row dimensions, wrap anchors, stage lines, hover tooltip, and footer; the original authoritative `.ip get` lookup code was not modified.

### Verification and rollback
- [GitHub Actions run 38386220003](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38386220003) passed Lua 5.1 syntax, TOC, mocked UI and QA artifact upload after code/test changes.
- **In-game visual confirmation still needed** with the maintainer's custom font, including General Information's URL copy popup and Admina's accepted Tier 2 detection.
- Back up the installed addon folder/SavedVariables before testing. Roll back by restoring the previously working addon folder. No live DB/quest/server progression changes.

## 13 October 2026 — PR #6 Resource Hub copy and readability

**Status:** Implemented in [PR #6](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/6), simulated tests passed; real WoW 3.3.5a test pending. This is not a released build.

- Added **Copy Resource Hub URL** on General Information and a `/ip hub` shortcut. A native 3.3.5a `InputBoxTemplate` popup shows the exact Resource Hub URL, sets keyboard focus, selects the URL, and explains Ctrl+C. Escape/close/parent close dismiss the popup.
- A fixed copy button only appears on General Information, and its guide scroll region is shortened to keep the button unobstructed. Switching pages closes/hides the popup.
- Increased the content header spacing, removed a forced 560px text width that could cause clipping at narrower widths, sized Settings text to the usable panel width, and reflowed sidebar rows based on wrapped label height.
- Expanded simulated Lua 5.1 tests for popup URL/focus/selection/close, slash alias, General-only button placement, Settings, narrow text widths, custom-font navigation and regression-safe tier lookup.
- GitHub Actions [run 38384842721](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38384842721) passed Lua 5.1 syntax, TOC validation, and mocked UI behaviour after these changes.
- The character's actual progression and server modules are untouched. No new SavedVariables fields are introduced. Backup the last working addon folder and relevant SavedVariables before testing the PR artifact.

### Pending checks
1. In WoW 3.3.5a, use General Information → Copy Resource Hub URL and verify Ctrl+A/Ctrl+C paste into a browser.
2. Confirm the popup closes with Escape, X and closing the main addon; `/ip hub` also opens it.
3. Check large/custom fonts, smaller UI scales, footer readability, nav scrolling, narrow text wrapping and Settings warning.
4. Confirm the existing `.ip get`-based tier auto-detection still reports Admina's Tier 2.

### Following approved feature
Issue [#4](https://github.com/CosmicCuddle/Individual-Progression-Companion/issues/4): tier-specific personal preparation checklists. Keep them local and character-specific, not server progression.

## 13 October 2026 — Maintainer QA acceptance: GM tier detection

**Status:** Approved in-game acceptance for the reported bug using the GM character Admina. Implementation remains in PR #5 and **not merged or released**.

- The maintainer explicitly accepts the successful Admina GM-character test as sufficient proof for this particular tier-detection fix, and does not require repetition on normal players, different targets or other characters.
- Previously observed: `.ip get Admina` returned progression 2 while the old addon showed 6. After installing PR #5's QA build, the maintainer reported the addon now behaves correctly.
- The acceptance scope is **Admina GM-character test passed**. Other user roles, target switching, error paths, client environments and no-response recovery were **not independently tested**; do not label them all passed.
- Do not alter player quests, database or server config. The fix is read-only; stable version remains v5.2.0 until separately released.
- Treat PR #5 as eligible for code review and orderly integration after its documentation PR #1 and UI PR #2 dependencies. Any merge/publish requires a separate explicit action.
- The three approved follow-on improvements remain copyable Resource Hub URL, UI fonts/scale accessibility, and personal per-tier checklists; timeout/Retry can be considered separately.

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

