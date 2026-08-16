local addonName, addon = ...
local pcall = pcall
local SendAddonMessage = C_ChatInfo and C_ChatInfo.SendAddonMessage
local IsInRaid, IsInGroup = IsInRaid, IsInGroup
local table = table

addon.Broadcast = addon.Broadcast or {}
local Broadcast = addon.Broadcast
local Constants = addon.Constants

Broadcast.activeReceivers = {} -- Map of [senderName] = { [langName] = true }
Broadcast.writerSpeaking = {}  -- Map of [senderName] = langName

local lastBroadcast = 0

function Broadcast.BroadcastCapabilities()
    if not SendAddonMessage then return end
    
    local now = GetTime()
    if now - lastBroadcast < 1 then return end
    lastBroadcast = now

    local db = ICanSpeakLanguagesDB
    local selectedLang = (db and db.selectedLanguage) or "Common"
    local savedLangs = (db and db.savedLanguages) or {}

    local channel = "SAY"
    if IsInRaid and IsInRaid() then
        channel = "RAID"
    elseif IsInGroup and IsInGroup() then
        channel = "PARTY"
    end

    local langsStr = table.concat(savedLangs, ",")
    pcall(SendAddonMessage, Constants.ADDON_PREFIX, "SPEAKING:" .. selectedLang, channel)
    pcall(SendAddonMessage, Constants.ADDON_PREFIX, "LANGS:" .. langsStr, channel)
end

function Broadcast.BroadcastSpokenLanguage()
    Broadcast.BroadcastCapabilities()
end
