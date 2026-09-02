-- ============================================================================
-- IndividualProgressionAddon - WoW 3.3.5a
-- Vanilla + TBC + Wrath Progression Companion UI - Server Edition v5.0
-- Slash commands: /ip, /progression
--
-- Keeps the original server communication contract:
--   Client -> server: .ipsvc data
--   Server -> client: ##IPSVC##PD~<progression value>
-- ============================================================================

local ADDON_NAME = "IndividualProgressionAddon"
local MSG_PREFIX = "##IPSVC##"
local DELIMITER  = "~"

-- ============================================================================
-- COLORS / HELPERS
-- ============================================================================

local C = {
    gold   = "|cffffd100",
    white  = "|cffffffff",
    grey   = "|cff9a9a9a",
    dark   = "|cff666666",
    green  = "|cff55dd55",
    yellow = "|cffffcc55",
    red    = "|cffff6666",
    blue   = "|cff80c0ff",
    cyan   = "|cff6edcff",
    orange = "|cffff9f45",
    purple = "|cffc49cff",
    reset  = "|r",
}

local function H(text)
    return C.gold .. text .. C.reset
end

local function SH(text)
    return C.cyan .. text .. C.reset
end

local function Bullet(text, color)
    return (color or C.white) .. "  - " .. text .. C.reset
end

local function Priority(label, text, color)
    return (color or C.white) .. "[" .. label .. "] " .. C.reset .. text
end

local function Join(lines)
    return table.concat(lines, "\n")
end

-- ============================================================================
-- PROGRESSION DATA
--
-- The backend value represents the HIGHEST COMPLETED progression milestone.
-- Molten Core and Onyxia are separate player-facing tabs. Tier 1 remains
-- locked until Molten Core progression has been completed.
-- ============================================================================

local VANILLA_STAGES = {
    mc = {
        nav = "Tier 0     Molten Core",
        title = "Tier 0 - Molten Core",
        short = "Opening Vanilla Raid",
        icon = "Interface\\Icons\\Spell_Fire_Fire",
        minValue = 0,
        completeAt = 1,
        objective = "Defeat Ragnaros in Molten Core.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Molten Core is your first Vanilla progression milestone. Complete this tier before Tier 1 - Onyxia's Lair becomes available.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Complete Molten Core progression and defeat Ragnaros.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("QUEST", "Attunement to the Core - obtained from Lothos Riftwaker in Blackrock Mountain.", C.yellow),
                Bullet("Enter Blackrock Depths and recover the Core Fragment beside the Molten Core portal near the end of BRD."),
                Priority("FIRST ENTRY", "Your first Molten Core entry must be made through Blackrock Depths using the internal Molten Core entrance near the end of the dungeon.", C.orange),
                Bullet("After completing Attunement to the Core and satisfying the first-entry requirement, Lothos provides the convenient Molten Core shortcut."),
                "",
                SH("RUNE DOUSING"),
                Priority("REQUIRED", "Molten Core rune handling is manual on this server.", C.red),
                Bullet("Build Hydraxian Waterlords reputation so you can obtain the Quintessence needed to douse the runes."),
                Bullet("Plan dousing across the raid: Eternal Quintessence keeps its normal 1-hour cooldown."),
                "",
                SH("RAID PREPARATION"),
                Bullet("Build your Phase 1 Pre-Raid BiS set from available level-60 dungeons, quests, professions and PvP."),
                Bullet("Prepare class consumables, food, bandages and Greater Fire Protection Potions."),
                Bullet("Enchant important gear, but avoid overspending on pieces you expect to replace quickly."),
                Bullet("Make sure raid-critical weapon skills are trained and capped where relevant."),
                "",
                SH("IMPORTANT DUNGEONS NOW"),
                Priority("IMPORTANT", "Dungeon Set 2 is enabled early on this server. If your class benefits from it, you can begin the upgrade path during early level-60 gearing.", C.orange),
                Bullet("Blackrock Depths - Molten Core access, quests, gear, crafting and Blackrock progression."),
                Bullet("Lower / Upper Blackrock Spire - major Pre-Raid gear and preparation for later Blackrock progression."),
                Bullet("Scholomance - Pre-Raid gear, Argent Dawn progression and profession materials."),
                Bullet("Stratholme - Pre-Raid gear, Argent Dawn progression and later Naxxramas preparation."),
                "",
                SH("REPUTATIONS TO START"),
                Priority("IMPORTANT", "Hydraxian Waterlords - required for the classic Molten Core rune-dousing path.", C.orange),
                Priority("IMPORTANT", "Argent Dawn - start naturally while running Scholomance and Stratholme. It is needed for Naxxramas later and also offers profession recipes and other reputation rewards.", C.orange),
                Priority("RECOMMENDED", "Thorium Brotherhood - useful crafting plans and Fire Resistance-related progression for relevant professions.", C.yellow),
                "",
                SH("NEXT TIER"),
                Priority("LOCKED", "Tier 1 - Onyxia's Lair becomes available after Molten Core progression has been completed.", C.dark),
                "",
                SH("DO NOT SKIP"),
                Bullet("Attunement to the Core and the required first entry through BRD."),
                Bullet("Hydraxian Waterlords progress - rune dousing is part of the raid on this server."),
            })
        end,
    },

    onyxia = {
        nav = "Tier 1     Onyxia's Lair",
        title = "Tier 1 - Onyxia's Lair",
        short = "Opening Vanilla Raid",
        icon = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
        minValue = 1,
        completeAt = 2,
        objective = "Defeat Onyxia in Onyxia's Lair.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Onyxia's Lair is Tier 1. It becomes available after Molten Core progression has been completed.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Complete the Onyxia attunement chain, carry the Drakefire Amulet, and defeat Onyxia.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("REQUIRED", "Every raider needs a Drakefire Amulet in their inventory to enter Onyxia's Lair.", C.red),
                "",
                H("Horde Attunement"),
                Bullet("Warlord's Command -> Eitrigg's Wisdom -> For The Horde! -> What the Wind Carries -> The Champion of the Horde -> The Testament of Rexxar -> Oculus Illusions -> Emberstrife."),
                Bullet("Continue through The Test of Skulls: Scryer / Somnus / Chronalis -> The Test of Skulls, Axtroz -> Ascension... -> Blood of the Black Dragon Champion."),
                "",
                H("Alliance Attunement"),
                Bullet("Dragonkin Menace -> The True Masters chain -> Marshal Windsor -> Abandoned Hope -> A Crumpled Up Note -> A Shred of Hope -> Jail Break!"),
                Bullet("Continue through Stormwind Rendezvous -> The Great Masquerade -> The Dragon's Eye -> Drakefire Amulet."),
                "",
                Bullet("The final Onyxia preparation sends both factions through Upper Blackrock Spire before the Drakefire Amulet is obtained."),
                "",
                SH("WHY ONYXIA MATTERS BEYOND THIS TIER"),
                Priority("IMPORTANT", "Keep the Onyxia Scale Cloak progression in mind. The cloak becomes strategically important for Shadowflame encounters in Blackwing Lair.", C.orange),
                "",
                SH("RAID PREPARATION"),
                Bullet("Continue improving your Pre-Raid BiS while finishing the attunement chain."),
                Bullet("Onyxia is a short raid, so it fits well alongside Molten Core rather than replacing it in your weekly schedule."),
                Bullet("Once Tier 1 opens, prioritise the attunement chain alongside your continuing Molten Core farming."),
                "",
                SH("DO NOT SKIP"),
                Bullet("Drakefire Amulet - it is the actual entry requirement."),
                Bullet("The long attunement chain is worth beginning early while you are already running BRD and UBRS."),
            })
        end,
    },
    bwl = {
        nav = "Tier 2     Blackwing Lair",
        title = "Tier 2 - Blackwing Lair",
        short = "Blackwing Lair",
        icon = "Interface\\Icons\\INV_Misc_Head_Dragon_Black",
        minValue = 2,
        completeAt = 3,
        objective = "Defeat Nefarian.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Blackwing Lair is your next major raid. Although entry itself is separate from Onyxia, later Shadowflame encounters make the Onyxia Scale Cloak an important preparation item.",
                "",
                SH("NEWLY UNLOCKED / NOW RELEVANT"),
                Priority("IMPORTANT", "Blackwing Lair - your primary raid progression target.", C.orange),
                Priority("IMPORTANT", "Dire Maul - begin running East, West and North; include Tribute runs where useful.", C.orange),
                Priority("OPTIONAL - HIGH VALUE", "Azuregos - world boss in Azshara.", C.purple),
                Priority("OPTIONAL - HIGH VALUE", "Lord Kazzak - world boss in the Blasted Lands.", C.purple),
                "",
                SH("PRIMARY OBJECTIVES"),
                Priority("REQUIRED", "Complete Blackwing Lair progression and defeat Nefarian.", C.red),
                Priority("IMPORTANT", "Obtain / keep an Onyxia Scale Cloak ready for Shadowflame encounters.", C.orange),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("QUEST", "Blackhand's Command - loot the command from the Scarshield Quartermaster near the Blackrock Spire entrance.", C.yellow),
                Bullet("Complete Upper Blackrock Spire, defeat General Drakkisath, then use the Orb of Ascension behind him to finish Blackhand's Command."),
                Priority("FIRST ENTRY", "Your first Blackwing Lair entry must be made through Blackrock Spire using the internal BWL entrance inside Upper Blackrock Spire.", C.orange),
                Bullet("Once the access requirement is established, the Orb of Command outside Blackrock Spire provides the convenient raid shortcut."),
                "",
                SH("DIRE MAUL - WHY YOU SHOULD DO IT NOW"),
                Bullet("Powerful gear upgrades that were unavailable during your opening Pre-Raid phase."),
                Bullet("Class quests and class-specific rewards."),
                Bullet("Librams, enchants, profession recipes and valuable materials."),
                Bullet("Dire Maul North Tribute provides a distinct reward route and useful buffs."),
                Bullet("Re-check your old Pre-Raid/BiS list: several slots may now have better Dire Maul options."),
                "",
                SH("WORLD BOSSES"),
                Bullet("Azuregos - attempt as soon as your raid force is ready; his loot can remain useful for multiple tiers."),
                Bullet("Lord Kazzak - attempt during this stage rather than leaving him until AQ/Naxx gear trivialises the rewards."),
                "",
                SH("REPUTATIONS / PROFESSIONS"),
                Bullet("Continue Argent Dawn rather than postponing the entire grind until Naxxramas; reputation also unlocks profession recipes and other useful rewards."),
                Bullet("Continue Hydraxian Waterlords until Molten Core logistics are comfortable."),
                Bullet("Check Dire Maul profession recipes and class-specific books now that the dungeon is available."),
                "",
                SH("PREPARE FOR THE NEXT STAGE"),
                Bullet("Stock War Effort materials if you want to reduce the Tier 3 grind."),
                Bullet("Begin thinking about Nature Resistance options for later AQ progression."),
                Bullet("Keep raid consumable production sustainable across multiple weekly raid groups."),
            })
        end,
    },

    preaq = {
        nav = "Tier 3     Pre-AQ",
        title = "Tier 3 - Pre-AQ",
        short = "War Effort + Scarab Gong",
        icon = "Interface\\Icons\\Ability_Hunter_Pet_Silithid",
        minValue = 3,
        completeAt = 4,
        objective = "Complete the War Effort and ring the Scarab Gong.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "This is the AQ War Effort and Scarab Gong stage. Every player must complete each required resource turn-in at least once; after that, the completion quest requires 1,500 Commendation Signets. The Scarab Lord chain can be completed normally or through the alternative 'Simply Bang a Gong!' route.",
                "",
                SH("NEWLY UNLOCKED / NOW RELEVANT"),
                Priority("IMPORTANT", "Zul'Gurub - unlocks after Blackwing Lair on this server.", C.orange),
                Priority("IMPORTANT", "AQ War Effort - begin and complete all personal resource turn-ins.", C.orange),
                Priority("OPTIONAL - HIGH VALUE", "Dragons of Nightmare - Ysondre, Emeriss, Lethon and Taerar fit naturally into this later-Vanilla / Pre-AQ window.", C.purple),
                "",
                SH("PRIMARY OBJECTIVES"),
                Priority("REQUIRED", "Complete each War Effort resource quest at least once.", C.red),
                Priority("REQUIRED", "Earn the 1,500 Commendation Signets required to complete your War Effort progression.", C.red),
                Priority("REQUIRED", "Ring the Scarab Gong through the Scarab Lord chain or the alternative Simply Bang a Gong! route.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NO RAID ATTUNEMENT", "Zul'Gurub does not require an attunement quest; it is unlocked by your progression stage.", C.green),
                Priority("PROGRESSION GATE", "The AQ stage is unlocked by completing the War Effort requirements and the Scarab Gong objective.", C.orange),
                Bullet("Personal War Effort requirement: complete every required resource turn-in at least once and then collect 1,500 Commendation Signets."),
                Bullet("Complete the Scarab Lord path to Bang a Gong!, or use the available Simply Bang a Gong! alternative."),
                "",
                SH("ZUL'GURUB"),
                Bullet("Run ZG for strong side-grade/upgrade loot, class enchants and reputation rewards."),
                Bullet("Treat ZG as important catch-up/supporting progression, but not as the tier's final gate."),
                Bullet("Use ZG to fill weak raid slots before AQ opens."),
                "",
                SH("WORLD BOSSES"),
                Bullet("If Azuregos or Kazzak are still relevant, keep them in your rotation."),
                Bullet("Start the Dragons of Nightmare during this stage; their Nature-themed loot and world content fit the AQ preparation period."),
                "",
                SH("REPUTATIONS / PREPARATION"),
                Bullet("Begin serious Cenarion Circle work in Silithus as AQ becomes the focus."),
                Bullet("Prepare Nature Resistance pieces and consumables for AQ encounters where needed."),
                Bullet("Keep Argent Dawn moving in the background for Naxxramas attunement, recipes and other reputation rewards."),
                "",
                SH("DO NOT SKIP"),
                Bullet("War Effort personal turn-ins - these are progression requirements, not merely server flavour."),
                Bullet("Scarab Gong completion route - this is the stage-ending requirement."),
            })
        end,
    },

    aqwar = {
        nav = "Tier 4     AQ War",
        title = "Tier 4 - AQ War",
        short = "Gates Open / Outdoor War",
        icon = "Interface\\Icons\\Spell_Nature_InsectSwarm",
        minValue = 4,
        completeAt = 5,
        objective = "Complete 'Chaos and Destruction' during the AQ War.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "The Gates of Ahn'Qiraj are open and the outdoor AQ War is active. AQ20 and AQ40 are available during this phase. Some later AQ equipment quest NPCs remain unavailable until the war itself has ended.",
                "",
                SH("NEWLY UNLOCKED"),
                Priority("REQUIRED", "AQ outdoor war event.", C.red),
                Priority("AVAILABLE", "Ruins of Ahn'Qiraj (AQ20).", C.green),
                Priority("AVAILABLE", "Temple of Ahn'Qiraj (AQ40).", C.green),
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Complete 'Chaos and Destruction'.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NO RAID ATTUNEMENT", "AQ20 and AQ40 do not use a separate raid attunement quest at this point.", C.green),
                Bullet("Access is earned by completing the previous Pre-AQ War Effort / Scarab Gong progression gate."),
                Priority("STAGE QUEST", "Chaos and Destruction is the progression quest that ends the outdoor AQ War stage.", C.orange),
                "",
                SH("WHAT TO DO DURING THE WAR"),
                Bullet("Participate in the outdoor war rather than immediately treating AQ as only another raid portal."),
                Bullet("Begin AQ20 for reputation, skill books and useful gear while learning AQ mechanics."),
                Bullet("Start AQ40 progression if your raid is prepared, but expect the full post-war reward ecosystem to open afterward."),
                "",
                SH("PREPARATION"),
                Bullet("Maintain Nature Resistance options where your raid strategy needs them."),
                Bullet("Stock Greater Nature Protection Potions and other AQ-specific consumables."),
                Bullet("Continue Cenarion Circle and begin Brood of Nozdormu reputation progression through AQ content."),
                "",
                SH("IMPORTANT NOTE"),
                Bullet("Do not mistake 'AQ20/AQ40 are open' for 'all AQ reward NPCs are open'. Some quest and reward NPCs appear after the war ends."),
            })
        end,
    },

    aq = {
        nav = "Tier 5     Ahn'Qiraj",
        title = "Tier 5 - Ahn'Qiraj",
        short = "AQ40 Progression",
        icon = "Interface\\Icons\\INV_Misc_QirajiCrystal_04",
        minValue = 5,
        completeAt = 6,
        objective = "Defeat C'Thun in AQ40.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "The AQ War has ended. This stage centres on completing AQ40. Post-war gearing quests in Silithus and the strong gear / skill-book rewards from AQ20 are now fully part of your progression.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Progress through Temple of Ahn'Qiraj and defeat C'Thun.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NO NEW ATTUNEMENT", "There is no additional AQ40 attunement quest in this stage.", C.green),
                Bullet("The Gates of Ahn'Qiraj were opened during the previous stage; continue using the raid entrances normally."),
                Bullet("Your progression requirement here is raid completion: defeat C'Thun."),
                "",
                SH("NOW FULLY RELEVANT"),
                Bullet("AQ equipment quests and post-war Cenarion Hold content."),
                Bullet("AQ20 skill books and supporting gear."),
                Bullet("Cenarion Circle and Brood of Nozdormu reputation rewards."),
                "",
                SH("RAID PREPARATION"),
                Bullet("Finish Nature Resistance sets only where your raid strategy actually needs them; avoid sacrificing too much throughput unnecessarily."),
                Bullet("Keep consumable reserves high - AQ progression can consume more specialised protection potions than earlier raids."),
                Bullet("Review class upgrades from ZG, world bosses and Dire Maul if any weak slots survived into AQ."),
                "",
                SH("PREPARE FOR NAXXRAMAS"),
                Priority("IMPORTANT", "Push Argent Dawn reputation now. Higher standing reduces the Naxxramas attunement cost and gives access to useful recipes and other rewards.", C.orange),
                Bullet("Begin collecting materials and resistance pieces that will matter in Naxxramas."),
                Bullet("Make sure key professions have the gold/material buffer needed for end-of-Vanilla crafting."),
                "",
                SH("OPTIONAL CONTENT CHECK"),
                Bullet("Finish any remaining Azuregos, Kazzak or Nightmare Dragon targets while their loot still matters."),
                Bullet("Complete desired ZG reputation/class enchant goals before Naxx becomes the dominant raid focus."),
            })
        end,
    },

    naxx = {
        nav = "Tier 6     Naxxramas",
        title = "Tier 6 - Naxxramas",
        short = "Naxxramas + Scourge Invasion",
        icon = "Interface\\Icons\\Spell_Shadow_AnimateDead",
        minValue = 6,
        completeAt = 7,
        objective = "Attune to Naxxramas and defeat Kel'Thuzad.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Light's Hope Chapel's Naxxramas-related NPCs and quests are now available. The Scourge Invasion is active during this stage and Naxxramas 40 is your primary raid objective.",
                "",
                SH("NEWLY UNLOCKED"),
                Priority("REQUIRED", "Naxxramas attunement at Light's Hope Chapel.", C.red),
                Priority("REQUIRED", "Your first Naxxramas entry must be through the original entrance at the back of Stratholme before the Eastern Plaguelands teleport crystal can be used.", C.red),
                Priority("IMPORTANT", "Scourge Invasion event content.", C.orange),
                Priority("REQUIRED", "Naxxramas 40 progression.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("REPUTATION", "You must be at least Honored with the Argent Dawn to attune to Naxxramas.", C.orange),
                Priority("QUEST", "The Dread Citadel - Naxxramas, from Archmage Angela Dosantos at Light's Hope Chapel.", C.yellow),
                Bullet("Honored: 60 gold + 5 Arcane Crystals + 2 Nexus Crystals + 1 Righteous Orb."),
                Bullet("Revered: 30 gold + 2 Arcane Crystals + 1 Nexus Crystal."),
                Bullet("Exalted: attunement is free."),
                Priority("FIRST ENTRY", "After attuning, your first Naxxramas 40 entry must still be made through the original entrance at the back of Stratholme.", C.orange),
                Bullet("After that first Stratholme entry, the Eastern Plaguelands teleport crystal can be used for future Naxxramas runs."),
                "",
                SH("WORLD / FLIGHT PATH PHASING"),
                Priority("UNPHASED BY NOW", "By Tier 6 / Naxxramas, all five later-Vanilla flight paths are available to the character.", C.green),
                Bullet("Ratchet"),
                Bullet("Marshal's Refuge"),
                Bullet("Emerald Sanctuary"),
                Bullet("The Bulwark"),
                Bullet("Thondroril River"),
                Bullet("Some of these may appear earlier, but none remain phased beyond the Naxxramas stage."),
                "",
                SH("ARGENT DAWN"),
                Bullet("This is why you started Argent Dawn earlier: reputation directly affects the Naxxramas attunement cost, while its vendors also provide recipes and other rewards."),
                Bullet("If your reputation is low, finish Scholomance/Stratholme and relevant turn-ins before paying an unnecessarily expensive attunement."),
                "",
                SH("RAID PREPARATION"),
                Bullet("Prepare encounter-specific consumables and resistance gear, particularly Frost Resistance for the late Naxxramas path."),
                Bullet("Keep a deep stock of protection potions, flasks/elixirs, food, bandages and class reagents."),
                Bullet("Review profession-crafted endgame pieces and resistance crafts before spending raid materials."),
                "",
                SH("SCOURGE INVASION"),
                Priority("IMPORTANT", "Do the main event while it is active; this is a major part of the Naxxramas stage.", C.orange),
                Bullet("Six Scourge Invasion dungeon bosses are enabled early on this server, so you may already have fought some of them before reaching Naxxramas."),
                Bullet("Still check the invasion rewards, rare mobs and remaining event content before finishing the stage."),
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Kel'Thuzad to complete Vanilla raid progression and move to the Pre-TBC event stage.", C.red),
            })
        end,
    },

    pretbc = {
        nav = "Tier 7     Pre-TBC",
        title = "Tier 7 - Pre-TBC",
        short = "Dark Portal Invasion",
        icon = "Interface\\Icons\\Spell_Shadow_SummonFelGuard",
        minValue = 7,
        completeAt = 8,
        objective = "Complete 'Into the Breach'.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "This is the final Vanilla transition stage. Enemies are emerging from the Dark Portal and the Argent Dawn needs help defending Azeroth. Complete 'Into the Breach', finish any last Vanilla goals, then speak with Chronomancer Vezrath when you are ready to move into The Burning Crusade.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Participate in the Dark Portal invasion and complete 'Into the Breach'.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NO RAID ATTUNEMENT", "This is an event / expansion-transition stage rather than a raid attunement stage.", C.green),
                Priority("STAGE QUEST", "Into the Breach is the required Vanilla transition quest.", C.orange),
                Bullet("Completing the stage does not automatically move the character into TBC; the expansion unlock is purchased separately from Chronomancer Vezrath."),
                "",
                SH("BEFORE YOU LEAVE VANILLA"),
                Bullet("All five later-Vanilla phased flight paths are already available by this point: Ratchet, Marshal's Refuge, Emerald Sanctuary, The Bulwark and Thondroril River."),
                Bullet("Finish any Vanilla raid, world-boss or reputation goals you still care about."),
                Bullet("Buy or craft recipes that become inconvenient to return for later."),
                Bullet("Finish important profession specialisation or rare-recipe goals."),
                Bullet("Clean up attunement chains and major questlines you want recorded as part of the character's journey."),
                "",
                SH("RECOMMENDED FINAL CHECK"),
                Bullet("Molten Core / Onyxia / BWL goals complete."),
                Bullet("ZG and world-boss targets complete where desired."),
                Bullet("AQ20 / AQ40 goals complete."),
                Bullet("Naxxramas and Scourge Invasion goals complete."),
                Bullet("Important reputations and profession recipes secured."),
                "",
                SH("NEXT - THE BURNING CRUSADE"),
                Priority("REQUIRED SERVICE", "When you are ready to leave Vanilla, visit Chronomancer Vezrath in any capital city. He stands near that capital's faction leader.", C.orange),
                Bullet("Vanilla -> The Burning Crusade unlock cost: 2,500 gold."),
                Bullet("After the expansion unlock, your next era is Outland and level-70 progression."),
                Bullet("Jewelcrafting trainers and vendors become available with The Burning Crusade."),
                Bullet("Inscription remains phased until Wrath of the Lich King."),
                Priority("UNLOCK", "The Burning Crusade: Karazhan, Gruul's Lair and Magtheridon's Lair begin the next raid journey.", C.green),
            })
        end,
    },
}


