local path = arg[1] or "IndividualProgressionAddon.lua"
local f = assert(io.open(path, "rb"))
local source = f:read("*a"); f:close()
local block = assert(source:match("%-%- BEGIN STAGE TRANSPORT(.-)%-%- END STAGE TRANSPORT"))
local loadCode = loadstring or load
local name, now, sends, filter, notifications = "Tester", 100, {}, nil, 0
UnitName = function() return name end
GetTime = function() return now end
SendChatMessage = function(msg, channel) assert(channel == "SAY"); sends[#sends+1]=msg end
ChatFrame_AddMessageEventFilter = function(event, callback) assert(event=="CHAT_MSG_SYSTEM"); filter=callback end
local transport = assert(loadCode(block .. [[
    GetCurrentStageId = function(v) return "stage" .. v end
    UpdateDisplay = function() end
    return {request=RequestData, reply=HandleSelfProgressionReply, push=HandleAddonStagePush, world=HandleWorldEntry}
]]))()
local api = IndividualProgressionCompanionAPI
assert(api.RegisterListener(function() notifications = notifications + 1 end))
local function reply(v, who) return "Progression Level for " .. (who or name) .. " = " .. v end
local function push(v, who, channel) transport.push("IPPSTATE", "1\t" .. v, channel or "WHISPER", who or name) end
local function hidden(msg) return filter(nil,"CHAT_MSG_SYSTEM",msg) == true end
push(3); assert(api.GetCurrentValue()==nil) -- before world entry
transport.world(); assert(#sends==1 and sends[1]==".ip get Tester")
transport.world(); assert(#sends==1)
assert(api.GetCurrentValue()==nil)
push(8,"Foreign"); push(8,nil,"PARTY"); push(19); push("03"); assert(api.GetCurrentValue()==nil)
transport.push("IPPSTATE","2\t8","WHISPER",name); assert(api.GetCurrentValue()==nil)
push(5); assert(api.GetCurrentValue()==5)
local n=notifications; push(5); assert(notifications==n)
assert(hidden(reply(2))); assert(not hidden(reply(2,"Foreign")))
transport.reply(reply(2,"Foreign")); transport.reply(reply(19)); assert(api.GetCurrentValue()==5)
assert(not transport.request(true,true) and #sends==1) -- old reply outstanding
transport.reply(reply(2)); assert(api.GetCurrentValue()==5 and hidden(reply(2)))
assert(not transport.request(true,false) and #sends==1) -- ordinary guide open
assert(transport.request(true,true) and #sends==2 and api.GetCurrentValue()==nil)
transport.reply(reply(6)); assert(api.GetCurrentValue()==6)
push(0); assert(api.GetCurrentValue()==0) -- downgrade/reset
assert(not transport.request(true,false) and #sends==2)
assert(transport.request(true,true) and #sends==3)
push(7); now=now+15; assert(not hidden(reply(0)))
transport.reply(reply(0)); assert(api.GetCurrentValue()==7)
assert(not transport.request(true,true) and #sends==3) -- unresolved timeout cannot create ambiguity
name="Other"; assert(api.GetCurrentValue()==nil); transport.world(); assert(#sends==4 and sends[4]==".ip get Other")
transport.reply(reply(18,"Tester")); assert(api.GetCurrentValue()==nil)
transport.reply(reply(0)); assert(api.GetCurrentValue()==0)
assert(transport.request(true,true)); now=now+14.9; assert(not transport.request(true,true)); now=now+0.2
assert(transport.request(true,true)); push(8); transport.reply(reply(1)); assert(api.GetCurrentValue()==8)
assert(not transport.request(true,true)) -- multiple legacy queries may still reply
print("PASS: Companion stage transport, stale reply and timeout barriers, legacy refresh, self/format checks")
