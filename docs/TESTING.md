# Individual Progression Companion — Manual Test Plan

**Baseline:** v5.2.0, WoW 3.3.5a  
**Last test outcome:** Not yet run under this document (12 October 2026)  
**Purpose:** Reproducible checks before code changes, PR merge and release.

## Preparation

1. Back up `Interface/AddOns/IndividualProgressionAddon/` and, where present, `WTF/Account/<account>/SavedVariables/IndividualProgressionAddon.lua`.
2. Record client resolution, UI scale, addon version, server revision and progression module revision.
3. Use ordinary test characters with known progression states. Do not modify live characters or DB values solely for testing. Mark unavailable stages **Not tested**.
4. Record exact messages and screenshots of failures without exposing private account details.

## Core regression tests

| ID | Test | Expected result |
| --- | --- | --- |
| S01 | Log in with addon enabled | No Lua errors; interface loads |
| S02 | Use `/ip` and `/progression` | Window opens and closes normally |
| S03 | Use `/ip help` and `/ip commands` | Correct help and page |
| S04 | Open with server reachable | Correct current stage eventually appears |
| S05 | Select a different guide and click **Refresh** | Server data re-read; after proposed UX change, focus resets to actual current stage |
| S06 | Close and reopen | Fresh server request and current-stage selection as specified; no old character's stage |
| S07 | Withhold/delay response in isolated test setup | UI must not silently label old data as verified |
| S08 | Visit very long guides | No truncation, corruption or overlapping text |
| S09 | Check all navigation sections | Correct titles, content and readable scrolling |
| S10 | Drag and click minimap button | Persists location; toggles UI |
| S11 | Use `/reload` and log in again | Saved UI settings survive safely |
| S12 | Switch characters | No stale progression from previous character |
| S13 | Watch unrelated system chat | `##IPSVC##` protocol remains hidden, other messages visible |
| S14 | Press Escape while window open | After feature implementation, window closes; default game Escape behaviour unaffected otherwise |
| S15 | Open Settings and change future-content option | After feature implementation, default OFF, ON shows all pages, change persists |
| S16 | Open Settings with a known Tier 0 character after reply | Shows raw **Server progression value: 0** if the server actually replies with 0; compare a reported 1 with the character's actual tier to isolate the fault |
| S17 | Open Settings via `/ip settings` and inspect icon | Settings page opens; visible gear icon; no overlapping guide text/scroll region |
| S18 | Open Settings with normal and enlarged/custom fonts | The Show all content explanation, intended-progression warning and server value are all readable; none overlaps the others |
| S19 | Open General Information and scroll to the very bottom | A Further Server Information heading and the exact Naxxramas Resource Hub URL are visible |
| S20 | On General Information, click **Copy Resource Hub URL** | Text box opens with exact website address selected; Ctrl+C copies it for pasting outside WoW |
| S21 | Use `/ip hub`, Escape and the dialog X | The copy dialog opens, closes without leaving keyboard focus, and does not reopen unexpectedly |
| S22 | Move from General Information to Settings/other sections | The copy action hides, the dialog closes, and normal guide scrolling has its usual height |
| S23 | With custom font, check guide pages and the compact sidebar | Body text wraps inside the content panel, Settings remains legible, and sidebar rows **do not expand** into multiple lines |
| S24 | Recheck GM character progression after installing PR #6 | Maintainer's known Admina Tier 2 still auto-detects through the approved `.ip get` method |
| S25 | Using the maintainer's enlarged font, inspect Vanilla stages, General and Side Content | Restored compact sidebar remains a narrow, scrollable single-line list; long labels may truncate; Settings stays pinned |
| S26 | Hover a long sidebar item and move the cursor away | Complete original label appears in a tooltip on hover and disappears on leave |
| S27 | Inspect the short grey guide footer on Settings and long guide pages | `Guide only - server progression is unchanged.` is visible as one readable line without being clipped |
| S28 | With enlarged font, review Overview / Roadmap, World Boss Timeline, Vanilla Reputations, General Information and TBC Overview | Sidebar remains compact rather than adding hard line breaks or oversized rows; full original label is accessible via hover |
| S29 | Turn Show all content ON and inspect long TBC/Wrath tier names | Rows stay compact and scrolling reaches all entries; hovering over any shortened title shows the complete name |
| S30 | Dismiss any ElvUI help/tutorial overlay and recheck the header | Companion is unobstructed, independent of ElvUI's own help overlay |
| S31 | Open a Tier 0 guide and click **Preparation Checklist** | A tier-specific popup appears with guide-based tasks and prominent disclaimer that these are manual notes, not verified by the server |
| S32 | Tick checklist items, then `/reload` and reopen | **PASS — 13 Oct 2026:** maintainer confirmed a post-reload Tier 0 screenshot with all four Molten Core marks retained (including Hydraxian Waterlords), progress 4/5 |
| S33 | Untick one item | Only that manual item clears; others remain checked |
| S34 | On a different empty tier, create one temporary mark; click Reset once, close/reopen, then confirm with two clicks | **PASS — 13 Oct 2026 (maintainer-reported):** confirmation/cancellation worked, temporary mark cleared only after confirmation and previously saved Tier 0 notes remained unaffected |
| S35 | Switch between Tier 0, Tier 1 and Tier 2; optionally another character | Each tier has its own items and marks; another character/realm must not inherit them |
| S36 | Open General Information, Settings and `/ip hub` | Checklist button is absent on those pages; Resource Hub, compact sidebar and settings still work |
| S37 | Check checklist popup with larger/custom UI font and use `.ip get` separately | Text and controls are readable; manually checking boxes never changes the server progression value |
| S38 | Open the redesigned Tier 0 checklist near a busy in-game scene | Popup background is opaque; underlying guide/world text does not show through task cards; clear tier heading, disclaimer and progress indicator are visible |
| S39 | Open Tier 0 Molten Core's five-item checklist at usual UI scale | **All five task cards and their descriptions fit in the popup without scrolling**, with enough separation and legible text |
| S40 | Tick items, then try Reset and Done | X/Y progress display changes, previous marks persist on reopening, first reset click does not clear, Done closes and cancels pending reset |
| S41 | View a longer stage (e.g. BWL or TBC) using the existing custom font | **PASS — 13 Oct 2026:** maintainer supplied a Tier 9 (SSC / Tempest Keep) screenshot; all five task descriptions, including Kael'thas, fit legibly without scrolling, and user confirmed the layout was fine. Long-content overflow still has automated coverage, not a separate in-game overflow test. |
| S42 | Open a tier with longer text or enlarge font/UI scale temporarily | Cards grow according to actual text height; scrolling activates if required and reaches the final task without clipping |
| S43 | Observe the compact Tier 0 checklist in the maintainer's actual WoW client | **PASS — 13 Oct 2026:** screenshot shows all five Molten Core tasks with descriptions simultaneously visible, a 3/5 progress indicator, and Reset/Done controls; maintainer approved the appearance |
| S44 | Inspect Pre-AQ checklist's signet task and the active `Complete the War Effort` quest on an eligible character (read-only) | Signets correctly shown as a **required gate**; record whether live requirement is **1,500** (current Hub/guide) or **1,000** (public upstream SQL); do not edit quest or DB |
| S45 | Inspect Pre-TBC, Tier 8 and Tier 10 checklists without changing progression | `Into the Breach` remains the Tier 7 quest gate while 2,500g Vezrath service is separate; Nightbane is future SSC access; Hyjal is part of restored Black Temple access |
| S46 | Inspect Tier 17's final checklist | Outer bosses are distinguished from optional raid preparation; Halion boss is the final gate without claiming a Normal-only kill restriction |