local TBC_STAGES = {
    tbc8 = {
        nav = "Tier 8     Kara / Gruul / Mag",
        title = "Tier 8 - Karazhan / Gruul / Magtheridon",
        short = "Opening Burning Crusade raids",
        icon = "Interface\\Icons\\INV_Misc_Key_10",
        minValue = 8,
        completeAt = 9,
        objective = "Defeat Prince Malchezaar in Karazhan.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "This is your first full Burning Crusade raid stage. Karazhan, Gruul's Lair and Magtheridon's Lair are the main raid content, but Prince Malchezaar is the progression boss that advances the character to Tier 9.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Complete Karazhan progression and defeat Prince Malchezaar.", C.red),
                Priority("IMPORTANT", "Clear Gruul's Lair and Magtheridon's Lair as part of the intended Tier 8 raid journey.", C.orange),
                "",
                SH("KARAZHAN ATTUNEMENT / ACCESS"),
                Priority("REQUIRED", "Complete the Key to Karazhan / Master's Key attunement chain.", C.red),
                Bullet("Begin with Archmage Alturus outside Karazhan: Arcane Disturbances and Restless Activity, then continue through Contact from Dalaran and Khadgar."),
                Bullet("Collect the key fragments through Shadow Labyrinth, The Steamvault and The Arcatraz."),
                Bullet("Complete the Caverns of Time path through Old Hillsbrad so you can enter The Black Morass."),
                Bullet("Finish The Master's Touch by reaching Medivh in The Black Morass, then return to Khadgar for the Master's Key."),
                "",
                SH("GRUUL / MAGTHERIDON ACCESS"),
                Priority("NO ENTRY ATTUNEMENT", "Gruul's Lair and Magtheridon's Lair do not require a separate raid-entry attunement.", C.green),
                Bullet("Do not skip them: both raids feed directly into later TBC attunement chains."),
                "",
                SH("HEROIC DUNGEON TIMING"),
                Priority("DO NOW", "At level 70, begin Heroic dungeons alongside Karazhan preparation and Tier 8 raiding.", C.orange),
                Bullet("Use Heroics for early level-70 gearing, reputation and useful rewards; you do not need every Heroic cleared before entering Karazhan."),
                Priority("REQUIRED BEFORE TIER 9", "Finish the Heroic objectives used by the SSC and Tempest Keep attunement chains during Tier 8.", C.red),
                Bullet("This includes Heroic Slave Pens, Shattered Halls, Steamvault, Shadow Labyrinth and Arcatraz as their attunement steps become available."),
                "",
                SH("START TIER 9 ATTUNEMENTS NOW"),
                Priority("IMPORTANT", "Serpentshrine Cavern - prepare for The Cudgel of Kar'desh.", C.orange),
                Bullet("The attunement begins from Skar'this the Heretic in Heroic Slave Pens and later requires signets from Gruul and Nightbane."),
                Priority("IMPORTANT", "Tempest Keep - begin the Shadowmoon Valley / Cipher of Damnation route that leads into the Trial of the Naaru quests.", C.orange),
                Bullet("The Trial chain requires multiple Heroic dungeons and ultimately Magtheridon, so heroic-key reputation work is part of raid preparation."),
                "",
                SH("WORLD BOSSES"),
                Priority("OPTIONAL - HIGH VALUE", "Doom Lord Kazzak - Throne of Kil'jaeden, Hellfire Peninsula.", C.purple),
                Priority("OPTIONAL - HIGH VALUE", "Doomwalker - outside the Black Temple, Shadowmoon Valley.", C.purple),
                Bullet("These are best attempted during Tier 8 while their loot still represents meaningful progression."),
                "",
                SH("REPUTATIONS TO PRIORITISE"),
                Bullet("Thrallmar / Honor Hold - Hellfire dungeon rewards and heroic access preparation."),
                Bullet("Cenarion Expedition - Coilfang dungeons and heroic access preparation."),
                Bullet("Lower City - Auchindoun dungeon and heroic access preparation."),
                Bullet("Keepers of Time - Caverns of Time progression and heroic access preparation."),
                Bullet("The Sha'tar - Tempest Keep dungeon progression and heroic access preparation."),
                Bullet("The Violet Eye - Karazhan reputation rewards as you raid."),
                "",
                SH("PROFESSIONS"),
                Bullet("Jewelcrafting is now available on this server; Inscription remains locked until Wrath."),
                Bullet("Raise primary professions toward 375 and check faction vendors for recipes as your reputations increase."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating Prince Malchezaar advances you to Tier 9 - Serpentshrine Cavern and Tempest Keep.", C.green),
            })
        end,
    },

    tbc9 = {
        nav = "Tier 9     SSC / Tempest Keep",
        title = "Tier 9 - Serpentshrine Cavern / Tempest Keep",
        short = "Serpentshrine Cavern and The Eye progression",
        icon = "Interface\\Icons\\Spell_Frost_SummonWaterElemental_2",
        minValue = 9,
        completeAt = 10,
        objective = "Defeat Kael'thas Sunstrider in The Eye.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Serpentshrine Cavern and Tempest Keep are now your main raid progression. Both restored attunements matter, and Kael'thas Sunstrider is the progression boss that advances you to Tier 10.",
                "",
                SH("PRIMARY OBJECTIVES"),
                Priority("REQUIRED", "Complete The Eye attunement and defeat Kael'thas Sunstrider.", C.red),
                Priority("IMPORTANT", "Clear Serpentshrine Cavern and defeat Lady Vashj; her vial is required for Mount Hyjal attunement.", C.orange),
                "",
                SH("SERPENTSHRINE CAVERN ATTUNEMENT"),
                Priority("REQUIRED", "Complete The Cudgel of Kar'desh.", C.red),
                Bullet("Reach Skar'this the Heretic inside Heroic Slave Pens and accept The Cudgel of Kar'desh."),
                Bullet("Obtain the Earthen Signet from Gruul the Dragonkiller."),
                Bullet("Obtain the Blazing Signet from Nightbane in Karazhan."),
                Bullet("Return the signets to Skar'this to complete the attunement."),
                Priority("SERVER RULE", "All SSC bosses must be defeated before Lady Vashj's console can be used.", C.orange),
                "",
                SH("TEMPEST KEEP: THE EYE ATTUNEMENT"),
                Priority("REQUIRED", "Possess the Tempest Key and complete Trial of the Naaru: Magtheridon.", C.red),
                Bullet("Complete the Shadowmoon Valley chain that leads through The Cipher of Damnation and unlocks the Trial of the Naaru quests."),
                Bullet("Trial of the Naaru: Mercy - Heroic Shattered Halls."),
                Bullet("Trial of the Naaru: Strength - Heroic Steamvault and Heroic Shadow Labyrinth."),
                Bullet("Trial of the Naaru: Tenacity - Heroic Arcatraz."),
                Bullet("Trial of the Naaru: Magtheridon - defeat Magtheridon; the restored quest rewards the Tempest Key and Champion of the Naaru title."),
                Priority("SERVER RULE", "All Tempest Keep bosses must be defeated before the doors to Kael'thas open.", C.orange),
                "",
                SH("PREPARE FOR TIER 10"),
                Priority("IMPORTANT", "Accept / complete The Vials of Eternity as soon as the chain is available.", C.orange),
                Bullet("The quest requires the vial remnants from Lady Vashj and Kael'thas and is mandatory for Mount Hyjal access."),
                Bullet("Begin or continue the long Black Temple attunement chain in Shadowmoon Valley; you want Akama's Promise completed before the SSC continuation."),
                "",
                SH("REPUTATIONS"),
                Bullet("Continue The Violet Eye while farming Karazhan."),
                Bullet("Start The Scale of the Sands once Hyjal becomes accessible."),
                Bullet("Aldor / Scryers remain important for shoulder enchants, recipes and the Black Temple attunement route."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating Kael'thas advances you to Tier 10 - Mount Hyjal and Black Temple.", C.green),
            })
        end,
    },

    tbc10 = {
        nav = "Tier 10   Hyjal / Black Temple",
        title = "Tier 10 - Mount Hyjal / Black Temple",
        short = "Mount Hyjal and Black Temple progression",
        icon = "Interface\\Icons\\Spell_Shadow_SummonFelGuard",
        minValue = 10,
        completeAt = 12,
        objective = "Defeat Illidan Stormrage in Black Temple.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Mount Hyjal and Black Temple form the next raid stage. Illidan Stormrage is the progression boss. Zul'Aman is not a required progression tier on this server and will appear later as side content.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Complete Black Temple access and defeat Illidan Stormrage.", C.red),
                Priority("IMPORTANT", "Progress Mount Hyjal for Tier 6 gear, The Scale of the Sands reputation and the Black Temple attunement step.", C.orange),
                "",
                SH("MOUNT HYJAL ATTUNEMENT"),
                Priority("REQUIRED", "Complete The Vials of Eternity.", C.red),
                Bullet("Loot Vashj's Vial Remnant from Lady Vashj in Serpentshrine Cavern."),
                Bullet("Loot Kael's Vial Remnant from Kael'thas Sunstrider in Tempest Keep."),
                Bullet("Return both remnants to complete The Vials of Eternity and gain access to the Battle for Mount Hyjal."),
                "",
                SH("BLACK TEMPLE ATTUNEMENT"),
                Priority("REQUIRED", "Possess the Medallion of Karabor.", C.red),
                Bullet("Complete the Shadowmoon Valley Akama chain through Akama's Promise."),
                Bullet("After Fathom-Lord Karathress in SSC, continue with The Secret Compromised."),
                Bullet("Ruse of the Ashtongue - defeat Al'ar in Tempest Keep while using the Ashtongue Cowl."),
                Bullet("An Artifact From the Past - defeat Rage Winterchill in Mount Hyjal."),
                Bullet("Finish The Hostage Soul -> Entry Into the Black Temple -> A Distraction for Akama."),
                Bullet("A Distraction for Akama rewards the Medallion of Karabor required for entry."),
                Priority("GROUP HELP", "The .ip attune blacktemple command can copy the attunement item to eligible real players in your group when used by a player who already possesses it.", C.yellow),
                "",
                SH("RAID ORDER"),
                Bullet("You do not need to fully clear Mount Hyjal before beginning Black Temple once the Black Temple attunement is complete."),
                Bullet("However, the attunement itself requires Rage Winterchill, so Hyjal cannot be ignored completely."),
                "",
                SH("REPUTATIONS"),
                Bullet("The Scale of the Sands - Mount Hyjal reputation and raid rewards."),
                Bullet("Ashtongue Deathsworn - Black Temple reputation and profession rewards."),
                Bullet("Continue Aldor / Scryers and other profession-relevant factions until desired recipes and enchants are secured."),
                "",
                SH("WHAT UNLOCKS AFTER ILLIDAN"),
                Priority("UNLOCK", "Zul'Aman becomes available as optional side content on your server after Black Temple.", C.green),
                Priority("UNLOCK", "Tier 12 - Sunwell Plateau and Isle of Quel'Danas become your final TBC progression stage.", C.green),
            })
        end,
    },

    tbc12 = {
        nav = "Tier 12   Sunwell Plateau",
        title = "Tier 12 - Sunwell Plateau",
        short = "Final Burning Crusade progression",
        icon = "Interface\\Icons\\Spell_Holy_SummonLightwell",
        minValue = 12,
        completeAt = 13,
        objective = "Defeat Kil'jaeden in Sunwell Plateau.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Sunwell Plateau is the final Burning Crusade progression stage. The Isle of Quel'Danas and Magisters' Terrace are now available, and island content changes as your Shattered Sun Offensive reputation advances.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Kil'jaeden in Sunwell Plateau.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NO SEPARATE RAID ATTUNEMENT", "Sunwell access is controlled by your progression stage rather than a separate raid attunement item.", C.green),
                Bullet("The Isle of Quel'Danas, Magisters' Terrace and Sunwell Plateau are locked until this stage."),
                "",
                SH("ISLE OF QUEL'DANAS PROGRESSION"),
                Priority("IMPORTANT", "Build Shattered Sun Offensive reputation; the island itself is progression-phased around that reputation.", C.orange),
                Bullet("Friendly reputation opens the next major Isle phase."),
                Bullet("Honored reputation opens the following Isle phase."),
                Bullet("Revered reputation opens the later / fully developed Isle phase."),
                Bullet("Complete the Isle questlines and daily objectives as they become available."),
                Priority("MAGISTERS' TERRACE", "Complete the normal-difficulty quest chain through Hard to Kill before attempting Heroic Magisters' Terrace.", C.orange),
                Bullet("The chain begins from Crisis at the Sunwell for Aldor characters or Duty Calls for Scryer characters, then continues through Magisters' Terrace and The Scryer's Scryer."),
                "",
                SH("ZUL'AMAN"),
                Bullet("Zul'Aman is already available by this point and is useful side content for gear, timed-run rewards and additional progression variety."),
                Bullet("Killing Zul'jin does not advance your main progression state; Kil'jaeden remains the required final boss."),
                "",
                SH("REPUTATIONS / PROFESSIONS"),
                Bullet("Shattered Sun Offensive becomes the key final-stage reputation for Isle rewards and recipes."),
                Bullet("Finish outstanding Scale of the Sands, Ashtongue Deathsworn, Aldor / Scryer and profession-recipe goals before leaving TBC if desired."),
                "",
                SH("AFTER KIL'JAEDEN"),
                Priority("TBC COMPLETE", "Defeating Kil'jaeden completes the Burning Crusade raid journey.", C.green),
                Priority("NEXT EXPANSION", "When you are ready for Wrath, speak with Chronomancer Vezrath in any capital city near its faction leader.", C.orange),
                Bullet("The Burning Crusade -> Wrath of the Lich King expansion unlock costs 7,500 gold on your server."),
                Bullet("Inscription becomes available with Wrath of the Lich King."),
            })
        end,
    },
}

local TBC_OVERVIEW_PAGE = {
    title = "The Burning Crusade Roadmap",
    short = "Level 60-70 progression and raid preparation",
    icon = "Interface\\Icons\\Spell_Arcane_TeleportShattrath",
    body = function()
        return Join({
            SH("ENTERING THE BURNING CRUSADE"),
            Bullet("Complete the Vanilla Tier 7 transition and purchase the 2,500g Vanilla -> TBC unlock from Chronomancer Vezrath."),
            Bullet("Outland progression then opens and the level cap becomes 70."),
            Bullet("Jewelcrafting is now available; Inscription remains locked until Wrath."),
            Bullet("TBC talent rules apply: Rows 1-8 are open, only the middle talent of Row 9 is allowed, and Rows 10-11 remain blocked."),
            "",
            H("TBC RAID ROADMAP"),
            C.green .. "Tier 8" .. C.reset .. "       Karazhan / Gruul's Lair / Magtheridon's Lair",
            Bullet("Primary progression boss: Prince Malchezaar."),
            Bullet("Build level-70 Pre-Raid gear, heroic access, Karazhan attunement and Tier 9 attunement prerequisites."),
            "",
            C.green .. "Tier 9" .. C.reset .. "       Serpentshrine Cavern / Tempest Keep",
            Bullet("Restored SSC and The Eye attunements are required."),
            Bullet("Primary progression boss: Kael'thas Sunstrider."),
            "",
            C.green .. "Tier 10" .. C.reset .. "     Mount Hyjal / Black Temple",
            Bullet("The Vials of Eternity and Medallion of Karabor are required for access."),
            Bullet("Primary progression boss: Illidan Stormrage."),
            "",
            C.purple .. "SIDE CONTENT" .. C.reset .. "   Zul'Aman",
            Bullet("Unlocks after Black Temple on your server and does not advance the main progression state."),
            "",
            C.green .. "Tier 12" .. C.reset .. "     Sunwell Plateau / Isle of Quel'Danas",
            Bullet("Final TBC stage; build Shattered Sun Offensive reputation and defeat Kil'jaeden."),
            "",
            SH("THE BIG TBC PREP RULE"),
            Priority("IMPORTANT", "Do not wait until Tier 9 to think about heroic keys and attunements.", C.orange),
            Bullet("Several later raid attunements require Heroic dungeon objectives, Gruul, Magtheridon, Nightbane, SSC, TK and Hyjal kills."),
            Bullet("The best TBC pathway is to level, build faction reputation, unlock dungeon access, finish Karazhan, then keep future attunements moving in parallel with current raids."),
            "",
            SH("SUPPORT PAGES"),
            Bullet("Dungeons & Heroic Keys - leveling route, dungeon keys and Heroic preparation."),
            Bullet("TBC Reputations - heroic-access factions, raid reputations and optional endgame factions."),
            Bullet("TBC Professions - 375 progression, specialisations and recipe sources."),
            Bullet("TBC PvP - Arena Season 1 and level-70 PvP gearing."),
            Bullet("TBC World Bosses - Doom Lord Kazzak and Doomwalker timing."),
            Bullet("Zul'Aman - optional side raid after Black Temple."),
            "",
            SH("WORLD BOSSES"),
            Bullet("Doom Lord Kazzak and Doomwalker are optional high-value Tier 8 targets and are best tackled before later raid gear reduces their progression value."),
            "",
            SH("END OF TBC"),
            Bullet("After Kil'jaeden, Chronomancer Vezrath handles the 7,500g unlock into Wrath of the Lich King when you are ready."),
        })
    end,
}

local TBC_DUNGEONS_PAGE = {
    title = "TBC Dungeons & Heroic Keys",
    short = "Leveling route, dungeon access and heroic preparation",
    icon = "Interface\\Icons\\INV_Misc_Key_14",
    body = function()
        return Join({
            SH("WHY DUNGEONS MATTER SO MUCH IN TBC"),
            "TBC raid attunements repeatedly send you through normal and Heroic dungeons. Treat dungeon keys and faction reputation as raid preparation rather than optional side grinds.",
            "",
            SH("SUGGESTED LEVELING / DUNGEON ORDER"),
            Bullet("60-62: Hellfire Ramparts -> The Blood Furnace."),
            Bullet("62-64: The Slave Pens -> The Underbog."),
            Bullet("64-66: Mana-Tombs -> Auchenai Crypts."),
            Bullet("66-68: Old Hillsbrad Foothills -> Sethekk Halls."),
            Bullet("68-70: Shadow Labyrinth -> The Steamvault -> The Shattered Halls."),
            Bullet("Level 70: The Mechanar -> The Botanica -> The Arcatraz -> The Black Morass."),
            "",
            SH("HEROIC-KEY REPUTATIONS"),
            Priority("IMPORTANT", "Thrallmar / Honor Hold -> Flamewrought Key for Hellfire Citadel Heroics.", C.orange),
            Priority("IMPORTANT", "Cenarion Expedition -> Reservoir Key for Coilfang Heroics.", C.orange),
            Priority("IMPORTANT", "Lower City -> Auchenai Key for Auchindoun Heroics.", C.orange),
            Priority("IMPORTANT", "Keepers of Time -> Key of Time for Caverns of Time Heroics.", C.orange),
            Priority("IMPORTANT", "The Sha'tar -> Warpforged Key for Tempest Keep Heroics.", C.orange),
            Bullet("Raise each faction to the reputation required by its quartermaster and buy the key before the related raid attunement step blocks you."),
            "",
            SH("WHEN SHOULD I DO HEROIC DUNGEONS?"),
            Priority("LEVEL 60-69", "Focus on Normal dungeons, questing and reputation. You do not need to stop leveling just to prepare Heroics.", C.green),
            Priority("LEVEL 70 / TIER 8 PREP", "This is when Heroics should become part of your regular gearing route. Finish missing Heroic keys, improve pre-raid gear, earn reputation and collect useful dungeon rewards.", C.orange),
            Bullet("You do NOT need to clear every Heroic before starting Karazhan. Begin Karazhan when your character and group are ready."),
            Priority("DURING TIER 8", "Complete the Heroics required for SSC and Tempest Keep attunements before you finish Tier 8.", C.red),
            Bullet("Heroic Slave Pens - reach Skar'this the Heretic for The Cudgel of Kar'desh and the SSC attunement."),
            Bullet("Heroic Shattered Halls - Trial of the Naaru: Mercy."),
            Bullet("Heroic Steamvault + Heroic Shadow Labyrinth - Trial of the Naaru: Strength."),
            Bullet("Heroic Arcatraz - Trial of the Naaru: Tenacity."),
            Priority("BEFORE TIER 9", "Your required Heroic attunement objectives should be complete or nearly complete. Do not arrive at SSC / Tempest Keep with the Trial chain untouched.", C.red),
            Priority("TIER 9+", "Heroics become supplementary rather than your main progression route. Continue them for gear, badges, reputation, recipes or unfinished objectives.", C.yellow),
            Priority("TIER 12", "Complete the normal Magisters' Terrace quest chain before adding Heroic Magisters' Terrace to your endgame farming.", C.purple),
            "",
            SH("OTHER IMPORTANT DUNGEON ACCESS"),
            Priority("IMPORTANT", "Plan for flying at level 70; Tempest Keep's dungeon complex and several Outland endgame routes are designed around flying access.", C.orange),
            Bullet("Shadow Labyrinth Key - obtained through Sethekk Halls access progression."),
            Bullet("Shattered Halls Key - complete the key questline for convenient entry."),
            Bullet("Key to the Arcatraz - complete the Netherstorm key chain unless your group has another valid way to open the door."),
            Bullet("Caverns of Time - complete Old Hillsbrad before The Black Morass becomes part of the Karazhan attunement route."),
            "",
            SH("ATTUNEMENT CONNECTIONS"),
            Bullet("Karazhan uses Shadow Labyrinth, Steamvault, Arcatraz and Black Morass."),
            Bullet("SSC attunement begins in Heroic Slave Pens."),
            Bullet("The Eye attunement requires Heroic Shattered Halls, Steamvault, Shadow Labyrinth and Arcatraz, then Magtheridon."),
            "",
            SH("RECOMMENDED APPROACH"),
            Bullet("Use leveling dungeons to build reputation before level 70 rather than leaving every faction grind until raid week."),
            Bullet("At 70, finish missing keys and attunement dungeons before repeatedly farming content that does not advance access."),
        })
    end,
}

