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
    self.visible = false
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
function Methods:SetSize(w, h)
    self.width, self.height = w, h
end
function Methods:SetWidth(w)
    self.width = w
end
function Methods:GetWidth()
    return rawget(self, "width") or 560
end
function Methods:SetHeight(h)
    self.height = h
end
function Methods:GetStringHeight()
    return 20
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
UISpecialFrames = {}
SlashCmdList = {}

function ChatFrame_AddMessageEventFilter() end
function SendChatMessage(message, channel)
    assert(channel == "SAY", "Expected SAY for ipsvc requests")
    table.insert(outbound, message)
end
function UnitName() return "Tester" end
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
            and object.text.value == label then
            return object
        end
    end
    error("Navigation button missing: " .. label)
end
local function navLike(fragment)
    for _, object in ipairs(objects) do
        if object.kind == "Button" and type(object.text) == "table"
            and type(object.text.value) == "string"
            and string.find(object.text.value, fragment, 1, true) then
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
local function serverReply(payload)
    for _, frame in ipairs(eventFrames) do
        if frame.events and frame.events.CHAT_MSG_SYSTEM and frame.scripts.OnEvent then
            frame.scripts.OnEvent(frame, "CHAT_MSG_SYSTEM", "##IPSVC##" .. payload)
        end
    end
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

command("")
check(main:IsShown(), "Slash command did not open the frame")
check(outbound[#outbound] == ".ipsvc data", "Open did not request fresh progression")
serverReply("PD~0")
check(isSelected(navLike("Tier 0")), "Server value 0 should select Tier 0")
check(navLike("Tier 1"):IsShown(), "Tier 1 preview should be visible")
check(not navLike("Tier 2"):IsShown(), "Tier 2 must be hidden for Tier 0")
check(navLike("World Boss Timeline"):IsShown(), "Vanilla side content missing")
check(not navLike("TBC Overview"):IsShown(), "TBC must be hidden for Tier 0")
check(not navLike("Wrath Overview"):IsShown(), "Wrath must be hidden for Tier 0")
check(widgetWithLabel("General Information"):IsShown(), "General must always be visible")
check(widgetWithLabel("Settings"):IsShown(), "Settings must always be accessible")

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
check(navLike("Wrath Overview"):IsShown(), "Wrath guide missing at 13")
check(navLike("Wrath Reputations"):IsShown(), "Wrath side content missing")

-- Settings must be in the fixed footer and have an unobstructed checkbox.
click(widgetWithLabel("Settings"))
local settingsCheckbox
for _, object in ipairs(objects) do
    if object.kind == "CheckButton" then settingsCheckbox = object end
end
check(settingsCheckbox ~= nil, "Settings checkbox missing")
check(settingsCheckbox.parent:IsShown(), "Settings panel is not visible")
check(not named.IPGuideScrollFrame:IsShown(), "Guide scroll obscures Settings")
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

print("PASS: 3.3.5a mocked addon flow, refresh/reopen, staged navigation, Settings and diagnostics")
