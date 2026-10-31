# Individual Progression Companion

A World of Warcraft **3.3.5a** in-game progression handbook built around a customised AzerothCore server using the Grimfeather Individual Progression system.

The addon tracks the character's current Individual Progression state through server support and gives players practical, expansion-aware guidance for **Vanilla, The Burning Crusade and Wrath of the Lich King**.

> **Compatibility:** This project is configured for the CosmicCuddle server. Progression rules, phasing, unlock costs and some content guidance are server-specific and may require adjustment on other servers.

## Current Version

**Version 5.3.0**

Supported client: **World of Warcraft 3.3.5a**

## What's New in 5.3.0

This release adds progression-aware navigation and optional personal preparation tools while maintaining **World of Warcraft 3.3.5a / Lua 5.1** compatibility.

- **Authoritative personal tier detection:** Uses the normal-player, read-only `.ip get <own character name>` command on the configured CosmicCuddle server. Refresh and reopening the guide focus the player's actual stage. **In the unmerged draft PR #9 only**, the Companion also sends one automatic own-name query at first world entry (login/`/reload`) with duplicate suppression; no released-version behavior is implied.
- **Progression-first navigation:** Displays reached tiers and a next-tier preview by default, alongside relevant current-expansion side content and General pages. **Settings → Show All Content** reveals future guides for reference; doing so does **not** unlock progression.
- **Personal preparation checklists:** Each of the **17 numbered tier guides** offers an optional **Preparation Checklist** with **81** detailed tasks overall. Marks are stored per **realm, character and tier** in the existing `IndividualProgressionDB` SavedVariables, not sent to the server.
- **Safe controls:** Individual marks can be toggled freely; **Reset this tier** requires two clicks and affects only the selected character/tier. The compact sidebar remains unchanged.
- **Resource Hub link:** General Information provides a selectable URL and `/ip hub` shortcut. Use Ctrl+C to copy the address.
- **Readability:** Compact single-line navigation, full titles available on hover, improved long-page wrapping and the concise guide-only footer.

> Checklist entries are **personal planning notes**, not automatic quest/boss checks. A tick does not alter a character's server progression.

## What the Addon Does

The addon is designed to answer four simple questions:

- What should I do now?
- What is required to advance?
- What should I complete before moving on?
- What content has just become available?

Every numbered progression tier now contains a **step-by-step completion route** rather than only a short summary.

## Progression Coverage

### Vanilla

- Tier 0 — Molten Core
- Tier 1 — Onyxia's Lair
- Tier 2 — Blackwing Lair
- Tier 3 — Pre-AQ / War Effort
- Tier 4 — AQ War
- Tier 5 — Ahn'Qiraj
- Tier 6 — Naxxramas
- Tier 7 — Pre-TBC

Vanilla support pages also cover world bosses, reputations, PvP, talent restrictions, profession phasing, flight-path phasing and server rules.

### The Burning Crusade

- Karazhan / Gruul / Magtheridon
- Serpentshrine Cavern / Tempest Keep
- Mount Hyjal / Black Temple
- Sunwell Plateau
- Zul'Aman side progression

TBC support pages cover Heroic timing, keys, attunements, reputations, professions, PvP and world bosses.

### Wrath of the Lich King

- Tier 13 — Naxxramas / Eye of Eternity / Obsidian Sanctum
- Tier 14 — Ulduar
- Tier 15 — Trial of the Crusader
- Tier 16 — Icecrown Citadel
- Tier 17 — Ruby Sanctum

Wrath support pages cover dungeons and Heroics, emblems, Dalaran quests, reputations, professions, PvP, Wintergrasp, Vault of Archavon and the Argent Tournament.

## Detailed Tier Walkthroughs

Version 5.2 builds on the detailed-tier redesign.

Each tier page can include:

- Exact access or attunement requirements
- Required quest chains
- Dungeon prerequisites
- Raid boss order
- Progression-ending objective
- Recommended reputation work
- Profession preparation
- Useful side content
- What to prepare before the next tier

**Required to Advance** and **Recommended Before Advancing** are kept separate so players can see the difference between the technical server gate and the intended progression route.

## Pre-AQ / War Effort

The Pre-AQ guide explains the server-specific personal War Effort requirements:

- Complete each required War Effort resource turn-in at least once.
- Earn **1,500 Commendation Signets**.
- Complete the Scarab Gong progression.

Two Gong routes are documented:

**Full route:** complete the Scepter of the Shifting Sands / Scarab Lord chain.

**Shortcut route:** use the server's custom **Simply Bang a Gong!** progression route.

The shortcut currently requires the **Mallet of Zul'Farrak** and is a progression shortcut rather than a Scarab Lord reward route.

## Attunements & Access

The addon includes detailed guidance for major access requirements, including:

- Molten Core first entry through Blackrock Depths
- Onyxia attunement
- Blackwing Lair first entry through Upper Blackrock Spire
- AQ progression
- Naxxramas first entry through Stratholme
- Karazhan
- Serpentshrine Cavern
- Tempest Keep
- Mount Hyjal
- Black Temple
- Wrath tier gates

## Reputation Guides

Reputation pages explain:

- When to work on the faction
- How to earn reputation
- Why the reputation matters
- Important gear, enchants, recipes and mounts
- Which professions benefit most
- Whether it is required, recommended or optional