**Note:** S05, S06, S14, S15 contain requested future behaviour; **do not report them as current passes** before implementation and real-client testing.

## Automated checks

The feature branch includes `tests/test_ui_compatibility.lua` and GitHub Actions. These are **mocked Lua 5.1 tests**, not in-game acceptance tests. They simulate server replies for values 0, 1, 8, 13, 17 and 18, delayed/manual-navigation behaviour, Settings, and invalid replies. Always run the manual cases above before calling a UI feature verified or released.

## Progression boundary matrix

| Server value | Baseline client display assumption | Status |
| --- | --- | --- |
| `0` | Tier 0 / Molten Core | Not tested |
| `1` | Tier 1 / Onyxia | Not tested |
| `7` | Tier 7 / Pre-TBC | Not tested |
| `8` | TBC Tier 8 | Not tested |
| `12` | TBC Tier 12 | Not tested |
| `13` | Wrath Tier 13 | Not tested |
| `17` | Wrath Tier 17 | Not tested |
| `18+` | Progression complete | Not tested |

Also sample intermediate stages 2–6 and 9–16 when possible, especially values 10/11.

**Reported incident:** A player who should be in Tier 0 appeared as Tier 1. Reproduce with a known Tier 0 character and distinguish (a) server response value, (b) status banner, (c) sidebar highlighted tier, and (d) currently selected guide page. Do not assume the server or UI is at fault before measuring.

