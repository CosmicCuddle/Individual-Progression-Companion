# Individual Progression Companion — 81-item checklist content audit

**Audit date:** 13 October 2026  
**Scope:** draft [PR #7](https://github.com/CosmicCuddle/Individual-Progression-Companion/pull/7), 17 staged checklists / 81 existing task IDs.  
**Status:** **Guide-source audit complete. Live server-rule verification incomplete.** Do not treat every checklist assertion as tested on the deployed world server.

## 1. Evidence and authority

1. **Primary player-facing source:** `IndividualProgressionAddon.lua` tier entries `VANILLA_STAGES`, `TBC_STAGES` and `WOTLK_STAGES`. The checklist is a **summary of these existing guides**, not a separate set of authoritative game rules.
2. **Official Resource Hub:** [Naxxramas Resource Hub](https://cosmiccuddle.github.io/Naxxramas-Resource-Hub/), maintained in [site-content.html](https://github.com/CosmicCuddle/Naxxramas-Resource-Hub/blob/main/site-content.html). Its player-information section specifically describes (a) a **1,500-signets** Pre-AQ War Effort, (b) **2,500g** Vanilla → TBC and **7,500g** TBC → Wrath expansion service pricing, and (c) the difference between **Required to Advance** and **Recommended Before Advancing**.
3. **Additional corroboration where present:** The Hub's detailed Blackrock Spire/Blackrock Depths content describes **Blackhand's Command** dropping from the **Scarshield Quartermaster** and **Attunement to the Core** starting from **Lothos Riftwaker**, requiring the **Core Fragment** in BRD. The Resource Hub is **not** a complete independent source for all 81 tier-specific checklists.
4. **Public upstream, NOT automatically the deployed server:** [Grimfeather/mod-individual-progression](https://github.com/Grimfeather/mod-individual-progression) `src/IndividualProgression.cpp`, `src/IndividualProgression.h`, and `data/sql/world/base/aq_war_effort.sql`. The upstream source tracks boss-based progression and includes a **1,000**-signet War Effort quest in its SQL. This **disagrees with the server's companion/Resource Hub at 1,500**. Never silently replace the configured server guide with the upstream value. The maintainer's deployed fork/configuration and active quest counter need checking before certifying this number.
5. **Actual client evidence:** The maintainer visually approved Tier 0's current compact popup showing five tasks together and a 3/5 progress indicator. That proves only the visible design/marks, not whether any underlying quest objectives have been completed.

**Source-precedence rule:** Explicit deployed-server behaviour or maintained server source outranks documentation; current official server guides outrank mismatched generic upstream documentation for player-facing guidance **unless the live world disproves them**. Contradictions remain flagged, never concealed.

## 2. Method

- Matched **each of the 81 stable task IDs** and its description to the current companion's tier narrative, `REQUIRED TO ADVANCE`, numbered steps, optional/recommended advice, next-tier unlock and expansion-service instructions.
- Reviewed 17 stage objectives: Vanilla 0–7; Burning Crusade 8, 9, 10, 12; Wrath 13–17. **Tier 11 (Zul'Aman) is intentionally not a progression checkpoint.**
- Compared key server-specific claims against the Hub's player-information notes and relevant Blackrock quest explanations.
- Reclassified misleading tasks as `Required`, `Service`, `Future Access` or `Access` **without changing any task ID or StoredVariables shape**.
- Reworded detailed instructions to use exact NPCs, fragments, attunement prerequisites and boss routes when stated in the existing guide. Added a caution on unverified numeric War Effort signet requirements.
- Did **not** run GM progression commands, mutate quests or SQL, assume access to the deployed module code, or claim completion of live gates.

## 3. Coverage — all 81 tasks

`Guide-aligned` below means the listed task is supported by the companion's own guide **after** the audit edits. It does not imply server/DB testing.

| Tier | Stable task IDs reviewed | Player-facing source conclusion / caveat |
|---|---|---|
| **0 Molten Core** (5) | `gear`, `core`, `brd_entry`, `hydraxis`, `ragnaros` | The guide describes BRD attunement, required first entry, manual seven-rune dousing and Ragnaros progression. Clarified Aqual versus Eternal Quintessence. Hub separately corroborates BRD Core Fragment/Lothos. |
| **1 Onyxia** (5) | `chain`, `amulet`, `supplies`, `cloaks`, `onyxia` | Faction-specific attunement, carrying the Drakefire Amulet, optional BWL cloak preparation, Onyxia kill gate. Pre-BWL cloak work is preparation, not Tier 1's progression condition. |
| **2 Blackwing Lair** (5) | `blackhand`, `first_entry`, `cloaks`, `diremaul`, `nefarian` | Blackhand's Command/Drakkisath, special first entry, cloak and Dire Maul recommendations, Nefarian gate. Hub corroborates Blackhand's Command/Scarshield Quartermaster. |
| **3 Pre-AQ** (4) | `turnins`, `signets`, `zul_gurub`, `gong` | **Correction:** Signets are REQUIRED, not optional. All required resource turn-ins, signet quest and gong path are part of the guide's stage gate; Zul'Gurub is supporting content. Gong shortcut requires the Mallet of Zul'Farrak. **Number discrepancy unresolved: server guides 1,500 vs public upstream SQL 1,000.** |
| **4 AQ War** (4) | `chaos`, `aq20`, `aq40`, `reputation` | Turn in **Chaos and Destruction** for stage advance. AQ20, early AQ40 and two reputations are supporting activities. |
| **5 Ahn'Qiraj** (4) | `resists`, `brood`, `argent`, `cthun` | Nature Resistance, Brood and Argent Dawn are preparation; **C'Thun** is the completion boss. Resist sets are conditional on raid role, not universal. |
| **6 Naxxramas 40** (5) | `argent`, `attunement`, `first_entry`, `frost`, `kelthuzad` | Guide requires Argent Dawn Honored, attunement quest and special first entry, recommends Frost Resistance, then Kel'Thuzad. Quest cost scales with reputation; the checklist directs to the full guide. |
| **7 Pre-TBC** (4) | `breach`, `vanilla`, `gear`, `vezrath` | **Correction:** **Into the Breach** is the *stage* gate; Vezrath's **2,500g** expansion purchase is a separate character service. Optional older Vanilla goals and gear remain preparation only. |
| **8 Kara / Gruul / Mag** (5) | `outland`, `masters_key`, `nightbane`, `heroics`, `prince` | Master's Key route now lists Shadow Labyrinth, Steamvault, Arcatraz and Black Morass. **Nightbane's Blazing Signet is future SSC access**, not the current tier trigger; **Prince Malchezaar** is the Tier 8 completion boss. |
| **9 SSC / Tempest Keep** (5) | `ssc`, `tk`, `vials`, `bt`, `kael` | Guide includes Cudgel of Kar'desh (Gruul/Nightbane signets), Cipher/Trials of the Naaru and later Hyjal vial attunement; **Kael'thas** is the Tier 9 progression boss. |
| **10 Hyjal / Black Temple** (5) | `vials`, `karabor`, `hyjal`, `bt`, `illidan` | **Correction:** Hyjal includes a prerequisite for the restored Black Temple attunement, not merely an optional gearing activity. **Illidan** advances directly to **Tier 12**; ZA/Tier 11 remains optional. |
| **12 Sunwell** (5) | `queldanas`, `terrace`, `za`, `sunwell`, `kiljaeden` | Isle rep and Normal Magisters' Terrace are preparation. Clarified **Hard to Kill** before Heroic Magisters' Terrace; ZA is optional; **Kil'jaeden** is the TBC completion boss. The TBC → Wrath service costs 7,500g per guide/Hub, and is separately documented in the full guide. |
| **13 Wrath Naxx** (5) | `level`, `gear`, `emblems`, `raids`, `kel` | Guide describes level 80, early dungeon/Emblems of Heroism gear, optional Malygos/Sartharion and **Kel'Thuzad** progression. Clarified Malygos Focusing Iris access via Sapphiron. |
| **14 Ulduar** (5) | `emblems`, `siege`, `keepers`, `hardmodes`, `yogg` | Current Ulduar progress/keeper route and **Yogg-Saron** gate; hard modes and Algalon are optional, not advancement criteria. |
| **15 Trial** (5) | `tournament`, `champion`, `consumables`, `heroic`, `anubarak` | Tournament/ToC preparation and optional heroic mastery; **Anub'arak** is the required advancement boss. |
| **16 Icecrown** (5) | `halls`, `verdict`, `supplies`, `shadowmourne`, `lichking` | Frozen Halls order, Ashen Verdict, ICC preparation, optional Shadowmourne; **Lich King** advances to Ruby Sanctum. |
| **17 Ruby Sanctum** (5) | `entry`, `outer`, `supplies`, `halion`, `finalgear` | **Correction:** Outer sanctum bosses are on the route to Halion, not an optional gearing task. Halion is the progression target; guide presents **Normal** as intended, while Heroic is optional mastery. The wording no longer implies that Heroic kills cannot count. |
| **Total** | **81 IDs across 17 tiers** | All descriptions checked against their corresponding tier guide. **Not a deployed-server verification of every quest or condition.** |

## 4. Critical issues corrected in code

| Issue | Before | Now |
|---|---|---|
| Pre-AQ signets | `Recommended` and no required threshold context | `Required` plus source-qualified 1,500 signet figure and instruction to confirm the actual in-game quest counter |
| Pre-AQ gong | Very generic | Full Scepter path vs Simply Bang a Gong! shortcut (Mallet of Zul'Farrak) |
| Pre-TBC paid transition | Vezrath categorised as `Progression`, blurring paid service and quest gate | `Service` explicitly separate from `Into the Breach`; documented 2,500g cost |
| Nightbane | Ambiguous `Access` within Tier 8 | `Future Access` for the Tier 9 SSC Cudgel; not the Prince progression trigger |
| Mount Hyjal | Just `Recommended` | `Access`, citing Black Temple attunement sequence and An Artifact From the Past |
| Ruby Sanctum outer bosses | Just `Recommended` | `Access`, naming Baltharus, Saviana and Zarithrian |
| Halion | "Defeat Halion on Normal" could read as a Normal-only server restriction | "Defeat Halion" with separate description of intended Normal progression and optional Heroic |
| Sparse quest descriptions | Several statements only said "complete chain" | Added stage-guide details: Aqual/Eternal, Master's Key fragments, Gruul/Nightbane signets, Naaru trials, Hard to Kill, Focus Iris, etc. |

**Data compatibility:** Every task's `id`, tier key and SavedVariables location are unchanged. Rewording or category adjustment does not clear existing ticks. Any future task semantics change must use a new task ID or a documented migration.

## 5. Outstanding source disagreements and explicit limits

### HIGH — Pre-AQ required signet total

- **Current companion + Resource Hub:** **1,500** required Commendation Signets.
- **Public upstream module's** `aq_war_effort.sql`: **1,000** for the `Complete the War Effort` quest.
- **Unknown:** live deployed SQL, quests and overrides for this server. Do not overwrite live DB records or silently change to 1,000. The current player-facing checklist calls out the documented 1,500 **and tells players to check their in-game quest counter**.
- **For future verification:** Inspect the in-game `Complete the War Effort` quest/requirements on a suitable character, or review the currently deployed world DB/SQL migration as read-only evidence. No direct access to live DB is available here.

### MEDIUM — Custom first-entry, restored attunements and progression phasing

- MC first internal BRD entry, BWL first UBRS entry, Naxx40 first Stratholme entry, Black Temple group attunement and optional ZA/Tier 11 treatment are described in the **companion's server-specific guide**.
- Their full deployed-server handler implementations were not provided in this audit. The public upstream module is **not proof** that the current fork is deployed unchanged.
- Review any actual discrepancies reported by players or inspect the deployed custom module/SQL before asserting database-level verification.

### MEDIUM — Wrath emblem and quest staging

- Emblem tiers, Dalaran dailies, Vault availability and Focusing Iris access follow the companion's guide. These can be customized by the server; do not substitute stock WotLK mechanics without checking the actual deployment.
- The checklist presents broad preparation summaries and leaves the complete encounter/order rules in the existing tier pages.

### LOW — Personal checkbox semantics

- **Manual notes are not server-verified.** Ticking a prerequisite does not complete the prerequisite or advance a tier. A boss kill might advance the server progression even if the related manual checkbox remains clear.
- The accepted Tier 0 visual layout and the maintainer-approved compact sidebar should not be redesigned during content corrections.

## 6. Release gate

- [x] Every one of the 81 existing task IDs reviewed against its source tier guide.
- [x] Misleading gate/service/future-access classifications corrected.
- [x] High-risk numerical discrepancy explicitly recorded, not silently reconciled.
- [x] Saved task IDs unchanged; additive per-character/per-realm preferences unchanged.
- [x] Lua 5.1 mock and PR-only packaging checks passed ([Actions run 38399275794](https://github.com/CosmicCuddle/Individual-Progression-Companion/actions/runs/38399275794), head `febaad593ed4271a5a12e3a5591ced67241d44df`).
- [ ] Content sign-off for server-specific quest details or direct evidence for any disputed rule.
- [ ] Check SavedVariables survive `/reload` when convenient; tier and realm isolation already mocked.
- [ ] Keep PR #7 draft/unmerged and N-Addon-Collection pinned stable until approved.

No live server, quests, databases or published addon were modified as part of this audit.
