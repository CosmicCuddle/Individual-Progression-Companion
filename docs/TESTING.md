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