local TBC_REPUTATIONS_PAGE = {
    title = "TBC Reputations",
    short = "What to farm, when to farm it, and what each faction gives you",
    icon = "Interface\\Icons\\INV_Misc_Note_02",
    body = function()
        return Join({
            SH("HOW TO USE THIS PAGE"),
            "TBC reputation is part of progression, not just completionism. Some factions unlock Heroic dungeons, some provide powerful enchants and profession recipes, and others are tied directly to raids or optional endgame rewards.",
            "",
            Priority("FIRST PRIORITY", "While leveling and during Tier 8 preparation, focus first on the five dungeon factions connected to Heroic access.", C.red),
            Bullet("Do their zone quests while they are level-appropriate and run their normal dungeons while those dungeons are still useful for XP and gear."),
            Bullet("At level 70, finish any missing reputation needed to buy the related Heroic key and continue the factions that offer rewards important to your class or professions."),
            "",
            SH("CORE DUNGEON / HEROIC REPUTATIONS"),
            "These five factions are the most important early TBC reputations because their dungeon families feed directly into Heroic gearing and later raid attunements.",
            "",
            Priority("IMPORTANT", "Thrallmar / Honor Hold - Hellfire Peninsula", C.orange),
            Bullet("When: Start immediately after entering Outland. Hellfire quests, Hellfire Ramparts and The Blood Furnace make this one of the easiest reputations to begin while leveling."),
            Bullet("How: Quest through Hellfire Peninsula and use Ramparts / Blood Furnace early; The Shattered Halls and Heroic Hellfire Citadel dungeons continue the grind at higher level."),
            Bullet("Why: The quartermaster provides the Flamewrought Key for Hellfire Citadel Heroics, useful level-70 gear, profession recipes and an important role-specific head enchant."),
            Bullet("Progression value: Heroic Shattered Halls is later used by the Trial of the Naaru chain, so neglecting this reputation can delay Tempest Keep attunement."),
            "",
            Priority("IMPORTANT", "Cenarion Expedition - Zangarmarsh / Coilfang Reservoir", C.orange),
            Bullet("When: Start in Zangarmarsh and keep it moving through the 60s. It is particularly valuable for physical DPS, Feral tanks and several crafting professions."),
            Bullet("How: Cenarion quests, early Zangarmarsh turn-ins and the Coilfang dungeons all contribute. Slave Pens and Underbog are good leveling runs; Steamvault becomes a major level-70 reputation source."),
            Bullet("Why: The Reservoir Key opens Coilfang Heroics. The faction also offers strong gear, profession recipes and a highly useful physical-DPS head enchant; Feral Druids should also check the faction's weapon rewards."),
            Bullet("Progression value: Heroic Slave Pens begins the SSC attunement through Skar'this, while Heroic Steamvault is used in the Tempest Keep Trial chain."),
            "",
            Priority("IMPORTANT", "Lower City - Shattrath / Auchindoun", C.orange),
            Bullet("When: Begin while questing in Terokkar Forest and running Auchindoun. Do not leave it untouched until the week you want Heroic Shadow Labyrinth."),
            Bullet("How: Lower City quests, repeatable Arakkoa-related turn-ins and Auchindoun dungeons build reputation. Shadow Labyrinth becomes one of the main higher-level routes."),
            Bullet("Why: The Auchenai Key gives access to Auchindoun Heroics. The quartermaster also provides gear, profession recipes and a role-specific head enchant."),
            Bullet("Progression value: Heroic Shadow Labyrinth is required during the Trial of the Naaru: Strength step for Tempest Keep attunement."),
            "",
            Priority("IMPORTANT", "Keepers of Time - Caverns of Time", C.orange),
            Bullet("When: Begin as soon as Old Hillsbrad becomes appropriate and keep following the Caverns of Time quest chain into The Black Morass."),
            Bullet("How: Old Hillsbrad, Black Morass and their quests all award reputation. Unlike several other dungeon factions, these dungeons remain useful reputation sources for a long time."),
            Bullet("Why: The Key of Time opens Caverns of Time Heroics. The faction also provides useful gear, recipes and a tank-focused head enchant."),
            Bullet("Progression value: Completing Old Hillsbrad unlocks the path to Black Morass, and Black Morass is part of the Karazhan Master's Key attunement."),
            "",
            Priority("IMPORTANT", "The Sha'tar - Shattrath / Tempest Keep Dungeons", C.orange),
            Bullet("When: Start building it naturally once you reach Shattrath. Your Aldor or Scryer progression can help raise Sha'tar reputation before you begin serious Tempest Keep dungeon farming."),
            Bullet("How: Shattrath questing plus The Mechanar, The Botanica and The Arcatraz are the main practical sources at level 70."),
            Bullet("Why: The Warpforged Key opens Tempest Keep Heroics. The faction also supplies caster-focused rewards, profession recipes and an important spellcaster head enchant."),
            Bullet("Progression value: Heroic Arcatraz is part of Trial of the Naaru: Tenacity, and normal Arcatraz is also used during the Karazhan attunement route."),
            "",
            SH("SHATTRATH CHOICE / PROFESSION REPUTATIONS"),
            Priority("IMPORTANT CHOICE", "The Aldor OR The Scryers", C.orange),
            Bullet("When: Choose your allegiance after reaching Shattrath. Do this early enough that the items you collect while leveling can contribute to the faction you actually intend to keep."),
            Bullet("How: Each side uses its own repeatable signet/mark turn-ins plus Arcane Tomes or Fel Armaments at higher reputation, alongside quests in Shattrath, Netherstorm and Shadowmoon Valley."),
            Bullet("Why: Both factions provide powerful shoulder inscriptions, profession recipes, gear and access to faction-specific quest lines. Which is better depends on your class, spec and professions."),
            Bullet("Progression value: Your choice also feeds into later Shattrath content and parts of the Black Temple journey. Switching sides later is possible but deliberately time-consuming."),
            Bullet("Extra value: Building Aldor or Scryer reputation also helps your Sha'tar standing during the early part of that grind."),
            "",
            Priority("RECOMMENDED", "The Consortium - Nagrand / Netherstorm / Mana-Tombs", C.yellow),
            Bullet("When: Start casually in Nagrand and Mana-Tombs. Push it harder if you use Jewelcrafting, Enchanting or want its gem-related rewards."),
            Bullet("How: Mana-Tombs, Consortium quests, Obsidian Warbeads, Zaxxis Insignias and later Ethereum-related turn-ins can all be used."),
            Bullet("Why: The Consortium offers gear and recipes for several professions, especially Jewelcrafting. Higher standing also improves the monthly Membership Benefits gem package."),
            Bullet("High-value extra: At higher reputation you can access the additional Heroic Mana-Tombs boss Yor; Exalted eventually gives a permanent method of summoning him."),
            Bullet("Progression value: Useful and profitable, but not a main raid-progression gate. Prioritise it according to your professions and desired rewards."),
            "",
            SH("ZONE / OPTIONAL REPUTATIONS"),
            Priority("RECOMMENDED", "The Mag'har / Kurenai - Nagrand", C.yellow),
            Bullet("When: Work on your faction's version while leveling through Nagrand. Horde uses The Mag'har; Alliance uses Kurenai."),
            Bullet("How: Nagrand quests, Ogre / Kil'sorrow kills and Obsidian Warbead turn-ins can carry the reputation well beyond the normal quest path."),
            Bullet("Why: The main long-term rewards are Talbuk mounts, useful gear and profession recipes. Leatherworkers in particular should check the faction vendor."),
            Bullet("Progression value: Not required for raid access. Treat it as a strong leveling-side reputation and an optional mount/profession goal."),
            "",
            Priority("OPTIONAL", "Sporeggar - Zangarmarsh", C.purple),
            Bullet("When: Best started while you are already in Zangarmarsh, especially if you are killing Bog Lords, collecting Fertile Spores or running The Underbog."),
            Bullet("How: Early repeatable turn-ins raise the faction from its low starting reputation; later Fertile Spores, Sanguine Hibiscus and other repeatables can continue to Exalted."),
            Bullet("Why: Sporeggar uses Glowcaps as a vendor currency and offers unusual gear, consumables and profession recipes. It can be particularly worthwhile when a specific recipe is part of your profession plan."),
            Bullet("Progression value: Optional. Do not delay Heroic-key factions or raid attunements purely to finish Sporeggar."),
            "",
            Priority("OPTIONAL - MOUNTS", "Netherwing - Shadowmoon Valley", C.purple),
            Bullet("When: Start at level 70 once you have flying. Expert Riding is enough to begin the introductory chain, but Artisan Riding is required to continue the main reputation grind beyond Neutral."),
            Bullet("Where to begin: Find Mordenai in the Netherwing Fields of Shadowmoon Valley. The introductory story runs through Neltharaku, Dragonmaw Fortress, Karynaku and Zuluhed before Ally of the Netherwing raises you from Hated to Neutral."),
            Bullet("Neutral: Complete the Netherwing Ledge introduction and begin the first daily quests. Mining, Herbalism or Skinning can provide a profession-specific daily in addition to the normal daily route."),
            Bullet("Netherwing Eggs: Once unlocked, eggs found around Netherwing Ledge and related areas can be handed in repeatedly for extra reputation. They are particularly valuable because they speed up a grind otherwise limited heavily by daily quests."),
            Bullet("Friendly / Honored / Revered: More quest chains and daily quests unlock as your standing rises, so the reputation gain per day increases over time rather than staying fixed from Neutral to Exalted."),
            Bullet("How to approach it: Do the available dailies whenever you want steady progress, keep an eye out for Netherwing Eggs while on the Ledge, and complete each new reputation-rank quest chain as soon as it appears."),
            Bullet("Why: The main end reward is the Netherwing Drake collection. At Exalted you complete the final story and choose a Netherwing Drake; the other drake colours can then be obtained from the Netherwing mount vendor."),
            Bullet("Other value: The reputation chain provides substantial level-70 daily content and gold income, with additional quest rewards along the way. It is a long-term character goal rather than raid access."),
            Bullet("Progression value: Entirely optional. Do not delay Karazhan, Heroic attunements or required Tier 8 reputation work for Netherwing. It is best fitted around your raid progression once flying and your essential preparation are under control."),
            "",
            Priority("OPTIONAL - MOUNTS", "Sha'tari Skyguard - Skettis / Blade's Edge", C.purple),
            Bullet("When: Level 70 after gaining flying. It fits well as optional outdoor content alongside other daily reputations."),
            Bullet("How: Complete the Skettis quest chain, daily quests, mob farming and the Shadow Dust / Time-Lost Scroll summoning loop; later bosses culminate in Terokk."),
            Bullet("Why: Reputation unlocks gear and utility rewards, with Riding Nether Ray mounts as the main Exalted prize."),
            Bullet("Progression value: Optional. Useful for mounts and outdoor rewards, not a raid attunement requirement."),
            "",
            Priority("OPTIONAL", "Ogri'la - Blade's Edge Mountains", C.purple),
            Bullet("When: Level 70 after flying. Begin once your character can comfortably handle Blade's Edge endgame quests."),
            Bullet("How: Unlock the Ogri'la hub, then use daily quests and Apexis-related activities to build reputation."),
            Bullet("Why: Offers gear, profession-related rewards and Apexis Crystal content. Some activities overlap geographically with Sha'tari Skyguard progression."),
            Bullet("Progression value: Optional side progression. Good for extra rewards but not required for the main raid path."),
            "",
            SH("RAID REPUTATIONS"),
            Priority("IMPORTANT", "The Violet Eye - Karazhan", C.orange),
            Bullet("When: Tier 8. You do not need to stop and grind this separately; it rises naturally while completing the Karazhan attunement quests and clearing Karazhan."),
            Bullet("How: Karazhan quests, trash and bosses grant reputation all the way to Exalted."),
            Bullet("Why: The standout reward is the Violet Signet ring line, which upgrades as your reputation rises. Vendors also offer profession recipes and other raid-era rewards."),
            Bullet("Progression value: This is a natural Tier 8 raid reputation. Keep clearing Karazhan and remember to claim ring upgrades as they become available."),
            "",
            Priority("IMPORTANT", "The Scale of the Sands - Mount Hyjal", C.orange),
            Bullet("When: Tier 10, after completing The Vials of Eternity and gaining access to Mount Hyjal."),
            Bullet("How: Hyjal quests, trash and bosses build the reputation. Completing the Hyjal access quest gives you a strong starting boost."),
            Bullet("Why: The Band of Eternity ring is chosen early and upgraded through later reputation levels. The faction also provides Jewelcrafting recipes and sits alongside the Tier 6 token vendors."),
            Bullet("Progression value: Let it rise naturally with Hyjal clears; there is no reason to farm it before the raid is available."),
            "",
            Priority("IMPORTANT", "Ashtongue Deathsworn - Black Temple", C.orange),
            Bullet("When: Tier 10. The Black Temple attunement chain introduces the faction before you begin regular Black Temple clears."),
            Bullet("How: Attunement quests plus Black Temple trash and bosses build reputation to Exalted."),
            Bullet("Why: The faction sells numerous endgame crafting recipes, and Exalted unlocks class-specific Ashtongue Talisman trinkets."),
            Bullet("Progression value: A natural Black Temple reputation. It becomes increasingly valuable to raiders and crafters as Tier 10 farming continues."),
            "",
            Priority("IMPORTANT", "Shattered Sun Offensive - Isle of Quel'Danas", C.orange),
            Bullet("When: Tier 12 / Sunwell stage. This is the final major TBC reputation and should become a regular part of your endgame routine once the Isle is available."),
            Bullet("How: Isle questing, daily quests and Magisters' Terrace all provide reputation."),
            Bullet("Why: The quartermaster offers strong catch-up gear plus valuable Enchanting, Jewelcrafting, Alchemy and other profession rewards as your standing increases."),
            Bullet("Server-specific value: Your personal Shattered Sun reputation also controls parts of the Isle's phasing. Friendly, Honored and Revered progressively reveal later Isle content on this server."),
            Bullet("Progression value: High priority during the Sunwell stage because the reputation is both a reward track and part of how your personal Isle develops."),
            "",
            SH("SIMPLE PRIORITY BY STAGE"),
            Priority("LEVELING 60-69", "Thrallmar/Honor Hold -> Cenarion Expedition -> Lower City -> Keepers of Time, while choosing Aldor/Scryers and building useful side factions naturally.", C.green),
            Priority("LEVEL 70 / TIER 8", "Finish all five Heroic-key factions, add The Sha'tar, then let Violet Eye rise through Karazhan. Push Consortium or zone factions only when their rewards matter to you.", C.orange),
            Priority("TIER 9", "Keep Heroic-access factions healthy for unfinished attunements, but your main reputation work should now support current raids and professions.", C.yellow),
            Priority("TIER 10", "Scale of the Sands and Ashtongue Deathsworn become your natural raid reputations. Optional daily factions can be worked on between raids.", C.purple),
            Priority("TIER 12", "Shattered Sun Offensive becomes the main new reputation and should be progressed alongside Isle of Quel'Danas and Magisters' Terrace content.", C.red),
            "",
            SH("BOTTOM LINE"),
            "Do not try to Exalt every TBC faction before raiding. Build the reputations that unlock your next dungeon or raid step first, then push a faction further when its enchants, gear, profession recipes, mounts or other rewards are actually useful to your character.",
        })
    end,
}

local TBC_PROFESSIONS_PAGE = {
    title = "TBC Professions",
    short = "375 skill, specialisations and progression recipes",
    icon = "Interface\\Icons\\Trade_Engineering",
    body = function()
        return Join({
            SH("PROFESSION CAP"),
            Priority("IMPORTANT", "The Burning Crusade raises primary professions to 375.", C.orange),
            Bullet("Train the Master rank for the professions you intend to keep and work toward 375 while leveling through Outland."),
            Bullet("Jewelcrafting is now available on this server. Inscription remains phased until Wrath of the Lich King."),
            "",
            SH("WHY PROFESSIONS ARE PART OF PROGRESSION"),
            Bullet("Many strong recipes come from Outland reputations, Heroic dungeons, raids and world content."),
            Bullet("Check faction vendors whenever you reach Friendly, Honored, Revered or Exalted instead of waiting until the end of the expansion."),
            Bullet("Crafted items can fill pre-raid and early-raid gaps, especially before repeated raid clears are available."),
            "",
            SH("SPECIALISATIONS"),
            Priority("IMPORTANT", "Review your profession specialisation before committing expensive materials.", C.orange),
            Bullet("Alchemy: Potion, Elixir or Transmutation mastery."),
            Bullet("Tailoring: Mooncloth, Spellfire or Shadoweave specialisation."),
            Bullet("Blacksmithing: Armorsmith or Weaponsmith paths, with weapon specialisations where appropriate."),
            Bullet("Leatherworking: Dragonscale, Elemental or Tribal Leatherworking."),
            Bullet("Engineering: Gnomish and Goblin Engineering remain meaningful choices for recipes and utility."),
            "",
            SH("REPUTATION RECIPE CHECKLIST"),
            Bullet("Thrallmar / Honor Hold - check profession recipes while building Hellfire reputation."),
            Bullet("Cenarion Expedition - important profession and resistance-related recipes for several crafts."),
            Bullet("Lower City / The Sha'tar / Keepers of Time - check each quartermaster as heroic access reputation rises."),
            Bullet("The Aldor / The Scryers - your Shattrath choice affects available recipes and other long-term rewards."),
            Bullet("The Violet Eye, Scale of the Sands and Ashtongue Deathsworn - raid reputations can provide valuable endgame recipes."),
            Bullet("Shattered Sun Offensive - final-stage recipes and rewards become relevant on the Isle of Quel'Danas."),
            "",
            SH("RECOMMENDED TIMING"),
            Priority("TIER 8", "Reach useful profession breakpoints and secure important reputation recipes while building pre-raid gear.", C.yellow),
            Priority("TIER 9-10", "Keep raid-reputation recipes and crafted upgrades current rather than treating professions as finished at 375.", C.yellow),
            Priority("TIER 12", "Finish Shattered Sun and outstanding TBC recipe goals before moving to Wrath if you want a complete progression journey.", C.yellow),
        })
    end,
}

local TBC_PVP_PAGE = {
    title = "TBC PvP",
    short = "Arena Season 1 and level-70 PvP progression",
    icon = "Interface\\Icons\\INV_BannerPVP_02",
    body = function()
        return Join({
            SH("CURRENT ARENA SEASON"),
            Priority("SERVER SETTING", "The Burning Crusade is configured for Arena Season 1.", C.green),
            Bullet("The server phases TBC PvP and arena-season vendors to the Burning Crusade era."),
            Bullet("Season 1 is the active TBC arena vendor set on this server."),
            "",
            SH("VANILLA RANKS AFTER ENTERING TBC"),
            Bullet("Vanilla PvP titles you already earned remain on the character."),
            Priority("LOCKED", "New Vanilla PvP titles can no longer be earned after the character leaves Vanilla progression.", C.orange),
            Bullet("The custom Rank 1-14 honorable-kill ladder therefore belongs to the Vanilla journey, not TBC."),
            "",
            SH("TBC PVP PATH"),
            Bullet("Battleground Honor rewards are a legitimate gearing route alongside level-70 dungeons, crafted gear and raids."),
            Bullet("Arena provides a separate competitive gear path during Season 1."),
            Bullet("Continue relevant battleground reputations if you still want their faction rewards."),
            "",
            SH("WHEN TO DO IT"),
            Priority("TIER 8", "Best point to use PvP to strengthen weak pre-raid and early-raid slots.", C.yellow),
            Bullet("Keep raid attunements and Heroic access moving in parallel so PvP does not accidentally stall required progression."),
            Bullet("Later in TBC, PvP remains optional side progression rather than a raid-stage requirement."),
        })
    end,
}

local TBC_WORLD_BOSS_PAGE = {
    title = "TBC World Boss Timeline",
    short = "Outland world bosses and when to tackle them",
    icon = "Interface\\Icons\\Spell_Shadow_SummonInfernal",
    body = function()
        return Join({
            SH("TIER 8 - BEST WINDOW"),
            Priority("OPTIONAL - HIGH VALUE", "Doom Lord Kazzak - Throne of Kil'jaeden, Hellfire Peninsula", C.purple),
            Bullet("Recommended timing: early level-70 / Tier 8 progression."),
            Bullet("Treat him as organised raid content and attempt him before later tiers make his drops less meaningful."),
            "",
            Priority("OPTIONAL - HIGH VALUE", "Doomwalker - Shadowmoon Valley, outside Black Temple", C.purple),
            Bullet("Recommended timing: Tier 8 onward as soon as your raid force can handle him."),
            Bullet("The boss is physically near Black Temple, but he is side content rather than a Black Temple attunement requirement."),
            "",
            SH("PRIORITY"),
            Bullet("Required raid boss / attunement objective first."),
            Bullet("Then world bosses while their loot still improves your roster."),
            Bullet("Do not postpone both bosses until Sunwell unless you only want completion/collection value."),
        })
    end,
}

local ZULAMAN_PAGE = {
    title = "Zul'Aman",
    short = "Optional TBC side raid - unlocks after Black Temple",
    icon = "Interface\\Icons\\Ability_Druid_ChallangingRoar",
    body = function()
        return Join({
            SH("STATUS ON THIS SERVER"),
            Priority("SIDE CONTENT", "Zul'Aman is not a required progression tier.", C.purple),
            Priority("UNLOCK", "It becomes available after Black Temple / Illidan progression is complete.", C.green),
            Bullet("This is why the main raid progression jumps from Tier 10 to Tier 12 rather than treating Zul'Aman as a mandatory numbered tier."),
            "",
            SH("ACCESS"),
            Priority("NO RAID ATTUNEMENT", "Zul'Aman does not require a separate raid-entry attunement quest.", C.green),
            "",
            SH("WHY DO IT"),
            Bullet("Strong side-grade and catch-up-style gear while still remaining an authentic TBC raid experience."),
            Bullet("Timed-event rewards give the raid a different progression goal from standard boss clearing."),
            Bullet("Useful place to strengthen weaker slots before or during the Sunwell stage."),
            "",
            SH("PROGRESSION RULE"),
            Bullet("Defeating Zul'jin does not advance your Individual Progression stage on this server."),
            Bullet("Your required final TBC progression target remains Kil'jaeden in Sunwell Plateau."),
        })
    end,
}

local WORLD_BOSS_PAGE = {
    title = "Vanilla World Boss Timeline",
    short = "When to do each world boss",
    icon = "Interface\\Icons\\Ability_Hunter_Pet_DragonHawk",
    body = function()
        return Join({
            SH("WHY THIS PAGE EXISTS"),
            "World bosses are easy to forget because they do not directly advance your main progression. This guide places them where their loot and difficulty are most useful to your character.",
            "",
            H("EARLY VANILLA - TIER 2 WINDOW"),
            Priority("OPTIONAL - HIGH VALUE", "Azuregos - Azshara", C.purple),
            Bullet("Recommended timing: as soon as the early post-opening world-boss unlock is available."),
            Bullet("Do not wait until AQ/Naxx if you want his loot to serve as real progression rather than collection gear."),
            Bullet("Notable for powerful caster/melee items and the Mature Blue Dragon Sinew for the Hunter epic quest path."),
            "",
            Priority("OPTIONAL - HIGH VALUE", "Lord Kazzak - Blasted Lands", C.purple),
            Bullet("Recommended timing: alongside Azuregos in the early post-opening / BWL-era window."),
            Bullet("Treat him as a raid target, not a solo rare. His mechanics punish deaths and poor control."),
            Bullet("His loot contains strong raid-era upgrades and profession-related value."),
            "",
            H("LATER VANILLA - PRE-AQ WINDOW"),
            Priority("OPTIONAL - HIGH VALUE", "Ysondre - Dragon of Nightmare", C.purple),
            Priority("OPTIONAL - HIGH VALUE", "Emeriss - Dragon of Nightmare", C.purple),
            Priority("OPTIONAL - HIGH VALUE", "Lethon - Dragon of Nightmare", C.purple),
            Priority("OPTIONAL - HIGH VALUE", "Taerar - Dragon of Nightmare", C.purple),
            Bullet("Recommended timing: during Tier 3 / Pre-AQ progression, when later-Vanilla outdoor content becomes the focus."),
            Bullet("Their Nature-themed rewards and difficulty make them a natural fit while preparing for AQ."),
            Bullet("Kill whichever dragon is active; do not treat them as four simultaneous permanent spawns."),
            "",
            SH("PRIORITY RULE"),
            Bullet("World bosses are not required to advance your main progression stage."),
            Bullet("They are still worth scheduling because delaying them too long makes the loot less meaningful."),
            Bullet("If raid time is limited: required tier boss > attunements/event gates > world bosses > repeat farming."),
            "",
            SH("REMEMBER"),
            "World bosses are optional progression, but their rewards are most meaningful when you tackle them during the stage shown here rather than saving them until much later.",
        })
    end,
}