Vanilla, TBC and Wrath each have their own detailed reputation roadmap.

## Profession Guidance

Profession pages explain more than skill caps.

They include:

- Expansion-specific profession availability
- Useful or notable crafts
- Raid-useful items
- Profession bonuses
- Relevant reputation recipes
- Which reputations matter most to particular professions
- When profession investment is most useful during progression

Server phasing includes:

- Jewelcrafting locked during Vanilla
- Jewelcrafting available in TBC
- Inscription locked until Wrath

## Talent Rules

The server uses the 3.3.5 talent trees with expansion-specific restrictions.

### Vanilla

- Rows 1–6 fully available
- Row 7: middle talent only
- Rows 8–11 blocked

### The Burning Crusade

- Rows 1–8 fully available
- Row 9: middle talent only
- Rows 10–11 blocked

### Wrath of the Lich King

- Full 3.3.5 talent trees available

Restrictions apply separately to each talent tree and are based on talent position.

## PvP & World Content

The addon includes dedicated guidance for:

- Custom Vanilla PvP ranks
- Vanilla battleground reputations
- TBC Arena progression
- TBC world bosses
- Wrath Arena progression
- Wintergrasp
- Vault of Archavon
- Argent Tournament

Version 5.2 significantly expands these pages so they explain the gameplay loop, timing and rewards rather than only listing content.

## Chronomancer Vezrath

**Chronomancer Vezrath** is a male Bronze Draconid located near the faction leader in every capital city.

He provides progression and character services, including expansion transitions.

Current expansion unlock costs:

- Vanilla → TBC: **2,500 gold**
- TBC → Wrath: **7,500 gold**

## Addon Commands

Main command:

`/ip`

Alternative:

`/progression`

Useful commands include:

- `/ip current`
- `/ip general`
- `/ip talents`
- `/ip reputations`
- `/ip pvp`
- `/ip tbc`
- `/ip tbcdungeons`
- `/ip tbcreps`
- `/ip tbcprofessions`
- `/ip tbcpvp`
- `/ip tbcworldbosses`
- `/ip zulaman`
- `/ip wrath`
- `/ip wrathdungeons`
- `/ip wrathemblems`
- `/ip wrathreps`
- `/ip wrathprofessions`
- `/ip wrathpvp`
- `/ip wintergrasp`
- `/ip tournament`
- `/ip vezrath`
- `/ip commands`
- `/ip refresh`
- `/ip help`

The in-game Commands page also documents supported `.ip` server commands and identifies GM-only commands separately.

## Installation

1. Download the latest **standalone** release.
2. Extract the archive.
3. Copy the `IndividualProgressionAddon` folder into:

   `World of Warcraft/Interface/AddOns/`

4. Restart WoW or use `/reload`.
5. Type `/ip`.

When updating, **close WoW first** and back up the existing `IndividualProgressionAddon` folder and `WTF/Account/<account>/SavedVariables/IndividualProgressionAddon.lua`. Then replace the previous addon folder with exactly **one** copy. Do not install it twice alongside a copy already supplied by `N-Addon-Collection`. SavedVariables should be kept to preserve checklist marks and preferences.

## Server Integration

The addon queries its own character's progression using the read-only server command `.ip get <own character name>` on the customised CosmicCuddle server. It reads the named system-message reply to select the current tier; it does not use `.ip set` or grant progression. The older `.ipsvc data` service is no longer authoritative for tier detection in this version.

It does **not** independently infer progression from raid kills.

## Server-Specific Features

The guide currently reflects server-specific behaviour including:

- Chronomancer Vezrath
- Expansion unlock costs
- Progression catch-up rules
- 1,500-signets War Effort
- Talent restrictions
- Profession phasing
- Later-Vanilla flight-path phasing
- Early Dungeon Set 2
- Early Scourge bosses
- Manual Molten Core rune handling
- Restored TBC attunements
- Wrath content gating
- Configured Arena seasons

## Development Status

Vanilla, The Burning Crusade and Wrath progression are implemented.

Version **5.3.0** adds accurate read-only tier focus, configurable guide visibility, a copyable Resource Hub link and optional personal tier preparation checklists to the existing **5.2.0** progression handbook.

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Development & Project Continuity

Official project maintenance references:

- [Project Handover](docs/PROJECT-HANDOVER.md) — project overview, architecture, working procedures and safeguards.
- [Development Roadmap](docs/ROADMAP.md) — existing features, requested improvements, priorities and acceptance criteria.
- [Development Log](docs/DEVELOPMENT-LOG.md) — dated implementation decisions, outstanding work and verification results.
- [Manual Test Plan](docs/TESTING.md) — regression steps and evidence requirements.
- [Release & Collection Handover](docs/RELEASE-CHECKLIST.md) — versioning, validation, rollback and approved N-Addon-Collection import.

The roadmap records future ideas and outstanding optional QA; the features listed above are implemented for the 5.3.0 standalone release candidate. The `N-Addon-Collection` distribution is **separate** and must be updated from the approved standalone release commit, not automatically from this repository.

## Credits

Created by **CosmicCuddle** for AzerothCore 3.3.5a and designed to accompany the Grimfeather Individual Progression system.

World of Warcraft and related names, artwork and assets are trademarks or copyrights of Blizzard Entertainment.

This project is not affiliated with or endorsed by Blizzard Entertainment.
