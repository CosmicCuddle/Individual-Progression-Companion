-- Lightweight WoW 3.3.5a interface simulator for regression checks.
-- Tests client-side behaviour only; it does not validate actual server responses
-- or replace live in-game testing.
local objects = {}
local named = {}
local eventFrames = {}
local outbound = {}
local chat = {}

local Methods = {}
local metatable = {
    __index = function(self, key)
        return Methods[key] or function() return nil end
    end,
}

local function newObject(kind, name, parent)
    local object = setmetatable({
        kind = kind,
        name = name,
        parent = parent,
        scripts = {},
        events = {},
        visible = true,
        scroll = 0,
    }, metatable)
    table.insert(objects, object)
    if name then named[name] = object end
    return object
end

function Methods:CreateFontString()
    return newObject("FontString", nil, self)
end
function Methods:CreateTexture()
    return newObject("Texture", nil, self)
end
function Methods:SetScript(event, callback)
    self.scripts[event] = callback
    if event == "OnEvent" then table.insert(eventFrames, self) end
end
function Methods:GetScript(event)
    return self.scripts[event]
end
function Methods:Show()
    local wasHidden = not self.visible
    self.visible = true
    if wasHidden and self.scripts.OnShow then self.scripts.OnShow(self) end
end
function Methods:Hide()
    local wasVisible = self.visible
    self.visible = false
    if wasVisible and self.scripts.OnHide then self.scripts.OnHide(self) end
end
function Methods:IsShown()
    return self.visible
end
function Methods:SetParent(parent)
    self.parent = parent
end
function Methods:SetText(text)
    self.value = tostring(text or "")
end
function Methods:GetText()
    return rawget(self, "value")
end
function Methods:SetTexture(...)
    self.texture = {...}
end
function Methods:SetVertexColor(...)
    self.vertexColor = {...}
end
function Methods:SetSize(w, h)
    self.width, self.height = w, h
end
function Methods:SetWidth(w)
    self.width = w
end
function Methods:SetWordWrap(value)
    self.wordWrap = value
end
function Methods:SetNonSpaceWrap(value)
    self.nonSpaceWrap = value
end
function Methods:SetJustifyV(value)
    self.justifyV = value
end
function Methods:SetPoint(...)
    self.position = {...}
end
function Methods:GetWidth()
    return rawget(self, "width") or 560
end
function Methods:SetHeight(h)
    self.height = h
end
function Methods:GetStringHeight()
    return rawget(self, "simulatedStringHeight") or 20
end
function Methods:SetScrollChild(child)
    self.scrollChild = child
end
function Methods:SetFocus()
    self.focused = true
end
function Methods:ClearFocus()
    self.focused = false
end
function Methods:HighlightText()
    self.allSelected = true
end
function Methods:SetChecked(v)
    self.checked = (v and true or false)
end
function Methods:GetChecked()
    return rawget(self, "checked")
end
function Methods:GetVerticalScroll()
    return self.scroll or 0
end
function Methods:SetVerticalScroll(n)
    self.scroll = n
end
function Methods:GetVerticalScrollRange()
    return 1000
end
function Methods:AddMessage(msg)
    table.insert(chat, msg)
end

function CreateFrame(kind, name, parent)
    return newObject(kind, name, parent)
end
UIParent = newObject("Frame", "UIParent")
Minimap = newObject("Frame", "Minimap")
DEFAULT_CHAT_FRAME = newObject("ChatFrame", "DefaultChat")
GameTooltip = {
    SetOwner = function(self, owner) self.owner = owner end,
    SetText = function(self, value) self.value = value end,
    Show = function(self) self.visible = true end,
    Hide = function(self) self.visible = false end,
}
UISpecialFrames = {}
SlashCmdList = {}

function ChatFrame_AddMessageEventFilter() end
function SendChatMessage(message, channel)
    assert(channel == "SAY", "Expected SAY for ipsvc requests")
    table.insert(outbound, message)
end
local mockPlayerName = "Tester"
local mockRealmName = "Mock Realm"
function UnitName() return mockPlayerName end
function GetRealmName() return mockRealmName end
function UnitClass() return "Priest", "PRIEST" end
function UnitLevel() return 60 end
function strtrim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
function strsplit(delimiter, str)
    local items, start = {}, 1
    while true do
        local first, last = string.find(str, delimiter, start, true)
        if not first then
            table.insert(items, string.sub(str, start))
            break
        end
        table.insert(items, string.sub(str, start, first - 1))
        start = last + 1
    end
    return unpack(items)
