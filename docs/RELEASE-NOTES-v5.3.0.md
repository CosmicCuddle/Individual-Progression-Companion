# Individual Progression Companion v5.3.0 — Release Notes

**Status, 13 October 2026:** Changes are merged into main. A permanent tagged GitHub Release v5.3.0 has not yet been published; the current published release remains v5.2.0.

## Features

- Read-only self-tier detection through `.ip get <character>`, with automatic current-stage focus and Refresh.
- Progression-aware guide filtering, Show All Content option and Escape window handling.
- Copyable Resource Hub URL in General Information and `/ip hub`.
- Seventeen personal tier checklists containing 81 detailed, optional tasks. Checkmarks are saved by realm, character and tier and never update quests or server progression.
- Confirmed two-click Reset and the maintainer-preferred compact sidebar.

## In-game acceptance

The maintainer accepted the GM tier-detection test, Tier 0 and Tier 9 checklist appearance, four Molten Core notes surviving `/reload`, and safe temporary-tier Reset. A real-client forced-overflow scrolling test was not performed; Lua 5.1 simulated tests cover overflow.

The server's 1,500 Commendation Signets requirement is an intentional customization, differing from the upstream default.

## Publishing

1. Confirm the latest passing GitHub Actions run for the final main commit.
2. Download its `IP-Companion-v5.3.0-Standalone-Candidate` package and confirm a single `IndividualProgressionAddon/` folder containing the Lua and TOC files, without a QA notice.
3. In GitHub Releases, draft version `v5.3.0` using that validated commit. Attach the installable package, then publish.
4. Preserve v5.2.0 for rollback. Update `N-Addon-Collection` only through a separately reviewed source-import PR.

## Backups

Before updating WoW, save the installed addon directory and its `WTF/Account/<account>/SavedVariables/IndividualProgressionAddon.lua` file. Keep SavedVariables to retain personal checkmarks. No server, SQL or character progression changes are required.
