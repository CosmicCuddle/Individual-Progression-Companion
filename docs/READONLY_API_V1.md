# Read-only verified-self progression API v1 (draft)

## Why
A connected N-WhatsTraining addon should automatically hide level 61+ trainer spells during Vanilla and level 71+ until Wrath. **Character level is not a trustworthy indicator of Individual Progression era.**

## Existing source contract
IP Companion v5.3.0 queries the current server only on its normal guide refresh, sending `.ip get <own character name>`, then parses a **self-named** `Progression Level for <name> = <value>` reply. Its default `data.currentValue = 0` starts with `data.loaded=false`; zero must **never** be mistaken for a verified vanilla tier.

The new version-1 API is exported as a global `IndividualProgressionCompanionAPI` **only on this draft branch**:
- `GetCurrentValue()` returns the **verified numeric** milestone plus the character name, or nil while loading, unavailable, or mismatched.
- `RegisterListener(callback)` subscribes to the confirmed-value and invalidation events. Duplicates are ignored and errors in consumer code are isolated with `pcall`.
- A new local event when the Companion invalidates a lookup tells consumers to discard stale state; another after a validated self-named reply gives the new value.
- No new chat command is issued, no SavedVariables used to infer the current tier, no mutation and no personal/account information shared beyond the current in-game character name already available to addons.

## Consumer contract
- Vanilla stages 0–7 → level cap 60.
- TBC stages 8–12 → cap 70.
- Wrath stages 13–18 → cap 80.
- Consumers must show an explicit **unverified** state rather than interpreting nil as tier 0, and must validate the own-character match.
- API is optional; addons without Companion may implement manual preview controls.
- Companion itself does **not** modify any other addon's UI, spell training or game data.

## Safety and QA
- [ ] Lua 5.1 syntax of full Companion addon.
- [ ] Isolated runtime tests using the **production API block** confirm unknown, verified, invalidated, wrong character, duplicate callbacks and error isolation.
- [ ] Connected N-WhatsTraining uses only API data; no second `.ip get` query.
- [ ] Full in-game tier refresh, addon load order, /reload and character-switch tests.
- [ ] Independent owners and collaborator reviews before merging into companion main.

No production addon files or server state modified; this is an unmerged draft.