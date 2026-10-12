# Individual Progression Companion

A World of Warcraft **3.3.5a** in-game progression handbook built around a customised AzerothCore server using the Grimfeather Individual Progression system.

The addon tracks the character's current Individual Progression state through server support and gives players practical, expansion-aware guidance for **Vanilla, The Burning Crusade and Wrath of the Lich King**.

> **Compatibility:** This project is configured for the CosmicCuddle server. Progression rules, phasing, unlock costs and some content guidance are server-specific and may require adjustment on other servers.

## Current Version

**Version 5.2.0**

Supported client: **World of Warcraft 3.3.5a**

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

1. Download the latest release.
2. Extract the archive.
3. Copy the `IndividualProgressionAddon` folder into:

   `World of Warcraft/Interface/AddOns/`

4. Restart WoW or use `/reload`.
5. Type `/ip`.

When updating, replace the previous `IndividualProgressionAddon` folder.

## Server Integration

The addon communicates with the server-side support service and requests the character's current progression value.

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

Version **5.2.0** focuses on turning the addon from a reference sheet into a more complete **step-by-step server progression handbook**.

See [CHANGELOG.md](CHANGELOG.md) for version history.

## Development & Project Continuity

Official project maintenance references:

- [Project Handover](docs/PROJECT-HANDOVER.md) — continuation instructions, architecture and safeguards.
- [Development Roadmap](docs/ROADMAP.md) — existing features, requested improvements, priorities and acceptance criteria.
- [Development Log](docs/DEVELOPMENT-LOG.md) — dated implementation decisions, outstanding work and verification results.
- [Manual Test Plan](docs/TESTING.md) — regression steps and evidence requirements.

The roadmap contains proposed features, including a progression-aware navigation and Settings experience. Proposed work is not included in the v5.2.0 release unless separately implemented, tested and released.

## Credits

Created by **CosmicCuddle** for AzerothCore 3.3.5a and designed to accompany the Grimfeather Individual Progression system.

World of Warcraft and related names, artwork and assets are trademarks or copyrights of Blizzard Entertainment.

This project is not affiliated with or endorsed by Blizzard Entertainment.