-- ============================================================================
-- WRATH OF THE LICH KING
--
-- Progression values continue to represent the highest completed milestone:
-- 13 = TBC complete / opening Wrath stage
-- 14 = Kel'Thuzad defeated / Ulduar available
-- 15 = Yogg-Saron defeated / Trial of the Crusader era available
-- 16 = Anub'arak defeated / Frozen Halls + Icecrown Citadel available
-- 17 = Lich King defeated / Ruby Sanctum available
-- 18 = Halion defeated / Wrath progression complete
-- ============================================================================

local WOTLK_STAGES = {
    wrath13 = {
        nav = "Tier 13   Naxx / EoE / OS",
        title = "Tier 13 - Naxxramas / Eye of Eternity / Obsidian Sanctum",
        short = "Opening Wrath raid progression",
        icon = "Interface\\Icons\\Achievement_Boss_KelThuzad_01",
        minValue = 13,
        completeAt = 14,
        objective = "Defeat Kel'Thuzad in Naxxramas.",
        body = function()
            return Join({
                SH("BEFORE NORTHREND"),
                Priority("EXPANSION UNLOCK", "If this character has not yet purchased Wrath access, visit Chronomancer Vezrath and pay the 7,500 gold TBC -> Wrath unlock cost.", C.orange),
                Bullet("The addon can read your Individual Progression value, but it cannot detect whether the separate Character Services expansion purchase has already been made."),
                Bullet("Once Wrath access is unlocked, Northrend opens and you can progress from level 70 to 80."),
                "",
                SH("WHAT CHANGES IN WRATH"),
                Bullet("The full 3.3.5 talent trees are now available: Rows 1 through 11 can be used normally."),
                Bullet("Inscription is now available and profession skill caps rise to 450."),
                Bullet("Death Knights are now unlocked for the account under your current server rules and begin at Wrath progression."),
                Bullet("At level 77, Cold Weather Flying becomes an important travel unlock for Storm Peaks and Icecrown."),
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Kel'Thuzad in Wrath Naxxramas to advance to Tier 14.", C.red),
                "",
                SH("OPENING RAIDS"),
                Priority("MAIN RAID", "Naxxramas - 10-player and 25-player versions form the core opening raid progression.", C.orange),
                Priority("IMPORTANT", "The Obsidian Sanctum - Sartharion is available as opening-tier side raid content.", C.yellow),
                Priority("IMPORTANT", "The Eye of Eternity - Malygos is opening-tier side raid content and should be completed while its rewards are relevant.", C.yellow),
                "",
                SH("ATTUNEMENT / ACCESS REQUIREMENTS"),
                Priority("NAXXRAMAS", "No Vanilla-style Argent Dawn attunement is required for the Wrath version of Naxxramas.", C.green),
                Priority("OBSIDIAN SANCTUM", "No conventional attunement quest is required.", C.green),
                Priority("EYE OF ETERNITY", "The Malygos encounter uses the Focusing Iris key mechanic. Obtain the appropriate key through Sapphiron in Naxxramas; only one qualified raid member needs to activate the encounter.", C.orange),
                "",
                SH("LEVEL 80 / PRE-RAID PRIORITIES"),
                Bullet("Finish strong level-80 Normal dungeon rewards, then move into Heroics immediately once your group is ready."),
                Bullet("Wrath Heroics do not use the TBC reputation-key system."),
                Bullet("Use faction tabards in eligible level-80 dungeons to build the reputation needed for class-relevant head enchants and vendor rewards."),
                Bullet("Begin Sons of Hodir in Storm Peaks early if your character needs their shoulder enchants."),
                Bullet("Build crafted Pre-Raid gear, enchants, gems, consumables and profession bonuses before expensive raid upgrades."),
                "",
                SH("EMBLEMS"),
                Priority("OPENING WRATH", "Heroic dungeon bosses award Emblems of Heroism at this stage; Naxxramas uses the opening raid emblem tier.", C.yellow),
                Bullet("The server changes emblem drops as Wrath tiers advance, so Heroics remain relevant even after your first raid tier."),
                "",
                SH("WINTERGRASP / VAULT OF ARCHAVON"),
                Priority("AVAILABLE NOW", "Wintergrasp begins with Wrath progression. Use it for PvP rewards, quests and access to Vault of Archavon when your faction controls the fortress.", C.purple),
                Bullet("Archavon the Stone Watcher is the first Vault boss available in the opening Wrath tier."),
                "",
                SH("OPTIONAL HIGH-VALUE CHALLENGES"),
                Bullet("Sartharion with one, two or three drakes alive increases difficulty and rewards; 3-drake clears are an excellent opening-tier challenge."),
                Bullet("Complete Malygos and Obsidian Sanctum even though neither advances the Individual Progression state."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating Kel'Thuzad advances you to Tier 14 - Ulduar.", C.green),
            })
        end,
    },

    wrath14 = {
        nav = "Tier 14   Ulduar",
        title = "Tier 14 - Ulduar",
        short = "Ulduar progression and hard modes",
        icon = "Interface\\Icons\\Achievement_Boss_YoggSaron_01",
        minValue = 14,
        completeAt = 15,
        objective = "Defeat Yogg-Saron in Ulduar.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Ulduar is now your main progression raid. The server blocks Ulduar until the opening Wrath tier has been completed, so this is a true second raid stage rather than content you can skip ahead to early.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Yogg-Saron to advance to Tier 15.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS"),
                Priority("NO CONVENTIONAL ATTUNEMENT", "Ulduar does not require a separate raid attunement quest once Tier 14 is reached.", C.green),
                Bullet("Access itself is progression-gated: Kel'Thuzad must already be completed before Ulduar opens on this server."),
                "",
                SH("HOW TO APPROACH ULDUAR"),
                Bullet("Learn and clear encounters on their standard versions first unless your group is specifically ready to pursue hard modes."),
                Bullet("Ulduar hard modes are activated through encounter mechanics rather than one universal Heroic difficulty switch."),
                Priority("OPTIONAL - HIGH VALUE", "Hard modes provide stronger rewards and are an important part of the intended Ulduar endgame once the normal clear is stable.", C.purple),
                "",
                SH("ALGALON THE OBSERVER"),
                Priority("OPTIONAL ENDGAME", "Algalon is not required to advance Individual Progression, but he is one of the major Ulduar completion goals.", C.purple),
                Bullet("A raid member must complete the Celestial Planetarium key path."),
                Bullet("The key path requires the hard-mode sigils from Hodir, Thorim, Freya and Mimiron on the relevant raid size."),
                Bullet("Treat Algalon as a later Ulduar objective after your group is comfortable with the keeper hard modes."),
                "",
                SH("VAL'ANYR"),
                Priority("OPTIONAL LEGENDARY", "Healers pursuing Val'anyr should begin collecting Fragments of Val'anyr from Ulduar as soon as possible.", C.purple),
                Bullet("This is a long raid-based project, so decide early who will receive fragments rather than treating them as ordinary loot."),
                "",
                SH("HEROICS / EMBLEMS"),
                Bullet("Heroics are now supporting content rather than your main gearing source, but the server upgrades their emblem reward tier as Wrath progresses."),
                Priority("TIER 14", "Heroic bosses move to Emblems of Valor; Ulduar is the main source of the next raid-tier emblem rewards.", C.yellow),
                Bullet("Continue Heroics for missing slots, reputation, daily objectives and emblem purchases."),
                "",
                SH("WINTERGRASP / VAULT"),
                Priority("NEW VAULT BOSS", "Emalon the Storm Watcher joins Vault of Archavon during the Ulduar era.", C.purple),
                Bullet("Keep doing Wintergrasp and Vault when the rewards are useful to your class or PvP set."),
                "",
                SH("PREPARE FOR TIER 15"),
                Bullet("Finish Ulduar gear targets and useful hard modes before moving on if you want the raid to remain meaningful progression."),
                Bullet("The Argent Tournament / Trial content is deliberately held back until the next stage on this server."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating Yogg-Saron advances you to Tier 15 - Trial of the Crusader era content.", C.green),
            })
        end,
    },

    wrath15 = {
        nav = "Tier 15   Trial of Crusader",
        title = "Tier 15 - Trial of the Crusader",
        short = "Argent Tournament raid tier",
        icon = "Interface\\Icons\\Achievement_Boss_Anubarak",
        minValue = 15,
        completeAt = 16,
        objective = "Defeat Anub'arak in Trial of the Crusader.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "The Argent Tournament raid tier is now active. On this server both Trial of the Champion and Trial of the Crusader are progression-gated until Yogg-Saron has been defeated.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Anub'arak in Trial of the Crusader to advance to Tier 16.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS"),
                Priority("NO TRADITIONAL ATTUNEMENT", "Trial of the Crusader does not require a long attunement quest once this tier has been reached.", C.green),
                Priority("SERVER GATE", "Trial of the Champion and Trial of the Crusader only open after Ulduar progression is complete.", C.orange),
                "",
                SH("TRIAL OF THE CHAMPION"),
                Priority("DO NOW", "Run the 5-player Trial of the Champion when useful for new dungeon gear and Tournament-era rewards.", C.yellow),
                Bullet("It is designed as a quick level-80 gearing option during this stage and is especially useful for filling weak slots."),
                "",
                SH("TRIAL OF THE CRUSADER / GRAND CRUSADER"),
                Bullet("Clear the normal raid first and learn the encounter flow before pushing the Heroic Trial of the Grand Crusader difficulties."),
                Priority("OPTIONAL - HIGH VALUE", "Trial of the Grand Crusader is the advanced version of this tier and is worth pursuing for stronger rewards, achievements and mastery of the stage.", C.purple),
                Bullet("Individual Progression advances from the Anub'arak kill; heroic completion is not required to unlock Icecrown."),
                "",
                SH("ARGENT TOURNAMENT"),
                Priority("AVAILABLE NOW", "The Argent Tournament side-progression hub is now part of your server's active stage.", C.purple),
                Bullet("Work through Aspirant, Valiant and Champion progression, then use Champion's Seals for mounts, pets, tabards, gear and collection rewards."),
                Bullet("The Black Knight questline is a useful companion objective and ties directly into Trial of the Champion."),
                "",
                SH("LEVEL-80 ONYXIA"),
                Priority("OPTIONAL - RECOMMENDED TIMING", "Wrath Onyxia is not an Individual Progression boss. Level-80 characters can access her separately; this Tier 15 window is the natural era to schedule her if you want her loot and achievements while relevant.", C.purple),
                "",
                SH("HEROICS / EMBLEMS"),
                Priority("TIER 15", "Heroic dungeon bosses move to Emblems of Conquest on the server's emblem ladder.", C.yellow),
                Bullet("Older Heroics remain useful for emblem farming and reputation even when their direct gear is no longer an upgrade."),
                "",
                SH("WINTERGRASP / VAULT"),
                Priority("NEW VAULT BOSS", "Koralon the Flame Watcher joins Vault of Archavon during this stage.", C.purple),
                "",
                SH("PREPARE FOR ICECROWN"),
                Bullet("Finish important class reputations, Sons of Hodir shoulder enchants and profession bonuses before ICC if you have delayed them."),
                Bullet("Stock raid consumables and gold for enchants/gems; ICC gear upgrades arrive quickly once Tier 16 begins."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating Anub'arak advances you to Tier 16 - Frozen Halls and Icecrown Citadel.", C.green),
            })
        end,
    },

    wrath16 = {
        nav = "Tier 16   Icecrown Citadel",
        title = "Tier 16 - Icecrown Citadel",
        short = "Frozen Halls and Icecrown endgame",
        icon = "Interface\\Icons\\Achievement_Boss_LichKing",
        minValue = 16,
        completeAt = 17,
        objective = "Defeat the Lich King in Icecrown Citadel.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Icecrown is the main Wrath endgame stage. The server keeps the Frozen Halls and Icecrown Citadel locked until Trial of the Crusader progression is complete.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat the Lich King in Icecrown Citadel to advance to Tier 17.", C.red),
                "",
                SH("FROZEN HALLS - DO THESE NOW"),
                Priority("UNLOCKED", "Forge of Souls opens at this tier and begins the Frozen Halls sequence.", C.green),
                Bullet("Complete Forge of Souls first, then continue through Pit of Saron and Halls of Reflection."),
                Bullet("These dungeons provide strong late-Wrath dungeon gear and story progression directly connected to Icecrown."),
                Bullet("Pit of Saron and Halls of Reflection are effectively reached through the Forge of Souls quest/access sequence, so do not try to treat them as independent shortcuts."),
                "",
                SH("ICECROWN CITADEL ACCESS"),
                Priority("NO CONVENTIONAL ATTUNEMENT", "ICC does not use a Vanilla/TBC-style attunement chain once Tier 16 has been reached.", C.green),
                Priority("SERVER GATE", "The raid itself is blocked until Anub'arak progression is complete.", C.orange),
                "",
                SH("ICC PROGRESSION"),
                Bullet("Work through the Lower Spire, Plagueworks, Crimson Hall and Frostwing Halls before the Frozen Throne."),
                Bullet("Normal progression should be stable before your group invests heavily in Heroic encounter progression."),
                Priority("IMPORTANT", "Keep Ashen Verdict reputation moving every raid. It provides the ICC reputation ring progression and important crafting access.", C.orange),
                "",
                SH("SHADOWMOURNE"),
                Priority("OPTIONAL LEGENDARY", "Eligible melee characters can begin the Shadowmourne questline during ICC progression.", C.purple),
                Bullet("This is a long raid-resource commitment; choose the recipient deliberately before rare quest materials are distributed."),
                "",
                SH("HEROICS / EMBLEMS"),
                Priority("TIER 16+", "Heroic dungeon bosses move to Emblems of Triumph once ICC is available on this server.", C.yellow),
                Bullet("This keeps older Heroics useful for gearing alts/off-specs, filling weak slots and buying emblem gear while ICC progresses."),
                "",
                SH("WINTERGRASP / VAULT"),
                Priority("NEW VAULT BOSS", "Toravon the Ice Watcher joins Vault of Archavon from the ICC stage onward.", C.purple),
                "",
                SH("WEEKLY RAID OBJECTIVES"),
                Bullet("The Dalaran raid-quest system changes as the expansion advances; use the active weekly raid objective as extra value alongside your normal raid schedule."),
                "",
                SH("NEXT TIER"),
                Priority("PROGRESSION", "Defeating the Lich King advances you to Tier 17 - Ruby Sanctum.", C.green),
            })
        end,
    },

    wrath17 = {
        nav = "Tier 17   Ruby Sanctum",
        title = "Tier 17 - Ruby Sanctum",
        short = "Final Wrath progression",
        icon = "Interface\\Icons\\Achievement_Boss_Halion",
        minValue = 17,
        completeAt = 18,
        objective = "Defeat Halion in Ruby Sanctum.",
        body = function()
            return Join({
                SH("STAGE OVERVIEW"),
                "Ruby Sanctum is the final Individual Progression milestone in Wrath. The server blocks the raid until the Lich King has been defeated.",
                "",
                SH("PRIMARY OBJECTIVE"),
                Priority("REQUIRED", "Defeat Halion to complete the Wrath progression journey.", C.red),
                "",
                SH("ATTUNEMENT / ACCESS"),
                Priority("NO CONVENTIONAL ATTUNEMENT", "Ruby Sanctum requires no separate attunement quest once this stage has been reached.", C.green),
                Priority("SERVER GATE", "The raid only becomes available after Lich King progression is complete.", C.orange),
                "",
                SH("HOW TO TREAT RUBY SANCTUM"),
                Bullet("Continue ICC alongside Ruby Sanctum; the two raids together contain the final gearing targets for Wrath."),
                Bullet("Learn Halion on normal difficulty first, then pursue Heroic difficulty if it is part of your raid goals."),
                Bullet("Do not abandon unfinished ICC upgrades, Ashen Verdict reputation or legendary progress simply because the final progression raid has opened."),
                "",
                SH("FINAL WRATH CLEANUP"),
                Priority("RECOMMENDED", "Before considering the character finished, review remaining hard modes, achievements, profession recipes, reputations, mounts and legendary goals you actually care about.", C.yellow),
                Bullet("Ulduar hard modes / Algalon, Trial of the Grand Crusader, ICC Heroic and Ruby Sanctum Heroic are optional mastery goals rather than progression gates."),
                "",
                SH("WRATH COMPLETE"),
                Priority("FINAL MILESTONE", "Defeating Halion advances the character to progression value 18 and completes the current Individual Progression journey.", C.green),
                Bullet("There is no later expansion stage in this 3.3.5 progression ruleset."),
            })
        end,
    },
}

local WOTLK_OVERVIEW_PAGE = {
    title = "Wrath of the Lich King Roadmap",
    short = "Level 70-80 progression, raid tiers and side systems",
    icon = "Interface\\Icons\\Spell_Frost_Frost",
    body = function()
        return Join({
            SH("ENTERING WRATH"),
            Priority("CHARACTER SERVICE", "After completing TBC, purchase the 7,500g TBC -> Wrath unlock from Chronomancer Vezrath if this character has not already done so.", C.orange),
            Bullet("Northrend is progression-protected and opens with the Wrath stage."),
            Bullet("Level cap: 80."),
            Bullet("Talent trees: the full 3.3.5 trees are available."),
            Bullet("Inscription is now available; all primary professions can progress to 450."),
            Bullet("Death Knights unlock at this era under the current server rules."),
            "",
            H("WRATH RAID ROADMAP"),
            C.blue .. "Tier 13" .. C.reset .. "     Naxxramas / Eye of Eternity / Obsidian Sanctum",
            Bullet("Progression boss: Kel'Thuzad."),
            Bullet("Heroics, faction tabards, Sons of Hodir and Wintergrasp are immediate level-80 priorities."),
            "",
            C.blue .. "Tier 14" .. C.reset .. "     Ulduar",
            Bullet("Progression boss: Yogg-Saron."),
            Bullet("Hard modes and Algalon are optional high-value mastery content."),
            "",
            C.blue .. "Tier 15" .. C.reset .. "     Trial of the Crusader",
            Bullet("Progression boss: Anub'arak."),
            Bullet("Trial of the Champion and the Argent Tournament era become active on this server at this stage."),
            "",
            C.blue .. "Tier 16" .. C.reset .. "     Icecrown Citadel",
            Bullet("Progression boss: the Lich King."),
            Bullet("Forge of Souls -> Pit of Saron -> Halls of Reflection opens as the Frozen Halls route."),
            "",
            C.blue .. "Tier 17" .. C.reset .. "     Ruby Sanctum",
            Bullet("Progression boss: Halion, the final progression milestone."),
            "",
            SH("SERVER CONTENT GATES"),
            Bullet("Ulduar waits for Kel'Thuzad."),
            Bullet("Trial of the Champion / Trial of the Crusader wait for Yogg-Saron."),
            Bullet("Forge of Souls / Icecrown Citadel wait for Anub'arak."),
            Bullet("Ruby Sanctum waits for the Lich King."),
            "",
            SH("WHAT TO PRIORITISE AT LEVEL 80"),
            Priority("1", "Finish strong dungeon gear and begin Heroics immediately.", C.yellow),
            Priority("2", "Choose the tabard reputation that gives your most useful head enchant/rewards and start Sons of Hodir for shoulder enchants.", C.yellow),
            Priority("3", "Finish profession skill, gems, enchants, consumables and crafted Pre-Raid upgrades.", C.yellow),
            Priority("4", "Begin Naxxramas while continuing Heroics, Wintergrasp and side raids rather than waiting for perfect Pre-Raid BiS.", C.yellow),
            "",
            SH("SUPPORT / SIDE CONTENT PAGES"),
            Bullet("Dungeons & Heroics - leveling route, level-80 Heroics and later dungeon unlocks."),
            Bullet("Emblems & Dalaran Quests - the server's restored emblem ladder and daily/weekly timing."),
            Bullet("Wrath Reputations - detailed faction priorities, enchants, recipes and rewards."),
            Bullet("Wrath Professions - 450 skill, profession bonuses, Inscription and raid crafting."),
            Bullet("Wrath PvP - Arena Season 5 and gearing options."),
            Bullet("Wintergrasp & Vault - outdoor PvP and the tier-by-tier Vault boss timeline."),
            Bullet("Argent Tournament - server-timed Tournament progression and rewards."),
        })
    end,
}

local WOTLK_DUNGEONS_PAGE = {
    title = "Wrath Dungeons & Heroics",
    short = "70-80 route, Heroic timing and later dungeon unlocks",
    icon = "Interface\\Icons\\INV_Misc_Key_15",
    body = function()
        return Join({
            SH("THE MAIN RULE"),
            "Wrath dungeons are your leveling backbone and the fastest bridge into opening raid gear. Unlike TBC, level-80 Heroics do not require faction keys, so begin them as soon as you reach 80 and your group can handle them.",
            "",
            SH("SUGGESTED NORMAL-DUNGEON ROUTE"),
            Bullet("70-72: Utgarde Keep and The Nexus."),
            Bullet("72-74: Azjol-Nerub and Ahn'kahet: The Old Kingdom."),
            Bullet("74-76: Drak'Tharon Keep."),
            Bullet("75-77: The Violet Hold."),
            Bullet("76-78: Gundrak."),
            Bullet("77-80: Halls of Stone and Utgarde Pinnacle."),
            Bullet("78-80: The Oculus and The Culling of Stratholme."),
            Bullet("79-80: Halls of Lightning."),
            Bullet("Exact order can change with quests and available groups; the important point is to keep dungeon quests and useful reputation rewards moving while leveling."),
            "",
            SH("LEVEL 80 - START HEROICS"),
            Priority("TIER 13 - CORE PRE-RAID CONTENT", "Begin Heroic dungeons immediately at 80 rather than waiting until after Naxxramas.", C.red),
            Bullet("Use Heroics for Pre-Raid gear, emblems, reputation through tabards and daily dungeon objectives."),
            Bullet("There are no TBC-style Revered Heroic keys to farm first."),
            Bullet("Your server has RDF enabled, so specific-dungeon queuing can be used where the core supports it."),
            "",
            SH("REPUTATION TABARDS"),
            Bullet("At Friendly, the four major dungeon factions can provide tabards used to direct reputation in eligible level-80 dungeons."),
            Bullet("Kirin Tor - usually the first focus for caster DPS who want its head enchant/rewards."),
            Bullet("Knights of the Ebon Blade - usually the first focus for physical DPS."),
            Bullet("Argent Crusade - usually the first focus for healers."),
            Bullet("Wyrmrest Accord - usually the first focus for tanks."),
            Bullet("See Wrath Reputations for the full explanation; choose by your character, not by a fixed universal order."),
            "",
            SH("HOW HEROICS AGE THROUGH THE TIERS"),
            Priority("TIER 13", "Major Pre-Raid gearing source. Heroic bosses award Emblems of Heroism.", C.orange),
            Priority("TIER 14", "Support Ulduar preparation, fill weak slots and farm upgraded Emblems of Valor.", C.yellow),
            Priority("TIER 15", "Catch-up / off-spec / emblem content. Heroic bosses move to Emblems of Conquest.", C.yellow),
            Priority("TIER 16+", "Older Heroics still pay Emblems of Triumph, while the Frozen Halls become the most important late-Wrath 5-player route.", C.yellow),
            "",
            SH("TRIAL OF THE CHAMPION - TIER 15"),
            Priority("SERVER-GATED", "Trial of the Champion is unavailable until Yogg-Saron has been defeated and Tier 15 begins.", C.orange),
            Bullet("Once open, run Normal/Heroic versions when their gear can replace weak slots or help prepare for Trial of the Crusader."),
            "",
            SH("FROZEN HALLS - TIER 16"),
            Priority("SERVER-GATED", "Forge of Souls does not open until Anub'arak has been defeated and Tier 16 begins.", C.orange),
            Bullet("Complete the story/access chain in order: Forge of Souls -> Pit of Saron -> Halls of Reflection."),
            Bullet("These are the strongest late-Wrath dungeon catch-up options and should be part of early ICC preparation."),
            "",
            SH("DAILY / WEEKLY VALUE"),
            Bullet("Early Wrath uses Dalaran daily Heroic objectives; the active quest system changes as later Wrath tiers arrive."),
            Bullet("Do the active dungeon or raid quest when the reward is worthwhile, but do not let a daily objective delay your current progression raid."),
        })
    end,
}

