# Authoritative .ip get lookup — QA protocol

**Status:** Candidate fix only; neither merged nor verified against the live server.  
**Context:** [bug #3](https://github.com/CosmicCuddle/Individual-Progression-Companion/issues/3).

## Established evidence

For the same character, Admina, the maintainer's live screenshots showed:

- Normal read-only `.ip get`: **Progression Level for Admina = 2**.
- Original IP Companion, using `.ipsvc data`: **Server progression value 6** and displayed Tier 6.

The deployed `.ipsvc` server handler is not available in the reviewed repositories. Do not infer the cause of its incorrect value or modify production quests or character data.

## Candidate design

Instead of trusting `.ipsvc data`, the test build issues the read-only command:

```text
.ip get <logged-in character name>
```

It accepts only a full system-message reply of the form:

```text
Progression Level for <same character name> = <nonnegative integer>
```

WoW colour escape codes around the name or number are removed before matching. Replies for other characters, malformed results, and `##IPSVC##PD~...` values are ignored. The guide updates **downward or upward** only upon a correctly matched reply. This does not call `.ip set` or change any hidden quests, DB records or server progression.

**Important unverified assumption:** the maintainer confirmed ordinary players can use `.ip get`, but **has not yet tested the named argument form** on the deployed server. If that syntax is unsupported, this test build will remain in its pending state rather than trusting the known-discrepant service value. Do not release until confirmed and the error/timeout UX is addressed.

## Read-only in-game tests

1. **Back up** the current standalone addon folder and the relevant character/account SavedVariables before trying the candidate package. Do not install duplicate copies alongside N-Addon-Collection.
2. With Admina in game, type `/cleartarget`, then type `.ip get Admina`. Verify the server replies **Progression Level for Admina = 2**. If not, stop testing the candidate and record the exact response.
3. Install the passing **PR test artifact** from the candidate pull request (after closing WoW), ensuring `Interface/AddOns/IndividualProgressionAddon/IndividualProgressionAddon.toc` exists. Restart WoW.
4. Open `/ip`, wait for the server response, click Refresh and check Settings → **Server progression value**. Expected: **2** for Admina, Tier 2 selected, completed Tier 0 and Tier 1 visible, Tier 3 preview visible, Tier 6 hidden by default.
5. Repeat without a target and with a bot/other character selected. Expected: Admina's value remains **2**, not the target's value.
6. Test a non-GM character using the same command. If the server rejects named `.ip get`, capture the output and leave the PR unmerged.
7. Open/close, Refresh, ESC, Settings, Show all content and `/reload`, ensuring the addon does not affect actual progression.
8. Compare other existing, known-tier characters, if available. Do **not** call `.ip set` to generate tests.

## Known limits

- The new command may briefly appear in chat; the addon attempts to suppress only a correctly matching own progression reply.
- A missing or incompatible reply currently leaves a pending state. A dedicated timeout and Retry UX is a required follow-up for a general release.
- The exact deployed parser and any name-resolution restrictions are not yet confirmed from server source.
- The existing `GetCurrentStageId` numeric mapping is unchanged.
- Passing mocked Lua 5.1 tests does **not** mean real server compatibility.

## Rollback

Close WoW and restore the prior known-good addon folder. Restore SavedVariables only if needed. Do not alter server data. The server and both legacy PRs remain unchanged by this candidate.