end

local function check(value, message)
    if not value then error(message, 2) end
end
local function widgetWithLabel(label)
    for _, object in ipairs(objects) do
        if object.kind == "Button" and type(object.text) == "table"
            and (object.fullLabel or object.text.value) == label then
            return object
        end
    end
    error("Navigation button missing: " .. label)
end
local function navLike(fragment)
    for _, object in ipairs(objects) do
        if object.kind == "Button" and type(object.text) == "table"
            and type(object.fullLabel or object.text.value) == "string"
            and string.find(object.fullLabel or object.text.value, fragment, 1, true) then
            return object
        end
    end
    error("Navigation label fragment missing: " .. fragment)
end
local function widgetText(prefix)
    for _, object in ipairs(objects) do
        if object.kind == "FontString" and type(object.value) == "string"
            and string.find(object.value, prefix, 1, true) == 1 then
            return object.value
        end
    end
    return nil
end
-- WoW colour codes precede status labels, so search *within* the visible
-- FontString content rather than assuming the raw string starts with the label.
local function widgetContaining(fragment)
    for _, object in ipairs(objects) do
        if object.kind == "FontString" and type(object.value) == "string"
            and string.find(object.value, fragment, 1, true) then
            return object.value
        end
    end
    return nil
end
local function isSelected(button)
    return button.bg and button.bg.texture and button.bg.texture[4] == 0.13
end
local function click(button)
    check(button.scripts.OnClick, "Missing OnClick")
    button.scripts.OnClick(button)
end
local function buttonByText(label)
    for _, object in ipairs(objects) do
        if object.kind == "Button" and object.value == label then return object end
    end
    error("Button missing: " .. label)
end
local function systemMessage(message)
    for _, frame in ipairs(eventFrames) do
        if frame.events and frame.events.CHAT_MSG_SYSTEM and frame.scripts.OnEvent then
            frame.scripts.OnEvent(frame, "CHAT_MSG_SYSTEM", message)
        end
    end
end
local function serverReply(payload)
    -- Preserve existing staged-test inputs while simulating the new .ip get
    -- response format, including the WoW colours used in the live command.
    local numeric = payload:match("^PD~(.+)$")
    check(numeric ~= nil, "Bad test fixture: expected PD~value")
    systemMessage("Progression Level for |cff00ffffTester|r = |cff00ffff" .. numeric .. "|r")
end

function Methods:RegisterEvent(name)
    self.events = self.events or {}
    self.events[name] = true
end

-- Load the actual plugin code with mocked WoW APIs.
assert(loadfile("IndividualProgressionAddon.lua"))()
local main = named.IndividualProgressionFrame
local command = SlashCmdList.INDIVIDUALPROGRESSION
check(type(command) == "function", "Missing /ip handler")
check(main and not main:IsShown(), "Main addon frame should start hidden")
check(UISpecialFrames[1] == "IndividualProgressionFrame", "Escape registration missing")
check(UISpecialFrames[3] == "IPGuideTierChecklistFrame",
    "Tier checklist popup missing Escape registration")