local WOTLK_EMBLEMS_PAGE = {
    title = "Wrath Emblems & Dalaran Quests",
    short = "Restored emblem progression and recurring objectives",
    icon = "Interface\\Icons\\INV_Misc_Coin_18",
    body = function()
        return Join({
            SH("WHY THIS PAGE MATTERS"),
            "The server restores Wrath's emblem progression instead of leaving the final 3.3.5 catch-up rewards active from day one. Older content changes emblem value as your Individual Progression tier advances.",
            "",
            H("HEROIC DUNGEON EMBLEM LADDER"),
            Priority("TIER 13", "Heroic bosses: Emblems of Heroism.", C.yellow),
            Priority("TIER 14", "Heroic bosses: Emblems of Valor.", C.yellow),
            Priority("TIER 15", "Heroic bosses: Emblems of Conquest.", C.yellow),
            Priority("TIER 16+", "Heroic bosses: Emblems of Triumph once Icecrown is available.", C.yellow),
            Bullet("This is why Heroics remain worth doing even after their original item drops stop being upgrades."),
            "",
            H("RAID EMBLEMS"),
            Bullet("Naxxramas begins with its opening raid emblem rewards and is adjusted again as later tiers arrive."),
            Bullet("Ulduar introduces the next raid-tier emblem rewards and older raid drops are adjusted through the progression system."),
            Bullet("Trial and Icecrown-era raids continue the ladder rather than exposing final-patch catch-up rewards early."),
            Bullet("Use the current-tier vendors as part of your gearing plan, but spend emblems on meaningful upgrades rather than automatically buying the first item you can afford."),
            "",
            SH("ARCHMAGE TIMEAR - EARLY WRATH"),
            Priority("TIER 13-14", "Archmage Timear's Proof of Demise daily Heroic quests are part of the early Wrath experience before the later raid-quest system takes over.", C.blue),
            Bullet("These quests target specific Heroic end bosses, so combine them with the dungeons you already need for gear or reputation whenever possible."),
            "",
            SH("LATER DALARAN RAID QUESTS"),
            Priority("TIER 15+", "The Dalaran recurring raid-quest system changes as the expansion reaches later phases, including weekly raid targets.", C.blue),
            Bullet("Treat the active recurring quest as bonus value alongside your raid schedule, not as a replacement for progressing your current tier."),
            "",
            SH("SPENDING PRIORITY"),
            Bullet("Tier 13: use emblems to close major Pre-Raid gaps and build a stable Naxx set."),
            Bullet("Tier 14: target upgrades that help Ulduar progression or complete strong set bonuses."),
            Bullet("Tier 15: use the upgraded Heroic emblem tier to support ToC/ToGC progression and off-spec needs."),
            Bullet("Tier 16+: Triumph from Heroics is excellent for late catch-up, but ICC/Ruby Sanctum remain the source of your final progression gear."),
        })
    end,
}

local WOTLK_REPUTATIONS_PAGE = {
    title = "Wrath Reputations",
    short = "When to farm them, how to gain rep, and what they give you",
    icon = "Interface\\Icons\\INV_Misc_Note_02",
    body = function()
        return Join({
            SH("HOW TO USE THIS PAGE"),
            "Wrath reputations are easier to integrate into normal play than TBC Heroic-key reputations. Four major factions use dungeon tabards, Sons of Hodir is your main shoulder-enchant reputation, and later raid/tournament reputations become relevant only when their content opens.",
            "",
            Priority("LEVEL 80 PRIORITY", "Choose the faction that provides your most useful head enchant and wear its tabard while doing eligible level-80 dungeons. Work on Sons of Hodir in parallel if you need their shoulder enchants.", C.red),
            "",

            H("SONS OF HODIR - STORM PEAKS"),
            Priority("VERY HIGH PRIORITY - SHOULDER ENCHANTS", "Begin during late leveling / early Tier 13, especially for non-Scribes.", C.red),
            Bullet("Why it matters: Sons of Hodir provides the main Wrath reputation shoulder enchants. Honored unlocks lesser versions and Exalted unlocks the strongest versions."),
            Bullet("How to unlock it: complete the Storm Peaks/K3 quest route that eventually introduces the Sons of Hodir and repairs your standing with them."),
            Bullet("How to gain rep: continue their daily quests, turn in Relics of Ulduar and use Everfrost Chip turn-ins when available."),
            Bullet("What you gain: shoulder enchants for physical DPS, spell users/healers and tanks, plus profession recipes, gear and mammoth rewards."),
            Bullet("Who can deprioritise it: Inscription has profession-exclusive shoulder enchants, so Scribes are less dependent on Hodir for raid performance, though the faction still has completion/reward value."),
            "",

            H("KIRIN TOR - DALARAN / NORTHREND"),
            Priority("CASTER DPS HEAD ENCHANT / RECIPES", "Start naturally while leveling and finish at 80 with the Kirin Tor tabard if its rewards suit your class.", C.orange),
            Bullet("How to gain rep: Northrend quests involving the Kirin Tor, then dungeon championing with their tabard once available."),
            Bullet("Why it matters: Revered provides the major caster-focused head enchant; the faction also offers gear and profession recipes."),
            Bullet("Best for: caster DPS first, then anyone who wants a Kirin Tor recipe or vendor reward."),
            Bullet("Do not force Exalted immediately unless an Exalted reward matters to your character; Revered is often the practical combat milestone."),
            "",

            H("KNIGHTS OF THE EBON BLADE - ZUL'DRAK / ICECROWN"),
            Priority("PHYSICAL DPS HEAD ENCHANT", "High priority for melee and physical ranged DPS at level 80.", C.orange),
            Bullet("How to unlock it: progress the Ebon Blade questlines and establish the Shadow Vault in Icecrown so the quartermaster becomes usable."),
            Bullet("How to gain rep: quest through their hubs, then use the Ebon Blade tabard in eligible level-80 dungeons."),
            Bullet("What you gain: the major physical-DPS head enchant at Revered, gear and several profession recipes."),
            Bullet("Why to start early: unlocking Shadow Vault takes quest progress, so do not wait until raid night to discover you cannot reach the quartermaster."),
            "",

            H("ARGENT CRUSADE - ZUL'DRAK / ICECROWN"),
            Priority("HEALER HEAD ENCHANT / ENDGAME HUBS", "High priority for healers; useful supporting reputation for everyone else.", C.orange),
            Bullet("How to gain rep: quest through Argent Crusade story hubs, then champion them with the Argent Crusade tabard in eligible level-80 dungeons."),
            Bullet("What you gain: the healer-focused head enchant at Revered, gear and profession recipes."),
            Bullet("Why it remains relevant: the Crusade is tied heavily to Icecrown and later Argent Tournament content, so the reputation fits naturally into the Wrath story route."),
            "",

            H("THE WYRMREST ACCORD - DRAGONBLIGHT"),
            Priority("TANK HEAD ENCHANT / RED DRAKE", "High priority for tanks; optional-to-useful for other roles.", C.orange),
            Bullet("How to gain rep: Dragonblight quests and Wyrmrest dailies, then the Wyrmrest Accord tabard in eligible level-80 dungeons."),
            Bullet("What you gain: the major tanking head enchant at Revered, gear and profession rewards."),
            Bullet("Exalted reward: the Red Drake is a major faction mount goal."),
            Bullet("Practical target: tanks normally want Revered quickly; other roles can stop earlier unless a recipe, item or mount is desired."),
            "",

            H("HORDE EXPEDITION / ALLIANCE VANGUARD"),
            Priority("LEVELING / FACTION REWARDS", "Build this mostly through normal Northrend questing and faction sub-groups rather than a standard dungeon tabard grind.", C.yellow),
            Bullet("Why it matters: this umbrella reputation tracks your faction's wider Northrend war effort and unlocks useful vendor rewards as you advance."),
            Bullet("Profession value: Engineers pursuing the faction motorcycle mount schematic should pay particular attention to the appropriate faction vendor at high reputation."),
            Bullet("Recommended approach: let most of it rise naturally while leveling, then deliberately finish it only when a specific reward matters."),
            "",

            H("THE KALU'AK - COASTAL NORTHREND"),
            Priority("OPTIONAL - QUALITY OF LIFE / COLLECTION", "Work on it while leveling if you enjoy the questlines; finish later through its dailies if the rewards appeal to you.", C.purple),
            Bullet("How to gain rep: Kalu'ak quest hubs across Howling Fjord, Dragonblight and Borean Tundra plus their repeatable daily quests."),
            Bullet("What you gain: useful leveling/endgame items, a strong fishing pole at high reputation and collection rewards."),
            Bullet("Progression value: not required for raids, so do not delay Tier 13 just to reach Exalted."),
            "",

            H("THE ORACLES / FRENZYHEART TRIBE - SHOLAZAR BASIN"),
            Priority("OPTIONAL CHOICE", "Choose a side through the Sholazar questline, then use its dailies for faction-specific rewards.", C.purple),
            Bullet("The choice occurs after the Artruis the Heartless storyline and can later be changed if you want to pursue the other faction."),
            Bullet("The Oracles are famous for the Mysterious Egg reward path, which can produce pets and a rare mount."),
            Bullet("Frenzyheart provides its own consumables, trinket/toy-style rewards and collection goals."),
            Bullet("Neither faction is a raid requirement; treat them as a daily/collection project."),
            "",

            H("THE ASHEN VERDICT - ICECROWN CITADEL"),
            Priority("TIER 16 - VERY HIGH RAID VALUE", "Begin automatically as soon as ICC opens and keep it moving every raid.", C.red),
            Bullet("How to gain rep: kill enemies and bosses inside Icecrown Citadel."),
            Bullet("Why it matters: reputation upgrades the powerful Ashen Verdict ring through multiple stages."),
            Bullet("Profession value: later reputation levels also unlock important ICC-era crafting patterns and recipes."),
            Bullet("Do not treat this as a separate outdoor grind; it progresses naturally while you raid ICC."),
            "",

            H("THE SUNREAVERS / SILVER COVENANT - ARGENT TOURNAMENT"),
            Priority("TIER 15 SIDE CONTENT", "Relevant once the Argent Tournament stage opens on this server.", C.purple),
            Bullet("How to gain value: Tournament dailies and Champion progression tie into faction-city and Tournament rewards."),
            Bullet("What you gain: access to themed mounts, pets, tabards, titles and other Tournament purchases alongside Champion's Seals."),
            Bullet("Progression value: optional; do it because you want the Tournament rewards, not because Anub'arak requires it."),
            "",

            SH("REPUTATION PRIORITY BY STAGE"),
            Priority("LEVEL 70-79", "Let Kirin Tor, Wyrmrest, Argent Crusade and Ebon Blade rise naturally through questing. Unlock Sons of Hodir before or around level 80.", C.yellow),
            Priority("TIER 13", "Push the class-relevant head-enchant faction to Revered and build Sons of Hodir toward the shoulder enchant you need.", C.orange),
            Priority("TIER 14", "Finish remaining raid-performance enchants; optional factions can now be worked on between Ulduar raids."),
            Priority("TIER 15", "Argent Tournament factions become worthwhile side progression."),
            Priority("TIER 16", "Ashen Verdict becomes the new raid-reputation priority while ICC is current."),
            Priority("TIER 17", "Finish only the reputations whose final recipes, mounts, achievements or collection rewards you still want."),
        })
    end,
}

local WOTLK_PROFESSIONS_PAGE = {
    title = "Wrath Professions",
    short = "450 skill, profession bonuses and raid crafting",
    icon = "Interface\\Icons\\INV_Misc_EngGizmos_27",
    body = function()
        return Join({
            SH("WRATH PROFESSION GOAL"),
            "Raise your chosen professions toward 450 while leveling, then use their character bonuses, crafted gear and endgame recipes as part of progression rather than leaving them until after you are raid-geared.",
            "",
            Priority("NEW IN WRATH", "Inscription is now available. Its trainers and related NPCs are no longer phased out.", C.blue),
            "",
            H("ALCHEMY"),
            Bullet("Core value: flasks, elixirs, potions, transmutation and raid consumables."),
            Bullet("Character value: Mixology improves the effect/duration of flasks and elixirs you can make; Flask of the North provides a reusable profession option."),
            Bullet("Progression use: excellent self-sufficiency and raid-supply profession from Tier 13 onward."),
            "",
            H("BLACKSMITHING"),
            Bullet("Core value: crafted plate/weapons, belt buckles and endgame raid patterns."),
            Bullet("Character value: extra profession-only sockets on bracers and gloves let you add more gems."),
            Bullet("Progression use: strong for characters who value flexible extra stats and for supplying crafted raid pieces."),
            "",
            H("ENCHANTING"),
            Bullet("Core value: disenchant unwanted gear and provide the enchantments every progression set needs."),
            Bullet("Character value: profession-only ring enchants give the Enchanter additional personal stats."),
            Bullet("Progression use: especially useful when Heroics/raids generate large amounts of unwanted gear that can become enchanting materials."),
            "",
            H("ENGINEERING"),
            Bullet("Core value: explosives, utility devices, ammunition-related crafting and powerful glove/boot/head utility options."),
            Bullet("Character value: Engineering tinkers provide unique combat and movement tools that remain useful throughout Wrath."),
            Bullet("Progression use: one of the strongest utility professions for raiding and PvP, but it requires regular material investment."),
            "",
            H("INSCRIPTION"),
            Priority("NEW PROFESSION", "Creates glyphs, vellums, off-hands, Darkmoon cards and profession shoulder enchants.", C.blue),
            Bullet("Character value: Scribes use powerful profession-exclusive shoulder inscriptions, reducing their dependence on Sons of Hodir for raid-performance shoulder enchants."),
            Bullet("Progression use: glyph supply is immediately relevant to every class, while research/discovery and Darkmoon crafting give long-term goals."),
            "",
            H("JEWELCRAFTING"),
            Bullet("Core value: cut Northrend gems, rings/necks and other socket-related crafting."),
            Bullet("Character value: Dragon's Eye profession gems allow stronger personal gem choices within the profession limits."),
            Bullet("Progression use: extremely useful because every new raid tier produces gear that needs fresh gems."),
            "",
            H("LEATHERWORKING"),
            Bullet("Core value: leather/mail crafted gear, armor kits and raid patterns."),
            Bullet("Character value: Fur Lining bracer enchants provide strong profession-only stat bonuses."),
            Bullet("Progression use: useful for gearing leather/mail classes and supporting raid crafting."),
            "",
            H("TAILORING"),
            Bullet("Core value: cloth armor, bags, spellthreads and raid crafting."),
            Bullet("Character value: cloak embroideries provide unique proc-based profession bonuses."),
            Bullet("Progression use: particularly natural for cloth wearers, but bags and crafted cloth remain useful to the whole account."),
            "",
            H("GATHERING PROFESSIONS"),
            Bullet("Herbalism - Lifeblood provides a personal heal and gathering supplies Alchemy/Inscription."),
            Bullet("Mining - Toughness provides additional stamina and feeds Blacksmithing/Engineering/Jewelcrafting."),
            Bullet("Skinning - Master of Anatomy provides critical strike rating and supplies Leatherworking."),
            "",
            SH("SECONDARY PROFESSIONS"),
            Bullet("Cooking: use Dalaran cooking dailies and Northern Spices to unlock important feast/food recipes for raid preparation."),
            Bullet("Fishing: Dalaran fishing dailies, fish-based raid food and collection rewards make 450 Fishing worthwhile even when it is not a raid requirement."),
            Bullet("First Aid: keep bandages current for classes that can benefit from emergency self-healing."),
            "",
            SH("WHEN TO WORK ON PROFESSIONS"),
            Priority("70-79", "Gather Northrend materials while leveling and train new recipe ranks instead of waiting until 80.", C.yellow),
            Priority("TIER 13", "Reach useful endgame skill, secure your profession bonus and craft any real Pre-Raid upgrades.", C.orange),
            Priority("TIER 14-15", "Watch new raid recipes and crafted-item materials; keep valuable research/daily systems moving."),
            Priority("TIER 16", "Ashen Verdict / ICC crafting becomes especially important for endgame patterns and high-level crafted pieces."),
            Priority("TIER 17", "Finish rare recipes and collection goals that still matter to the character."),
        })
    end,
}

local WOTLK_PVP_PAGE = {
    title = "Wrath PvP",
    short = "Arena Season 5, battlegrounds and gearing",
    icon = "Interface\\Icons\\Achievement_Arena_2v2_7",
    body = function()
        return Join({
            SH("ACTIVE ARENA SEASON"),
            Priority("SERVER SETTING", "Wrath Arena Season 5 is active for this progression journey.", C.blue),
            Bullet("Season-specific PvP vendors are phased around the configured Wrath season rather than exposing every final-patch PvP set together."),
            "",
            SH("WHEN TO START"),
            Priority("TIER 13", "Begin level-80 battlegrounds, Wintergrasp and Arena whenever PvP rewards are useful for your character.", C.orange),
            Bullet("PvP gearing can fill weak slots while Heroics and opening raids are still being farmed."),
            Bullet("Resilience gear is primarily PvP equipment; compare it carefully before replacing stronger PvE items for raid performance."),
            "",
            SH("WINTERGRASP"),
            Bullet("Wintergrasp is the major new outdoor PvP system and is available once Wrath progression begins."),
            Bullet("It supplies honor, Wintergrasp-specific currencies/rewards and access to Vault of Archavon while your faction controls the fortress."),
            Bullet("See the dedicated Wintergrasp & Vault page for the boss unlock timeline."),
            "",
            SH("VANILLA TITLES"),
            Bullet("Previously earned Vanilla PvP titles remain on the character."),
            Priority("REMINDER", "New Vanilla rank titles can no longer be earned once the character has left Vanilla progression.", C.orange),
            "",
            SH("PRIORITY"),
            Bullet("PvP is optional for Individual Progression. Do it for Arena/Battleground progression, PvP gear, achievements and enjoyment rather than because a raid tier requires it."),
        })
    end,
}

local WINTERGRASP_PAGE = {
    title = "Wintergrasp & Vault of Archavon",
    short = "Outdoor PvP and tier-phased Vault bosses",
    icon = "Interface\\Icons\\Achievement_Wintergrasp_01",
    body = function()
        return Join({
            SH("WHEN IT OPENS"),
            Priority("TIER 13", "Wintergrasp becomes available when Wrath progression begins.", C.green),
            Bullet("The Wintergrasp queue NPCs are progression-aware and only appear once the character has reached the Wrath era."),
            "",
            SH("WHY DO WINTERGRASP"),
            Bullet("Participate for honor, Wintergrasp quests and currencies/rewards tied to the zone."),
            Bullet("Controlling Wintergrasp gives your faction access to Vault of Archavon."),
            Bullet("Wintergrasp vendors provide PvP-oriented gear and useful side rewards as your currency builds."),
            "",
            H("VAULT OF ARCHAVON BOSS TIMELINE"),
            Priority("TIER 13", "Archavon the Stone Watcher - opening Wrath Vault boss.", C.purple),
            Priority("TIER 14", "Emalon the Storm Watcher joins during Ulduar progression.", C.purple),
            Priority("TIER 15", "Koralon the Flame Watcher joins during Trial of the Crusader progression.", C.purple),
            Priority("TIER 16+", "Toravon the Ice Watcher joins once Icecrown progression begins.", C.purple),
            "",
            SH("WHEN TO RUN VAULT"),
            Bullet("Run the currently relevant Vault bosses while their tier/PvP drops can still improve your character."),
            Bullet("Vault is optional and does not advance Individual Progression, so your required progression raid remains the higher priority when raid time is limited."),
            Bullet("Because boss availability expands with your stage, revisit Vault after each major Wrath progression milestone rather than treating it as a one-time raid."),
        })
    end,
}

local ARGENT_TOURNAMENT_PAGE = {
    title = "Argent Tournament",
    short = "Tier 15 side progression, dailies and rewards",
    icon = "Interface\\Icons\\Achievement_Zone_Icecrown_01",
    body = function()
        return Join({
            SH("SERVER TIMING"),
            Priority("TIER 15", "The Tournament area/content is progression-phased to the Trial of the Crusader era on this server. Treat it as side progression after Yogg-Saron, not as an opening-Wrath grind.", C.orange),
            "",
            SH("TOURNAMENT PROGRESSION"),
            Bullet("Begin the Tournament introduction and learn the jousting mechanics."),
            Bullet("Progress through Aspirant -> Valiant -> Champion for your faction-city representatives."),
            Bullet("Continue Champion dailies to earn Champion's Seals and unlock more faction rewards."),
            "",
            SH("WHAT YOU GAIN"),
            Bullet("Faction-themed mounts and pets."),
            Bullet("Tabards, titles, achievements and collection rewards."),
            Bullet("Gear and other purchases bought with Champion's Seals."),
            Bullet("Extra city-faction reputation while completing Valiant/Champion goals."),
            "",
            SH("SUNREAVERS / SILVER COVENANT"),
            Bullet("Horde characters interact with the Sunreavers; Alliance characters interact with the Silver Covenant as part of the Tournament-era content."),
            Bullet("Their rewards are side progression rather than a raid attunement requirement."),
            "",
            SH("THE BLACK KNIGHT / TRIAL OF THE CHAMPION"),
            Priority("RECOMMENDED", "Complete the Black Knight questline while working through the Tournament. It provides story context for the 5-player Trial of the Champion.", C.yellow),
            Bullet("Trial of the Champion itself is also server-gated to Tier 15 and can be used for quick level-80 gear upgrades."),
            "",
            SH("PRIORITY RULE"),
            Bullet("Do not delay Trial of the Crusader progression just to finish every Tournament mount or city Champion track."),
            Bullet("Use the Tournament as a repeatable daily/collection project alongside Tier 15 raiding."),
        })
    end,
}

