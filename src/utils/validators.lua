local addonName, addon = ...
local UnitIsGroupLeader, IsInGroup = UnitIsGroupLeader, IsInGroup

addon.Validators = addon.Validators or {}
local Validators = addon.Validators

function Validators.CanUseDungeonMaster()
    if IsInGroup and IsInGroup() then
        return UnitIsGroupLeader and UnitIsGroupLeader("player") == true
    end
    return true
end

function Validators.IsDungeonMasterActive()
    if not Validators.CanUseDungeonMaster() then
        return false
    end
    local db = ICanSpeakLanguagesDB
    return db and db.dungeonMaster == true
end

function Validators.IsChannelEnabled(channelTypeOrEvent)
    if not channelTypeOrEvent then return true end
    local db = ICanSpeakLanguagesDB
    if not db then return true end
    local channels = db.channels or addon.Config.DEFAULT_CHANNELS

    local c = channelTypeOrEvent:upper()

    if c:find("WHISPER") or c:find("MONSTER_WHISPER") then
        return channels.whisper ~= false
    elseif c:find("SAY") or c:find("MONSTER_SAY") then
        return channels.say ~= false
    elseif c:find("YELL") or c:find("MONSTER_YELL") then
        return channels.yell ~= false
    elseif c:find("PARTY") or c:find("GROUP") then
        return channels.group == true
    elseif c:find("RAID_WARNING") or c:find("RAIDWARNING") then
        return channels.raidWarning == true
    elseif c:find("RAID") then
        return channels.raid == true
    end

    return true
end