command("")
check(main:IsShown(), "Slash command did not open the frame")
check(outbound[#outbound] == ".ip get Tester",
    "Open did not request the logged-in player's named read-only progression")
-- Wrong-character and legacy service replies must never select a tier.
systemMessage("Progression Level for |cff00ffffOtherPlayer|r = |cff00ffff6|r")
systemMessage("##IPSVC##PD~6")
check(widgetText("Server progression value: waiting for reply"),
    "Foreign or obsolete service reply changed current tier")
serverReply("PD~0")
check(isSelected(navLike("Tier 0")), "Server value 0 should select Tier 0")
check(navLike("Tier 1"):IsShown(), "Tier 1 preview should be visible")
check(not navLike("Tier 2"):IsShown(), "Tier 2 must be hidden for Tier 0")
check(navLike("World Boss Timeline"):IsShown(), "Vanilla side content missing")
check(not navLike("TBC Overview"):IsShown(), "TBC must be hidden for Tier 0")
check(not navLike("Wrath Overview"):IsShown(), "Wrath must be hidden for Tier 0")

-- The popup must be per character, per realm and per tier. It must never
-- alter server progression or saved visibility settings.
local tierChecklistBtn = buttonByText("Preparation Checklist")
local tierChecklist = named.IPGuideTierChecklistFrame
check(tierChecklistBtn:IsShown(), "Checklist button missing on a tier")
check(named.IPGuideScrollFrame.position[3] == 71,
    "Tier guide text must reserve space for checklist button")
local sentBeforeNotes = #outbound
click(tierChecklistBtn)
check(tierChecklist:IsShown(), "Tier checklist popup failed to open")
check(widgetContaining("These checkmarks are your private planning notes"),
    "Checklist must clearly say it is not server verification")
check(widgetContaining("Tier 0 - Molten Core"),
    "Tier checklist title should match selected page")
check(widgetContaining("PERSONAL RAID PREPARATION"),
    "Checklist needs its new prominent section heading")
check(widgetContaining("MY NOTES: 0 of 5 marked"),
    "Checklist must clearly distinguish manually marked items")
check(tierChecklist.width == 770 and tierChecklist.height == 590,
    "Checklist popup should have space for detailed task cards")
local notesScroll = named.IPGuideTierChecklistScrollFrame
local notesScrollChild = named.IPGuideTierChecklistScrollChild
check(notesScroll and notesScrollChild and notesScroll.scrollChild == notesScrollChild,
    "Detailed checklist needs its own scrollable viewport")
local opaqueBackground
for _, object in ipairs(objects) do
    if object.kind == "Texture" and object.parent == tierChecklist
        and object.texture and object.texture[1] == "Interface\\Buttons\\WHITE8X8" then
        opaqueBackground = object
    end
end
check(opaqueBackground and opaqueBackground.vertexColor
    and opaqueBackground.vertexColor[4] == 1,
    "Checklist must have an opaque background to block guide text underneath")

local notesRows = {}
local resetNotes
for _, object in ipairs(objects) do
    if object.kind == "CheckButton" and object.parent
        and object.parent.parent == notesScrollChild then
        table.insert(notesRows, object)
    elseif object.kind == "Button" and object.parent == tierChecklist and
        object.value == "Reset this tier" then
        resetNotes = object
    end
end
check(#notesRows == 5 and resetNotes, "Expected five notes and a reset action")
check(notesRows[1].card and notesRows[1].card.parent == notesScrollChild
    and notesRows[1].card.height >= 100,
    "Detailed task card not sized inside scroll content")
check(notesRows[2].card.position[2] == notesScrollChild,
    "Task cards must be positioned in their own scrolling area")
check(notesRows[1].detail.value:find("Blackrock Depths", 1, true),
    "Pre-raid task needs concrete dungeon/consumable guidance")
check(notesRows[2].detail.value:find("Lothos Riftwaker", 1, true)
    and notesRows[2].detail.value:find("Core Fragment", 1, true),
    "Core attunement should explain NPC and quest objective")
check(notesRows[1].stateText.value:find("NOT MARKED", 1, true),
    "Unmarked task needs its own visible state label")
check(notesScrollChild.height > 450,
    "Detailed task cards should be scrollable without overlap")
check(notesRows[1].kindText.value:find("RECOMMENDED", 1, true),
    "Checklist cards need an explicit task category")
notesScroll.scripts.OnMouseWheel(notesScroll, -1)
check(notesScroll:GetVerticalScroll() > 0,
    "Checklist scroll wheel must reach content below the viewport")
notesScroll.scripts.OnMouseWheel(notesScroll, 1)
check(notesScroll:GetVerticalScroll() == 0,
    "Checklist scroll wheel must move back to the top")
check(not notesRows[1]:GetChecked(), "New character checklist should be empty")
notesRows[1]:SetChecked(true)
click(notesRows[1])
check(IndividualProgressionDB.personalChecklists["Mock Realm"]["Tester"].mc.gear == true,
    "Manual completion was not saved to character and realm")
check(#outbound == sentBeforeNotes, "Checklist sent an unexpected server command")
check(not notesRows[2]:GetChecked(), "Manual notes leaked into other tasks")
tierChecklist:Hide()
click(tierChecklistBtn)
check(notesRows[1]:GetChecked(), "Manual note did not survive reopening")
check(notesRows[1].stateText.value:find("MARKED", 1, true),
    "Marked task should visibly update its status")
check(widgetContaining("MY NOTES: 1 of 5 marked"),
    "Checklist must update visual progress after checking an item")
-- A custom font may make a card taller, but should not clip the detail.
notesRows[1].detail.simulatedStringHeight = 94
click(notesRows[1]) -- unmark; remeasure the extended detail
check(notesRows[1].card.height >= 160,
    "Checklist should grow its card height to match large detail text")
click(notesRows[1]) -- mark again
notesRows[1].detail.simulatedStringHeight = nil
local doneButton = buttonByText("Done")
click(doneButton)
check(not tierChecklist:IsShown(), "Done button must close the checklist popup")
click(tierChecklistBtn)
check(notesRows[1]:GetChecked(), "Done should not erase saved marks")
check(resetNotes.value == "Reset this tier", "Reset confirmation unexpectedly armed")
click(resetNotes)
check(resetNotes.value == "Confirm reset?" and notesRows[1]:GetChecked(),
    "Reset must require two deliberate clicks")
tierChecklist:Hide()
click(tierChecklistBtn)
check(resetNotes.value == "Reset this tier" and notesRows[1]:GetChecked(),
    "Closing popup must cancel reset confirmation")
mockPlayerName = "SomeoneElse"
tierChecklist:Hide()
click(tierChecklistBtn)
check(not notesRows[1]:GetChecked(), "Manual notes leaked to another character")
notesRows[2]:SetChecked(true)
click(notesRows[2])
check(IndividualProgressionDB.personalChecklists["Mock Realm"]["SomeoneElse"].mc.core == true,
    "Second character's manual task did not save independently")
tierChecklist:Hide()
mockPlayerName = "Tester"
mockRealmName = "Another Realm"
click(tierChecklistBtn)
check(not notesRows[1]:GetChecked() and not notesRows[2]:GetChecked(),
    "Manual notes leaked to another realm")
tierChecklist:Hide()
mockRealmName = "Mock Realm"
click(tierChecklistBtn)
check(notesRows[1]:GetChecked() and not notesRows[2]:GetChecked(),
    "Original character's notes were overwritten by another scope")
notesRows[2]:SetChecked(true)
click(notesRows[2])
check(IndividualProgressionDB.personalChecklists["Mock Realm"]["Tester"].mc.core == true,
    "Second independent task should be saved")
notesRows[1]:SetChecked(false)
click(notesRows[1])
check(not notesRows[1]:GetChecked() and notesRows[2]:GetChecked(),
    "Unchecking a single note should preserve other notes")
check(not IndividualProgressionDB.personalChecklists["Mock Realm"]["Tester"].mc.gear,
    "Unchecking did not remove only the selected mark")
click(resetNotes)
check(notesRows[2]:GetChecked(), "First reset click unexpectedly deleted progress")
click(resetNotes)
check(not notesRows[1]:GetChecked() and not notesRows[2]:GetChecked(),
    "Confirmed reset did not clear this tier")
check(IndividualProgressionDB.personalChecklists["Mock Realm"]["SomeoneElse"].mc.core == true,
    "Reset damaged another character's notes")
check(#outbound == sentBeforeNotes, "Local checklist must never send server commands")
tierChecklist:Hide()
check(widgetWithLabel("General Information"):IsShown(), "General must always be visible")
check(widgetWithLabel("Settings"):IsShown(), "Settings must always be accessible")

-- Maintainer rejected the tall, wrapped sidebar after in-game review.
-- Lock in the original compact 225px sidebar and single-line 28px rows.
local tierZero = navLike("Tier 0")
local worldBossNav = navLike("World Boss Timeline")
local generalNav = widgetWithLabel("General Information")
check(tierZero.width == 178 and tierZero.height == 28,
    "Compact sidebar stage row dimensions changed")
check(worldBossNav.width == 178 and generalNav.height == 28,
    "Compact sidebar information row dimensions changed")
check(tierZero.parent.width == 188,
    "Navigation scroll child should fit original 225px sidebar")
check(tierZero.text.value == "Tier 0     Molten Core",
    "Stage title should remain in the original one-line layout")
check(worldBossNav.text.value == "World Boss Timeline" and
    generalNav.text.value == "General Information",
    "Information labels should retain original one-line wording")
check(not tierZero.text.value:find("\n", 1, true),
    "The rejected multiple-line tier labels have returned")
check(tierZero.text.position[1] == "RIGHT",
    "Sidebar label should use original vertically centred anchors")
worldBossNav.scripts.OnEnter(worldBossNav)
check(GameTooltip.visible and GameTooltip.value == "World Boss Timeline",
    "Full sidebar title must remain accessible on hover")
worldBossNav.scripts.OnLeave(worldBossNav)
check(not GameTooltip.visible, "Sidebar tooltip should close on exit")

-- Preserve the approved concise footer and other independent PR #6 features.
check(widgetContaining("Guide only - server progression is unchanged."),
    "Concise footer is missing")
check(not widgetContaining("Server progression companion - Vanilla, TBC"),
    "Old overlong footer returned")

-- Reopen should display pending, then focus an authoritative newer tier.
main:Hide()
local requests = #outbound
main:Show()
check(#outbound == requests + 1, "Reopen did not request fresh data")
check(widgetText("Server progression value: waiting for reply"),
    "Pending state should not show an old server value")
serverReply("PD~1")
check(isSelected(navLike("Tier 1")), "Server value 1 should select Tier 1")
check(navLike("Tier 2"):IsShown(), "Next-tier preview should advance")

-- A malformed payload must not silently become Tier 0.
local refresh
for _, object in ipairs(objects) do
    if object.kind == "Button" and object.value == "Refresh" then refresh = object end
end
check(refresh ~= nil, "Refresh button missing")
check(widgetContaining("CURRENT STAGE"), "Known Tier 1 should have a current-stage subtitle")
click(refresh)
check(not widgetContaining("CURRENT STAGE"),
    "Refresh left stale CURRENT STAGE text visible while pending")
check(widgetContaining("Waiting for server..."),
    "Stage subtitle should mark pending server verification")
serverReply("PD~not_a_number")
check(widgetText("Server progression value: waiting for reply"),
    "Bad server payload was accepted")
serverReply("PD~8")
check(isSelected(navLike("Tier 8")), "TBC stage should focus after refresh")
check(navLike("TBC Reputations"):IsShown(), "TBC side content missing at 8")
check(not navLike("World Boss Timeline"):IsShown(), "Past side content should be hidden")
check(not navLike("Wrath Overview"):IsShown(), "Wrath appeared too early")

-- Manual navigation after a pending request must not be overridden.
click(refresh)
click(widgetWithLabel("General Information"))
serverReply("PD~13")
check(isSelected(widgetWithLabel("General Information")),
    "Server reply stole user's manual page selection")
check(widgetContaining("FURTHER SERVER INFORMATION"),
    "General Information is missing its Resource Hub footer")
check(widgetContaining("https://cosmiccuddle.github.io/Naxxramas-Resource-Hub/"),
    "General Information has an incorrect or missing Resource Hub URL")
local hubButton = buttonByText("Copy Resource Hub URL")
local hubPopup = named.IPGuideResourceHubCopyFrame
local hubEdit = named.IPGuideResourceHubEditBox
check(hubButton:IsShown(), "Copy button should appear only on General Information")
check(not tierChecklistBtn:IsShown(), "Tier checklist button must hide on general pages")
check(named.IPGuideScrollFrame.position[3] == 71,
    "General guide content must leave room for its copy button")
click(hubButton)
check(hubPopup:IsShown(), "Copy popup did not open")
check(hubEdit:GetText() == "https://cosmiccuddle.github.io/Naxxramas-Resource-Hub/",
    "Copy field URL does not match Resource Hub")
check(hubEdit.focused and hubEdit.allSelected,
    "URL must be focused and selected for Ctrl+C")
hubEdit.scripts.OnEscapePressed(hubEdit)
check(not hubPopup:IsShown() and not hubEdit.focused,
    "Esc should close the copy field without leaving keyboard focus")

-- Relative widths should never force a 560-wide FontString into a narrow scroll.
named.IPGuideScrollFrame.width = 330
click(widgetWithLabel("General Information"))
local guideBodyFound
for _, object in ipairs(objects) do
    if object.parent == named.IPGuideScrollFrame.scrollChild and object.kind == "FontString"
        and object:IsShown() then
        guideBodyFound = object
        break
    end
end
check(guideBodyFound and guideBodyFound.width == 322,
    "Guide text ignores narrower content widths")
named.IPGuideScrollFrame.width = 560
click(widgetWithLabel("General Information"))
check(navLike("Wrath Overview"):IsShown(), "Wrath guide missing at 13")
check(navLike("Wrath Reputations"):IsShown(), "Wrath side content missing")

-- Settings must be in the fixed footer and have an unobstructed checkbox.
click(widgetWithLabel("Settings"))
local settingsCheckbox
for _, object in ipairs(objects) do
    if object.kind == "CheckButton" and object.parent ~= tierChecklist
        and object.parent ~= hubPopup then
        settingsCheckbox = object
        break
    end
end
check(settingsCheckbox ~= nil, "Settings checkbox missing")
check(settingsCheckbox.parent:IsShown(), "Settings panel is not visible")
check(not named.IPGuideScrollFrame:IsShown(), "Guide scroll obscures Settings")
check(not hubButton:IsShown(), "Hub copy button should hide outside General Information")
check(not hubPopup:IsShown(), "Copy popup should not stay open on Settings")
check(not tierChecklistBtn:IsShown(), "Tier notes button must hide on Settings")
local warning = widgetContaining("This companion is designed to guide you through progression")
local hint = widgetContaining("Off (recommended): follow the tiers")
check(warning ~= nil and hint ~= nil, "Settings caveat or guidance text missing")
local hintObject, warningObject, diagnosticObject
for _, object in ipairs(objects) do
    if object.kind == "FontString" then
        if object.value == hint then hintObject = object end
        if object.value == warning then warningObject = object end
        if type(object.value) == "string" and string.find(object.value, "Server progression value:", 1, true) == 1 then
            diagnosticObject = object
        end
    end
end
check(warningObject.position[2] == hintObject,
    "Warning must follow guide description's actual height")
check(diagnosticObject.position[2] == warningObject,
    "Server diagnostic must follow warning's actual height")
check(hintObject.width >= 450 and warningObject.width == hintObject.width,
    "Settings guidance should adapt to the available panel width")
check(widgetText("Server progression value: 13"), "Diagnostic server value is wrong")
check(not settingsCheckbox:GetChecked(), "Show all must default OFF")
settingsCheckbox:SetChecked(true)
click(settingsCheckbox)
check(IndividualProgressionDB.showAllContent == true,
    "Show all preference not saved")
check(navLike("World Boss Timeline"):IsShown(),
    "Show all did not restore older expansion side content")
check(navLike("Wrath Overview"):IsShown(), "Show all hides Wrath")
settingsCheckbox:SetChecked(false)
click(settingsCheckbox)
check(not navLike("World Boss Timeline"):IsShown(),
    "Turning Show all off must hide old expansion side content")
click(widgetWithLabel("General Information"))
check(named.IPGuideScrollFrame:IsShown(), "Guide scroll did not return after Settings")
check(hubButton:IsShown(), "Hub button should return on General Information")
-- Custom fonts must not silently re-enable the rejected bulky row layout.
local longNav = navLike("Tier 13")
longNav.text.simulatedStringHeight = 55
click(widgetWithLabel("Settings"))
check(longNav.height == 28, "Custom fonts must not expand compact sidebar rows")
longNav.text.simulatedStringHeight = nil
click(widgetWithLabel("General Information"))

-- Refresh must focus the actual stage after a later in-game progression change.
click(refresh)
serverReply("PD~17")
check(isSelected(navLike("Tier 17")), "Tier 17 did not become current")
click(refresh)
serverReply("PD~18")
check(isSelected(navLike("Wrath Overview")),
    "End-of-progression response should open Wrath overview")
check(widgetText("Server progression value: 18"), "End-stage diagnostic missing")
check(IndividualProgressionDB.showAllContent == false,
    "Settings preference should be preserved")
command("settings")
check(settingsCheckbox.parent:IsShown(), "/ip settings did not open Settings")
check(widgetWithLabel("Settings").icon.texture[1] == "Interface\\Icons\\INV_Gizmo_02",
    "Settings navigation icon missing")
command("hub")
check(hubPopup:IsShown() and hubEdit.focused,
    "/ip hub should show the selectable URL")
main:Hide()
check(not hubPopup:IsShown(), "Closing addon must also close Resource Hub popup")
main:Show()
serverReply("PD~18")
check(not hubPopup:IsShown(), "Resource popup reopened unexpectedly")

-- Regression: a genuine server-side progression decrease must move the
-- guide backwards rather than leaving the previously displayed high tier.
-- This is a simulated response; the live discrepancy needs separate diagnosis.
click(refresh)
serverReply("PD~6")
check(isSelected(navLike("Tier 6")), "Simulated progression 6 should select Tier 6")
check(navLike("Tier 7"):IsShown(), "Tier 7 preview should be shown at stage 6")
click(refresh)
check(outbound[#outbound] == ".ip get Tester",
    "Refresh must address the self character, not the selected target")
systemMessage("Progression Level for |cff00ffffOtherPlayer|r = |cff00ffff6|r")
systemMessage("##IPSVC##PD~6")
check(widgetText("Server progression value: waiting for reply"),
    "Foreign or legacy reply changed progression during refresh")
serverReply("PD~2")
check(isSelected(navLike("Tier 2")), "Refresh should move from Tier 6 back to Tier 2")
check(navLike("Tier 3"):IsShown(), "Tier 3 preview should be visible at Tier 2")
check(not navLike("Tier 6"):IsShown(), "Old Tier 6 should be hidden after Tier 2 reply")
check(not navLike("TBC Overview"):IsShown(), "TBC should be hidden after return to Tier 2")
check(widgetText("Server progression value: 2"),
    "Server diagnostic should reflect new lower progression value")
check(isSelected(navLike("Tier 2")), "Tier 2 focus lost after sidebar reflow")
check(tierChecklistBtn:IsShown(), "Tier 2 checklist button should be visible")
click(tierChecklistBtn)
check(widgetContaining("Tier 2 - Blackwing Lair"),
    "Tier 2 checklist should show the appropriate stage heading")
check(notesRows[1].detail.value:find("Scarshield Quartermaster", 1, true),
    "Tier 2 checklist must explain Blackhand's Command")
check(not notesRows[1]:GetChecked(), "Tier 0 notes incorrectly copied to Tier 2")
notesRows[1]:SetChecked(true)
click(notesRows[1])
check(IndividualProgressionDB.personalChecklists["Mock Realm"]["Tester"].bwl.blackhand == true,
    "Tier 2 note did not persist independently of other tiers")
local beforeTierClick = #outbound
tierChecklist:Hide()
check(#outbound == beforeTierClick, "Tier checklist should not send a server command")

-- Every defined stage must have its own notes without adding sidebar rows.
-- Show all content is used only to visit future stages; it does not alter
-- actual player progression or the data returned by .ip get.
command("settings")
settingsCheckbox:SetChecked(true)
click(settingsCheckbox)
local stageNumbers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17 }
for _, number in ipairs(stageNumbers) do
    local nav
    for _, object in ipairs(objects) do
        if object.kind == "Button" and type(object.fullLabel) == "string"
            and object.fullLabel:match("^Tier " .. number .. "%s") then
            nav = object
            break
        end
    end
    check(nav and nav:IsShown(), "Missing testable tier " .. number)
    click(nav)
    check(tierChecklistBtn:IsShown(), "Tier " .. number .. " has no checklist")
    click(tierChecklistBtn)
    check(tierChecklist:IsShown(), "Tier " .. number .. " checklist failed to open")
    local visibleCount = 0
    for _, row in ipairs(notesRows) do
        if row:IsShown() then
            visibleCount = visibleCount + 1
            check(row.taskId and row.stageId == nav.pageId and row.title.value
                and type(row.detail.value) == "string" and
                #row.detail.value > 50 and row.card.height >= 100,
                "Tier " .. number .. " showed stale, vague or missing task details")
        end
    end
    check(visibleCount >= 4 and visibleCount <= 5,
        "Tier " .. number .. " should show four or five tasks")
    check(notesScroll:GetVerticalScroll() == 0,
        "Opening a different tier must reset the checklist scroll position")
    tierChecklist:Hide()
end
check(#outbound == beforeTierClick, "Exploring checklists sent extra server commands")
command("settings")
settingsCheckbox:SetChecked(false)
click(settingsCheckbox)
check(IndividualProgressionDB.showAllContent == false,
    "Checklist exploration changed saved Show all preference")

print("PASS: 3.3.5a compact navigation, all tier checklists, character/realm isolation, URL and tier regression")
