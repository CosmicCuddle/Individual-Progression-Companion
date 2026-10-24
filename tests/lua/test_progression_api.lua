-- Real Lua 5.1 execution of the production companion's isolated API block.
-- Doesn't load its full UI and NEVER sends an in-game server chat query.
UnitName = function(unit) assert(unit == "player"); return "Tester" end
local data = { loaded=false, currentValue=0, requestedName="Tester" }
local handle = assert(io.open("IndividualProgressionAddon.lua", "rb"))
local source = handle:read("*a")
handle:close()
local block = source:match("%-%- BEGIN READ%-ONLY PROGRESSION API(.-)%-%- END READ%-ONLY PROGRESSION API")
assert(block, "Missing stable API marker")
local create = assert(loadstring("local data = ...\n" .. block .. "\nreturn PublishProgressionUpdate"))
local publish = create(data)
local api = IndividualProgressionCompanionAPI
assert(type(api) == "table" and api.version == 1)
assert(api.GetCurrentValue() == nil, "Must not reveal unverified initial tier zero")

local seen = {}
local callback = function(value, name) table.insert(seen, {value=value,name=name}) end
assert(api.RegisterListener(callback))
assert(api.RegisterListener(callback)) -- duplicate ignored
assert(not api.RegisterListener("bad"))

data.loaded = true
local value, character = api.GetCurrentValue()
assert(value == 0 and character == "Tester", "Confirmed Vanilla value must work")
publish()
assert(#seen == 1 and seen[1].value == 0)
data.currentValue = 8
publish()
assert(#seen == 2 and seen[2].value == 8)
data.currentValue = 13
publish()
assert(#seen == 3 and seen[3].value == 13)

data.loaded = false
publish()
assert(#seen == 4 and seen[4].value == nil)
assert(api.GetCurrentValue() == nil)

-- Changed character: never expose a stale other-character tier.
data.loaded = true
data.requestedName = "Another"
assert(api.GetCurrentValue() == nil)
publish()
assert(#seen == 5 and seen[5].value == nil)
data.requestedName = "Tester"

local second = 0
assert(api.RegisterListener(function() second=second+1; error("consumer error") end))
data.currentValue = 18
publish()
assert(#seen == 6 and seen[6].value == 18 and second == 1,
    "Errors in consumer must not interfere with other clients")
assert(api.GetCurrentValue() == 18)

print("PASS: verified-self API, pending invalidation, event subscribers, no duplicates, consumer error isolation")