local GENERAL_PAGE = {
    title = "General Information",
    short = "Server rules, phasing, professions & travel",
    icon = "Interface\\Icons\\INV_Misc_Map_01",
    body = function()
        return Join({
            SH("WORLD & CONTENT PHASING"),
            "Some NPCs, profession systems and convenience travel points are intentionally phased so they appear at the appropriate point in the progression journey. If something listed here is missing, it is normally progression phasing rather than a bug.",
            "",
            SH("PHASED PROFESSIONS"),
            Priority("THE BURNING CRUSADE", "Jewelcrafting is unavailable during Vanilla. Its trainers, vendors and related NPCs are phased until The Burning Crusade becomes available.", C.green),
            Priority("WRATH OF THE LICH KING", "Inscription is unavailable during Vanilla and The Burning Crusade. Its trainers, vendors and related NPCs are phased until Wrath of the Lich King.", C.blue),
            "",
            SH("PHASED FLIGHT PATHS"),
            "Several later-added flight masters are intentionally unavailable during earlier Vanilla progression:",
            Bullet("Ratchet"),
            Bullet("Marshal's Refuge"),
            Bullet("Emerald Sanctuary"),
            Bullet("The Bulwark"),
            Bullet("Thondroril River"),
            Priority("BY TIER 6", "All five flight paths are unphased and available by the Naxxramas stage. Some may become available earlier as the Vanilla journey advances.", C.green),
            "",
            SH("GROUP PROGRESSION RULE"),
            Priority("IMPORTANT", "Characters may only group with others in the same progression phase.", C.orange),
            Bullet("If two characters cannot group normally, compare their Individual Progression stage before assuming the group system is broken."),
            "",
            SH("QUESTING"),
            Bullet("Quest-object markers and sparkles are disabled. Read quest text and objective descriptions carefully."),
            Bullet("Vanilla and TBC quest XP uses restored pre-catch-up values."),
            "",
            SH("REPUTATION GUIDANCE"),
            Bullet("Vanilla faction progression now has its own detailed guide under Vanilla Side Content. Use that page for Hydraxian Waterlords, Thorium Brotherhood, Argent Dawn, Zandalar Tribe, Cenarion Circle, Brood of Nozdormu and Timbermaw Hold."),
            "",
            SH("EARLY CONTENT OPTIONS"),
            Priority("AVAILABLE EARLY", "Dungeon Set 2 progression is enabled early, so the upgrade chain can be worked on before its normal later-Vanilla window.", C.yellow),
            Priority("AVAILABLE EARLY", "The six Scourge Invasion dungeon bosses are enabled early rather than being restricted only to the Naxxramas stage.", C.yellow),
            "",
            SH("EXPANSION-ERA CHARACTER OPTIONS"),
            Bullet("Blood Elves and Draenei unlock after Vanilla progression is completed and begin at the start of The Burning Crusade progression."),
            Bullet("Death Knights remain tied to completion of The Burning Crusade progression before Wrath-era play."),
        })
    end,
}

local TALENT_RULES_PAGE = {
    title = "Talent Rules",
    short = "Expansion-based 3.3.5 talent restrictions",
    icon = "Interface\\Icons\\INV_Misc_Book_07",
    body = function()
        return Join({
            SH("HOW TALENTS WORK"),
            "The server uses the Wrath of the Lich King 3.3.5 talent trees, but lower parts of each tree are blocked until the appropriate expansion.",
            "",
            SH("VANILLA / CLASSIC - LEVEL 1 TO 60"),
            Priority("ALLOWED", "Rows 1 through 6 are fully available.", C.green),
            Priority("ROW 7", "Only the middle talent is available. The left and right talents are blocked.", C.yellow),
            Priority("BLOCKED", "Rows 8 through 11 are unavailable.", C.red),
            Bullet("The middle Row 7 talent represents the old Vanilla-style 31-point talent."),
            "",
            SH("THE BURNING CRUSADE - LEVEL 61 TO 70"),
            Priority("ALLOWED", "Rows 1 through 8 are fully available.", C.green),
            Priority("ROW 9", "Only the middle talent is available. The left and right talents are blocked.", C.yellow),
            Priority("BLOCKED", "Rows 10 and 11 are unavailable.", C.red),
            Bullet("The middle Row 9 talent represents the old TBC-style 41-point talent."),
            "",
            SH("WRATH OF THE LICH KING - LEVEL 71 TO 80"),
            Priority("FULL TREE", "Rows 1 through 11 are available normally.", C.blue),
            "",
            SH("IMPORTANT"),
            Bullet("These restrictions apply separately to every talent tree."),
            Bullet("You may still split talent points between multiple trees."),
            Bullet("The restriction is based on the talent's position in the tree, not its name or whether it exists in the 3.3.5 calculator."),
        })
    end,
}

local REPUTATIONS_PAGE = {
    title = "Vanilla Reputations",
    short = "When to farm them, how to earn them, and what they give you",
    icon = "Interface\\Icons\\INV_Misc_Note_02",
    body = function()
        return Join({
            SH("HOW TO USE THIS PAGE"),
            "Vanilla reputations are not all equally urgent. Some directly support raid access or raid mechanics, while others are mainly valuable for profession recipes, enchants, gear or completion goals.",
            "",
            Priority("DO FIRST", "Prioritise Hydraxian Waterlords for Molten Core and begin Argent Dawn early enough that Naxxramas attunement never becomes a last-minute wall.", C.red),
            Bullet("Farm a reputation harder when its next reward actually helps your class, professions, raid role or current progression tier."),
            Bullet("Several reputations rise naturally from raids. Do not delay progression just to reach Exalted before the content that actually awards the reputation is available."),
            "",

            H("HYDRAXIAN WATERLORDS - AZSHARA / MOLTEN CORE"),
            Priority("TIER 0 - ESSENTIAL RAID SUPPORT", "Start immediately while preparing for and clearing Molten Core.", C.red),
            Bullet("Why it matters: your server uses manual Molten Core rune dousing. The Hydraxian quest line gives access to the Quintessence items needed to extinguish the runes and reach Majordomo Executus and Ragnaros."),
            Bullet("How to work on it: begin Duke Hydraxis' quests in Azshara, kill the required elemental enemies, then continue the chain into Molten Core. Molten Core bosses continue to award reputation as you raid."),
            Bullet("Important quest step: complete Hands of the Enemy by bringing Duke Hydraxis the hands from Lucifron, Gehennas, Shazzrah and Sulfuron Harbinger. This leads into your reusable access to Aqual Quintessence pickups."),
            Bullet("Aqual Quintessence: one-use dousing item. After using it you must obtain another from Duke Hydraxis before the next use."),
            Bullet("Revered reward: Eternal Quintessence gives you a permanent dousing item rather than consuming the item each time."),
            Bullet("Server rule: Eternal Quintessence keeps its normal 1-hour cooldown, so having several raid members able to douse is still useful."),
            Bullet("What you gain: the reputation is mainly about Molten Core access/mechanics rather than a huge gear vendor. Treat Revered as a very useful quality-of-life milestone for a regular MC raider."),
            "",

            H("THORIUM BROTHERHOOD - SEARING GORGE / BLACKROCK DEPTHS"),
            Priority("EARLY VANILLA - HIGH VALUE FOR CRAFTERS", "Start when Blackrock Mountain content becomes part of your level-60 route.", C.orange),
            Bullet("Why it matters: this is one of Vanilla's strongest profession reputations. Its vendor contains specialist fire-themed, Dark Iron and Molten Core-era recipes that can be valuable to both an individual character and the guild's raid crafting network."),
            Bullet("How to begin: Thorium Point quests and material turn-ins in Searing Gorge move you through the early reputation levels."),
            Bullet("Friendly to Honored: Dark Iron Residue from Blackrock Depths is the practical reputation route through Gaining Acceptance."),
            Bullet("Honored onward: Lokhtos Darkbargainer in the Grim Guzzler accepts high-end materials such as Dark Iron Ore, Fiery Cores, Lava Cores, Core Leather and Blood of the Mountain."),
            Bullet("What you gain: progressively stronger Blacksmithing, Leatherworking, Tailoring, Alchemy and Enchanting recipes. Examples include Dark Iron / Flarecore / Molten crafting and powerful weapon-enchant formulas."),
            Bullet("Who should push it: Blacksmiths, Leatherworkers, Tailors, Enchanters and guild-designated crafters should check every reputation breakpoint. A character with no useful recipe target can treat it as recommended rather than mandatory."),
            Bullet("Best timing: work on Friendly/Honored while BRD is still relevant, then use surplus Molten Core materials later instead of buying an expensive Exalted grind immediately."),
            "",

            H("ARGENT DAWN - PLAGUELANDS / SCHOLOMANCE / STRATHOLME"),
            Priority("START EARLY - IMPORTANT", "Begin during normal level-60 dungeon gearing and keep it moving toward Naxxramas.", C.red),
            Bullet("Why it matters: at least Honored is required for The Dread Citadel - Naxxramas attunement. Higher reputation makes that attunement substantially cheaper, and Exalted removes the material/gold cost."),
            Bullet("How to work on it: complete Argent Dawn quests in the Plaguelands, run Scholomance and Stratholme, and use the Argent Dawn Commission / Scourgestone turn-in system while farming undead content."),
            Bullet("Best approach: wear/work on the reputation while you are already farming dungeon gear, recipes, Righteous Orbs and other level-60 materials. That turns the grind into parallel progression instead of a Tier 6 emergency."),
            Bullet("What you gain: profession recipes, useful consumable/vendor rewards and resistance-focused shoulder enchants at the higher reputation levels."),
            Bullet("Profession value: the quartermasters include recipes for Alchemy, Blacksmithing, Leatherworking, Tailoring, First Aid and other useful crafts depending on reputation."),
            Bullet("Raid value: Revered and Exalted are not strictly required to enter Naxxramas, but they reduce or remove the attunement cost. Check the Naxxramas tab for the exact attunement requirements."),
            Bullet("Recommended target: reach Honored well before Tier 6. Continue toward Revered/Exalted if the cheaper attunement, recipes or resistance enchants are valuable to your character."),
            "",

            H("ZANDALAR TRIBE - ZUL'GURUB"),
            Priority("TIER 3 - IMPORTANT / HIGH VALUE", "Begin when Zul'Gurub unlocks after Blackwing Lair.", C.orange),
            Bullet("Why it matters: Zandalar reputation turns repeated Zul'Gurub clears into a long reward track containing enchants, profession recipes, consumables and class-related rewards."),
            Bullet("How to earn it: kill Zul'Gurub trash and bosses, collect Bijous and the different ZG coin sets, and use the repeatable turn-ins on Yojamba Isle."),
            Bullet("Efficiency: Bijous can be destroyed at the Altar of Zanza for reputation and Zandalar Honor Tokens; coin sets can also be turned in repeatedly. This lets raid drops continue your reputation outside the boss kills themselves."),
            Bullet("Friendly value: class-specific head/leg enchant progression becomes available and several profession recipes begin to appear."),
            Bullet("Revered value: Zanza consumables become one of the more distinctive ZG reputation rewards and can be useful for raid preparation."),
            Bullet("Exalted value: powerful Zandalar shoulder enchants become available, using Zandalar Honor Tokens."),
            Bullet("Profession value: Bloodvine and other ZG-era Tailoring, Leatherworking, Blacksmithing, Alchemy and Engineering recipes make this especially worthwhile for crafters."),
            Bullet("Best timing: simply keep clearing ZG while it is useful for gear. Push extra Bijou/coin turn-ins when you are close to a reward breakpoint you actually need."),
            "",

            H("CENARION CIRCLE - SILITHUS / AQ"),
            Priority("TIER 3-5 - IMPORTANT", "Begin serious work during Pre-AQ and continue through the Ahn'Qiraj stages.", C.orange),
            Bullet("Why it matters: Cenarion Circle ties together Silithus endgame quests, Twilight Cultist content, Nature Resistance preparation, profession recipes and Ahn'Qiraj reward systems."),
            Bullet("How to earn it: Silithus quests, Twilight Cultist kills and turn-ins, summoned Templar/Duke/Royal encounters, Field Duty-style activities when available, and later AQ20/AQ40 content all contribute."),
            Bullet("Nature Resistance value: the faction sells several important Nature Resistance crafting patterns and enchants. These are particularly relevant while preparing for AQ encounters where resistance sets may be useful."),
            Bullet("Profession value: Blacksmithing, Enchanting, Leatherworking and Tailoring all gain useful AQ-era recipes at different reputation levels."),
            Bullet("Gear value: Cenarion Circle quests and badge systems can produce strong endgame items in addition to the profession recipes, so check rewards as your reputation rises rather than treating it only as a bar to fill."),
            Bullet("Best timing: start during Pre-AQ, then let AQ20/AQ40 and Silithus activity continue the grind. There is little reason to force Exalted before the content that naturally awards the reputation is part of your progression."),
            "",

            H("BROOD OF NOZDORMU - AQ40"),
            Priority("TIER 5 - RAID REPUTATION", "Treat this as part of Temple of Ahn'Qiraj progression, not a prerequisite before entering AQ40.", C.orange),
            Bullet("Why it matters: Brood reputation directly powers major AQ40 rewards, especially the Signet Ring of the Bronze Dragonflight upgrade path and Tier 2.5 armor quests."),
            Bullet("Starting point: characters begin deeply Hated. AQ40 trash is designed to pull that reputation upward rapidly until you approach Neutral."),
            Bullet("How to earn it: AQ40 trash, bosses, Qiraji Lord's Insignias and Ancient Qiraji Artifacts are the main sources. AQ-related outdoor/event content can also contribute depending on the stage."),
            Bullet("Efficiency tip: ordinary AQ40 trash stops giving reputation at Neutral 2999/3000. Save Qiraji Lord's Insignias and Ancient Qiraji Artifacts until the trash reputation has done as much work as possible, then use turn-ins to continue."),
            Bullet("Ring rewards: at Neutral you can choose a Bronze Dragonflight ring path suited to your role; it is upgraded again at Friendly, Honored, Revered and Exalted."),
            Bullet("Tier 2.5 rewards: AQ40 class-set quests use Brood reputation gates - shoulders/boots begin at Neutral, helm/legs at Friendly and chest at Honored."),
            Bullet("Best timing: clear AQ40 normally and let the reputation rise with raid progression. Push saved turn-ins when they unlock your next ring or Tier 2.5 breakpoint."),
            "",

            H("TIMBERMAW HOLD - FELWOOD / WINTERSPRING"),
            Priority("OPTIONAL - PROFESSION / COMPLETION VALUE", "Work on this when its recipes or rewards are useful rather than because the raid path requires it.", C.purple),
            Bullet("Why it matters: Timbermaw is primarily a profession and completion reputation. It also makes travel through Timbermaw Hold safer once the furbolgs stop being hostile to you."),
            Bullet("How to earn it: kill Deadwood furbolgs in Felwood and Winterfall furbolgs in Winterspring, then use repeatable Deadwood Headdress Feather and Winterfall Spirit Bead turn-ins."),
            Bullet("Friendly rewards: useful recipes such as Transmute Earth to Water, 2H Weapon - Agility and Warbear Leatherworking patterns become available."),
            Bullet("Honored/Revered rewards: more Enchanting, Tailoring, Leatherworking and Blacksmithing recipes open, including weapon Agility and several Timbermaw-themed crafted pieces."),
            Bullet("Exalted reward: Defender of the Timbermaw provides a unique summon trinket and marks completion of the faction."),
            Bullet("Best timing: farm it alongside Felwood/Winterspring objectives, materials or profession goals. Do not delay a raid attunement or current-tier upgrade just to finish Timbermaw."),
            "",

            SH("SIMPLE PRIORITY BY STAGE"),
            Priority("TIER 0", "Hydraxian Waterlords is the immediate raid-mechanics priority. Start Argent Dawn in parallel and work Thorium Brotherhood if its profession recipes matter.", C.red),
            Priority("TIER 1-2", "Continue Argent Dawn whenever Scholomance/Stratholme are useful. Keep Hydraxian/Thorium progressing naturally through Blackrock content.", C.yellow),
            Priority("TIER 3", "Add Zandalar Tribe when Zul'Gurub opens and begin serious Cenarion Circle work in Silithus.", C.orange),
            Priority("TIER 4-5", "Cenarion Circle and then Brood of Nozdormu become the main AQ-era reputations. Use reputation rewards to support Nature Resistance, professions and Tier 2.5 progression.", C.orange),
            Priority("TIER 6", "Argent Dawn must already be at least Honored for Naxxramas attunement. Higher standing saves attunement cost and may unlock additional rewards.", C.red),
            Priority("OPTIONAL", "Timbermaw Hold can be fitted around the main progression path whenever its recipes, travel convenience or completion rewards matter to you.", C.purple),
            "",
            SH("BOTTOM LINE"),
            "Do not grind every reputation to Exalted just because it exists. Push the faction that unlocks your next raid mechanic, attunement, enchant, recipe or gear reward, and let raid reputations rise naturally while that content is current.",
        })
    end,
}

local PVP_PAGE = {
    title = "Vanilla PvP",
    short = "Custom PvP ranks, battleground reputation & gearing",
    icon = "Interface\\Icons\\INV_BannerPVP_01",
    body = function()
        return Join({
            SH("VANILLA PVP RANKING"),
            "Vanilla PvP titles on this server are earned from lifetime honorable kills. Each rank unlocks when your character reaches the required kill total.",
            "",
            H("RANK REQUIREMENTS"),
            "Rank 1   Private / Scout                 - 100 honorable kills",
            "Rank 2   Corporal / Grunt                 - 200 honorable kills",
            "Rank 3   Sergeant / Sergeant              - 400 honorable kills",
            "Rank 4   Master Sergeant / Senior Sergeant - 800 honorable kills",
            "Rank 5   Sergeant Major / First Sergeant  - 1,400 honorable kills",
            "Rank 6   Knight / Stone Guard             - 2,000 honorable kills",
            "Rank 7   Knight-Lieutenant / Blood Guard  - 3,000 honorable kills",
            "Rank 8   Knight-Captain / Legionnaire     - 4,500 honorable kills",
            "Rank 9   Knight-Champion / Centurion      - 6,000 honorable kills",
            "Rank 10  Lieutenant Commander / Champion  - 8,000 honorable kills",
            "Rank 11  Commander / Lieutenant General   - 10,000 honorable kills",
            "Rank 12  Marshal / General                - 13,000 honorable kills",
            "Rank 13  Field Marshal / Warlord          - 18,000 honorable kills",
            "Rank 14  Grand Marshal / High Warlord     - 24,000 honorable kills",
            "",
            SH("IMPORTANT RULES"),
            Priority("PERSISTENT", "Vanilla PvP titles remain on the character after progressing into TBC/Wrath.", C.green),
            Priority("VANILLA ONLY", "New Vanilla PvP titles cannot be earned after the character leaves Vanilla progression.", C.orange),
            Bullet("If a high Vanilla rank is part of your character's goals, finish the required honorable kills before moving into TBC."),
            "",
            SH("BATTLEGROUND REPUTATIONS"),
            Bullet("Warsong Gulch: Warsong Outriders / Silverwing Sentinels."),
            Bullet("Arathi Basin: The Defilers / The League of Arathor."),
            Bullet("Alterac Valley: Frostwolf Clan / Stormpike Guard."),
            Bullet("Battleground reputation rewards can provide useful gearing alternatives alongside dungeon and raid progression."),
            "",
            SH("GEARING PATH"),
            Priority("OPTIONAL - HIGH VALUE", "PvP can be used as a real gearing route rather than only side content.", C.purple),
            Bullet("Compare PvP rewards against your current Pre-Raid, raid and reputation options before committing to a long grind."),
            Bullet("Ranks and battleground reputations are separate progression systems; work on whichever rewards your character actually needs."),
            "",
            SH("CHECK YOUR RANK"),
            Bullet("The server command .ip pvp reports current rank progress when your account permissions allow that command."),
        })
    end,
}

local CHARACTER_SERVICES_PAGE = {
    title = "Chronomancer Vezrath",
    short = "Character Services & progression catch-up",
    icon = "Interface\\Icons\\INV_Misc_PocketWatch_01",
    body = function()
        return Join({
            SH("WHERE TO FIND HIM"),
            "Chronomancer Vezrath is a male Bronze Draconid stationed in every capital city, near that capital's faction leader.",
            "",
            SH("PROGRESSION CATCH-UP"),
            "If another character on your account has already completed progression, eligible characters can purchase previously achieved progression from Chronomancer Vezrath.",
            Priority("ACCOUNT-LIMITED", "You can never buy beyond the highest progression already achieved on your account.", C.orange),
            Priority("SERVER LIMIT", "Catch-up purchases are currently capped at AQ War Effort progression.", C.orange),
            "",
            H("CATCH-UP PRICES"),
            Bullet("Molten Core completion - 150 gold."),
            Bullet("Onyxia completion - 200 gold."),
            Bullet("Blackwing Lair completion - 250 gold."),
            Bullet("Pre-AQ completion - 300 gold."),
            Bullet("AQ War Effort completion - 500 gold."),
            Bullet("AQ, Naxxramas and later progression cannot currently be purchased through the catch-up service."),
            Bullet("Progression catch-up prices are per purchased tier and are not cumulative."),
            "",
            SH("EXPANSION UNLOCKS"),
            Priority("VANILLA -> TBC", "2,500 gold", C.gold),
            Bullet("After completing the Vanilla journey, speak with Chronomancer Vezrath when you are ready to advance into The Burning Crusade."),
            "",
            Priority("TBC -> WOTLK", "7,500 gold", C.gold),
            Bullet("After defeating Kil'jaeden and completing The Burning Crusade progression, return to Chronomancer Vezrath when you are ready to advance into Wrath of the Lich King."),
            Bullet("Inscription trainers and vendors become available with Wrath of the Lich King."),
            "",
            SH("OTHER CHARACTER SERVICES"),
            Bullet("Name Change - 50 gold."),
            Bullet("Appearance Change - 25 gold."),
            Bullet("Race Change - 150 gold."),
            Bullet("Faction Change - 750 gold."),
            "",
            SH("TBC RACES"),
            Bullet("Blood Elves and Draenei unlock for the account after Vanilla progression is completed."),
            Bullet("Those races begin at the start of The Burning Crusade progression on this server."),
        })
    end,
}