## Proposed progression-aware navigation tests

- [ ] Tier 0 default: Tier 0 and Tier 1 navigation visible; later Vanilla tiers hidden; Vanilla side content and General visible; TBC/Wrath groups hidden.
- [ ] After stage progression: reveal tiers as agreed; never hide the current tier.
- [ ] On TBC/Wrath transition: display correct expansion and its side content; other-expansion handling follows documented acceptance rules.
- [ ] Setting **Show all content** OFF by default for new installation; ON restores all existing navigation; preserved across reload/login.
- [ ] Refresh, reopen and character switch all update visible navigation for the new current stage.
- [ ] In no-data/error state, avoid claiming a verified stage or permanently hiding access to troubleshooting/Settings.

## Content audit

- [ ] Vanilla raid gates, attunements, Molten Core rune dousing, Pre-AQ and Naxx steps
- [ ] TBC raids, attunements, Heroic timing, keys, professions and side content
- [ ] Wrath raids, emblems, dungeons, reputations, profession rules and PvP
- [ ] Live server behaviour for Chronomancer Vezrath, talent phasing, flight paths and optional content
- [ ] Required-to-advance guidance kept separate from recommended/optional work

## UI, accessibility, upgrade and packaging

- [ ] At least two UI scales/resolutions if feasible; text readable; no clipping/overlap
- [ ] Sidebar and content scroll, current-stage jump, slash commands and minimap
- [ ] Escape handling without interference with standard game windows
- [ ] Fresh SavedVariables and existing `IndividualProgressionDB` upgrade cases
- [ ] Distribution folder and `.toc` version correct for release
- [ ] N-Addon-Collection inclusion/compatibility checked if distributed there

## Evidence and release gate

Log date, tested version/commit, client/server revision, test IDs, **Pass / Fail / Blocked / Not tested**, screenshots or exact errors, and rollback approach in `docs/DEVELOPMENT-LOG.md`.

No release should be presented as fully verified with uninvestigated critical failures, stale/incorrect progression, broken protocol or data loss. Clearly disclose any untested scenarios.


## PR #9 one-shot automatic self-IP acceptance — NOT YET RUN IN GAME (31 October 2026)

**Draft-only review checklist; do not install from this page without CosmicCuddle's separate test approval and a backup of the current Companion/N-WhatsTraining addon folders and all relevant `WTF/` SavedVariables.**

1. In a **normal non-GM 3.3.5a client**, with Companion and paired N-WhatsTraining draft loaded, log in without opening either guide. Confirm Companion remains hidden, the normal `.ip get <own character>` form is accepted once (debug/log if available), and N-WhatsTraining initially shows **`IP unverified - showing 1-60`**, then the correct 60/70/80 cap only after the validated self reply. Do not select a different target to determine your own tier.
2. Repeat `/reload`, then enter an instance or change zone. Expect **one query for the new Lua session**, zero extra from zoning; the Guide stays hidden. The normal-player command table has `ip get` security 0 in the pinned fork source; effective deployed settings and full named response still require confirmation.
3. Open the Guide **while the initial reply is still pending** (if an ordinary delayed response allows this). Expect no second automatic query, no stale numeric stage, and correct focus after reply. Once completed, manually click Refresh and confirm a fresh own-name reply and no cross-character leakage.
4. With guide closed, type `/ip refresh` once. Expect **one** read-only own-name query and guide open, not two. Explicit Refresh after a completed query must still fetch again.
5. Confirm invalid or wrong-name, out-of-range (outside 0–18), denied or absent responses **never** unlock expansion display in N-WhatsTraining. Real server chat may not supply every negative case: offline Lua harness tests exercise those without altering server data.
6. Test character switching and save/reload using **non-mutating** gameplay actions. A later milestone change should be reflected only after a new authoritative refresh; the draft does not claim instant passive stage changes.

**Rollback** (only if testing was separately approved): close WoW, restore the previously backed-up Companion/N-WhatsTraining addon folders and original `WTF/` SavedVariables if necessary. No SQL/DBC, GM commands, quest adjustments, server rebuild or main merge is part of this test.
