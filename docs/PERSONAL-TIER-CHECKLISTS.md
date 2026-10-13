# Personal Tier Preparation Checklists — QA and Data Contract

**Repository:** https://github.com/CosmicCuddle/Individual-Progression-Companion  
**Implementation:** [PR #7](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/7)  
**Status:** Draft feature; Lua 5.1 mocks only until the maintainer tests the client.

## Goal

Add lightweight, optional **personal checklist notes** to tier guide pages without changing the progression rules or the **maintainer-approved compact sidebar**.

- A **Preparation Checklist** button appears beneath the scrolling text on the **17 stage pages** (Vanilla tiers 0–7; TBC tiers 8, 9, 10, 12; Wrath tiers 13–17).
- 81 initial tasks, 4–5 per stage, summarise attunements/access, preparation, reputation, optional activities and the final progression boss based on the **existing** `IndividualProgressionAddon.lua` guide.
- Items are labelled **Access**, **Recommended**, **Optional** or **Progression**. These are **guide categories, not live server checks**.
- The button does not appear on General Information, Settings or side-content pages. No new sidebar navigation rows are added.
- A popup shows the tasks and how many have been marked. An individual checkmark can be added or removed at any time.
- The popup explicitly states that checked items are **personal notes only** and are **not validated by the server**.
- Clicking **Reset this tier** once changes it to **Confirm reset?**. Clicking again clears only the current tier's marks. Closing the window cancels the pending reset.

## Popup visual layout revision (13 October 2026)

**User feedback:** The first working popup appeared too transparent, visually sparse and too vague to guide preparation. Its five one-line items sat directly over the underlying guide with little information.

The revised popup preserves the same checklist data but:
- Uses an additional **fully opaque background texture** to prevent underlying guide text from bleeding through.
- Presents a consistent **Personal Raid Preparation** heading, the actual tier name, a warning that these are not server-verified, and a **marked X/Y** progress bar.
- Renders separate, height-measured task cards in a **scrollable** view. Each has its category, full title, a short guide-derived explanation, and **Marked / Not Marked** status.
- Adds **Done** to close, and retains the two-click **Reset this tier** safeguard. The compact sidebar remains unchanged.
- Adds individual explanatory text for **all 81 existing task IDs** rather than changing their meanings or wiping previous ticks.

The first draft's successful open/tick screenshot does **not** verify this redesigned appearance. Please test contrast, scroll access to the final task, font wrapping, and data persistence in-game before a stable release.

## Compact adaptive task cards (13 October 2026)

After testing the opaque, detailed layout in WoW, the maintainer approved the improved appearance but observed that the five short Molten Core cards should **fit at once**, instead of wasting space and forcing scrolling.

- Existing items, descriptions, completion IDs and personal SavedVariables are all preserved.
- The task number is displayed in the checkbox gutter; the category and full task title now share the heading line, with the full explanation immediately below.
- Card height is calculated from the actual text metrics with a smaller minimum height and tighter gaps. Extra whitespace is removed without shortening the explanatory content.
- The header warning is shorter but still states that marks are personal notes, not server completion; the fixed footer controls are retained.
- If a longer tier or custom font cannot fit, the scroll frame remains available so text is **never deliberately clipped to avoid scrolling**.
- Manual **S39** verifies Tier 0 fits without scrolling; **S42** confirms the fallback for larger content. Passing Lua mocks does **not** prove the client font has the same metrics.

## Maintainer visual acceptance — 13 October 2026

- The maintainer's in-game screenshot of the **compact-card PR #7 test build** confirms all **five Molten Core tasks** and their descriptions are visible without scrolling, with three items marked and the progress indicator displaying **3 of 5**.
- The maintainer explicitly approved this appearance: **"Yes i like it works really well."** Record Tier 0 compact layout as **PASS**.
- This is not proof that marks persist across `/reload`, that all other tier content fits, or that the manual Reset confirmation has been tested. The content wording still needs comparison with the deployed progression rules.
- Keep the original compact sidebar, task IDs, per-character SavedVariables model and optional scrolling for longer tiers. **Do not enlarge the Tier 0 cards again without new feedback.**

## SavedVariables contract

Existing SavedVariables name: `IndividualProgressionDB` (unchanged).

New optional key, created only when a checkmark is set:

```lua
IndividualProgressionDB.personalChecklists = {
    ["Realm Name"] = {
        ["CharacterName"] = {
            mc = {
                core = true,
                hydraxis = true,
            },
            bwl = {
                blackhand = true,
            },
        },
    },
}
```

- Outer keys use `GetRealmName()` and `UnitName("player")` from the **current logged-in character**.
- Inner tier and item IDs are stable; marking/unmarking one task never changes a different character, realm or tier.
- An unchecked task is absent from the saved table; a reset removes that character's selected tier table only.
- If player name or realm is unavailable, marking is **not allowed**. Never fall back to a shared unnamed bucket.
- Pre-existing settings, including `showAllContent`, minimap position and other fields, remain in place. No migration that rewrites existing records.
- **No calls to** `.ip set`, no quest/boss/reputation modifications, no SQL or server module changes, and no new server protocol.
- Manual notes do not automatically become complete when the character changes tiers, beats a boss, joins a group, or uses a GM character.

## Read-only in-game acceptance checks

1. **Back up** the installed `Interface/AddOns/IndividualProgressionAddon/` folder and the relevant `WTF/Account/<account>/SavedVariables/IndividualProgressionAddon.lua` file before installing a PR test package.
2. On an existing character at Tier 0, open `/ip` and open Molten Core. Click **Preparation Checklist**. Expect its name, the manual-notes explanation and five checklist tasks.
3. Tick **Complete Attunement to the Core**. Close and reopen the popup: expect that task still checked. Untick it: expect that task alone to clear.
4. Tick two different tasks, then type `/reload` and reopen the popup. Both marks should still be checked.
5. Click **Reset this tier** once. Expect **Confirm reset?**, with existing marks unchanged. Close/reopen to cancel. Click twice to confirm: only this tier's marks should clear.
6. Navigate to another tier, such as Onyxia's Lair or Blackwing Lair. Expect that tier's own checklist, initially independent of the Molten Core marks.
7. Optionally log into another character or realm. Its saved marks should be independent. This is **not necessary to re-approve the already accepted GM tier detection**.
8. Open General Information, Settings and `/ip hub`. The checklist button must hide on those pages; the Resource Hub copy popup and Show all option should still work.
9. With the maintainer's preferred large custom font, verify the checklist popup fits and all checkbox descriptions remain readable without overlapping. The compact sidebar must be unchanged.
10. Tick any checklist and use `.ip get` separately, if desired. It should remain unchanged because personal notes do **not** modify server progression.

## Content review and limits

Checklist lines are condensed from the current tier guides. They are **not a substitute for the full guide** or proof of live server rules. Before a stable release, review attunement labels, quest names and server-specific requirements against the deployed modules and the Naxxramas Resource Hub.

Changing a task's wording while keeping its ID preserves the prior user's marks; replacing a task's meaning requires a new ID or an explicit migration plan. Never silently reuse an old ID for a different requirement.

This initial version does not include a global reset, automatic quest detection, to-do list sharing, export/import or background notifications.

## Rollback

Close the WoW client, restore the previous known-good addon folder and, **only if necessary**, the SavedVariables backup. The new `personalChecklists` key is additive, but restoring an older SavedVariables file can discard checklist entries added since that backup. Do not touch the live character database.

Until the maintainer approves the feature, do not merge PR #7, tag a release or update `N-Addon-Collection`.