local COMMANDS_PAGE = {
    title = "Commands / Help",
    short = "Addon commands and Individual Progression server commands",
    icon = "Interface\\Icons\\INV_Misc_Note_05",
    body = function()
        return Join({
            SH("ADDON COMMANDS"),
            H("/ip"),
            Bullet("Toggle the Individual Progression guide."),
            H("/ip current"),
            Bullet("Open the progression stage your character is currently working on across Vanilla, TBC or Wrath."),
            H("/ip tbc"),
            Bullet("Open The Burning Crusade overview / roadmap."),
            H("/ip tbcdungeons"),
            Bullet("Open TBC dungeon, access and Heroic-key guidance."),
            H("/ip tbcreps"),
            Bullet("Open the TBC Reputations guide."),
            H("/ip tbcprofessions"),
            Bullet("Open the TBC Professions guide."),
            H("/ip tbcpvp"),
            Bullet("Open TBC PvP and Arena Season guidance."),
            H("/ip tbcworldbosses"),
            Bullet("Open the TBC World Boss Timeline."),
            H("/ip zulaman"),
            Bullet("Open Zul'Aman side-content guidance."),
            H("/ip wrath"),
            Bullet("Open the Wrath of the Lich King overview / roadmap."),
            H("/ip wrathdungeons"),
            Bullet("Open Wrath dungeon and Heroic timing guidance."),
            H("/ip wrathemblems"),
            Bullet("Open the Wrath emblem and Dalaran recurring-quest guide."),
            H("/ip wrathreps"),
            Bullet("Open the detailed Wrath Reputations guide."),
            H("/ip wrathprofessions"),
            Bullet("Open the Wrath Professions guide."),
            H("/ip wrathpvp"),
            Bullet("Open Wrath PvP / Arena Season 5 guidance."),
            H("/ip wintergrasp"),
            Bullet("Open Wintergrasp and Vault of Archavon guidance."),
            H("/ip tournament"),
            Bullet("Open Argent Tournament guidance."),
            H("/ip worldbosses"),
            Bullet("Open the Vanilla World Boss Timeline."),
            H("/ip general"),
            Bullet("Open General Information."),
            H("/ip talents"),
            Bullet("Open the expansion-based Talent Rules page."),
            H("/ip reputations"),
            Bullet("Open the Vanilla Reputations guide."),
            H("/ip pvp"),
            Bullet("Open the Vanilla PvP guide."),
            H("/ip services"),
            Bullet("Open Chronomancer Vezrath's Character Services page."),
            H("/ip vezrath"),
            Bullet("Open Chronomancer Vezrath's Character Services page."),
            H("/ip refresh"),
            Bullet("Request your current progression from the server again."),
            H("/ip commands"),
            Bullet("Open this command-reference page."),
            H("/ip help"),
            Bullet("Print the addon command list in chat."),
            Bullet("/progression can be used instead of /ip for addon commands."),
            "",
            SH("INDIVIDUAL PROGRESSION SERVER COMMANDS"),
            "These are dot-commands provided by Individual Progression. Most can be used by normal players; .ip set and .ip tele require GM permissions. Some commands also depend on server configuration.",
            "",
            H(".ip get [player]"),
            Bullet("Show the target/self progression value."),
            "",
            H(".ip set <value>"),
            Priority("GM", "Set the selected/self character to a progression value.", C.orange),
            "",
            H(".ip setbot"),
            Bullet("Synchronise grouped bot characters to the player's current progression state."),
            "",
            H(".ip pvp [player]"),
            Bullet("Show Vanilla PvP rank progress and honorable kills for the target/self."),
            "",
            H(".ip tele <onyxia|naxx>"),
            Priority("GM", "Teleport the target/self to the restored Vanilla raid when the required attunement/access conditions are met.", C.orange),
            Bullet("Aliases onyxia40 and naxx40 are also accepted."),
            "",
            H(".ip attune <onyxia|blacktemple>"),
            Bullet("Group attunement helper. The character using it must already meet the relevant attunement/item requirement."),
            Bullet("Aliases onyxia40 and bt are also accepted."),
            "",
            H(".ip pet <family>"),
            Bullet("Displays restored Hunter pet / Warlock demon spell-rank information for supported pet families."),
            "",
            H(".ip setrep"),
            Bullet("Account reputation synchronisation helper for configured factions."),
            Priority("DISABLED", "This command is currently disabled by your server configuration.", C.red),
            "",
            SH("IMPORTANT"),
            Bullet("Slash commands such as /ip open this addon."),
            Bullet("Dot commands such as .ip pvp are server commands handled by Individual Progression."),
            Bullet("Do not use .ip set unless you intentionally want to change progression."),
        })
    end,
}

local OVERVIEW_PAGE = {
    title = "Vanilla Progression Roadmap",
    short = "The complete level-60 journey",
    icon = "Interface\\Icons\\INV_Misc_Book_09",
    body = function()
        return Join({
            SH("HOW TO READ THIS GUIDE"),
            "The addon separates three different ideas: required progression, important supporting content, and optional content that is best done while it is still relevant.",
            "",
            C.red .. "[REQUIRED]" .. C.reset .. " Advances or directly enables progression.",
            C.orange .. "[IMPORTANT]" .. C.reset .. " Does not always advance your current stage, but should normally be done.",
            C.yellow .. "[RECOMMENDED]" .. C.reset .. " Strong preparation, reputations, professions or gearing.",
            C.purple .. "[OPTIONAL - HIGH VALUE]" .. C.reset .. " Side content worth doing in its intended tier.",
            "",
            H("VANILLA TIMELINE"),
            C.gold .. "Tier 0" .. C.reset .. "       Molten Core",
            Bullet("First tracked raid milestone. Complete MC access, manual rune dousing preparation and defeat Ragnaros."),
            "",
            C.gold .. "Tier 1" .. C.reset .. "       Onyxia's Lair",
            Bullet("Unlocks after Molten Core progression is completed. Complete the Drakefire Amulet attunement and defeat Onyxia."),
            "",
            C.gold .. "Tier 2" .. C.reset .. "       Blackwing Lair",
            Bullet("Dire Maul enters the gearing route; Azuregos + Lord Kazzak become world-boss targets."),
            Bullet("Onyxia Scale Cloak becomes strategically important for Shadowflame."),
            "",
            C.gold .. "Tier 3" .. C.reset .. "       Pre-AQ",
            Bullet("Zul'Gurub, War Effort, Scarab Gong route and later-Vanilla world-boss progression."),
            "",
            C.gold .. "Tier 4" .. C.reset .. "       AQ War",
            Bullet("Gates open, AQ outdoor war active, AQ20/AQ40 available; finish Chaos and Destruction."),
            "",
            C.gold .. "Tier 5" .. C.reset .. "       Ahn'Qiraj",
            Bullet("Full post-war AQ gearing/reputation ecosystem; defeat C'Thun."),
            "",
            C.gold .. "Tier 6" .. C.reset .. "       Naxxramas",
            Bullet("Argent Dawn attunement, Naxx40, Scourge Invasion; defeat Kel'Thuzad."),
            "",
            C.gold .. "Tier 7" .. C.reset .. "       Pre-TBC",
            Bullet("Dark Portal invasion; complete Into the Breach and finish your Vanilla journey."),
            "",
            SH("IMPORTANT UNLOCKS AT A GLANCE"),
            Bullet("Dire Maul: early post-opening / Tier 2 pathway."),
            Bullet("Azuregos + Lord Kazzak: early post-opening / Tier 2 pathway."),
            Bullet("Zul'Gurub: after Blackwing Lair, during Tier 3 / Pre-AQ."),
            Bullet("Dragons of Nightmare: later Vanilla / Pre-AQ pathway."),
            Bullet("AQ20 + AQ40: Tier 4 when the gates open."),
            Bullet("Naxxramas + Scourge Invasion: Tier 6."),
            "",
            SH("CHRONOMANCER VEZRATH"),
            Bullet("Found in every capital city near that capital's faction leader."),
            Bullet("Provides eligible account progression catch-up services."),
            Bullet("Required for the 2,500g Vanilla -> TBC and 7,500g TBC -> WotLK expansion unlocks."),
            "",
            SH("SERVER-SPECIFIC RULES"),
            Bullet("Talent access is restricted by expansion even though the client uses the full 3.3.5 talent trees. See the Talent Rules tab."),
            Bullet("Characters can only group with others in the same progression phase."),
            Bullet("Dungeon Set 2 progression is available early on this server."),
            Bullet("Six Scourge Invasion dungeon bosses are available early rather than being restricted only to the Naxxramas stage."),
            Bullet("Quest object markers and sparkles are disabled, so read quest text and objectives carefully."),
            Bullet("Your current progression stage is read automatically when this window opens."),
            "",
            SH("GUIDE SECTIONS"),
            Bullet("Vanilla Side Content now contains World Bosses, Vanilla Reputations and Vanilla PvP."),
            Bullet("Use the detailed Reputations page for when to farm each major Vanilla faction, how to earn it and what rewards make it worthwhile."),
            Bullet("Use Vanilla PvP for the custom Rank 1-14 requirements, title rules and battleground reputation path."),
            Bullet("General Information is reserved for server-wide systems such as profession phasing and flight-path phasing."),
            Bullet("Use Talent Rules for the Vanilla, TBC and Wrath talent-tree limits."),
        })
    end,
}

-- ============================================================================
-- DATA MODEL / SERVER COMMUNICATION
-- ============================================================================

local data = {
    currentValue = 0,
    loaded = false,
    selectedPage = "overview",
}

local function SendCommand(cmd)
    SendChatMessage(".ipsvc " .. cmd, "SAY")
end

local function RequestData()
    SendCommand("data")
end

local UpdateDisplay
local SelectPage

local function ParseMessage(payload)
    local parts = { strsplit(DELIMITER, payload) }
    if parts[1] == "PD" then
        data.currentValue = tonumber(parts[2]) or 0
        data.loaded = true
        UpdateDisplay()
    end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", function(self, event, msg, ...)
    if msg and msg:find("^##IPSVC##") then
        return true
    end
end)

-- ============================================================================
-- UI BACKDROPS
-- ============================================================================

local BACKDROP_MAIN = {
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
}

local BACKDROP_INNER = {
    bgFile   = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
}

-- ============================================================================
-- MAIN FRAME
-- ============================================================================

local mainFrame = CreateFrame("Frame", "IndividualProgressionFrame", UIParent)
mainFrame:SetSize(900, 720)
mainFrame:SetPoint("CENTER")
mainFrame:SetBackdrop(BACKDROP_MAIN)
mainFrame:SetBackdropColor(0.035, 0.035, 0.055, 0.98)
mainFrame:SetBackdropBorderColor(0.55, 0.45, 0.22, 1)
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame:SetFrameStrata("DIALOG")
mainFrame:SetClampedToScreen(true)
mainFrame:Hide()

local title = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 22, -18)
title:SetText(C.gold .. "Individual Progression" .. C.reset)

local subtitle = mainFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
subtitle:SetPoint("LEFT", title, "RIGHT", 10, -1)
subtitle:SetText(C.grey .. "Vanilla + TBC + Wrath Server Companion" .. C.reset)

local closeBtn = CreateFrame("Button", nil, mainFrame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -5, -5)

local refreshBtn = CreateFrame("Button", nil, mainFrame, "UIPanelButtonTemplate")
refreshBtn:SetSize(74, 22)
refreshBtn:SetPoint("TOPRIGHT", -42, -12)
refreshBtn:SetText("Refresh")
refreshBtn:SetScript("OnClick", RequestData)

-- Header status box
local headerBox = CreateFrame("Frame", nil, mainFrame)
headerBox:SetPoint("TOPLEFT", 18, -48)
headerBox:SetPoint("TOPRIGHT", -18, -48)
headerBox:SetHeight(72)
headerBox:SetBackdrop(BACKDROP_INNER)
headerBox:SetBackdropColor(0.08, 0.08, 0.11, 0.96)
headerBox:SetBackdropBorderColor(0.38, 0.33, 0.22, 0.8)

local characterText = headerBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
characterText:SetPoint("TOPLEFT", 12, -10)
characterText:SetJustifyH("LEFT")

local currentText = headerBox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
currentText:SetPoint("TOPLEFT", 12, -32)
currentText:SetJustifyH("LEFT")

local objectiveText = headerBox:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
objectiveText:SetPoint("TOPLEFT", 12, -51)
objectiveText:SetJustifyH("LEFT")
objectiveText:SetTextColor(0.78, 0.78, 0.78)

local jumpBtn = CreateFrame("Button", nil, headerBox, "UIPanelButtonTemplate")
jumpBtn:SetSize(105, 22)
jumpBtn:SetPoint("RIGHT", -12, 0)
jumpBtn:SetText("Current Stage")

-- Sidebar
local sidebar = CreateFrame("Frame", nil, mainFrame)
sidebar:SetPoint("TOPLEFT", 18, -128)
sidebar:SetPoint("BOTTOMLEFT", 18, 18)
sidebar:SetWidth(225)
sidebar:SetBackdrop(BACKDROP_INNER)
sidebar:SetBackdropColor(0.055, 0.055, 0.075, 0.96)
sidebar:SetBackdropBorderColor(0.33, 0.3, 0.22, 0.8)

local sidebarTitle = sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
sidebarTitle:SetPoint("TOPLEFT", 12, -12)
sidebarTitle:SetText(C.gold .. "PROGRESSION GUIDE" .. C.reset)

local navScroll = CreateFrame("ScrollFrame", "IPGuideNavScrollFrame", sidebar, "UIPanelScrollFrameTemplate")
navScroll:SetPoint("TOPLEFT", 4, -31)
navScroll:SetPoint("BOTTOMRIGHT", -27, 34)
navScroll:EnableMouseWheel(true)

local navScrollChild = CreateFrame("Frame", nil, navScroll)
navScrollChild:SetSize(188, 900)
navScroll:SetScrollChild(navScrollChild)
navScroll:SetScript("OnMouseWheel", function(self, delta)
    local current = self:GetVerticalScroll() or 0
    local maxScroll = self:GetVerticalScrollRange() or 0
    local nextScroll = current - (delta * 45)
    if nextScroll < 0 then nextScroll = 0 end
    if nextScroll > maxScroll then nextScroll = maxScroll end
    self:SetVerticalScroll(nextScroll)
end)

-- Content panel
local contentPanel = CreateFrame("Frame", nil, mainFrame)
contentPanel:SetPoint("TOPLEFT", sidebar, "TOPRIGHT", 8, 0)
contentPanel:SetPoint("BOTTOMRIGHT", -18, 18)
contentPanel:SetBackdrop(BACKDROP_INNER)
contentPanel:SetBackdropColor(0.055, 0.055, 0.07, 0.96)
contentPanel:SetBackdropBorderColor(0.33, 0.3, 0.22, 0.8)

local headerArt = contentPanel:CreateTexture(nil, "BACKGROUND")
headerArt:SetPoint("TOPLEFT", 8, -7)
headerArt:SetPoint("TOPRIGHT", -8, -7)
headerArt:SetHeight(68)
headerArt:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Parchment-Horizontal")
headerArt:SetTexCoord(0, 1, 0, 0.52)
headerArt:SetAlpha(0.18)

local pageIcon = contentPanel:CreateTexture(nil, "ARTWORK")
pageIcon:SetSize(48, 48)
pageIcon:SetPoint("TOPLEFT", 18, -12)
pageIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

local pageTitle = contentPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
pageTitle:SetPoint("TOPLEFT", 78, -14)
pageTitle:SetPoint("TOPRIGHT", -16, -14)
pageTitle:SetJustifyH("LEFT")

local pageSub = contentPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
pageSub:SetPoint("TOPLEFT", pageTitle, "BOTTOMLEFT", 0, -4)
pageSub:SetJustifyH("LEFT")
pageSub:SetTextColor(0.65, 0.65, 0.65)

local divider = contentPanel:CreateTexture(nil, "ARTWORK")
divider:SetPoint("TOPLEFT", 14, -72)
divider:SetPoint("TOPRIGHT", -14, -72)
divider:SetHeight(1)
divider:SetTexture(1, 0.82, 0, 0.22)

local scrollFrame = CreateFrame("ScrollFrame", "IPGuideScrollFrame", contentPanel, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 14, -82)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 31)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(1, 1)
scrollFrame:SetScrollChild(scrollChild)

local bodyText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
bodyText:SetPoint("TOPLEFT", 2, -2)
bodyText:SetJustifyH("LEFT")
bodyText:SetJustifyV("TOP")
bodyText:SetWordWrap(true)
bodyText:SetNonSpaceWrap(true)
bodyText:SetSpacing(3)

-- Long guide pages can exceed the reliable height of a single FontString on the
-- 3.3.5 client. Keep several smaller FontStrings stacked vertically instead.
local bodyTextBlocks = { bodyText }

local function ConfigureBodyBlock(fs)
    fs:SetJustifyH("LEFT")
    fs:SetJustifyV("TOP")
    fs:SetWordWrap(true)
    fs:SetNonSpaceWrap(true)
    fs:SetSpacing(3)
end

local function SplitBodyText(text)
    local chunks = {}
    local lines = {}
    local chars = 0
    local maxLines = 18
    local maxChars = 1800

    for line in string.gmatch((text or "") .. "\n", "(.-)\n") do
        local add = string.len(line) + 1
        if table.getn(lines) > 0 and (table.getn(lines) >= maxLines or chars + add > maxChars) then
            table.insert(chunks, table.concat(lines, "\n"))
            lines = {}
            chars = 0
        end
        table.insert(lines, line)
        chars = chars + add
    end

    if table.getn(lines) > 0 then
        table.insert(chunks, table.concat(lines, "\n"))
    end

    if table.getn(chunks) == 0 then
        table.insert(chunks, "")
    end

    return chunks
end

local footerNote = contentPanel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
footerNote:SetPoint("BOTTOMLEFT", 16, 10)
footerNote:SetPoint("BOTTOMRIGHT", -16, 10)
footerNote:SetJustifyH("LEFT")
footerNote:SetText(C.dark .. "Server progression companion - Vanilla, TBC and Wrath progression, attunements, side content and server rules in one guide." .. C.reset)

-- ============================================================================
-- NAVIGATION
-- ============================================================================

local navButtons = {}
local vanillaStageOrder = { "mc", "onyxia", "bwl", "preaq", "aqwar", "aq", "naxx", "pretbc" }
local tbcStageOrder = { "tbc8", "tbc9", "tbc10", "tbc12" }
local wrathStageOrder = { "wrath13", "wrath14", "wrath15", "wrath16", "wrath17" }

local function CreateNavButton(id, label, y)
    local btn = CreateFrame("Button", nil, navScrollChild)
    btn:SetSize(178, 28)
    btn:SetPoint("TOPLEFT", 10, y)

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetTexture(1, 1, 1, 0.025)
    btn.bg = bg

    local navIcon = btn:CreateTexture(nil, "ARTWORK")
    navIcon:SetSize(20, 20)
    navIcon:SetPoint("LEFT", 5, 0)
    navIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    if id == "overview" then
        navIcon:SetTexture(OVERVIEW_PAGE.icon)
    elseif id == "tbcoverview" then
        navIcon:SetTexture(TBC_OVERVIEW_PAGE.icon)
    elseif id == "tbcdungeons" then
        navIcon:SetTexture(TBC_DUNGEONS_PAGE.icon)
    elseif id == "tbcreputations" then
        navIcon:SetTexture(TBC_REPUTATIONS_PAGE.icon)
    elseif id == "tbcprofessions" then
        navIcon:SetTexture(TBC_PROFESSIONS_PAGE.icon)
    elseif id == "tbcpvp" then
        navIcon:SetTexture(TBC_PVP_PAGE.icon)
    elseif id == "tbcworldbosses" then
        navIcon:SetTexture(TBC_WORLD_BOSS_PAGE.icon)
    elseif id == "zulaman" then
        navIcon:SetTexture(ZULAMAN_PAGE.icon)
    elseif id == "wrathoverview" then
        navIcon:SetTexture(WOTLK_OVERVIEW_PAGE.icon)
    elseif id == "wrathdungeons" then
        navIcon:SetTexture(WOTLK_DUNGEONS_PAGE.icon)
    elseif id == "wrathemblems" then
        navIcon:SetTexture(WOTLK_EMBLEMS_PAGE.icon)
    elseif id == "wrathreputations" then
        navIcon:SetTexture(WOTLK_REPUTATIONS_PAGE.icon)
    elseif id == "wrathprofessions" then
        navIcon:SetTexture(WOTLK_PROFESSIONS_PAGE.icon)
    elseif id == "wrathpvp" then
        navIcon:SetTexture(WOTLK_PVP_PAGE.icon)
    elseif id == "wintergrasp" then
        navIcon:SetTexture(WINTERGRASP_PAGE.icon)
    elseif id == "argenttournament" then
        navIcon:SetTexture(ARGENT_TOURNAMENT_PAGE.icon)
    elseif id == "worldbosses" then
        navIcon:SetTexture(WORLD_BOSS_PAGE.icon)
    elseif id == "general" then
        navIcon:SetTexture(GENERAL_PAGE.icon)
    elseif id == "talents" then
        navIcon:SetTexture(TALENT_RULES_PAGE.icon)
    elseif id == "reputations" then
        navIcon:SetTexture(REPUTATIONS_PAGE.icon)
    elseif id == "pvp" then
        navIcon:SetTexture(PVP_PAGE.icon)
    elseif id == "vezrath" then
        navIcon:SetTexture(CHARACTER_SERVICES_PAGE.icon)
    elseif id == "commands" then
        navIcon:SetTexture(COMMANDS_PAGE.icon)
    elseif VANILLA_STAGES[id] then
        navIcon:SetTexture(VANILLA_STAGES[id].icon)
    elseif TBC_STAGES[id] then
        navIcon:SetTexture(TBC_STAGES[id].icon)
    elseif WOTLK_STAGES[id] then
        navIcon:SetTexture(WOTLK_STAGES[id].icon)
    end
    btn.icon = navIcon

    local mark = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    mark:SetPoint("LEFT", 28, 0)
    mark:SetWidth(31)
    mark:SetJustifyH("CENTER")
    btn.mark = mark

    local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("LEFT", 61, 0)
    txt:SetPoint("RIGHT", -5, 0)
    txt:SetJustifyH("LEFT")
    txt:SetText(label)
    btn.text = txt

    btn:SetScript("OnEnter", function(self)
        if data.selectedPage ~= id then
            self.bg:SetTexture(1, 0.82, 0, 0.07)
        end
    end)
    btn:SetScript("OnLeave", function(self)
        if data.selectedPage ~= id then
            self.bg:SetTexture(1, 1, 1, 0.025)
        end
    end)
    btn:SetScript("OnClick", function() SelectPage(id) end)

    navButtons[id] = btn
    return btn
end

local navY = -2
local vanillaHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
vanillaHeader:SetPoint("TOPLEFT", 8, navY)
vanillaHeader:SetText(C.gold .. "VANILLA" .. C.reset)
navY = navY - 22
CreateNavButton("overview", "Overview / Roadmap", navY)
navY = navY - 29
for _, id in ipairs(vanillaStageOrder) do
    CreateNavButton(id, VANILLA_STAGES[id].nav, navY)
    navY = navY - 29
end

local worldHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
worldHeader:SetPoint("TOPLEFT", 8, navY - 2)
worldHeader:SetText(C.gold .. "VANILLA SIDE CONTENT" .. C.reset)
navY = navY - 24
CreateNavButton("worldbosses", "World Boss Timeline", navY)
navY = navY - 29
CreateNavButton("reputations", "Vanilla Reputations", navY)
navY = navY - 29
CreateNavButton("pvp", "Vanilla PvP", navY)
navY = navY - 36

local tbcHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tbcHeader:SetPoint("TOPLEFT", 8, navY - 2)
tbcHeader:SetText(C.green .. "THE BURNING CRUSADE" .. C.reset)
navY = navY - 24
CreateNavButton("tbcoverview", "TBC Overview / Roadmap", navY)
navY = navY - 29
for _, id in ipairs(tbcStageOrder) do
    CreateNavButton(id, TBC_STAGES[id].nav, navY)
    navY = navY - 29
end

local tbcSideHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
tbcSideHeader:SetPoint("TOPLEFT", 8, navY - 2)
tbcSideHeader:SetText(C.green .. "TBC SUPPORT / SIDE CONTENT" .. C.reset)
navY = navY - 24
CreateNavButton("tbcdungeons", "Dungeons & Heroic Keys", navY)
navY = navY - 29
CreateNavButton("tbcreputations", "TBC Reputations", navY)
navY = navY - 29
CreateNavButton("tbcprofessions", "TBC Professions", navY)
navY = navY - 29
CreateNavButton("tbcpvp", "TBC PvP", navY)
navY = navY - 29
CreateNavButton("tbcworldbosses", "TBC World Bosses", navY)
navY = navY - 29
CreateNavButton("zulaman", "Zul'Aman", navY)
navY = navY - 36

local wrathHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wrathHeader:SetPoint("TOPLEFT", 8, navY - 2)
wrathHeader:SetText(C.blue .. "WRATH OF THE LICH KING" .. C.reset)
navY = navY - 24
CreateNavButton("wrathoverview", "Wrath Overview / Roadmap", navY)
navY = navY - 29
for _, id in ipairs(wrathStageOrder) do
    CreateNavButton(id, WOTLK_STAGES[id].nav, navY)
    navY = navY - 29
end

local wrathSideHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
wrathSideHeader:SetPoint("TOPLEFT", 8, navY - 2)
wrathSideHeader:SetText(C.blue .. "WRATH SUPPORT / SIDE CONTENT" .. C.reset)
navY = navY - 24
CreateNavButton("wrathdungeons", "Dungeons & Heroics", navY)
navY = navY - 29
CreateNavButton("wrathemblems", "Emblems & Dalaran Quests", navY)
navY = navY - 29
CreateNavButton("wrathreputations", "Wrath Reputations", navY)
navY = navY - 29
CreateNavButton("wrathprofessions", "Wrath Professions", navY)
navY = navY - 29
CreateNavButton("wrathpvp", "Wrath PvP", navY)
navY = navY - 29
CreateNavButton("wintergrasp", "Wintergrasp & Vault", navY)
navY = navY - 29
CreateNavButton("argenttournament", "Argent Tournament", navY)
navY = navY - 36

local generalHeader = navScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
generalHeader:SetPoint("TOPLEFT", 8, navY - 2)
generalHeader:SetText(C.gold .. "GENERAL" .. C.reset)
navY = navY - 24
CreateNavButton("general", "General Information", navY)
navY = navY - 29
CreateNavButton("talents", "Talent Rules", navY)
navY = navY - 29
CreateNavButton("vezrath", "Chronomancer Vezrath", navY)
navY = navY - 29
CreateNavButton("commands", "Commands / Help", navY)
navY = navY - 34
navScrollChild:SetHeight(math.max(900, -navY + 10))

local legend = sidebar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
legend:SetPoint("BOTTOMLEFT", 12, 10)
legend:SetJustifyH("LEFT")
legend:SetText(C.green .. "DONE" .. C.reset .. "   " .. C.gold .. "NOW" .. C.reset .. "   " .. C.dark .. "LOCKED" .. C.reset)

-- ============================================================================
-- PAGE / STATUS LOGIC
-- ============================================================================

local function GetCurrentStageId(cv)
    if cv == 0 then return "mc" end
    if cv == 1 then return "onyxia" end
    if cv == 2 then return "bwl" end
    if cv == 3 then return "preaq" end
    if cv == 4 then return "aqwar" end
    if cv == 5 then return "aq" end
    if cv == 6 then return "naxx" end
    if cv == 7 then return "pretbc" end
    if cv == 8 then return "tbc8" end
    if cv == 9 then return "tbc9" end
    if cv == 10 or cv == 11 then return "tbc10" end
    if cv == 12 then return "tbc12" end
    if cv == 13 then return "wrath13" end
    if cv == 14 then return "wrath14" end
    if cv == 15 then return "wrath15" end
    if cv == 16 then return "wrath16" end
    if cv == 17 then return "wrath17" end
    return nil
end

local function GetStageTable(id)
    return VANILLA_STAGES[id] or TBC_STAGES[id] or WOTLK_STAGES[id]
end

local function GetStageState(id, cv)
    local stage = GetStageTable(id)
    if not stage then return "guide" end
    if cv >= stage.completeAt then return "done" end
    local current = GetCurrentStageId(cv)
    if current == id then return "current" end
    if cv < stage.minValue then return "locked" end
    return "available"
end

local function UpdateNavStates()
    for id, btn in pairs(navButtons) do
        if data.selectedPage == id then
            btn.bg:SetTexture(1, 0.82, 0, 0.13)
        else
            btn.bg:SetTexture(1, 1, 1, 0.025)
        end

        if id == "overview" or id == "worldbosses" or id == "tbcoverview" or id == "tbcdungeons" or id == "tbcreputations" or id == "tbcprofessions" or id == "tbcpvp" or id == "tbcworldbosses" or id == "zulaman" or id == "wrathoverview" or id == "wrathdungeons" or id == "wrathemblems" or id == "wrathreputations" or id == "wrathprofessions" or id == "wrathpvp" or id == "wintergrasp" or id == "argenttournament" or id == "general" or id == "talents" or id == "reputations" or id == "pvp" or id == "vezrath" or id == "commands" then
            btn.mark:SetText(C.blue .. "i" .. C.reset)
            btn.text:SetTextColor(0.92, 0.92, 0.92)
        else
            local state = GetStageState(id, data.currentValue)
            if state == "done" then
                btn.mark:SetText(C.green .. "OK" .. C.reset)
                btn.text:SetTextColor(0.45, 0.85, 0.45)
            elseif state == "current" then
                btn.mark:SetText(C.gold .. ">>" .. C.reset)
                btn.text:SetTextColor(1.0, 0.82, 0.0)
            elseif state == "available" then
                btn.mark:SetText(C.yellow .. "--" .. C.reset)
                btn.text:SetTextColor(0.9, 0.8, 0.45)
            else
                btn.mark:SetText(C.dark .. "--" .. C.reset)
                btn.text:SetTextColor(0.36, 0.36, 0.36)
            end
        end
    end
end

local function SetPageContent(titleText, subText, text, iconTexture)
    pageTitle:SetText(C.gold .. titleText .. C.reset)
    pageSub:SetText(subText or "")
    pageIcon:SetTexture(iconTexture or "Interface\\Icons\\INV_Misc_Book_09")

    local width = scrollFrame:GetWidth() - 8
    if width < 400 then width = 560 end

    local chunks = SplitBodyText(text or "")
    local yOffset = 2

    for i = 1, table.getn(chunks) do
        local fs = bodyTextBlocks[i]
        if not fs then
            fs = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            ConfigureBodyBlock(fs)
            bodyTextBlocks[i] = fs
        end

        fs:ClearAllPoints()
        fs:SetPoint("TOPLEFT", 2, -yOffset)
        fs:SetWidth(width)
        fs:SetText(chunks[i])
        fs:Show()

        local blockHeight = fs:GetStringHeight() or 0
        if blockHeight < 1 then blockHeight = 16 end
        yOffset = yOffset + blockHeight + 6
    end

    for i = table.getn(chunks) + 1, table.getn(bodyTextBlocks) do
        bodyTextBlocks[i]:SetText("")
        bodyTextBlocks[i]:Hide()
    end

    scrollChild:SetSize(width, yOffset + 16)
    scrollFrame:SetVerticalScroll(0)
end

SelectPage = function(id)
    data.selectedPage = id or "overview"
    IndividualProgressionDB = IndividualProgressionDB or {}
    IndividualProgressionDB.lastPage = data.selectedPage

    if data.selectedPage == "overview" then
        SetPageContent(OVERVIEW_PAGE.title, OVERVIEW_PAGE.short, OVERVIEW_PAGE.body(), OVERVIEW_PAGE.icon)
    elseif data.selectedPage == "tbcoverview" then
        SetPageContent(TBC_OVERVIEW_PAGE.title, TBC_OVERVIEW_PAGE.short, TBC_OVERVIEW_PAGE.body(), TBC_OVERVIEW_PAGE.icon)
    elseif data.selectedPage == "tbcdungeons" then
        SetPageContent(TBC_DUNGEONS_PAGE.title, TBC_DUNGEONS_PAGE.short, TBC_DUNGEONS_PAGE.body(), TBC_DUNGEONS_PAGE.icon)
    elseif data.selectedPage == "tbcreputations" then
        SetPageContent(TBC_REPUTATIONS_PAGE.title, TBC_REPUTATIONS_PAGE.short, TBC_REPUTATIONS_PAGE.body(), TBC_REPUTATIONS_PAGE.icon)
    elseif data.selectedPage == "tbcprofessions" then
        SetPageContent(TBC_PROFESSIONS_PAGE.title, TBC_PROFESSIONS_PAGE.short, TBC_PROFESSIONS_PAGE.body(), TBC_PROFESSIONS_PAGE.icon)
    elseif data.selectedPage == "tbcpvp" then
        SetPageContent(TBC_PVP_PAGE.title, TBC_PVP_PAGE.short, TBC_PVP_PAGE.body(), TBC_PVP_PAGE.icon)
    elseif data.selectedPage == "tbcworldbosses" then
        SetPageContent(TBC_WORLD_BOSS_PAGE.title, TBC_WORLD_BOSS_PAGE.short, TBC_WORLD_BOSS_PAGE.body(), TBC_WORLD_BOSS_PAGE.icon)
    elseif data.selectedPage == "zulaman" then
        SetPageContent(ZULAMAN_PAGE.title, ZULAMAN_PAGE.short, ZULAMAN_PAGE.body(), ZULAMAN_PAGE.icon)
    elseif data.selectedPage == "wrathoverview" then
        SetPageContent(WOTLK_OVERVIEW_PAGE.title, WOTLK_OVERVIEW_PAGE.short, WOTLK_OVERVIEW_PAGE.body(), WOTLK_OVERVIEW_PAGE.icon)
    elseif data.selectedPage == "wrathdungeons" then
        SetPageContent(WOTLK_DUNGEONS_PAGE.title, WOTLK_DUNGEONS_PAGE.short, WOTLK_DUNGEONS_PAGE.body(), WOTLK_DUNGEONS_PAGE.icon)
    elseif data.selectedPage == "wrathemblems" then
        SetPageContent(WOTLK_EMBLEMS_PAGE.title, WOTLK_EMBLEMS_PAGE.short, WOTLK_EMBLEMS_PAGE.body(), WOTLK_EMBLEMS_PAGE.icon)
    elseif data.selectedPage == "wrathreputations" then
        SetPageContent(WOTLK_REPUTATIONS_PAGE.title, WOTLK_REPUTATIONS_PAGE.short, WOTLK_REPUTATIONS_PAGE.body(), WOTLK_REPUTATIONS_PAGE.icon)
    elseif data.selectedPage == "wrathprofessions" then
        SetPageContent(WOTLK_PROFESSIONS_PAGE.title, WOTLK_PROFESSIONS_PAGE.short, WOTLK_PROFESSIONS_PAGE.body(), WOTLK_PROFESSIONS_PAGE.icon)
    elseif data.selectedPage == "wrathpvp" then
        SetPageContent(WOTLK_PVP_PAGE.title, WOTLK_PVP_PAGE.short, WOTLK_PVP_PAGE.body(), WOTLK_PVP_PAGE.icon)
    elseif data.selectedPage == "wintergrasp" then
        SetPageContent(WINTERGRASP_PAGE.title, WINTERGRASP_PAGE.short, WINTERGRASP_PAGE.body(), WINTERGRASP_PAGE.icon)
    elseif data.selectedPage == "argenttournament" then
        SetPageContent(ARGENT_TOURNAMENT_PAGE.title, ARGENT_TOURNAMENT_PAGE.short, ARGENT_TOURNAMENT_PAGE.body(), ARGENT_TOURNAMENT_PAGE.icon)
    elseif data.selectedPage == "worldbosses" then
        SetPageContent(WORLD_BOSS_PAGE.title, WORLD_BOSS_PAGE.short, WORLD_BOSS_PAGE.body(), WORLD_BOSS_PAGE.icon)
    elseif data.selectedPage == "general" then
        SetPageContent(GENERAL_PAGE.title, GENERAL_PAGE.short, GENERAL_PAGE.body(), GENERAL_PAGE.icon)
    elseif data.selectedPage == "talents" then
        SetPageContent(TALENT_RULES_PAGE.title, TALENT_RULES_PAGE.short, TALENT_RULES_PAGE.body(), TALENT_RULES_PAGE.icon)
    elseif data.selectedPage == "reputations" then
        SetPageContent(REPUTATIONS_PAGE.title, REPUTATIONS_PAGE.short, REPUTATIONS_PAGE.body(), REPUTATIONS_PAGE.icon)
    elseif data.selectedPage == "pvp" then
        SetPageContent(PVP_PAGE.title, PVP_PAGE.short, PVP_PAGE.body(), PVP_PAGE.icon)
    elseif data.selectedPage == "vezrath" or data.selectedPage == "services" then
        data.selectedPage = "vezrath"
        SetPageContent(CHARACTER_SERVICES_PAGE.title, CHARACTER_SERVICES_PAGE.short, CHARACTER_SERVICES_PAGE.body(), CHARACTER_SERVICES_PAGE.icon)
    elseif data.selectedPage == "commands" then
        SetPageContent(COMMANDS_PAGE.title, COMMANDS_PAGE.short, COMMANDS_PAGE.body(), COMMANDS_PAGE.icon)
    else
        local stage = GetStageTable(data.selectedPage)
        if stage then
            local state = GetStageState(data.selectedPage, data.currentValue)
            local stateText
            if state == "done" then
                stateText = C.green .. "Completed" .. C.reset
            elseif state == "current" then
                stateText = C.gold .. "CURRENT STAGE" .. C.reset
            elseif state == "locked" then
                stateText = C.dark .. "Locked / Future" .. C.reset
            else
                stateText = C.yellow .. "Available" .. C.reset
            end
            SetPageContent(stage.title, stateText .. "   |   Goal: " .. stage.objective, stage.body(), stage.icon)
        else
            data.selectedPage = "overview"
            SetPageContent(OVERVIEW_PAGE.title, OVERVIEW_PAGE.short, OVERVIEW_PAGE.body(), OVERVIEW_PAGE.icon)
        end
    end

    UpdateNavStates()
end

UpdateDisplay = function()
    local name = UnitName("player") or "Player"
    local className, classToken = UnitClass("player")
    local level = UnitLevel("player") or 0

    local classColor = RAID_CLASS_COLORS and classToken and RAID_CLASS_COLORS[classToken]
    if classColor then
        characterText:SetText(string.format("%s%s|r   %s%s|r   %sLevel %d|r", classColor.colorStr and "|c" .. classColor.colorStr or C.white, name, C.grey, className or "", C.grey, level))
    else
        characterText:SetText(C.white .. name .. C.reset .. "   " .. C.grey .. (className or "") .. "   Level " .. level .. C.reset)
    end

    if not data.loaded then
        currentText:SetText(C.grey .. "Reading progression from server..." .. C.reset)
        objectiveText:SetText("")
        UpdateNavStates()
        return
    end

    local currentId = GetCurrentStageId(data.currentValue)
    if currentId then
        local stage = GetStageTable(currentId)
        local eraLabel
        local eraColor
        if data.currentValue >= 13 then
            eraLabel = "Current Wrath Stage: "
            eraColor = C.blue
        elseif data.currentValue >= 8 then
            eraLabel = "Current TBC Stage: "
            eraColor = C.green
        else
            eraLabel = "Current Vanilla Stage: "
            eraColor = C.blue
        end
        currentText:SetText(eraColor .. eraLabel .. C.reset .. C.gold .. stage.title .. C.reset)
        objectiveText:SetText("Next progression goal: " .. stage.objective)
    elseif data.currentValue >= 18 then
        currentText:SetText(C.blue .. "Wrath of the Lich King progression complete." .. C.reset .. "  " .. C.grey .. "Halion defeated - full progression journey complete." .. C.reset)
        objectiveText:SetText("Review optional hard modes, achievements, reputations, professions and collection goals as desired.")
    else
        currentText:SetText(C.grey .. "Progression state unavailable." .. C.reset)
        objectiveText:SetText("")
    end

    UpdateNavStates()
    SelectPage(data.selectedPage)
end

jumpBtn:SetScript("OnClick", function()
    local id = GetCurrentStageId(data.currentValue)
    if id then
        SelectPage(id)
    elseif data.currentValue >= 18 then
        SelectPage("wrathoverview")
    else
        SelectPage("overview")
    end
end)

-- ============================================================================
-- EVENTS
-- ============================================================================

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_SYSTEM")
eventFrame:SetScript("OnEvent", function(self, event, msg)
    if event == "CHAT_MSG_SYSTEM" and msg and msg:find("^" .. MSG_PREFIX) then
        ParseMessage(msg:sub(#MSG_PREFIX + 1))
    end
end)

mainFrame:SetScript("OnShow", function()
    data.loaded = false
    IndividualProgressionDB = IndividualProgressionDB or {}
    data.selectedPage = IndividualProgressionDB.lastPage or "overview"
    UpdateDisplay()
    RequestData()
end)

-- ============================================================================
-- SLASH COMMANDS
-- ============================================================================

SLASH_INDIVIDUALPROGRESSION1 = "/progression"
SLASH_INDIVIDUALPROGRESSION2 = "/ip"

SlashCmdList["INDIVIDUALPROGRESSION"] = function(msg)
    msg = strtrim((msg or ""):lower())

    if msg == "help" then
        DEFAULT_CHAT_FRAME:AddMessage(C.gold .. "Individual Progression" .. C.reset .. " commands:")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip              - Toggle the progression guide")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip current      - Open your current progression stage")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbc          - Open the TBC overview")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbcdungeons  - Open TBC dungeon / heroic-key guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbcreps      - Open TBC reputation guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbcprofessions - Open TBC profession guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbcpvp       - Open TBC PvP / Arena Season guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tbcworldbosses - Open TBC world-boss guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip zulaman      - Open Zul'Aman guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrath         - Open the Wrath overview")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrathdungeons - Open Wrath dungeon / Heroic guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrathemblems  - Open Wrath emblem / Dalaran quest guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrathreps     - Open Wrath reputation guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrathprofessions - Open Wrath profession guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wrathpvp      - Open Wrath PvP / Arena Season 5 guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip wintergrasp   - Open Wintergrasp / Vault guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip tournament    - Open Argent Tournament guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip worldbosses  - Open the Vanilla world-boss timeline")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip general      - Open general server information")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip talents      - Open expansion talent rules")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip reputations  - Open Vanilla reputation guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip pvp          - Open Vanilla PvP guidance")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip services     - Open Chronomancer Vezrath services")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip vezrath      - Open Chronomancer Vezrath services")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip commands     - Open the addon command reference")
        DEFAULT_CHAT_FRAME:AddMessage("  /ip refresh      - Refresh progression from the server")
        return
    elseif msg == "current" then
        mainFrame:Show()
        local id = GetCurrentStageId(data.currentValue)
        if id then
            SelectPage(id)
        elseif data.currentValue >= 18 then
            SelectPage("wrathoverview")
        else
            SelectPage("overview")
        end
        return
    elseif msg == "tbc" or msg == "outland" then
        mainFrame:Show()
        SelectPage("tbcoverview")
        return
    elseif msg == "tbcdungeons" or msg == "heroics" or msg == "heroickeys" then
        mainFrame:Show()
        SelectPage("tbcdungeons")
        return
    elseif msg == "tbcreps" or msg == "tbcreputations" then
        mainFrame:Show()
        SelectPage("tbcreputations")
        return
    elseif msg == "tbcprofessions" or msg == "tbcprof" or msg == "tbcprofs" then
        mainFrame:Show()
        SelectPage("tbcprofessions")
        return
    elseif msg == "tbcpvp" or msg == "tbcarena" then
        mainFrame:Show()
        SelectPage("tbcpvp")
        return
    elseif msg == "tbcworldbosses" or msg == "tbcbosses" then
        mainFrame:Show()
        SelectPage("tbcworldbosses")
        return
    elseif msg == "zulaman" or msg == "za" then
        mainFrame:Show()
        SelectPage("zulaman")
        return
    elseif msg == "wrath" or msg == "wotlk" or msg == "northrend" then
        mainFrame:Show()
        SelectPage("wrathoverview")
        return
    elseif msg == "wrathdungeons" or msg == "wrathheroics" then
        mainFrame:Show()
        SelectPage("wrathdungeons")
        return
    elseif msg == "wrathemblems" or msg == "emblems" then
        mainFrame:Show()
        SelectPage("wrathemblems")
        return
    elseif msg == "wrathreps" or msg == "wrathreputations" then
        mainFrame:Show()
        SelectPage("wrathreputations")
        return
    elseif msg == "wrathprofessions" or msg == "wrathprof" or msg == "wrathprofs" then
        mainFrame:Show()
        SelectPage("wrathprofessions")
        return
    elseif msg == "wrathpvp" or msg == "wratharena" then
        mainFrame:Show()
        SelectPage("wrathpvp")
        return
    elseif msg == "wintergrasp" or msg == "wg" or msg == "vault" then
        mainFrame:Show()
        SelectPage("wintergrasp")
        return
    elseif msg == "tournament" or msg == "argenttournament" then
        mainFrame:Show()
        SelectPage("argenttournament")
        return
    elseif msg == "worldbosses" or msg == "bosses" then
        mainFrame:Show()
        SelectPage("worldbosses")
        return
    elseif msg == "general" or msg == "info" then
        mainFrame:Show()
        SelectPage("general")
        return
    elseif msg == "talents" or msg == "talent" then
        mainFrame:Show()
        SelectPage("talents")
        return
    elseif msg == "reputations" or msg == "reputation" or msg == "reps" then
        mainFrame:Show()
        SelectPage("reputations")
        return
    elseif msg == "pvp" or msg == "pvpguide" then
        mainFrame:Show()
        SelectPage("pvp")
        return
    elseif msg == "services" or msg == "vezrath" then
        mainFrame:Show()
        SelectPage("vezrath")
        return
    elseif msg == "commands" or msg == "command" then
        mainFrame:Show()
        SelectPage("commands")
        return
    elseif msg == "refresh" then
        if not mainFrame:IsShown() then mainFrame:Show() end
        RequestData()
        return
    end

    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        mainFrame:Show()
    end
end

-- ============================================================================
-- MINIMAP BUTTON (preserved from original addon)
-- ============================================================================

local minimapBtn = CreateFrame("Button", "IPAddonMinimapButton", Minimap)
minimapBtn:SetSize(33, 33)
minimapBtn:SetFrameStrata("MEDIUM")
minimapBtn:SetFrameLevel(8)
minimapBtn:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

local minimapOverlay = minimapBtn:CreateTexture(nil, "OVERLAY")
minimapOverlay:SetSize(53, 53)
minimapOverlay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
minimapOverlay:SetPoint("TOPLEFT")

local minimapIcon = minimapBtn:CreateTexture(nil, "BACKGROUND")
minimapIcon:SetSize(21, 21)
minimapIcon:SetTexture("Interface\\Icons\\INV_Misc_Book_09")
minimapIcon:SetPoint("CENTER", minimapBtn, "CENTER", 0, 1)

IndividualProgressionDB = IndividualProgressionDB or { minimapAngle = 190 }
if IndividualProgressionDB.minimapAngle == nil then
    IndividualProgressionDB.minimapAngle = 190
end

local function UpdateMinimapPosition()
    local angle = math.rad(IndividualProgressionDB.minimapAngle or 190)
    local x = math.cos(angle) * 80
    local y = math.sin(angle) * 80
    minimapBtn:ClearAllPoints()
    minimapBtn:SetPoint("CENTER", Minimap, "CENTER", x, y)
end

minimapBtn:RegisterForDrag("LeftButton")
minimapBtn:SetScript("OnDragStart", function(self)
    self:SetScript("OnUpdate", function(self)
        local mx, my = Minimap:GetCenter()
        local cx, cy = GetCursorPosition()
        local scale = Minimap:GetEffectiveScale()
        cx, cy = cx / scale, cy / scale
        IndividualProgressionDB.minimapAngle = math.deg(math.atan2(cy - my, cx - mx))
        UpdateMinimapPosition()
    end)
end)

minimapBtn:SetScript("OnDragStop", function(self)
    self:SetScript("OnUpdate", nil)
end)

minimapBtn:SetScript("OnClick", function()
    if mainFrame:IsShown() then mainFrame:Hide() else mainFrame:Show() end
end)

minimapBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
    GameTooltip:SetText(C.gold .. "Individual Progression" .. C.reset)
    GameTooltip:AddLine("Click to toggle the progression guide.", 1, 1, 1)
    GameTooltip:AddLine("Drag to reposition this button.", 0.7, 0.7, 0.7)
    GameTooltip:AddLine("/ip help for commands.", 0.55, 0.8, 1)
    GameTooltip:Show()
end)

minimapBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("PLAYER_LOGIN")
initFrame:SetScript("OnEvent", function()
    UpdateMinimapPosition()
end)

DEFAULT_CHAT_FRAME:AddMessage(C.gold .. "Individual Progression" .. C.reset .. " Server Companion loaded. Type " .. C.green .. "/ip" .. C.reset .. " to open.")
